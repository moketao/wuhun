package core.singleton {
	import core.EventCenter;
	import core.Sender;
	import core.interfaces.IMsg;
	import core.interfaces.IHandler;

	/**
	 * 单例对象基类

	 *
	 */
	public class SingletonClass extends Sender implements IHandler {
		protected var m_strClassName:String;

		public function SingletonClass(className:String) {
			m_strClassName=className;
			checkIsSingleton();
			SingletonManager.getInstance().addSingletonClass(m_strClassName);
			EAdd();
		}

		private function checkIsSingleton():void {
			if (SingletonManager.getInstance().hasClass(m_strClassName)) {
				throw("Reduplicately Create " + m_strClassName);
			}
		}

		public function EAdd():void {
			// TODO Auto Generated method stub
			EventCenter.add(EList(), this);
		}

		public function EHandle(notice:IMsg):void {
			// TODO Auto Generated method stub

		}

		public function EList():Array {
			// TODO Auto Generated method stub
			return [];
		}



	}
}
