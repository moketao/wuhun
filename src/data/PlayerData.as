package data
{
	
	
	/**
	 * 动态类，运行时从服务端接收新的字段，加入其中。（策划临时需要添加的字段）
	 */
	dynamic public class PlayerData{
		/**
		 * 动态类，运行时从服务端接收新的字段，加入其中。（策划临时需要添加的字段）
		 */
		public function PlayerData(){}
		public var SID:String;//角色的SID
		public var speed:Number;//临时记录的速度，由action决定，站立是0，跑动是2或者其它整数，可根据延迟误差做微调
		public var XX:Number;  //f32，横坐标
		public var ZZ:Number;  //f32，纵坐标
		public var YY:Number;  //f32，高度
		public var dir:Number;//角色的角度0~360（不是弧度）
		public var action:int;//角色的动作状态，参考ActionType这个类
	}
}