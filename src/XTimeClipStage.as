package
{
	import feathers.controls.Panel;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;

	public class XTimeClipStage extends XDragPanel
	{
		private var pos:XTimePos;
		private var container:Sprite;
		public static var one:XTimeClipStage;

		private var rule:XTimeRule;
		public function XTimeClipStage(p:DisplayObjectContainer,titleStr:String,w:int,h:int)
		{
			one = this;
			super(titleStr);
			setSize(w,h);
			p.addChild(this);
			
			container = new Sprite(); addChild(container);
			container.y = 22;
			
			verticalScrollPolicy = Panel.SCROLL_POLICY_OFF;
			horizontalScrollPolicy = Panel.SCROLL_POLICY_OFF;
			
			rule = new XTimeRule();
			addChild(rule);
			
			pos = new XTimePos();
			addChild(pos);
		}
		public function getTime(c:XTimeClip):Number{
			return rule.timePerPixel*c.x;
		}
		public function addClips(clips:Array):void
		{
			var max:int = maxX();
			for (var i:int = 0; i < clips.length; i++) {
				var c:XTimeClip = clips[i] as XTimeClip;
				c.x = max+XTimeClip.defaultW*i;
				container.addChild(c);
			}
		}
		
		public function addClip(c:XTimeClip):void
		{
			var max:int = maxX();
			c.x = max+XTimeClip.defaultW;
			container.addChild(c);
		}
		
		private function maxX():int
		{
			var max:int;
			for (var i:int = 0; i < container.numChildren; i++) {
				var tmpx:Number = container.getChildAt(i).x;
				if(tmpx > max) max=tmpx;
			}
			return max
		}
		
		public function toJSON():String
		{
			var arr:Array = sortChild();
			
			var ob:Object = {};
			var out:Array = [];
			for (var i:int = 0; i < arr.length; i++) {
				var c:XTimeClip = arr[i] as XTimeClip;
				out.push(c.toJSONObject());
			}
			ob.arr = out;
			return JSON.stringify(ob,null,"\t");
		}
		
		private function sortChild():Array
		{
			var arr:Array = [];
			for (var i:int = 0; i < container.numChildren; i++) {
				var ob:DisplayObject = container.getChildAt(i);
				arr.push(ob);
			}
			arr.sort(sortFunction);
			return arr;
		}
		
		public function sortFunction(a:DisplayObject, b:DisplayObject):int
		{
			// TODO Auto Generated method stub
			if(a.x>b.x) return 1;
			if(a.x<b.x) return -1;
			return 0;
		}
	}
}