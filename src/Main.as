package 
{
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.input.controllers.Keyboard;

	[SWF(width="1200", height="800", frameRate="30", backgroundColor="#000000")]
	public class Main extends StarlingCitrusEngine
	{
		public function Main()
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
				//G.hostUrl = "http://app1101135929.qzoneapp.com/res/";
				G.hostUrl = "http://121.40.174.8/res/";
			}
			
			G.hostUrl = "E:/xampp/htdocs/xys/res/";
			G.hostUrl = "../www/res/";
			G.IS_DEBUG = true;
			
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