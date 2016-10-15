package
{
	import flash.geom.Rectangle;
	
	import feathers.controls.NumericStepper;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class XTimeRule extends Sprite
	{

		private var maxPos:XDragSprite;

		private var step:NumericStepper;
		public function XTimeRule()
		{
			maxPos = new XDragSprite(null,true,false,new Rectangle(0,0,999,999));
			maxPos.addChild(new Quad(15,21,0x333333));
			maxPos.x = 728;
			maxPos.y = 1;
			maxPos.addEventListener(Event.COMPLETE,function(e:*):void{
				create();
			});
			
			step = new NumericStepper();
			step.minimum = 0;
			step.maximum = 10;
			step.step = 0.5;
			step.value = 4;//默认4秒
			step.x = 21;
			step.y = -2;
			
			maxPos.addChild(step);
			
			addChild(maxPos);
			
			create();
		}
		private var arr:Array = [];

		private var container:Sprite;
		private function create():void
		{
			if(!container){
				container = new Sprite(); addChild(container);
			}
			container.removeChildren(0,-1,true);
			arr = [];
			
			var num:Number = step.value*10+1;
			for (var i:int = 0; i < num; i++) {
				var h:int = 6;
				var color:uint = 0x777777;
				if(i%5==0){
					h = 13;
				}
				if(i%10==0){
					h = 20;
					color = 0x555555;
				}
				var q:Quad = new Quad(1,h,color);
				arr.push(q);
				container.addChild(q);
			}
			layout();
		}
		
		private function layout():void
		{
			var num:Number = step.value*10+1;
			var sp:Number = (maxPos.x-2)/num;
			for (var i:int = 0; i < arr.length; i++) {
				var h:int = 6;
				if(i%5==0) 	h = 13;
				if(i%10==0) h = 20;
				var q:Quad = arr[i] as Quad;
				q.x = int(Math.round(i*sp));
				q.y = 20-h;
			}
		}
		public function get timePerPixel():Number
		{
			return step.value/(maxPos.x-2);
		}
	}
}