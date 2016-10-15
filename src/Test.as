package
{
	import flash.display.Sprite;
	
	import starling.core.Starling;
	import tmp.TestRoot;
	
	public class Test extends Sprite
	{
		public function Test()
		{
			var s:Starling = new Starling(TestRoot,stage);
			s.start();
		}
	}
}