package
{
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	
	public class XTimePos extends XDragSprite
	{

		private var bg1:Quad;

		private var bg2:Quad;
		public function XTimePos()
		{
			super(null,true,false,new Rectangle(0,0,999,999));
			var color1:uint = 0x00dd00;
			var color2:uint = 0x009900;
			bg1 = new Quad(1,999,color1);
			bg2 = new Quad(30,20,color2);
			bg2.y = 1;
			bg1.alpha = .7;
			bg2.alpha = .3;
			addChild(bg2);
			addChild(bg1);
		}
	}
}