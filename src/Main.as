package {
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.Security;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

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
			
			//配置文件
			var a:ApplicationDomain = ApplicationDomain.currentDomain;
			data=a.getDefinition("Config") as Class;
			
			//获取预加载Sprite
			var root:Sprite = data.root as Sprite;
			
			//系统右键菜单
			new StageMenu(root);
			StageMenu.addMenu("v" + Capabilities.version);
			
			//预定义除了横向和纵向的其它四个行走方向
			Input.define("AS",Key.A,Key.S);
			Input.define("SD",Key.S,Key.D);
			Input.define("DW",Key.D,Key.W);
			Input.define("WA",Key.W,Key.A);
		}
	}
}


