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
		
		public var flag:int;//是否需要强制更新各种，比如x，y，等等（本地记录，不需要从服务端获取，收到服务器讯息时设为1，update函数确定读取后，设置为0，这个值只对other有效，对me无用）
		public var lastAction:int;//角色的动作状态，参考ActionType这个类（本地的上次记录，不需要从服务端获取）
		public var lastDir:Number;//角色的动作状态，参考ActionType这个类（本地的上次记录，不需要从服务端获取）
		public var fixX:Number;//（本地的需要修正的X偏差量，不需要从服务端获取）
		public var fixZ:Number;//（本地的需要修正的Z偏差量，不需要从服务端获取）
	}
}