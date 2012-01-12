package jp.itoz.net.rtmfp
{
    import jp.itoz.utils.DateUtil;
    import jp.itoz.utils.ArrayUtil;

    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.NetStatusEvent;
    import flash.net.GroupSpecifier;
    import flash.net.NetConnection;
    import flash.net.NetGroup;
    import flash.net.NetGroupSendMode;
    import flash.utils.Dictionary;

    /**
     */
    public class RTMFPGroup extends EventDispatcher
    {
        private var __peers : Dictionary;
        private var _peers : Array;
        private var _gs : GroupSpecifier;
        private var _ng : NetGroup;
        private var _nc : NetConnection;
        private var _groupId : String;
        private var _nearId : String;
        private var _debug : Boolean;
        
        public function RTMFPGroup(groopId:String ,debug:Boolean = false,target : IEventDispatcher = null)
        {
            super(target);
            __peers = new Dictionary();
            _peers = [];
            _groupId = groopId;
            _debug = debug;
        }

//
        public function connect(nc : NetConnection, multicastIp : String = "225.225.0.1:30303") : void
        {
            _nc = nc;
            _nearId = _nc.nearID;
            
            _gs = new GroupSpecifier(_groupId);
            _gs.postingEnabled = true;
            _gs.routingEnabled = true;
            _gs.multicastEnabled = true;
            _gs.ipMulticastMemberUpdatesEnabled = true;
            _gs.objectReplicationEnabled = true;
            _gs.addIPMulticastAddress(multicastIp);
            // _gs.peerToPeerDisabled = true;
            
            _ng = new NetGroup(nc, _gs.groupspecWithAuthorizations());
            _ng.addEventListener(NetStatusEvent.NET_STATUS, netGroopStatusHandler);

            if (_debug) {
                var message : String = "====================\n";
                message += multicastIp + "\n";
                message += "nc nearID: " + _nc.nearID + "\n";
                message += "ng localCoverageFrom : " + _ng.localCoverageFrom + "\n" ;
                message += "ng localCoverageTo : " + _ng.localCoverageTo + "\n";
                message += "====================\n";
                trace(message);
            }
        }
  
        private function netGroopStatusHandler(event : NetStatusEvent) : void
        {
            var peerId : String ;
            var peer : RTMFPPeer;
            var msgObj:Object;
            switch (event.info.code) {
                case "NetGroup.Neighbor.Connect":
                    // ----------------------------------
                    // ピア接続された
                    // ----------------------------------
                    peerId = event.info.peerID;
                    peer = new RTMFPPeer(_ng, peerId,_debug);//作成
                    addPeer(peer);
                    break;
                case "NetGroup.Neighbor.Disconnect":
                    // ----------------------------------
                    // ピアクローズ
                    // ----------------------------------
                    peerId = event.info.peerID;
                    peer = __peers[peerId];
                    if (peer != null) {
                        removePeer(peer);
                    }
                    break;
                case "NetGroup.Posting.Notify":
                    // ----------------------------------
                    // グループ全員の通知を受け取った
                    // ----------------------------------
//                    peerId = event.info.peerID;
//                    trace('★peerId: ' + (peerId));
//                    peer = __peers[peerId];
//                    trace('★peer: ' + (peer));
                    msgObj = event.info.message ;
                    if (msgObj != null ) {
                        dispatchEvent(new RTMFPPeerMessageEvent(RTMFPPeerMessageEvent.RECEIVE_POST_NOTIFY, false, false, msgObj.peerId, msgObj));
                    }
                    break;
                case "NetGroup.SendTo.Notify":
                    // ----------------------------------
                    // メッセージ受信した
                    // ----------------------------------
//                    peerId = event.info.peerID;
//                    peer = __peers[peerId];
                    msgObj = event.info.message;
                    if (msgObj != null) {
                        dispatchEvent(new RTMFPPeerMessageEvent(RTMFPPeerMessageEvent.RECEIVE_SENDTO_NOTIFY, false, false, msgObj.peerId, msgObj));
                    }
                    break;
            }
            if (_debug) {
                trace("[" + DateUtil.getTimeStamp() + "] /*****************************");
                for (var i : * in event.info) {
                    trace(i + "	:" + event.info[i]);
                }
            }
        }

        // --------------------------------------------------------------------------
        //
        // 通知送信
        //
        // --------------------------------------------------------------------------
        
        // ======================================================================
        /**
         * グループ全員に通知
         * @param handlerName ハンドラネーム
         * @param obj 受け渡したいオブジェクト
         * @return Boolean　通知できたかどうか
         */
        public function post(handlerName : String, dataObj : Object) : Boolean
        {
            dataObj.peerId = nearId;
            var msgObj : RTMFPPeerMessageObject = new RTMFPPeerMessageObject(handlerName, nearId, dataObj);
            msgObj.sender = _ng.convertPeerIDToGroupAddress(_nc.nearID);
            var result : String = _ng.post(msgObj);
            return  errorCheck(result);
        }

        // ======================================================================
        /**
         * Nearistに通知 (特定のpeer)
         * @param handlerName ハンドラネーム
         * @param peerId 通知したいPeerId
         * @param obj 受け渡したいオブジェクト
         * @return Boolean　通知できたかどうか
         */
        public function nearist(handlerName : String, peerId : String, dataObj : Object) : Boolean
        {
            dataObj.peerId = nearId;
            var msgObj : RTMFPPeerMessageObject = new RTMFPPeerMessageObject(handlerName, nearId, dataObj);
            msgObj.destination = _ng.convertPeerIDToGroupAddress(peerId);
            var result : String = _ng.sendToNearest(msgObj, msgObj.destination);
            return  errorCheck(result);

            // var msgObj : Object = new Object();
            // msgObj.handlerName = handlerName;
            // dataObj.peerId = _nearId;
            // trace('★★_nearId: ' + (dataObj.peerId));
            // msgObj.dataObject = dataObj;
            // msgObj.destination = _ng.convertPeerIDToGroupAddress(peerId);
            // var result : String = _ng.sendToNearest(msgObj, msgObj.destination);
            // return  errorCheck(result);
        }


        // ======================================================================
        /**
         * Neighborに通知 (お隣さん)
         * @param handlerName ハンドラネーム
         * @param obj 受け渡したいオブジェクト
         * @param sendMode どちら側のNeighborに通知するか
         * @return Boolean　通知できたかどうか
         */
        public function neigbor(handlerName : String, dataObj : Object, sendMode : String = NetGroupSendMode.NEXT_INCREASING) : Boolean
        {
            dataObj.peerId = nearId;
            var msgObj : RTMFPPeerMessageObject = new RTMFPPeerMessageObject(handlerName, nearId, dataObj);
            msgObj.sender = _ng.convertPeerIDToGroupAddress(_nc.nearID);
            var result : String = _ng.sendToNeighbor(msgObj, sendMode);
            return errorCheck(result);
        }

        // ======================================================================
        /**
         * 送信エラーチェック
         */
        private function errorCheck(result : String) : Boolean
        {
            if (result == "error") {
                //nearist エラー
                dispatchEvent(new RTMFPPeerMessageEvent(RTMFPPeerMessageEvent.SEND_NEAREST_ERROR));
                return false;
            }else if(result == "no route"){
                //neighborエラー
                dispatchEvent(new RTMFPPeerMessageEvent(RTMFPPeerMessageEvent.SEND_NEIGHBOR_ERROR));
                return false;
            }
            return true;
        }
        
        //--------------------------------------------------------------------------
        //
        //  ピアの追加/削除
        //
        //--------------------------------------------------------------------------
        /**
         * ピアの追加
         */
        private function addPeer(peer : RTMFPPeer) : void
        {
            __peers[peer.peerId] = peer;
            _peers.push(peer);
            dispatchEvent(new RTMFPPeerEvent(RTMFPPeerEvent.PEER_CONNECT, false, false, peer.peerId));
        }

        /**
         * ピアの削除
         */
        private function removePeer(peer : RTMFPPeer) : void
        {
            for (var i : int = 0; i < _peers.length; i++) {
                var p : RTMFPPeer = _peers[i] as RTMFPPeer  ;
                if ( p.peerId == peer.peerId) {
                    _peers = ArrayUtil.cutOut(i, _peers);
                    __peers[peer.peerId] = null;
                    delete __peers[peer.peerId] ;
                    p.close();
                    break;
                }
            }
            if (peer != null) dispatchEvent(new RTMFPPeerEvent(RTMFPPeerEvent.PEER_CLOSE, false, false, peer.peerId));
        }

        // --------------------------------------------------------------------------
        //
        // remove
        //
        // --------------------------------------------------------------------------
        /**
         * グループから離脱する
         */

        public function reset() : void
        {
            close();
            leave();
            _peers = [];
            __peers = new Dictionary();
        }
        internal function leave() : void
        {
            for each (var peer:RTMFPPeer in _peers) {
                // ぴあを全部クローズ
                peer.close();
            }
            _peers = null;
            __peers = null;
        }
        
        public function close() : void
        {
            if (_ng != null) _ng.close();
        }


        // --------------------------------------------------------------------------
        //
        // getter
        //
        // --------------------------------------------------------------------------
        public function get peers() : Array
        {
            return _peers;
        }

        public function get nearId() : String
        {
            return _nearId;
        }
    }
}
