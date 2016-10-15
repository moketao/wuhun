package {
	import flash.net.SharedObject;
	
	import loading.Res;

	public class G {
		public static var IS_DEBUG:Boolean = false;
		public static var IN_PHONE:Boolean = false;
		public static const MAX_STAGE_WIDTH:int=1400;
		public static const MIN_STAGE_WIDTH:int=1000;
		public static const MAX_STAGE_HEIGHT:int=600;
		public static const MIN_STAGE_HEIGHT:int=450;
		public static var StoryNow:Boolean;
		public static var DEFAULT_NAME:String="无名";
		public static var FONT:String="宋体";
		public static var FRAME_RATE:int=25;
		public static var Platform:String="QQ";
		public static var hostUrl:String="";
		public static var recharge:String;
		public static var speed:Number = 8;
		public static var res:Res = new Res();
		
		public static function SO(key:String, val:*=null):*
		{
			var so:SharedObject = SharedObject.getLocal("wuhun");
			if(val!=null) so.data[key] = val;
			return so.data[key];
		}
		public function G() {
		}
	}
}
