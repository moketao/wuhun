package core.resource {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**
	 * 资源Utils
	 */
	public class ResourceUtils {
		public function ResourceUtils() {
		}

		public static function draw(mc:MovieClip):BitmapData {
			mc.gotoAndStop(1);
			var bmd:BitmapData=new BitmapData(mc.width, mc.height, true, 0xFFFFFF);
			bmd.draw(mc, null, null, null, null, true);
			return bmd;
		}

		public static function copySprite(sprite:DisplayObject):BitmapData {
			var bmd:BitmapData;
			if (sprite.width != 0 && sprite.height != 0) {
				bmd=new BitmapData(sprite.width, sprite.height, true, 0xFFFFFF);
				bmd.draw(sprite, null, null, null, null, true);
			} else {
				bmd=new BitmapData(1, 1, true, 0xFFFFFF);
			}
			return bmd;
		}

	}
}
