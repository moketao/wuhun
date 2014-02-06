package core {
	import core.interfaces.ISender;
	public class Sender implements ISender {
		public function Sender() {
		}
		public function send(notificationName:String, body:Object=null):void {
			EventCenter.send(notificationName, body);
		}
	}
}
