package core.interfaces {
	public interface IResource {
		function clear():void;
		function canGc():Boolean;
		function isComplete():Boolean;
		function isLoading():Boolean;
		function setLoading():void;
		function load(url:String, LinkName:String="", callBack:Function=null):void;
		function setContent(content:*):void;
	}
}

