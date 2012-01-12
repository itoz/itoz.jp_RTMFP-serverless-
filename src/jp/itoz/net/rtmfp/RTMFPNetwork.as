package jp.itoz.net.rtmfp
{
    import flash.events.IOErrorEvent;
    import flash.events.Event;
    import flash.events.NetStatusEvent;
    import flash.net.NetConnection;
    import flash.utils.Dictionary;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    /**
     * @author itoz2
     */
    public class RTMFPNetwork extends EventDispatcher
    {
        private var __groups : Dictionary;
        private var _groups : Array;
        private var _nc : NetConnection;
        
        public var client:Object ={};
        public function RTMFPNetwork(target : IEventDispatcher = null)
        {
            super(target);
        }

        public function connect() : void
        {
            __groups = new Dictionary;
            _groups = new Array;
            _nc = new NetConnection();
            _nc.maxPeerConnections = 5;
            _nc.addEventListener(NetStatusEvent.NET_STATUS, connectionStatusHandler);
            _nc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _nc.connect("rtmfp:");
        }

        private function ioErrorHandler(event : IOErrorEvent) : void
        {
            dispatchEvent(event);
        }
        

        private function connectionStatusHandler(event : NetStatusEvent) : void
        {
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    // rtmfpサーバーと接続確立された
                    dispatchEvent(new Event(Event.CONNECT));
                    break;
                case "NetConnection.Connect.Closed":
                    close();
                    break;
                case "NetConnection.Connect.Failed":
                    break;
                case "NetStream.Connect.Success":
                    break;
                case "NetConnection.Connect.NetworkChange":
                    // netワーク変化
                    trace("NetworkChange lebel " + event.info.level)
                    if (event.info.level == "error") {
                        trace("切断されました")
                    }
                    break;
                case "NetStream.Connect.Closed":
                    // hangUp();
                    break;
            }
//            trace('event.info.code: ' + (event.info.code));
//            for (var i : * in event.info) {
//                trace("	" + i + "	:	" + event.info[i]);
//            }
        }

        /**
         * グループに参加する
         * @param groupId 参加するグループのID
         * @return 参加したグループの <code>Group</code> オブジェクト
         */
        public function createGroop(groupId : String,debug:Boolean = false) : RTMFPGroup
        {
            var group : RTMFPGroup;
            group = __groups[groupId];
            if (!group) {
                // 同じグループ名がなければ
                __groups[groupId] = group = new RTMFPGroup(groupId, debug);
                _groups.push(group);
            }
            return group;
        }
		
        
        public function close() : void
        {
			for each(var group:RTMFPGroup in _groups) {
				group.leave();
			}
			_groups=null;
			__groups=null;
			_nc.removeEventListener(NetStatusEvent.NET_STATUS,connectionStatusHandler);
			_nc.close();
			_nc=null;
            dispatchEvent(new Event(Event.CLOSE));
        }

        public function get netconenction() : NetConnection
        {
            return _nc;
        }
    }
}
