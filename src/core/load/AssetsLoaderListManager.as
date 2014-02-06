package core.load {
	import core.resource.LoaderVo;
	import core.resource.MakeVo;

	/**
	 * 加载列队数据管理者
	 * @author ZJK
	 */
	public class AssetsLoaderListManager {
		private static var instance:AssetsLoaderListManager;
		private var avatarWillLoaderVer:Vector.<LoaderVo>; //人物资源加载列队
		private var skillWillLoaderVer:Vector.<LoaderVo>; //技能资源加载列队
		private var enchantmentLoaderVer:Vector.<LoaderVo>; //附魔资源加载列队
		private var willMakeVer:Vector.<MakeVo>; //处理列队

		/**
		 *
		 */
		public function AssetsLoaderListManager() {
			avatarWillLoaderVer=new Vector.<LoaderVo>();
			skillWillLoaderVer=new Vector.<LoaderVo>();
			enchantmentLoaderVer=new Vector.<LoaderVo>();

			willMakeVer=new Vector.<MakeVo>();
		}

		/**
		 * 单例
		 * @return
		 */
		public static function getInstance():AssetsLoaderListManager {
			if (instance == null) {
				instance=new AssetsLoaderListManager();
			}
			return instance;
		}

		/**
		 * 放入加载列队
		 */
		public function pushLoader(loaderVo:LoaderVo):void {
			if (loaderVo.assetsType == AssetsLoaderManager.AVATAR) {
				avatarWillLoaderVer.push(loaderVo);
			} else if (loaderVo.assetsType == AssetsLoaderManager.SKILL) {
				skillWillLoaderVer.push(loaderVo);
			} else if (loaderVo.assetsType == AssetsLoaderManager.ENCHANTMENT) {
				enchantmentLoaderVer.push(loaderVo);
			}
		}

		/**
		 * 取一个将要加载的人身资源数组长度
		 */
		public function getAvatarLoaderLength():int {
			return avatarWillLoaderVer.length;
		}

		/**
		 * 取一个将要加载的技能资源数组长度
		 */
		public function getSkillLoaderLength():int {
			return skillWillLoaderVer.length;
		}

		/**
		 * 取一个将要加载的技能资源数组长度
		 */
		public function getEnchantmentLoaderLength():int {
			return enchantmentLoaderVer.length;
		}

		/**
		 * 取一个将要加载的LoaderVo
		 */
		public function getAvatarLoaderVo():LoaderVo {
			var loaderVo:LoaderVo=avatarWillLoaderVer.shift();
			return loaderVo;
		}

		/**
		 * 取一个将要加载的LoaderVo
		 */
		public function getSkillLoaderVo():LoaderVo {
			var loaderVo:LoaderVo=skillWillLoaderVer.shift();
			return loaderVo;
		}

		/**
		 * 取一个将要加载的LoaderVo
		 */
		public function getEnchantmentLoaderVo():LoaderVo {
			var loaderVo:LoaderVo=enchantmentLoaderVer.shift();
			return loaderVo;
		}
		
		/**
		 * 存放任务
		 */
		public function pushMakeVo(makeVo:MakeVo):void {
			willMakeVer.push(makeVo);
		}

		/**
		 * 取长度
		 */
		public function getMakeVoLength():int {
			return willMakeVer.length;
		}

		/**
		 * 取一个
		 */
		public function getMakeVo():MakeVo {
			var makeVo:MakeVo=willMakeVer.shift();
			return makeVo;
		}

	}
}
