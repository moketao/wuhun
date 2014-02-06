package core.interfaces {
	public interface ISender {
		function send(notificationName:String, body:Object=null):void;
	}
}
