package
{
	import flash.display.BitmapData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Pic extends Sprite
	{
		public var fileName:String;
		public var url:String;
		public function Pic(p:Layer,fileName:String,xx:int,yy:int)
		{
			this.fileName = fileName;
			x = xx;
			y = yy;
			p.addChild(this);
			
			//加载
			url = G.hostUrl+fileName;
			G.res.load("test",[url],onLoad);
		}
		
		private function onLoad():void
		{
			var bd:BitmapData = G.res.loader.getBitmapData(url);
			var t:Texture = Texture.fromBitmapData(bd,false);
			var image:Image = new Image(t);
			addChild(image);
		}
	}
}