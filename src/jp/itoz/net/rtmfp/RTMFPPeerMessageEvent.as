package jp.itoz.net.rtmfp
{
    import flash.events.Event;

    /**
     * peerIdと
     * messageObject.dataObject.peerId
     * は同じものになる
     */
    public class RTMFPPeerMessageEvent  extends RTMFPPeerEvent 
    {
        /**
         * 全員の通知を受け取った
         */
        public static const RECEIVE_POST_NOTIFY : String = "RECEIVE_POST_NOTIFY";
        /**
         * 直接の通知を受け取った
         */
        public static const RECEIVE_SENDTO_NOTIFY : String = "RECEIVE_SENDTO_NOTIFY";
        /**
         * 送信失敗
         */
        public static const SEND_NEIGHBOR_ERROR : String = "SEND_ERROR";
        public static const SEND_NEAREST_ERROR : String = "SEND_NEARIST_ERROR";
        private var _messageObject : Object;

        public function RTMFPPeerMessageEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false, peerId : String = null, messageObject : Object = null)
        {
            super(type, bubbles, cancelable, peerId);
            _messageObject = messageObject;
        }


        public override function clone() : Event
        {
            return new RTMFPPeerMessageEvent(type, bubbles, cancelable, peerId, _messageObject);
        }

        public override function toString() : String
        {
            return formatToString("RTMFPPeerMessageEvent", "type", "bubbles", "cancelable", "eventPhase", "peerId", "messageObject");
        }

        public function get messageObject() : Object
        {
            return _messageObject;
        }
    }
}
