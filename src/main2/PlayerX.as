package main2{
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
		
		[Embed(source="../../res/h18.xml",mimeType="application/octet-stream")]
		public static const h17xml:Class;
		
		[Embed(source="../../res/h18.png")]
		public static const h17:Class;
		
		[Embed(source="../../res/shadow.png")]
		public static const Shadow:Class;

		private var aniNow:String;

		private var ani:AnimationSequence;
		private var waitSkillOK:Boolean;
		
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
			s.alpha = .6;
			s.scaleX = 1.3;
			s.scaleY = 1.3;
			s.pivotX = (s.width>>1);
			s.pivotY = s.height>>1;
			box.addChild(s);
			
			var t:Texture = Texture.fromBitmap(new h17(),false);
			var xml:XML = XML(new h17xml());
			var a:TextureAtlas = new TextureAtlas(t,xml);
			
			aniNow = "idle";
			ani = new AnimationSequence(a, ["idle", "run" ,"att01" ,"att02" ,"att03" ,"att04" ,"att05"], aniNow,8,true);
			ani.setAnimFps(
				["idle",	"run"	],
				[5,			12		]
			);
			ani.onAnimationComplete.add(function(okName:String):void{
				if(okName=="idle") return;
				if(okName=="run") return;
				play("idle",true,false);
			});
			ani.pivotX = ani.width>>1;
			ani.pivotY = ani.height;
			ani.y = 232;
			box.addChild(ani);
			
			view = box;
		}
		
		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);
			
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

