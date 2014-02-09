package
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import data.PlayerData;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class Game extends Sprite
	{
		private var mouseX:Number;
		private var mouseY:Number;
		/**所有玩家*/
		public static var PlayerDic:Dictionary = new Dictionary();
		
		/**玩家自己的数据*/
		public var d:PlayerData = new PlayerData();
		public function Game()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		
		private function onAdd(e:Event):void{
			var isHW:Boolean = Starling.context.driverInfo.toLowerCase().indexOf("software") == -1;
			trace("isHW Render:",isHW)
			stage.addEventListener(TouchEvent.TOUCH,onT);
			stage.addEventListener(Event.ENTER_FRAME,update);
			var p:Splayer = new Splayer();
			addChild(p);
		}
		
		private function update(e:Event):void{
			var hasMove:Boolean = true;
			var dir:Point = d.dir;//虚拟移动目标终点，这个值将来有可能是从服务端传过来的，用于异步移动误差处理
			dir = checkPress(dir);
			if(dir.x==0 && dir.y==0) hasMove=false;
			if(hasMove){
				d.speed = G.speed;
			}else{
				dir.x = 0;
				dir.y = 0;
				d.speed = 0;
			}
			d.dir = dir;
			move();
		}
		private function checkPress(dir:Point):Point
		{
			var hasPressDir:Boolean = false;
			var h:int = 0;
			var v:int = 0;
			if(Input.check(Key.D)){
				h += 100;
				hasPressDir = true;
			}
			if(Input.check(Key.A)){
				h -= 100;
				hasPressDir = true;
			}
			if(Input.check(Key.W)){
				v -= 100;
				hasPressDir = true;
			}
			if(Input.check(Key.S)){
				v += 100;
				hasPressDir = true;
			}
			if(h==0 && v==0){
				if(Input.lastKey == Key.D){
					if(Input.check(Key.D))h = 100;
				}
				if(Input.lastKey == Key.A){
					if(Input.check(Key.A))h = -100;
				}
				if(Input.lastKey == Key.W){
					if(Input.check(Key.W))v = -100;
				}
				if(Input.lastKey == Key.S){
					if(Input.check(Key.S))v = 100;
				}		
			}
			dir.x = h;
			dir.y = v;
			return dir;
		}
		public static var point:Point = new Point;
		public function move():void{
			var targetPoint:Point = new Point(x+d.dir.x,y+d.dir.y);//相对坐标的dir（玩家作为原点），转换成绝对的（世界0点作为原点）
			var speed:Number = d.speed;
			if(speed>0){
				FP.stepTowards(this,targetPoint.x,targetPoint.y,speed);//this向着dir这个目标点移动，速度为speed
			}
		}
		private function onT(e:TouchEvent):void{
			var touch:Touch = e.getTouch(stage);
			if(!touch) return;
			var pos:Point = touch.getLocation(stage);
			mouseX = pos.x;
			mouseY = pos.y;
		}
	}
}