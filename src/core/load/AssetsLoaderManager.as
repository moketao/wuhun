package core.load {
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import core.resource.ResourceManager;
	import core.resource.LoaderVo;
	import core.resource.MakeVo;

	public class AssetsLoaderManager {
		private static var instance:AssetsLoaderManager;
		public static const AVATAR:int=1; //人物资源
		public static const SKILL:int=2; //技能资源
		public static const ENCHANTMENT:int=3; //附魔资源
		public var nowLoaderVo:LoaderVo; //正在加载的资源
		private var urlLoader:URLLoader;
		private var timer:Timer;
		public var avatarExist:Dictionary; //已存在的化身(包括正在加载的和已经处理好的)
		public var skillExist:Dictionary; //已存在的技能
		public var enchantmentExist:Dictionary; //已存在的附魔

		public function AssetsLoaderManager() {
			avatarExist=new Dictionary();
			skillExist=new Dictionary();
			enchantmentExist=new Dictionary();

			urlLoader=new URLLoader();
			urlLoader.dataFormat=URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

			timer=new Timer(15000, 0); //5秒钟没有任何数据
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}

		public static function getInstance():AssetsLoaderManager {
			if (instance == null) {
				instance=new AssetsLoaderManager();
			}
			return instance;
		}

		public function myload():void {
			//body
			pushLoader_AVATAR(200);

			//skill
			var loaderVo:LoaderVo=new LoaderVo();
			loaderVo.assetsType=SKILL;
			loaderVo.assetsId=3;
			AssetsLoaderListManager.getInstance().pushLoader(loaderVo);

			//load
			checkLoader();
		}

		/**
		 * 将需要加载的资源放入列队(化身)
		 */
		private function pushLoader_AVATAR(assetsId:int):void {
			if (avatarExist[assetsId] != null) {
				return;
			} else {
				avatarExist[assetsId]=assetsId;
			}

			var loaderVo:LoaderVo=new LoaderVo();
			loaderVo.assetsType=AVATAR;
			loaderVo.assetsId=assetsId;

			AssetsLoaderListManager.getInstance().pushLoader(loaderVo);
		}

		/**
		 * 将需要加载的资源放入列队(附魔)
		 */
		private function pushLoader_Enchanting(avatarId:int, enemyId:int):void {
			var id:String;
				id=avatarId + '';//todo:处理特效

			if (enchantmentExist[id] != null) {
				return;
			} else {
				enchantmentExist[id]=id;
			}

			var loaderVo:LoaderVo=new LoaderVo();
			loaderVo.assetsType=ENCHANTMENT;
			loaderVo.assetsId=avatarId;
			loaderVo.enemyId=enemyId;

			AssetsLoaderListManager.getInstance().pushLoader(loaderVo);
		}

		/**
		 * 检查是不是有资源可以加载
		 */
		private function checkLoader():void {
			if (nowLoaderVo == null) //没有正在加载的资源
			{
				if (AssetsLoaderListManager.getInstance().getAvatarLoaderLength() > 0) {
					nowLoaderVo=AssetsLoaderListManager.getInstance().getAvatarLoaderVo();
					urlLoader.load(new URLRequest(ResourceManager.m_strDevice + 'data/player/' + nowLoaderVo.assetsId + '.swf'));
					timer.start();
					return;
				} else if (AssetsLoaderListManager.getInstance().getEnchantmentLoaderLength() > 0) {
					nowLoaderVo=AssetsLoaderListManager.getInstance().getEnchantmentLoaderVo();
					var id:String;
					id=nowLoaderVo.assetsId.toString() + ''; //todo处理特效
					urlLoader.load(new URLRequest(ResourceManager.m_strDevice + 'player/' + id + '.swf?' + ResourceManager.getInstance().getVersion('player/' + id + '.swf')));
					timer.start();
					return;
				} else if (AssetsLoaderListManager.getInstance().getSkillLoaderLength() > 0) {
					nowLoaderVo=AssetsLoaderListManager.getInstance().getSkillLoaderVo(); //释放技能的ID 并不是资源id
					urlLoader.load(new URLRequest(ResourceManager.m_strDevice + 'data/effect/' + nowLoaderVo.assetsId + '.swf'));
					timer.start();
					return;
				}
			}
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			timer.stop();
			urlLoader.close();
			checkLoader();
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void {
			if (event.status == 404) {
				timer.stop();
				if (G.IS_DEBUG) {
					var str:String;
					if (nowLoaderVo.assetsType == 1) {
						str='化身' + nowLoaderVo.assetsId;
					} else if (nowLoaderVo.assetsType == 2) {
						str='技能' + nowLoaderVo.assetsId;
					}
					throw new Error('找伟东 没有这个资源 ' + str);
				}
			}
		}

		private function progressHandler(event:ProgressEvent):void {
			//BattleWillLoaderManager.getInstance().setLoaderProgress(event.bytesLoaded, event.bytesTotal, nowLoaderVo.assetsType);
			timer.stop();
			timer.start();
		}

		/**
		 * 加载完成
		 */
		private function completeHandler(event:Event):void {
			if (urlLoader.bytesLoaded != urlLoader.bytesTotal) {
				timer.stop();
				if (nowLoaderVo.assetsType == AVATAR) {
					//BattleWillLoaderManager.getInstance().makeComplete(AVATAR); //就当这个资源处理完了
				} else if (nowLoaderVo.assetsType == SKILL) {
					//BattleWillLoaderManager.getInstance().makeComplete(SKILL); //就当这个资源处理完了
				} else if (nowLoaderVo.assetsType == ENCHANTMENT) {
					//BattleWillLoaderManager.getInstance().makeComplete(ENCHANTMENT); //就当这个资源处理完了
				}
				nowLoaderVo=null;
				checkLoader();
				return;
			}
			timer.stop();
			var makeVo:MakeVo=new MakeVo();
			makeVo.byteArray=urlLoader.data as ByteArray;
			makeVo.assetsType=nowLoaderVo.assetsType;
			makeVo.assetsId=nowLoaderVo.assetsId;
			makeVo.enemyId=nowLoaderVo.enemyId;
			AssetsMakeManager.getInstance().pushWillMake(makeVo);
			nowLoaderVo=null;
			checkLoader();
		}

		/**
		 * 加载时间到 重新加载
		 */
		private function onTimer(event:TimerEvent):void {
			timer.stop();
			if (nowLoaderVo.assetsType == AVATAR) {
				urlLoader.load(new URLRequest(ResourceManager.m_strDevice + 'data/player/' + nowLoaderVo.assetsId + '_KAI.swf?' + ResourceManager.getInstance().getVersion('data/player/' + nowLoaderVo.assetsId + '_KAI.swf')));
				timer.start();
			} else if (nowLoaderVo.assetsType == SKILL) {
				urlLoader.load(new URLRequest(ResourceManager.m_strDevice + 'data/effect/' + nowLoaderVo.assetsId + '_KAI.swf?' + ResourceManager.getInstance().getVersion('data/effect/' + nowLoaderVo.assetsId + '_KAI.swf')));
				timer.start();
			} else if (nowLoaderVo.assetsType == ENCHANTMENT) {
				var id:String;
				id=nowLoaderVo.assetsId.toString() + ''; //todo:处理特效
				urlLoader.load(new URLRequest(ResourceManager.m_strDevice + 'player/' + id + '.swf?' + ResourceManager.getInstance().getVersion('player/' + id + '.swf')));
				timer.start();
			}
		}

		/**
		 * 选择角色后 马上加载
		 */
		public function initLoad(avatarId:int, isCreate:Boolean):void {
			if (isCreate) //如果是创建角色
			{
				pushLoader_AVATAR(avatarId);
				pushLoader_AVATAR(1131); //加载小兵
				checkLoader(); //检查一下
			}
		}

		public function dispose():void {
		}
	}
}
