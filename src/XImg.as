package
{
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class XImg extends Sprite
	{
		private var lastX:Number;
		private var lastY:Number;
		private var selIcon:Image;
		private var bg:Quad;
		private var alphaUnSel:Number = .3;
		private var alphaSel:Number = 1;
		public var hasSel:Boolean;
		private var frame:Rectangle;
		private var r:Rectangle;
		private var t:Texture;
		public function clone(maxWidth:int):XImg
		{
			return new XImg(t,name,frame,r,maxWidth);
		}
		public function XImg(t:Texture,_name:String,frame:Rectangle,r:Rectangle,max:int=90)
		{
			this.t = t;
			this.r = r;
			this.frame = frame;
			var c:Sprite = new Sprite();
			
			bg = new Quad(r.width,r.height,0xff0000);
			bg.x = -frame.x;
			bg.y = -frame.y;
			bg.alpha = alphaUnSel;
			c.addChild(bg);
			
			
			var image:Image = new Image(t);
			c.addChild(image);
			
			var clip:Rectangle = new Rectangle();
			clip.x = bg.x;
			clip.y = bg.y;
			clip.width = r.width;
			clip.height = r.height;
			
			c.clipRect = clip;
			
			c.x = frame.x;
			c.y = frame.y;
			
			addChild(c);
			
			this.name = _name;
			if(r.width>max || r.height>max){
				var b:Number;
				if(r.width>r.height){
					b = max/r.width;
				}else{
					b = max/r.height;
				}
				scaleX = b;
				scaleY = b;
			}
			
			addEventListener(TouchEvent.TOUCH,onT);
		}
		
		private function onT(e:TouchEvent):void
		{
			var t:Touch;
			t = e.getTouch(this,TouchPhase.BEGAN);
			if(t){
				lastX = t.globalX;
				lastY = t.globalY;
				return;
			}
			t = null;
			t = e.getTouch(this,TouchPhase.ENDED);
			if(t){
				if(Math.abs(t.globalX-lastX)<10){
					if(Math.abs(t.globalY-lastY)<10){
						if(hasSel){
							sel(false);
						}else{
							sel(true);
						}
					}
				}
			}
		}
		
		private function sel(yes:Boolean):void
		{
			this.hasSel = yes;
			if(!selIcon){
				selIcon = new Image(ActionEditor.theme.atlas.getTexture("picker-list-item-selected-icon"));
				selIcon.x = bg.width-selIcon.width;
				selIcon.y = bg.height-selIcon.height;
				addChild(selIcon);
			}
			selIcon.visible = yes? true:false;
			bg.alpha = yes? alphaSel:alphaUnSel;
		}
	}
}