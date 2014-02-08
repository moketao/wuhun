package data
{
	
	/**
	 * 动态类，运行时从服务端接收新的字段，加入其中。（策划临时需要添加的字段）
	 */
	dynamic public class PlayerData
	{
		/**
		 * 动态类，运行时从服务端接收新的字段，加入其中。（策划临时需要添加的字段）
		 */
		public var speed:Number = G.SPEED;
		public var dir:Number = 0;//(0~360)
		public function PlayerData()
		{
		}
	}
}