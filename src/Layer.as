package
{
	import starling.display.Sprite;
	
	public class Layer extends Sprite
	{
		public var w:int;
		public var h:int;
		public var isMain:Boolean;
		public function Layer(p:Scene,ob:Object)
		{
			w = ob.w;
			h = ob.h;
			isMain = ob.isMain;
			for (var i:int = 0; i < ob.pics.length; i++) {
				var pob:Object = ob.pics[i];
				new Pic(this,pob.name,pob.x,pob.y);
			}
			p.addChild(this);
		}
		public function move(bfb:Number):void{
			var mx:Number = w*bfb;
			x = -mx;
		}
	}
}