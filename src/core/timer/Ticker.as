package core.timer {
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;

	import core.interfaces.ITicker;

	public class Ticker {
		private var m_StartMS:Number;

		/**
		 *1帧有17毫秒
		 */
		private var tickerCount:uint;

		private var isRuning:Boolean=false;
		private var m_dicTickers:Dictionary;
		public function Ticker() {
			m_dicTickers=new Dictionary();
			isRuning=true;
		}

		public function addTicker(ticker:ITicker):void {
			if (m_dicTickers[ticker] == undefined) {
				m_dicTickers[ticker]=true;
			}
		}

		public function removeTicker(ticker:ITicker):void {
			if (m_dicTickers[ticker]) {
				delete m_dicTickers[ticker];
			}
		}

		public function step():void {
			if (!this.isRuning) {
				return;
			}

			this.loop();
			if (Game.stage.focus is TextField) {
				if ((Game.stage.focus as TextField).type != TextFieldType.INPUT) {
					if ((Game.stage.focus as TextField).htmlText.indexOf("HREF") != -1) {
						Game.stage.focus=Game.stage;
					}
				}
			}
		}

		private function loop():void {
			var ticker:ITicker;
			this.tickerCount++;
			for (ticker in m_dicTickers) {
				ticker.tick(this.tickerCount);
			}
		}

	}
}
