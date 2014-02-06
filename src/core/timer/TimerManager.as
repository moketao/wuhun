package core.timer {
	import flash.utils.Dictionary;

	import core.interfaces.ITicker;
	import core.singleton.SingletonClass;

	/**
	 * 时间管理中心
	 */
	public class TimerManager extends SingletonClass implements ITicker {
		public static const NAME:String="TimerManager";

		private static var date:Date=new Date();
		private static var _instance:TimerManager;

		private var m_dicHandleList:Dictionary;
		private var m_dicNoCompensateHandleList:Dictionary;

		/**
		 * 帧率
		 */
		public static var _frameRate:int=G.FRAME_RATE;

		/**
		 * 每帧多少毫秒
		 */
		public static var frameTime:int=Math.ceil(1000 / _frameRate);

		public function TimerManager() {
			super(NAME);
			m_dicHandleList=new Dictionary();
			m_dicNoCompensateHandleList=new Dictionary();
			startTick();
		}

		public static function getInstance():TimerManager {
			return _instance=_instance || new TimerManager();
		}

		/**
		 * 客户端的时间戳
		 * @return
		 *
		 */
		public static function clientTimeStamp():int {
			//todo: rrturn Role.ServerTimeStamp;
			return 0;
		}

		private function startTimer():void {

		}

		public function startTick():void {
			Game.ticker.addTicker(this);
		}

		public function stopTick():void {
			Game.ticker.removeTicker(this);
		}

		public function tick(tickerCount:uint):void {
			frameHandler();
			noCompensateHandler();
		}

		public function add(interval:int, fun:Function, params:Object=null):void {
			if (m_dicHandleList[fun] != null) {
				return;
			}
			m_dicHandleList[fun]=createHandlerInfo(interval, params);
		}

		public function addWithoutCompensate(interval:int, fun:Function, params:Object=null):void {
			if (m_dicNoCompensateHandleList[fun] != null) {
				return;
			}
			m_dicNoCompensateHandleList[fun]=createHandlerInfo(interval, params);
		}

		private function createHandlerInfo(interval:int, params:Object):Object {
			//interval毫秒/1000 * 帧率
			var _totalFrame:Number=Math.round((interval / 1000) * _frameRate);
			return {totalFrame: _totalFrame, curFrame: 0, param: params};
		}

		public function remove(fun:Function):void {
			if (m_dicHandleList[fun] != null) {
				m_dicHandleList[fun]=null;
				delete m_dicHandleList[fun];
			}
			if (m_dicNoCompensateHandleList[fun] != null) {
				m_dicNoCompensateHandleList[fun]=null;
				delete m_dicNoCompensateHandleList[fun];
			}
		}

		public function frameHandler():void {
			var _fun:*;
			var _obj:Object=null;
			for (_fun in m_dicHandleList) {
				_obj=m_dicHandleList[_fun];
				_obj.curFrame++;
				if (_obj.curFrame >= _obj.totalFrame) {
					_obj.curFrame=0;
					if (_obj.param == null) {
						_fun();
						continue;
					}
					_fun(_obj.param);
				}
			}
		}

		public function noCompensateHandler():void {
			var _fun:*;
			var _obj:Object=null;
			for (_fun in m_dicNoCompensateHandleList) {

				_obj=m_dicNoCompensateHandleList[_fun];
				_obj.curFrame++;
				if (_obj.curFrame >= _obj.totalFrame) {
					_obj.curFrame=0;
					if (_obj.param == null) {
						_fun();
						continue;
					}
					_fun(_obj.param);
				}
			}
		}

	}
}
