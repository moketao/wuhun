package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.Security;

	public class Main extends Sprite {
		public static var data:*;

		public function Main() {
			Security.allowDomain("*");
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function init(e:Event):void {

			//config
			//var a:ApplicationDomain = ApplicationDomain.currentDomain;//临时注释
			//data=a.getDefinition("Config") as Class;//临时注释

			//preloader
			//var root:Sprite = data.root as Sprite;
			var root:Sprite=this; //临时处理，没有Preloader的情况下

			//stagemenu
			new StageMenu(root);
			StageMenu.addMenu("v" + Capabilities.version);

			//layer
			//Layer.init(data.layer);
			Layer.init(this); //临时处理，没有Preloader的情况下

			//game
			//Game.init(data.layer.stage);
			Game.init(stage); //临时处理，没有Preloader的情况下
		}
	}
}


