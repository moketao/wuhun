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
			//FP系统初始化
			super.init();
			
			//安全选项
			Security.allowDomain("*");
			
			//预加载Sprite传送过来的配置类
			var a:ApplicationDomain = ApplicationDomain.currentDomain;
			data=a.getDefinition("Config") as Class;
			
			//获取预加载Sprite
			var root:Sprite = data.root as Sprite;
			
			//系统右键菜单
			new StageMenu(root);
			StageMenu.addMenu("v" + Capabilities.version);
			
			//预定义除了横向和纵向的其它行走方向
			//Input.define("ASD",Key.A,Key.S,Key.D);
		}
	}
}


