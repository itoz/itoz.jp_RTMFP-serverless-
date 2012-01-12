/**
 * @author itoz
 */
package jp.itoz.net.rtmfp
{
    public class RTMFPPeerMessageObject extends Object
    {
        public var sender : String;
        public var destination : String;
        private var _handlerName : String;
        private var _peerId : String;
        private var _dataObject : Object;

        public function RTMFPPeerMessageObject(handlerName : String, nearId:String ,dataObject : Object = null)
        {
            super();
            _peerId = nearId;
            _handlerName = handlerName;
            _dataObject = dataObject;
        }

        public function set dataObject(dataObject : Object) : void
        {
            _dataObject = dataObject;
        }

        public function get dataObject() : Object
        {
            return _dataObject;
        }

        public function get handlerName() : String
        {
            return _handlerName;
        }

        public function set handlerName(handlerName : String) : void
        {
            _handlerName = handlerName;
        }

        public function get peerId() : String
        {
            return _peerId;
        }

        public function set peerId(peerId : String) : void
        {
            _peerId = peerId;
        }
    }
}
