/**
 *============================================================
 * copyright(c) 2011-2012 itoz.jp
 * @author  itoz
 * 2011/12/1
 *============================================================
 */
package
{
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;

    import jp.itoz.net.rtmfp.RTMFPGroup;
    import jp.itoz.net.rtmfp.RTMFPNetwork;
    import jp.itoz.net.rtmfp.RTMFPPeerEvent;
    import jp.itoz.net.rtmfp.RTMFPPeerMessageEvent;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    /**
     *  [sample] itoz.jp.net.rtmfp　package
     *  このswfを複数立ち上げてボタンを押してみてください
     */
    public class SampleRTMFP extends Sprite
    {
        private var _network : RTMFPNetwork;
        private var _group : RTMFPGroup;
        private var _postButton : Sprite;
        private var _tf : TextField;
        private var _neigborButton : Sprite;

        public function SampleRTMFP()
        {
            addEventListener(Event.ADDED_TO_STAGE, onAdded);
        }

        private function onAdded(event : Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAdded);
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            // ネットワーク作成
            _network = new RTMFPNetwork();

            // 独自メソッド定義
            _network.client = {
                "toEveryone":
                    function(obj : Object = null) : void
                    {
           	             if (_tf != null) _tf.text += "" + obj["message"] + "\n";
                    }
                , "toNeigbor":
                    function(obj : Object = null) : void
                    {
                        if (_tf != null) _tf.text += "" + obj["message"] + "\n";
                    }
            };
            _network.addEventListener(Event.CONNECT, onConnected);
            _network.connect();
        }

        /**
         * Network接続完了
         */
        private function onConnected(event : Event) : void
        {
            // グループを取得
            _group = _network.createGroop("sampleGroupId", true);
            _group.addEventListener(RTMFPPeerEvent.PEER_CLOSE, onPeerClose);
            _group.addEventListener(RTMFPPeerEvent.PEER_CONNECT, onPeerConnect);
            _group.addEventListener(RTMFPPeerMessageEvent.RECEIVE_POST_NOTIFY, onReceivePost);
            _group.addEventListener(RTMFPPeerMessageEvent.RECEIVE_SENDTO_NOTIFY, onReceiveSend);
            _group.addEventListener(RTMFPPeerMessageEvent.SEND_NEAREST_ERROR, onSendError);
            _group.addEventListener(RTMFPPeerMessageEvent.SEND_NEIGHBOR_ERROR, onSendError);
            // グループに接続
            _group.connect(_network.netconenction, "225.225.0.1:30303");

            // View 作成
            createInterface();
        }

        /**
         * View 作成
         */
        private function createInterface() : void
        {
            // TextField
            _tf = addChild(new TextField()) as TextField;
            _tf.defaultTextFormat = new TextFormat(null, 12, 0x192891);
            _tf.autoSize = TextFieldAutoSize.LEFT;
            _tf.y = 50;

            // 全員に通知ボタン
            _postButton = addChild(new Sprite()) as Sprite;
            _postButton.graphics.beginFill(0xcc0000);
            _postButton.graphics.drawRect(0, 0, 100, 20);
            _postButton.graphics.endFill();
            _postButton.addEventListener(MouseEvent.CLICK, onClickBtn1);
            _postButton.buttonMode = true;

            // Neibor通知ボタン
            _neigborButton = addChild(new Sprite()) as Sprite;
            _neigborButton.graphics.beginFill(0xdeff00);
            _neigborButton.graphics.drawRect(0, 0, 100, 20);
            _neigborButton.graphics.endFill();
            _neigborButton.y = 25;
            _neigborButton.addEventListener(MouseEvent.CLICK, onClickBtn2);
            _neigborButton.buttonMode = true;
        }

        /**
         * 全員に通知（自分以外）
         */
        private function onClickBtn1(event : MouseEvent) : void
        {
            // 独自メソッドを呼ぶ
            var  date : Date = new Date();
            _group.post("toEveryone", {"date":date.getTime(), "message":"Hello Everyone!"});
        }

        /**
         * お隣さんへ通知
         */
        private function onClickBtn2(event : MouseEvent) : void
        {
            // 独自メソッドを呼ぶ
            _group.neigbor("toNeigbor", {"message":"Hello Neigbor!"});
        }

        private function onPeerConnect(event : RTMFPPeerEvent) : void
        {
            trace(event.peerId);
        }

        private function onPeerClose(event : RTMFPPeerEvent) : void
        {
            trace(event.peerId);
        }

        /**
         * 全員に通知を受け取った
         */
        private function onReceivePost(event : RTMFPPeerMessageEvent) : void
        {
            receive(event);
        }

        /**
         * 直接通知を受け取った
         */
        private function onReceiveSend(event : RTMFPPeerMessageEvent) : void
        {
            receive(event);
        }

        /**
         * 独自定義メソッドあれば、呼ぶ
         */
        private function receive(event : RTMFPPeerMessageEvent) : void
        {
            var msgObj : Object = event.messageObject;
            if (msgObj != null && msgObj.handlerName != null ) {
                if (_network.client[msgObj.handlerName] != null) {
                    _network.client[msgObj.handlerName](msgObj.dataObject);
                }
            }
        }

        /**
         * 送信エラー
         */
        private function onSendError(event : RTMFPPeerMessageEvent) : void
        {
            if (_tf != null ) _tf.text = "[ERROR]\n";
        }
    }
}
