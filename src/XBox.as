package
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class XBox extends Sprite
	{
		private var bg:Quad;
		private var bg0:Quad;//上边
		private var bg1:Quad;//右边
		private var bg2:Quad;//下边
		private var bg3:Quad;//左边
		private var color:uint;
		private var borderColor:uint;
		private var _borderSize:uint=2;
		
		private var boderContainer:Sprite;
		
		public function get borderSize():uint
		{
			return _borderSize;
		}
		
		public function set borderSize(v:uint):void
		{
			_borderSize = v;
		}
		
		public function XBox(p:DisplayObjectContainer,width:Number, height:Number, color:uint=0xffffff, borderColor:uint=0xff0000)
		{
			this.borderColor = borderColor;
			this.color = color;
			bg = new Quad(width, height, color);
			boderContainer = new Sprite(); addChild(boderContainer);
			bg0 = new Quad(_borderSize, _borderSize, borderColor);
			bg1 = new Quad(_borderSize, _borderSize, borderColor);
			bg2 = new Quad(_borderSize, _borderSize, borderColor);
			bg3 = new Quad(_borderSize, _borderSize, borderColor);
			boderContainer.addChild(bg);
			boderContainer.addChild(bg0);
			boderContainer.addChild(bg1);
			boderContainer.addChild(bg2);
			boderContainer.addChild(bg3);
			bg.alpha = .5;
			boderContainer.alpha = .5;
			resize(width,height);
			p.addChild(this);
		}
		
		public function resize(ww:int,hh:int):void
		{
			bg.width = ww;
			bg.height = hh;
			layoutBorder();
		}
		
		private function layoutBorder():void
		{
			var w:Number = bg.width;
			var h:Number = bg.height;
			bg0.width = w;
			bg1.height = h; bg1.x=w-_borderSize;
			bg2.width = w; bg2.y=h-_borderSize;
			bg3.height = h;
		}
		public override function get width():Number
		{
			return super.width;
		}
		
		public override function set width(v:Number):void
		{
			bg.width = v;
			layoutBorder();
		}
		
		public override function get height():Number { 
			return bg.height;
		}
		
		public override function set height(v:Number):void
		{
			bg.height = v;
			layoutBorder();
		}
		
	}
}