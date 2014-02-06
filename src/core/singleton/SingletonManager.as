package core.singleton {
	import flash.utils.Dictionary;

	public final class SingletonManager {

		private static var _instance:SingletonManager;

		private var m_dicSingletonClass:Dictionary;

		public function SingletonManager() {
			if (_instance != null) {
				throw("Reduplicately Create SingletonManager");
				return;
			}
			m_dicSingletonClass=new Dictionary();
		}

		public static function getInstance():SingletonManager {
			if (_instance == null) {
				_instance=new SingletonManager();
			}
			return _instance;
		}

		public function addSingletonClass(className:String):void {
			m_dicSingletonClass[className]=true;
		}

		public function hasClass(className:String):Boolean {
			return m_dicSingletonClass[className] != null;
		}

	}
}
