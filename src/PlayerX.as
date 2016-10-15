package {
	import flash.geom.Rectangle;
	
	import citrus.objects.platformer.simple.DynamicObject;
	import citrus.view.starlingview.AnimationSequence;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class PlayerX extends DynamicObject {
		
		public var gravity:Number = 0;
		
		public var acceleration:Number = 40;
		public var maxVelocity:Number = 280;
		
		/**
		 * Defines which input Channel to listen to.
		 */
		[Inspectable(defaultValue = "0")]
		public var inputChannel:uint = 0;

		private var limit:Rectangle;
		
		[Embed(source="../res/h18.xml",mimeType="application/octet-stream")]
		public static const h17xml:Class;
		
		[Embed(source="../res/h18.png")]
		public static const h18:Class;
		
		[Embed(source="../res/g001/sprites.xml",mimeType="application/octet-stream")]
		public static const g001xml:Class;
		
		[Embed(source="../res/g001/sprites.png")]
		public static const g001:Class;
		
		[Embed(source="../res/shadow.png")]
		public static const Shadow:Class;

		private var aniNow:String;

		private var ani:AnimationSequence;
		private var waitSkillOK:Boolean;
		
		/**param参数：**/
		public var actionNames:Array = ["idle"];
		public var actionFPSs:Array = [8];
		public var action0:String = "idle";
		public var isMe:Boolean = false;
		public var ox:int = 0;
		public var oy:int = 0;
		
		public function PlayerX(name:String, params:Object = null ,limit:Rectangle=null) {
			this.limit = limit;
			
			updateCallEnabled = true;
			
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object = null):void {
			
			super.initialize(poolObjectParams);
			
			_velocity.y = gravity;
			
			var box:Sprite = new Sprite();
			
			var shadow_img:Texture = Texture.fromBitmap(new Shadow(),false);
			var s:Image = new Image(shadow_img);
			s.alpha = .5;
			s.pivotX = s.width*0.5;
			s.pivotY = s.height>>1;
			box.addChild(s);
			
			
			var t:Texture;
			var xml:XML;
			if(isMe){
				t = Texture.fromBitmap(new h18(),false);
				xml = XML(new h17xml());
				a = new TextureAtlas(t,xml);
			}else{
				t = Texture.fromBitmap(new g001(),false);
				xml = XML(new g001xml());
			}
			var a:TextureAtlas = new TextureAtlas(t,xml);
			
			aniNow = action0;
			ani = new AnimationSequence(a, actionNames, aniNow,8,true);
			ani.setAnimFps(actionNames,actionFPSs);
			ani.onAnimationComplete.add(function(okName:String):void{
				if(okName=="idle") return;
				if(okName=="run") return;
				play(action0,true,false);
			});
			ani.pivotX = ani.width>>1;
			ani.pivotY = ani.height;
			ani.y = oy;
			box.addChild(ani);
			
			view = box;
		}
		private var count:int;
		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);
			count++;
			if(count%5==0){
				if(count>99993)count=0;
				var deep:uint = uint( (y-limit.top)/limit.height * 100 );
				group = deep;
				if(group>100){
					throw new Error("超过100group");
				}
			}
			
			if(!isMe) return; //怪物不对键盘做响应
			
			var moveKeyPressed:Boolean = false;
			
			if(!waitSkillOK){
				if (_ce.input.isDoing("left",inputChannel)) {
					_velocity.x -= acceleration;
					inverted = true;
					moveKeyPressed = true;
				}
				if (_ce.input.isDoing("right",inputChannel)) {
					_velocity.x += acceleration;
					inverted = false;
					moveKeyPressed = true;
				}
				if (_ce.input.isDoing("up",inputChannel)) {
					_velocity.y -= acceleration;
					moveKeyPressed = true;
				}
				if (_ce.input.isDoing("down",inputChannel)) {
					_velocity.y += acceleration;
					moveKeyPressed = true;
				}
				if(!moveKeyPressed){
					_velocity.x = 0;
					_velocity.y = 0;
					play("idle",true,false);
				}else{
					play("run",true,false);
				}
			}
			
			//最大速度限制
			if (_velocity.x > (maxVelocity))
				_velocity.x = maxVelocity;
			else if (_velocity.x < (-maxVelocity))
				_velocity.x = -maxVelocity;
			
			if (_velocity.y > (maxVelocity))
				_velocity.y = maxVelocity;
			else if (_velocity.y < (-maxVelocity))
				_velocity.y = -maxVelocity;
			
			if (_ce.input.isDoing("J",inputChannel)) {
				play("att04",true,true);
				_velocity.x = 0;
				_velocity.y = 0;
			}
			
			//地图可行走区域限制
			if (x > (limit.width)){
				x=limit.width;
				_velocity.x = 0;
			}else if (x < limit.x){
				x=limit.x;
				_velocity.x = 0;
			}
			if (y > (limit.height)){
				y=limit.height;
				_velocity.y = 0;
			}else if (y < limit.y){
				y=limit.y;
				_velocity.y = 0;
			}
		}
		
		private function play(actionName:String,loop:Boolean,waitForOK:Boolean):void
		{
			if(aniNow==actionName) return;
			if(ani){
				aniNow = actionName;
				ani.changeAnimation(actionName,loop);
				if(waitForOK){
					waitSkillOK = true;
				}else{
					waitSkillOK = false;
				}
			}
		}
	}
}

