package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	import starling.core.Starling;
	
	[SWF(width="1000", height="400", frameRate="30", backgroundColor="#dddddd")]
	public class Main extends Sprite
	{
		private var _starling:Starling;
		
		public function Main()
		{
			initParameter();
			_starling = new Starling(Game, stage);
			_starling.start();
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		
		private function initParameter():void{
			var ob:Object = this.loaderInfo.parameters;
			G.IS_DEBUG = ob.debug=="true"? true:false;
			if(G.IS_DEBUG){
				trace("本地模式");
				G.hostUrl = "http://localhost/xys/res/";
			}else{
				trace("服务器模式");
				G.hostUrl = "http://app1101135929.qzoneapp.com/res/";
			}
		}
		
		protected function onAdd(event:Event):void{
			FP.stage = stage;
			Input.enable();
			new StageMenu(this);
			StageMenu.addMenu("v"+Capabilities.version);
		}
	}
}


