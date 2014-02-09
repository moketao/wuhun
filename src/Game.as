package
{
	import com.moketao.socket.CustomSocket;
	
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;
	
	import cmds.C10000Up;
	import cmds.C12000Down;
	import cmds.C12000Up;
	import cmds.C12001Down;
	import cmds.C12001Up;
	
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
			
			p = new Splayer();
			addChild(p);
			
			inputTxt = new TextField();
			inputTxt.width = 250;
			inputTxt.height = 50;
			inputTxt.type = TextFieldType.INPUT;
			inputTxt.text = "输入你的名字";
			Starling.current.nativeOverlay.addChild(inputTxt);
			
			s = CustomSocket.getInstance();
			s.addCmdListener(12001,on_12001_Down);
			s.addCmdListener(12000,on12000);
			startSocket();
			
		}
		
		private function update(e:Event):void{
			var hasMove:Boolean = true;
			var dir:Point = d.dir;//虚拟移动目标终点，这个值将来有可能是从服务端传过来的，用于异步移动误差处理
			dir = checkPress(dir);
			if(dir.x==0 && dir.y==0) hasMove=false;
			if(hasMove){
				d.speed = G.speed;
				d.dir = dir;
				move();
			}else{
				dir.x = 0;
				dir.y = 0;
				d.speed = 0;
			}
			
		}
		private function checkPress(dir:Point):Point
		{
			if(Input.check(Key.ENTER))checkForTextInput();
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
		
		private function checkForTextInput():void{
			var ob:* = Starling.current.nativeStage.focus;
			if(ob==inputTxt){
				Starling.current.nativeStage.focus = null;
				login();
			}
		}
		public function startSocket():void {
			//s.start("s1.app888888.qqopenapp.com",8000);
			if (s.connected)
				s.close();
			s.start("127.0.0.1", 8000);
			trace("重新连接");
		}
		public var s:CustomSocket;
		private function login():void{
			//登录
			var c1:C10000Up = new C10000Up();
			c1.SID = inputTxt.text;
			s.sendMessage(10000,c1);
			
			//进入地图A
			var c2:C12000Up = new C12000Up();
			c2.MapName = "MapA";
			s.sendMessage(12000, c2);
			
		}
		private function on12000(vo:C12000Down):void{
			if(vo.Flag==1)trace("进入地图");
		}
		public static var point:Point = new Point;

		private var p:Splayer;

		private var inputTxt:flash.text.TextField;
		public function move():void{
			var pdir:Point = d.dir;
			var targetPoint:Point = new Point(p.x+pdir.x,p.y+pdir.y);//相对坐标的dir（玩家作为原点），转换成绝对的（世界0点作为原点）
			var speed:Number = d.speed;
			if(speed>0){
				FP.stepTowards(p,targetPoint.x,targetPoint.y,speed);//this向着dir这个目标点移动，速度为speed
				send_12001_Up();
			}
		}
		/** 移动 **/
		private function send_12001_Up():void{
			var c3:C12001Up = new C12001Up();
			c3.XX = p.x;
			c3.ZZ = p.y;
			c3.YY = 0;
			s.sendMessage(12001, c3);
		}
		private function on_12001_Down(vo:C12001Down):void{
			trace("=====================");
			trace(vo.XX);
			trace(vo.ZZ);
			trace(vo.YY);
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