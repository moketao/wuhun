package main2
{
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.input.controllers.Keyboard;

	[SWF(width="1000", height="400", frameRate="30", backgroundColor="#000000")]
	public class Main2 extends StarlingCitrusEngine
	{
		public function Main2()
		{

		}
		
		override public function initialize():void
		{
			var ob:Object = this.loaderInfo.parameters;
			G.IS_DEBUG = ob.debug=="true"? true:false;
			if(G.IS_DEBUG){
				trace("本地模式");
				G.hostUrl = "http://localhost/xys/res/";
			}else{
				trace("服务器模式");
//				G.hostUrl = "http://app1101135929.qzoneapp.com/res/";
				G.hostUrl = "http://121.40.174.8/res/";
			}
			setUpStarling(true);
		}
		override public function handleStarlingReady():void
		{
			state = new GameState();
			input.keyboard.addKeyAction("left", Keyboard.A);
			input.keyboard.addKeyAction("up", Keyboard.W);
			input.keyboard.addKeyAction("right", Keyboard.D);
			input.keyboard.addKeyAction("down", Keyboard.S);
			input.keyboard.addKeyAction("J", Keyboard.J);
		}
	}
}