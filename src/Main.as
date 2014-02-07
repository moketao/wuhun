package {
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.Security;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	public class Main extends Engine {
		public static var data:*;

		public function Main() {
			super(G.MAX_STAGE_WIDTH,G.MAX_STAGE_HEIGHT,G.FRAME_RATE,true);
			FP.world = new MyWorld();
		}
		public override function init():void {
			super.init();
			
			//security
			Security.allowDomain("*");
			
			//config
			var a:ApplicationDomain = ApplicationDomain.currentDomain;
			data=a.getDefinition("Config") as Class;
			
			//preloader
			var root:Sprite = data.root as Sprite;
			
			//stagemenu
			new StageMenu(root);
			StageMenu.addMenu("v" + Capabilities.version);
		}
	}
}


