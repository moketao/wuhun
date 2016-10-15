package
{
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	
	public class XTimeClip extends XDragSprite
	{
		public var img:XImg;
		public static var defaultW:int = 40;
		public function XTimeClip(ximg:XImg=null)
		{
			super(null,true,true,new Rectangle(0,0,999,150));
			var bg:Quad = new Quad(defaultW,20,0x000000); addChild(bg);
			
			if(ximg){
				name = ximg.name;
				img = ximg;
				img.x = 1;
				img.y = 1;
				addChild(img);
			}
		}
		
		public function toJSONObject():Object
		{
			var ob:Object = {};
			ob.name = name;
			ob.start = XTimeClipStage.one.getTime(this);
			return ob;
		}
	}
}