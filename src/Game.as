package
{
	import com.moketao.socket.CustomSocket;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import cmds.C10000Up;
	import cmds.C11000Down;
	import cmds.C12000Down;
	import cmds.C12000Up;
	import cmds.C12001Down;
	import cmds.C12001Up;
	import cmds.C12002Down;
	
	import data.ActionType;
	import data.PlayerData;
	
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.utils.Color;

	public class Game extends Sprite
	{
//		[Embed(source="../res/map/m0/bga.jpg")]
//		public static const BGA:Class;
		[Embed(source="map01.txt", mimeType="application/octet-stream")]  
		public var txtCls:Class; 
		public var mouseX:Number;
		public var mouseY:Number;
		
		/**所有玩家*/
		public static var PlayerDic:Dictionary = new Dictionary();
		public function Game()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		public function onAdd(e:Event):void{
			//细碎小事
			var isHW:Boolean = Starling.context.driverInfo.toLowerCase().indexOf("software") == -1;
			trace("isHW Render:",isHW)
			//Starling.current.showStats = true;
			stage.addEventListener(TouchEvent.TOUCH,onT);
			stage.addEventListener(Event.ENTER_FRAME,enterFrame);
			
			
			var byteDataTxt:ByteArray = new txtCls();  
			var str:String = byteDataTxt.readUTFBytes(byteDataTxt.bytesAvailable);
			var mapOB:Object = JSON.parse(str);
			
			scene = new Scene();
			addChild(scene);
			scene.parse(mapOB);
			mainLayer = scene.mainLayer;
			
			//四叉树地图内部的【玩家】，其他玩家将在 Socket 连通后添加。
			me = new Splayer();
			me.isME = true;
			me.x = 180;
			me.y = 350;
			mainLayer.addChild(me);
			
			//网络
			s = CustomSocket.getInstance();
			s.addCmdListener(12001,on_12001_Down);
			s.addCmdListener(12000,on12000);
			s.addCmdListener(12002,on12002);
			s.addCmdListener(11000,on11000);
			startSocket();
			
			setTimeout(login,3000);
		}
		
		public function randomColor():uint
		{
			return Color.rgb(Math.random() * 255, Math.random() * 255, Math.random() * 255);
		}
		public function randomPointInRectangle(rectangle:Rectangle):Point
		{
			return new Point (rectangle.x + rectangle.width * Math.random(),
				rectangle.y + rectangle.height * Math.random());
		}
		
		/** 主循环，每帧运行 	//todo：优化，渲染压力高时，主动降帧 ，并使用e.passedTime来处理移动距离 **/
		public function enterFrame(e:EnterFrameEvent):void{
			for each (var other:Splayer in PlayerDic) {
				var d:PlayerData = other.d;
				var dir:Number;
				if(other.isME){
					me.d.dir = dir = checkNewDir();//运动方向
				}else{
					dir = d.dir;
				}
				var speed:Number = getSpeed(d.action);
				other.actionBySpeed(speed,dir);
				
				if(speed>0){
					var targetPoint:Point = new Point(Math.cos(dir*Math.PI/180)*1000000,-Math.sin(dir*Math.PI/180)*1000000);//极远的目标点
					if(speed>0){
						stepTowards(other,targetPoint.x,targetPoint.y,speed);//向着dir这个目标点移动，速度为speed，可以优化stepTowards这个函数
					}
					
					//限制，不要超出地图
					other.x = clamp(other.x,PAD_SIZE,mainLayer.w-PAD_SIZE);
					other.y = clamp(other.y,300,mainLayer.h);
				}
				if(other.isME){
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
		public static function stepTowards(object:Object, x:Number, y:Number, distance:Number = 1):void
		{
			point.x = x - object.x;
			point.y = y - object.y;
			if (point.length <= distance)
			{
				object.x = x;
				object.y = y;
				return;// new Point(x,y);
			}
			point.normalize(distance);
			object.x = object.x+point.x;
			object.y = object.y+point.y;
			//return new Point(object.x,object.y);
		}
		public static function clamp(value:Number, min:Number, max:Number):Number
		{
			if (max > min)
			{
				if (value < min) return min;
				else if (value > max) return max;
				else return value;
			} else {
				// Min/max swapped
				if (value < max) return max;
				else if (value > min) return min;
				else return value;
			}
		}
		public var cameraPos:Point = new Point;
		public var cameraPosLast:Point = new Point;
		public var cameraIsMove:Boolean;
		public function cameraFollow(e:EnterFrameEvent):void{
			
			//纯抽象摄像机，原理是反向横移地图。距离视图中间较远时激活次操作
			cameraPos.x = me.x -this.stage.stageWidth/2;
			//cameraPos.y = me.y -this.stage.stageHeight/2;
			
			//限制摄像机（实际是限制地图反向横移坐标）
			cameraPos.x = clamp(cameraPos.x,0,mainLayer.w-this.stage.stageWidth);
			//cameraPos.y = clamp(cameraPos.y,0,WORLD_BOUND_Y-this.stage.stageHeight);

			if(int(cameraPos.x)!=int(cameraPosLast.x) || int(cameraPos.y)!=int(cameraPosLast.y)){
				cameraPosLast.x = cameraPos.x;
				//cameraPosLast.y = cameraPos.y;
				cameraIsMove = true;
			}else{
				cameraIsMove = false;
			}
			mainLayer.x = -cameraPos.x;//反向横移
			//mainLayer.y = -cameraPos.y;//原理同上
		}
		public var count:int;
		public function fix(other:Splayer, d:PlayerData):void
		{
			point.x = d.fixX;
			point.y = d.fixZ;
			stepTowards(other,other.x+d.fixX,other.y+d.fixZ,point.length*0.333);//每次接近33.3%
			d.fixX *= 0.666;
			d.fixZ *= 0.666;
		}
		
		/**降低发送的Hz（如果方向不变，action不变）针对 other*/
		public function needSendfix_about_other(other:Splayer,d:PlayerData):Boolean{
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
		public function needSend12001_about_me(d:PlayerData):Boolean{
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

		
		public var actionToSpeedDic:Dictionary;
		public function getSpeed(action:int):Number{
			if(actionToSpeedDic==null){
				actionToSpeedDic = new Dictionary();
				actionToSpeedDic[0] = 0;//站立速度0
				actionToSpeedDic[1] = 8;//奔跑速度8
			}
			return actionToSpeedDic[action];//todo:考虑各种负面状态。
		}
		public function checkNewDir():Number
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
				if(h!=0 && cameraIsMove){
					me.d.faceTo = h>0? 1:-1;
					scene.moveLayers(cameraPos,mainLayer.w);
				}else{
					//backgroundA.speed = 0;
				}
			}else{
				me.d.action = ActionType.STAND;
				//backgroundA.speed = 0;
				return me.d.dir;
			}
			var p:Number =	Math.atan2(-v,h)*180/Math.PI;//0~180或者0到-180
			return p;
		}
		public function startSocket():void {
			if (s.connected){
				trace("已连接，先断开");
				s.close();
			}
			if(G.IS_DEBUG){
				s.start("127.0.0.1", 8000);
			}else{
				s.start("app1101135929.qzone.qzoneapp.com",8000);
			}
			trace("正在连接");
		}
		public var s:CustomSocket;
		public var hasLogin:Boolean;
		public function login():void{
			if(hasLogin) return;
			//登录
			var c1:C10000Up = new C10000Up();
			c1.SID = me.SID;
			s.sendMessage(10000,c1);
			PlayerDic[me.SID]=me;
			
			//进入地图A
			var c2:C12000Up = new C12000Up();
			c2.MapName = "MapA";
			s.sendMessage(12000, c2);
			
			hasLogin = true;
		}
		public function on12000(vo:C12000Down):void{
			if(vo.Flag==1)trace("进入地图");
		}
		public function on12002(vo:C12002Down):void{
			trace("玩家退出:"+vo.SID,PlayerDic);
		}
		public function on11000(vo:C11000Down):void{
			trace("服务器主动推送消息:"+vo.Str);
		}
		public static var point:Point = new Point;

		public var me:Splayer;

		public var inputTxt:flash.text.TextField;
		public var PAD_SIZE:Number = 20;
		public var FOLLOW_RATE:Number = 0.1;
		public var FOLLOW_TRAIL:Number = 50;
		public var mainLayer:Layer;

		public var scene:Scene;

		public var cameraMove:Point;
		/** 移动 **/
		public function send_12001_Up():void{
			var c3:C12001Up = new C12001Up();
			c3.XX = me.x;
			c3.ZZ = me.y;
			c3.YY = 0;
			c3.Dir = me.d.dir;
			c3.Action = me.d.action;
			s.sendMessage(12001, c3);
		}
		public function on_12001_Down(vo:C12001Down):void{
			//trace(vo.SID+"在移动");
			var op:Splayer = PlayerDic[vo.SID]
			if(!op){
				//不存在则创建
				op = new Splayer();
				op.d.SID = vo.SID;
				op.x = vo.XX;
				op.y = vo.ZZ;
				mainLayer.addChild(op);
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
		public function onT(e:TouchEvent):void{
			var touch:Touch = e.getTouch(stage);
			if(!touch) return;
			var pos:Point = touch.getLocation(stage);
			mouseX = pos.x;
			mouseY = pos.y;
		}
	}
}