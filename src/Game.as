package
{
	import com.moketao.socket.CustomSocket;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
	
	import data.ActionType;
	import data.PlayerData;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.extensions.QuadtreeSprite;
	import starling.utils.Color;
	
	public class Game extends Sprite
	{
		private var mouseX:Number;
		private var mouseY:Number;
		/**所有玩家*/
		public static var PlayerDic:Dictionary = new Dictionary();
		public function Game()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		private var _quadtreeSprite:QuadtreeSprite;
		private var _worldBounds:Rectangle;
		private static const SQUARE_SIZE:Number = 50;
		private static const PAD_SIZE:Number = 100;
		private function onAdd(e:Event):void{
			
			//细碎小事
			var isHW:Boolean = Starling.context.driverInfo.toLowerCase().indexOf("software") == -1;
			trace("isHW Render:",isHW)
			Starling.current.showStats = true;
			stage.addEventListener(TouchEvent.TOUCH,onT);
			stage.addEventListener(Event.ENTER_FRAME,enterFrame);
			
			
			//四叉树
			_worldBounds = new Rectangle(0,0, WORLD_BOUND_X, WORLD_BOUND_Y);
			_quadtreeSprite = new QuadtreeSprite(_worldBounds, new Rectangle(0,0,this.stage.stageWidth+PAD_SIZE*2,this.stage.stageHeight+PAD_SIZE*2),true);
			_quadtreeSprite.touchable = false;
			//_quadtreeSprite.blendMode = BlendMode.NONE;//只对大背景使用，省去 alpha 晕死
			addChild(_quadtreeSprite);
			
			
			//四叉树地图内部的【物体】
			for (var i:int = 0; i < 1000; ++i)
			{
				var square:Quad = new Quad(SQUARE_SIZE, SQUARE_SIZE, randomColor());
				var randomPosition:Point = randomPointInRectangle(_worldBounds);
				square.x = randomPosition.x;
				square.y = randomPosition.y;
				_quadtreeSprite.addChild(square);
			}
			
			
			//四叉树地图内部的【玩家】，其他玩家将在 Socket 连通后添加。
			me = new Splayer();
			me.x = 180;
			me.y = 150;
			_quadtreeSprite.addChild(me);
			
			
			//登录时需要输入名字，由于Starling不支持输入文本，所以下面这个是传统TXT，用于输入文本	//todo：不用时隐藏
			inputTxt = new TextField();
			inputTxt.width = 550;
			inputTxt.height = 50;
			inputTxt.y = 40;
			inputTxt.type = TextFieldType.INPUT;
			inputTxt.text = "删除这行文字，再输入你的名字，然后按回车，即可使用【A】【S】【D】【W】控制角色";
			Starling.current.nativeOverlay.addChild(inputTxt);
			
			
			//网络
			s = CustomSocket.getInstance();
			s.addCmdListener(12001,on_12001_Down);
			s.addCmdListener(12000,on12000);
			s.addCmdListener(12002,on12002);
			s.addCmdListener(11000,on11000);
			startSocket();
		}
		
		private function randomColor():uint
		{
			return Color.rgb(Math.random() * 255, Math.random() * 255, Math.random() * 255);
		}
		private function randomPointInRectangle(rectangle:Rectangle):Point
		{
			return new Point (rectangle.x + rectangle.width * Math.random(),
				rectangle.y + rectangle.height * Math.random());
		}
		
		/** 主循环，每帧运行 	//todo：优化，渲染压力高时，主动降帧 ，并使用e.passedTime来处理移动距离 **/
		private function enterFrame(e:EnterFrameEvent):void{
			if(Input.check(Key.ENTER))checkForTextInput();
			for each (var other:Splayer in PlayerDic) {
				var d:PlayerData = other.d;
				var dir:Number;
				var isME:Boolean;
				if(other==me){
					isME = true;
					me.d.dir = dir = checkNewDir();//运动方向
				}else{
					dir = d.dir;
				}
				var speed:Number = getSpeed(d.action);
				
				if(speed>0){
					var targetPoint:Point = new Point(Math.cos(dir*Math.PI/180)*1000000,-Math.sin(dir*Math.PI/180)*1000000);//极远的目标点
					if(speed>0){
						FP.stepTowards(other,targetPoint.x,targetPoint.y,speed);//向着dir这个目标点移动，速度为speed，可以优化stepTowards这个函数
					}
					
					//限制，不要超出地图
					other.x = FP.clamp(other.x,PAD_SIZE,WORLD_BOUND_X-PAD_SIZE);
					other.y = FP.clamp(other.y,PAD_SIZE,WORLD_BOUND_Y-PAD_SIZE);
					
					if(count%26==0)_quadtreeSprite.updateChild(other);//更新四叉树//26帧更新一次，否则性能消耗太大
				}
				if(isME){
					if(needSend12001_about_me(d)){
						send_12001_Up();
					}
				}else{
					if(needSendfix_about_other(other,d)){
						fix(other,d);//其他玩家，距离如果有偏差，则修正。
					}
				}
			}
			cameraFollow(e);
		}
		
		private var cameraPos:Point = new Point;
		private function cameraFollow(e:EnterFrameEvent):void{
			
			//_quadtreeSprite.x += _velocityX * e.passedTime; //todo:使用时间，消除误差
			//_quadtreeSprite.y += _velocityY * e.passedTime; //todo:使用时间，消除误差
			
			//纯抽象摄像机，原理是反向横移地图。距离视图中间较远时激活次操作
			cameraPos.x = me.x -this.stage.stageWidth/2;
			cameraPos.y = me.y -this.stage.stageHeight/2;
			
			//限制摄像机（实际是限制地图反向横移坐标）
			cameraPos.x = FP.clamp(cameraPos.x,0,WORLD_BOUND_X-this.stage.stageWidth);
			cameraPos.y = FP.clamp(cameraPos.y,0,WORLD_BOUND_Y-this.stage.stageHeight);

			_quadtreeSprite.x = -int(cameraPos.x);//反向横移
			_quadtreeSprite.y = -int(cameraPos.y);//原理同上

			if(++count%28==0){
				var newViewPort:Rectangle = _quadtreeSprite.visibleViewport.clone();
				newViewPort.x = Math.abs(_quadtreeSprite.x)-PAD_SIZE;	//向外扩展更新范围
				newViewPort.y = Math.abs(_quadtreeSprite.y)-PAD_SIZE;	//同上
				_quadtreeSprite.visibleViewport = newViewPort;//28帧更新一次，否则 CPU 会爆掉。
			}
		}
		private var count:int;
		private function fix(other:Splayer, d:PlayerData):void
		{
			point.x = d.fixX;
			point.y = d.fixZ;
			FP.stepTowards(other,other.x+d.fixX,other.y+d.fixZ,point.length*0.333);//每次接近33.3%
			d.fixX *= 0.666;
			d.fixZ *= 0.666;
		}
		
		/**降低发送的Hz（如果方向不变，action不变）针对 other*/
		private function needSendfix_about_other(other:Splayer,d:PlayerData):Boolean{
			var need:Boolean = false;
			if(d.flag==1){
				//flag值为1时，代表 other要求周围玩家进行更新（包括me）
				d.flag = 0;
				need = true;
			}
			point.x = d.fixX;
			point.y = d.fixZ;
			if(point.length>3){//还需要修正3个像素以上
				d.flag = 0;
				need = true;
			}
			if(need){
				return need;
			}
			return false;
		}
		
		/**降低发送的Hz（如果方向不变，action不变）针对 me*/
		private function needSend12001_about_me(d:PlayerData):Boolean{
			var need:Boolean = false;
			if(d.lastAction!=d.action){
				d.lastAction = d.action;
				need = true;
			}
			if(d.lastDir!=d.dir){
				d.lastDir = d.dir;
				need = true;
			}
			if(need){
				return need;
			}
			return need;
		}

		
		private var actionToSpeedDic:Dictionary;
		private function getSpeed(action:int):Number{
			if(actionToSpeedDic==null){
				actionToSpeedDic = new Dictionary();
				actionToSpeedDic[0] = 0;//站立速度0
				actionToSpeedDic[1] = 8;//奔跑速度8
			}
			return actionToSpeedDic[action];//todo:考虑各种负面状态。
		}
		private function checkNewDir():Number
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
			if(h!=0||v!=0){
				me.d.action = ActionType.RUN;
			}else{
				me.d.action = ActionType.STAND;
			}
			var p:Number =	int(Math.atan2(-v,h)*180/Math.PI);//0~180或者0到-180
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
			if (s.connected){
				trace("已连接，先断开");
				s.close();
			}
			s.start("app1101135929.qzone.qzoneapp.com",8000);
			//s.start("127.0.0.1", 8000);
			trace("正在连接");
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
		private var WORLD_BOUND_X:Number = 2000;
		private var WORLD_BOUND_Y:Number = 1000;
		private var FOLLOW_RATE:Number = 0.1;
		private var FOLLOW_TRAIL:Number = 50;
		/** 移动 **/
		private function send_12001_Up():void{
			var c3:C12001Up = new C12001Up();
			c3.XX = me.x;
			c3.ZZ = me.y;
			c3.YY = 0;
			c3.Dir = me.d.dir;
			c3.Action = me.d.action;
			s.sendMessage(12001, c3);
		}
		private function on_12001_Down(vo:C12001Down):void{
			//trace(vo.SID+"在移动");
			var op:Splayer = PlayerDic[vo.SID]
			if(!op){
				//不存在则创建
				op = new Splayer();
				op.d.SID = vo.SID;
				op.x = vo.XX;
				op.y = vo.ZZ;
				_quadtreeSprite.addChild(op);
				PlayerDic[vo.SID] = op;
			}
			//如果存在，则利用XX和ZZ校准移动，在update或者onEnterFrame里面修正移动，而不是直接赋值
			op.d.action = vo.Action;
			op.d.XX = vo.XX;
			op.d.ZZ = vo.ZZ;
			op.d.YY = vo.YY;
			op.d.dir = vo.Dir;
			op.d.flag = 1;
			//记录差距，以后每帧修正一部分
			op.d.fixX = op.d.XX-op.x;
			op.d.fixZ = op.d.ZZ-op.y;
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