package tmp
{
	import feathers.themes.MetalWorksMobileTheme2;
	
	import starling.display.Sprite;
	
	public class TestRoot extends Sprite
	{
		public function TestRoot()
		{
			new MetalWorksMobileTheme2(false);
			
			var p:XDragPanel = new XDragPanel("test");
			p.setSize(300,100);
			addChild(p);
		}
	}
}