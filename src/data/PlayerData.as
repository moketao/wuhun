package data
{
	import flash.geom.Point;
	
	/**
	 * 动态类，运行时从服务端接收新的字段，加入其中。（策划临时需要添加的字段）
	 */
	dynamic public class PlayerData{
		/**
		 * 动态类，运行时从服务端接收新的字段，加入其中。（策划临时需要添加的字段）
		 */
		public function PlayerData(){}
		public var speed:Number;
		public var dir:Point = new Point();//角色的相对虚拟移动目标点（并非角度）
	}
}