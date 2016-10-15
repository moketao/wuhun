package
{
	import flash.geom.Point;
	
	import feathers.controls.Header;
	import feathers.controls.Panel;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class XDragPanel extends Panel
	{
		private var isDrag:Boolean;
		private var p:Point = new Point();
		public function XDragPanel(titleStr:String)
		{
			super();
			this.headerProperties.title = titleStr;
			var me:XDragPanel = this;
			this.headerFactory = function():Header
			{
				var header:Header = new Header();
				header.addEventListener(TouchEvent.TOUCH,function(e:TouchEvent):void{
					
					var t:Touch;
					t = e.getTouch(header,TouchPhase.BEGAN);
					if(t){
						isDrag = true;
					}
					
					t = null;
					t = e.getTouch(header,TouchPhase.MOVED);
					if(t && isDrag){
						t.getMovement(me.parent,p);
						me.x += p.x;
						me.y += p.y;
					}
					
					t = null;
					t = e.getTouch(header,TouchPhase.ENDED);
					if(t){
						isDrag = false;
					}
				});
				return header;
			}
		}
	}
}