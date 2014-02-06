package core.load {
	import flash.utils.Dictionary;

	import core.resource.AssetsVo;

	public class AssetsDataManager {
		private static var instance:AssetsDataManager;

		public var avatarDic:Dictionary; //战斗资源保存字典 <AssetsVo>
		public var skillDic:Dictionary; //技能资源保存字典 <AssetsVo>
		private var myPlayerAvatarId:int;
		private var myPlayerSkillIdArr:Array=[];

		public function AssetsDataManager() {
			avatarDic=new Dictionary();
			skillDic=new Dictionary();
		}

		public static function getInstance():AssetsDataManager {
			if (instance == null) {
				instance=new AssetsDataManager();
			}
			return instance;
		}

		/**
		 * 保存资源
		 */
		public function save(assetsType:int, assetsVo:AssetsVo):void {
			if (assetsType == AssetsLoaderManager.AVATAR) {
				avatarDic[assetsVo.assetsId]=assetsVo;
			} else
				(assetsType == AssetsLoaderManager.SKILL)
			{
				skillDic[assetsVo.assetsId]=assetsVo;
			}
		}

		/**
		 * 获取化身资源(附魔特效一共有3个地方需要检查 1:直接取资源的时候 2:化身资源加载完毕的时候 3:附魔特效加载完毕的时候)
		 */
		public function getAssets_AVATAR(assetsId:int, enchantingLv:int):AssetsVo {
			if (avatarDic[assetsId] != null) {
				var key:Object;

				var assetsVo:AssetsVo=avatarDic[assetsId];
				assetsVo.old=0;

				var tempAssetsVo:AssetsVo=new AssetsVo();
				tempAssetsVo.assetsId=assetsVo.assetsId;
				tempAssetsVo.old=assetsVo.old;
				tempAssetsVo.acitonId2XYArrDic=new Dictionary(); //assetsVo.acitonId2XYArrDic;
				tempAssetsVo.acitonId2BitmapVerDic=new Dictionary();
				for (key in assetsVo.acitonId2BitmapVerDic) {
					tempAssetsVo.acitonId2BitmapVerDic[key]=assetsVo.acitonId2BitmapVerDic[key];
				}
				for (key in assetsVo.acitonId2XYArrDic) {
					tempAssetsVo.acitonId2XYArrDic[key]=assetsVo.acitonId2XYArrDic[key];
				}
				return tempAssetsVo;
			} else {
				return null
			}
		}

		/**
		 * 获取技能资源
		 */
		public function getAssets_SKILL(assetsId:int):AssetsVo {
			if (skillDic[assetsId] != null) {
				(skillDic[assetsId] as AssetsVo).old=0;
				return skillDic[assetsId];
			} else {
				return null;
			}
		}

		/**
		 * 清理
		 */
		public function dispose():void {
			var assetsVo:AssetsVo;

			for each (assetsVo in avatarDic) {
				assetsVo.old++; //全部资源 过时度+1 
				if (assetsVo.old > 1) {
					//不卸载自己的资源
					if (assetsVo.assetsId != myPlayerAvatarId) {
						delete AssetsLoaderManager.getInstance().avatarExist[assetsVo.assetsId];
						delete avatarDic[assetsVo.assetsId];
						assetsVo.acitonId2BitmapVerDic=null;
						assetsVo.acitonId2XYArrDic=null;
						assetsVo.bitmapDataVer=null;
						assetsVo.XYVer=null;
					}
				}
			}

			//不卸载自己的资源
			var id:String;
			id=myPlayerAvatarId + ""; //todo:添加特效

			var skillArr:Array=myPlayerSkillIdArr;
			for each (assetsVo in skillDic) {
				assetsVo.old++; //全部资源 过时度+1  
				if (assetsVo.old > 1) {
					//不卸载自己的资源
					if (skillArr.indexOf(assetsVo.assetsId) == -1) {
						delete AssetsLoaderManager.getInstance().skillExist[assetsVo.assetsId];
						delete skillDic[assetsVo.assetsId];
						assetsVo.acitonId2BitmapVerDic=null;
						assetsVo.acitonId2XYArrDic=null;
						assetsVo.bitmapDataVer=null;
						assetsVo.XYVer=null;
					}
				}
			}
		}
	}
}
