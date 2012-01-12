package jp.itoz.net.rtmfp
{
	import flash.events.Event;
	
	
    public class RTMFPPeerEvent extends Event
    {
		
		public static const PEER_CONNECT:String="peerConnect";
		
		public static const PEER_CLOSE:String="peerClose";
		
        private var _peerId : String;
		
		
        public function RTMFPPeerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false, peerId : String = null)
        {
			_peerId=peerId;
			super(type,bubbles,cancelable);
		}
		
		
		public function get peerId():String {
			return _peerId;
		}
		
		public override function clone():Event {
			return new RTMFPPeerEvent(type,bubbles,cancelable,_peerId);
		}
		
		
		public override function toString():String {
			return formatToString("PeerEvent","type","bubbles","cancelable","eventPhase","peerId"); 
		}
	}
}