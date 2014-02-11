package
{
	import com.moketao.socket.CustomSocket;
	
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;
	
	import cmds.C10000Up;
	import cmds.C11000Down;
	import cmds.C12000Down;
	import cmds.C12000Up;
	import cmds.C12001Down;
	import cmds.C12001Up;
	import cmds.C12002Down;
	
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
			
			me = new Splayer();
			addChild(me);
			
			inputTxt = new TextField();
			inputTxt.width = 250;
			inputTxt.height = 50;
			inputTxt.type = TextFieldType.INPUT;
			inputTxt.text = "输入你的名字";
			Starling.current.nativeOverlay.addChild(inputTxt);
			
			s = CustomSocket.getInstance();
			s.addCmdListener(12001,on_12001_Down);
			s.addCmdListener(12000,on12000);
			s.addCmdListener(12002,on12002);
			s.addCmdListener(11000,on11000);
			startSocket();
			
		}
		
		private function update(e:Event):void{
			for each (var other:Splayer in PlayerDic) {
				var d:PlayerData = other.d;
				var dir:Number
				if(other==me){
					dir = checkNewDir();//运动方向
				}else{
					dir = d.dir;
				}
				var speed:Number = getSpeed(d.action);//速度，todo，如果有偏差，则加大速度。
				var targetPoint:Point = new Point(Math.sin(dir*Math.PI/180)*1000000,Math.sin(dir*Math.PI/180)*1000000);//极远的目标点
				if(speed>0){
					FP.stepTowards(me,targetPoint.x,targetPoint.y,speed);//this向着dir这个目标点移动，速度为speed，可以优化stepTowards这个函数
					send_12001_Up();
				}
			}
			
		}
		private function checkNewDir():Number
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
			
			var p:Number =	Math.atan2(v,h)*180/Math.PI;//0~180或者0到-180
			return p;
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
			PlayerDic[inputTxt.text]=me;
			
			//进入地图A
			var c2:C12000Up = new C12000Up();
			c2.MapName = "MapA";
			s.sendMessage(12000, c2);
		}
		private function on12000(vo:C12000Down):void{
			if(vo.Flag==1)trace("进入地图");
		}
		private function on12002(vo:C12002Down):void{
			trace("玩家退出:"+vo.SID);
		}
		private function on11000(vo:C11000Down):void{
			trace("服务器主动推送消息:"+vo.Str);
		}
		public static var point:Point = new Point;

		private var me:Splayer;

		private var inputTxt:flash.text.TextField;
		/** 移动 **/
		private function send_12001_Up():void{
			var c3:C12001Up = new C12001Up();
			c3.XX = me.x;
			c3.ZZ = me.y;
			c3.YY = 0;
			s.sendMessage(12001, c3);
		}
		private function on_12001_Down(vo:C12001Down):void{
			trace("=====================");
			trace(vo.SID+"在移动");
			trace(vo.XX);
			trace(vo.ZZ);
			trace(vo.YY);
			var op:Splayer = PlayerDic[vo.SID]
			if(op){
				//如果存在，则利用XX和ZZ校准移动，在update或者onEnterFrame里面修正移动，而不是直接赋值
				op.d.action = vo.Action;
				op.d.dir = vo.Dir;
			}else{
				//不存在则创建
				op = new Splayer();
				addChild(op);
				PlayerDic[vo.SID] = op;
			}
			//todo:删除服务器不再关注的op（OtherPlayer），根据距离和热度。
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