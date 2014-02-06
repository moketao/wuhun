package core.interfaces {

	public interface IHandler {
		function EList():Array;
		function EHandle(notice:IMsg):void;
		function EAdd():void;
	}
}
