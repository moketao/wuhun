package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	import starling.core.Starling;
	
	[SWF(width="1000", height="400", frameRate="60", backgroundColor="#dddddd")]
	public class Main extends Sprite
	{
		private var _starling:Starling;
		
		public function Main()
		{
			_starling = new Starling(Game, stage);
			_starling.start();
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		
		protected function onAdd(event:Event):void{
			FP.stage = stage;
			Input.enable();
			new StageMenu(this);
			StageMenu.addMenu("v"+Capabilities.version);
		}
	}
}


