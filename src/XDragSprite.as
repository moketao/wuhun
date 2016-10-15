package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class XDragSprite extends Sprite
	{
		private var isDrag:Boolean;
		private var p:Point = new Point();
		private var moveInX:Boolean;
		private var moveInY:Boolean;
		private var limit:Rectangle;
		private var dragObject:DisplayObject;
		public function XDragSprite(dragObject:DisplayObject=null,moveInX:Boolean=true,moveInY:Boolean=true,limit:Rectangle=null)
		{
			this.dragObject = dragObject;
			if(!dragObject) this.dragObject = this;
			
			this.limit = limit;
			this.moveInY = moveInY;
			this.moveInX = moveInX;
			checkLimit();
			this.addEventListener(TouchEvent.TOUCH,onT);
		}
		
		private function onT(e:TouchEvent):void
		{
			var t:Touch;
			t = e.getTouch(this,TouchPhase.BEGAN);
			if(t){
				isDrag = true;
			}
			
			t = null;
			t = e.getTouch(this,TouchPhase.MOVED);
			if(t && isDrag){
				t.getMovement(dragObject.parent,p);
				if(moveInX)dragObject.x += p.x;
				if(moveInY)dragObject.y += p.y;
				checkLimit();
			}
			
			t = null;
			t = e.getTouch(this,TouchPhase.ENDED);
			if(t){
				isDrag = false;
				dispatchEventWith(Event.COMPLETE);//拖拽完成时发送事件
			}
		}
		
		private function checkLimit():void
		{
			if(limit){
				if(dragObject.x > limit.width) 	dragObject.x =limit.width;
				if(dragObject.x < limit.x) 		dragObject.x =limit.x;
				if(dragObject.y > limit.height) dragObject.y =limit.height;
				if(dragObject.y < limit.y) 		dragObject.y =limit.y;
			}
		}
	}
}