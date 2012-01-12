package jp.itoz.net.rtmfp
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.NetStatusEvent;
    import flash.net.NetGroup;

    /**
     * @author itoz2
     */
    public class RTMFPPeer extends EventDispatcher
    {
        private var _peerId : String;
        private var _ng : NetGroup;
        public var client : Object = {};
        private var _debug : Boolean;

        /**
         * @param ng 接続したNetGroop
         * @param peerId ピアのID
         */
        public function RTMFPPeer(ng : NetGroup, peerId : String, debug:Boolean = false,target : IEventDispatcher = null)
        {
            super(target);
            _debug = debug;
            _peerId = peerId;
            _ng = ng;
            _ng.addEventListener(NetStatusEvent.NET_STATUS, netGroopStatusHandler);
        }

       
        private function netGroopStatusHandler(event : NetStatusEvent) : void
        {
            switch (event.info.code) {
//                case "NetGroup.SendTo.Notify":
//                    
//                    // メッセージ受信した
//                    var msgObj:RTMFPMessageObject = event.info.message as  RTMFPMessageObject;
//                    
//                    if(msgObj!=null){
//                        
//                    	dispatchEvent(
//                        	new RTMFPPeerMessageEvent(
//                            	 RTMFPPeerMessageEvent.RECEIVE_SENDTO_NOTIFY,false,false
//		                    	,this
//		                        , msgObj)
//                        );
//                    }
//                    break;
            }
            if (_debug) {
                trace("--------------------------");
                for (var i : * in event.info) {
                    trace(i + "	:" + event.info[i]);
                }
            }
        }

        public function close() : void
        {
            if (_ng) {
                if (_ng.hasEventListener(NetStatusEvent.NET_STATUS)) {
                    _ng.removeEventListener(NetStatusEvent.NET_STATUS, netGroopStatusHandler);
                }
                _ng = null;
            }
            dispatchEvent(new RTMFPPeerEvent(RTMFPPeerEvent.PEER_CLOSE, false, false, _peerId));
        }

        public function get peerId() : String
        {
            return _peerId;
        }
    }
}
