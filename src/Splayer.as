package
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Splayer extends Image
	{
		[Embed(source="sample-sprite.png")]
		private const PLAYER:Class;
		public function Splayer()
		{
			var texture:Texture = Texture.fromBitmap(new PLAYER());
			super(texture);
		}
	}
}