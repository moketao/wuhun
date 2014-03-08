package
{
	import flash.display3D.IndexBuffer3D;
	import flash.utils.Dictionary;
	
	import data.PlayerData;
	
	import dragonBones.Bone;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Splayer extends Sprite
	{
		[Embed(source="../res/h17.xml",mimeType="application/octet-stream")]
		public static const h17xml:Class;
		
		[Embed(source="../res/h17.png")]
		public static const h17:Class;
		
		[Embed(source="../res/shadow.png")]
		public static const Shadow:Class;
		
		public static const RUN:String = "run";
		public static const IDLE:String = "idle";
		public static const arr:Array = [RUN,IDLE];//所有 action 数组
		
		public var NOW:String = "";
		public var dic:Dictionary = new Dictionary();
		
		public var d:PlayerData = new PlayerData();

		//动作
		private var f_run:Vector.<Texture>;
		private var f_idle:Vector.<Texture>;

		private var m_run:MovieClip;
		private var m_idle:MovieClip;

		public var isME:Boolean;
		public function Splayer()
		{
			var shadow_img:Texture = Texture.fromBitmap(new Shadow(),false);
			var t:Texture = Texture.fromBitmap(new h17(),false);
			var xml:XML = XML(new h17xml());
			var a:TextureAtlas = new TextureAtlas(t,xml);
			
			for (var i:int = 0; i < arr.length; i++) {
				var key:String = arr[i];
				var mc:MovieClip = new MovieClip(a.getTextures("h17_"+key+"_"),13);
				mc.pivotX = mc.width>>1;
				mc.pivotY = mc.height;
				if(key==IDLE){
					mc.fps = 5;
				}
				dic[key] = mc;
			}
			action(IDLE);
			//this.readjustSize();
			
			var s:Image = new Image(shadow_img);
			s.pivotX = (s.width>>1) + 5;
			s.pivotY = s.height - 3;
			addChild(s);
		}
		
		public function action(key:String):void{
			if(key==NOW)
				return;
			
			var mc:MovieClip = dic[key];
			var mc_now:MovieClip = dic[NOW];
			if(mc_now){
				removeChild(mc_now);//移除旧动画
				Starling.juggler.remove(mc_now);
			}
			if(mc){
				addChild(mc);//添加新动画
				Starling.juggler.add(mc);
			}
			NOW = key;
		}
		
		private var last_dir_abs:int;
		public function actionBySpeed(speed:Number, dir:Number):void{
			if(speed>0){
				action(RUN);
			}else{
				action(IDLE);
			}
			
			var dir_abs:int = Math.abs(dir);
			
			if(dir_abs==last_dir_abs || dir_abs==90)
				return;
			
			if(dir_abs>90){
				this.scaleX = -1;
			}else{
				this.scaleX = 1;
			}
			last_dir_abs = dir_abs;				
		}
	}
}