package core.resource {
	import flash.display.BitmapData;

	public class BitmapFrame {


		public var rx:Number=0;
		public var ry:Number=0;
		public var bitmapData:BitmapData;

		public function BitmapFrame() {
		}

		public function dispose():void {
			if (bitmapData != null) {
				bitmapData.dispose();
			}
		}
	}
}
