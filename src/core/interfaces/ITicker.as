package core.interfaces {

	public interface ITicker {
		function startTick():void;
		function stopTick():void;
		function tick(tickerCount:uint):void;
	}
}
