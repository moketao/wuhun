package core {
	import flash.utils.Dictionary;
	
	import core.interfaces.IHandler;

	public class EventCenter {

		private static var dic:Dictionary=new Dictionary();

		public function EventCenter() {
		}

		private static function addOne(notificationName:String, handler:IHandler):void {
			if (dic[notificationName] == null) {
				dic[notificationName]=new Dictionary();
			}
			dic[notificationName][handler]=true;
		}

		public static function removeObserver(notificationName:String, handler:IHandler):void {
			if (dic[notificationName] != null) {
				delete dic[notificationName][handler];
			}
		}

		public static function getObservers(notificationName:String):Dictionary {
			return dic[notificationName];
		}

		public static function send(notificationName:String, body:Object):void {
			var d:Dictionary=dic[notificationName] as Dictionary;
			if (d != null) {
				var notice:MSG=new MSG(notificationName, body);
				for (var o:* in d) {
					(o as IHandler).EHandle(notice);
				}
			}
		}

		public static function add(eventArr:Array, handler:IHandler):void {
			var len:int=eventArr.length;
			for (var i:int=0; i < len; i++) {
				if (eventArr[i] is Array && eventArr[i].length > 1) {
					addOne(eventArr[i][0], handler);
				} else {
					addOne(eventArr[i], handler);
				}
			}
		}

		public static function remove(notificationNameList:Array, handler:IHandler):void {
			var len:int=notificationNameList.length;
			for (var i:int=0; i < len; i++) {
				removeObserver(notificationNameList[i], handler);
			}
		}

	}
}

