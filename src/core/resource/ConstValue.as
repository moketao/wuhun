package core.resource {

	/**
	 * 静态常量值
	 * @author ZJK
	 */
	public class ConstValue {

		/**
		 * 待机
		 * @default
		 */
		public static const ACTION_IDLE:uint=1;
		/**
		 * 行走
		 * @default
		 */
		public static const ACTION_WALK:uint=2;
		/**
		 * 跑
		 * @default
		 */
		public static const ACTION_RUN:uint=3;
		/**
		 * 跑动攻击
		 * @default
		 */
		public static const ACTION_RUNATTACK:uint=4;
		/**
		 * 跳攻击
		 * @default
		 */
		public static const ACTION_JUMPATTACK_WALK:uint=5;
		/**
		 * 走跳
		 * @default
		 */
		public static const ACTION_JUMP_WALK:uint=6;
		/**
		 * 死亡
		 * @default
		 */
		public static const ACTION_DEAD:uint=7;
		/**
		 * 击飞
		 * @default
		 */
		public static const ACTION_UNATTACKFLY:uint=8;
		/**
		 * 爬起
		 * @default
		 */
		public static const ACTION_UNATTACKUP:uint=9;
		/**
		 * 击中
		 * @default
		 */
		public static const ACTION_UNATTACK:uint=10;
		/**
		 * 普通攻击 4
		 * @default
		 */
		public static const ACTION_ATTACK4:uint=11;
		/**
		 * 普通攻击 3
		 * @default
		 */
		public static const ACTION_ATTACK3:uint=12;
		/**
		 * 普通攻击 2
		 * @default
		 */
		public static const ACTION_ATTACK2:uint=13;
		/**
		 * 普通攻击 1
		 * @default
		 */
		public static const ACTION_ATTACK1:uint=14;
		/**
		 * 1-4 普通攻击
		 * @default
		 */
		public static const ACTION_ALL_ATTACK:uint=36;
		/**
		 * 技能攻击动作5
		 * @default
		 */
		public static const ACTION_EFFECT5_WALK:uint=15;
		/**
		 * 技能攻击动作4
		 * @default
		 */
		public static const ACTION_EFFECT4_WALK:uint=16;
		/**
		 * 技能攻击动作3
		 * @default
		 */
		public static const ACTION_EFFECT3_WALK:uint=17;
		/**
		 * 技能攻击动作2
		 * @default
		 */
		public static const ACTION_EFFECT2_WALK:uint=18;
		/**
		 * 技能攻击动作1
		 * @default
		 */
		public static const ACTION_EFFECT1_WALK:uint=19;
		/**
		 * 二段跳 走
		 * @default
		 */
		public static const ACTION_JUMP_DOUBLE_RUN:uint=20;
		/**
		 * 二段跳 跑
		 * @default
		 */
		public static const ACTION_JUMP_DOUBLE_WALK:uint=21;
		/**
		 * 跑跳
		 * @default
		 */
		public static const ACTION_JUMP_RUN:uint=22;
		/**
		 * 下坠动作
		 * @default
		 */
		public static const ACTION_DOWN_WALK:uint=23;
		/**
		 * 跳攻击
		 * @default
		 */
		public static const ACTION_JUMPATTACK_RUN:uint=24;
		/**
		 * 下坠动作
		 * @default
		 */
		public static const ACTION_DOWN_RUN:uint=25;
		/**
		 * 技能攻击动作5
		 * @default
		 */
		public static const ACTION_EFFECT5_RUN:uint=26;
		/**
		 * 技能攻击动作4
		 * @default
		 */
		public static const ACTION_EFFECT4_RUN:uint=27;
		/**
		 * 技能攻击动作3
		 * @default
		 */
		public static const ACTION_EFFECT3_RUN:uint=28;
		/**
		 * 技能攻击动作2
		 * @default
		 */
		public static const ACTION_EFFECT2_RUN:uint=29;
		/**
		 * 技能攻击动作1
		 * @default
		 */
		public static const ACTION_EFFECT1_RUN:uint=30;
		/**
		 * 技能攻击动作5
		 * @default
		 */
		public static const ACTION_EFFECT5_JUMP:uint=31;
		/**
		 * 技能攻击动作4
		 * @default
		 */
		public static const ACTION_EFFECT4_JUMP:uint=32;
		/**
		 * 技能攻击动作3
		 * @default
		 */
		public static const ACTION_EFFECT3_JUMP:uint=33;
		/**
		 * 技能攻击动作2
		 * @default
		 */
		public static const ACTION_EFFECT2_JUMP:uint=34;
		/**
		 * 技能攻击动作1
		 * @default
		 */
		public static const ACTION_EFFECT1_JUMP:uint=35;
		/**
		 * 灵珠
		 * @default
		 */
		public static const ACTION_MAGIC:uint=37;

		//__________________________________________________________________________________________________________________________________
		/**
		 * 按键方向
		 * @default
		 */
		public static const DIRECT_1:uint=1;
		/**
		 *
		 * @default
		 */
		public static const DIRECT_2:uint=2;
		/**
		 *
		 * @default
		 */
		public static const DIRECT_3:uint=3;
		/**
		 *
		 * @default
		 */
		public static const DIRECT_4:uint=4;
		/**
		 * 没有按键! 默认朝向
		 * @default
		 */
		public static const DIRECT_5:uint=5;
		/**
		 *
		 * @default
		 */
		public static const DIRECT_6:uint=6;
		/**
		 *
		 * @default
		 */
		public static const DIRECT_7:uint=7;
		/**
		 *
		 * @default
		 */
		public static const DIRECT_8:uint=8;
		/**
		 *
		 * @default
		 */
		public static const DIRECT_9:uint=9;
		//__________________________________________________________________________________________________________________________________

		/**
		 * 队伍 敌人
		 * @default
		 */
		public static const TEAM_ENEMY:int=1;
		/**
		 * 队伍 红队
		 * @default
		 */
		public static const TEAM_RED:int=2;
		/**
		 * 队伍 蓝队
		 * @default
		 */
		public static const TEAM_BLUE:int=3;

		//__________________________________________________________________________________________________________________________________
		/**
		 * 小怪
		 * @default
		 */
		public static const ITEM_TYPE_MONSTER:int=0;
		/**
		 * BOSS
		 * @default
		 */
		public static const ITEM_TYPE_BOSS:int=1;
		/**
		 * 精英
		 * @default
		 */
		public static const ITEM_TYPE_ELITE:int=2;
		/**
		 * 玩家
		 * @default
		 */
		public static const ITEM_TYPE_PLAYER:int=3;
		/**
		 * 佣兵
		 * @default
		 */
		public static const ITEM_TYPE_BABY:int=4;
		/**
		 * 剧情怪
		 * @default
		 */
		public static const ITEM_TYPE_STORY:int=5;
	}
}
