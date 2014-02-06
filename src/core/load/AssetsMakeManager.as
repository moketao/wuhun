package core.load {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.Dictionary;

	import core.resource.DrawTool;
	import core.resource.AssetsVo;
	import core.resource.MakeVo;
	import core.resource.ConstValue;

	public class AssetsMakeManager {
		private static var instance:AssetsMakeManager;
		private static var allMcNameVer:Vector.<String>;
		public var nowMakeVo:MakeVo;
		private var loader:Loader;

		public function AssetsMakeManager() {
			if (allMcNameVer == null) {
				allMcNameVer=new Vector.<String>();
				allMcNameVer.push('WALK');
				allMcNameVer.push('UNATTACKUP');
				allMcNameVer.push('UNATTACKFLY');
				allMcNameVer.push('UNATTACK');
				allMcNameVer.push('RUNATTACK');
				allMcNameVer.push('RUN');
				allMcNameVer.push('JUMPATTACK');
				allMcNameVer.push('JUMP');
				allMcNameVer.push('IDLE');
				allMcNameVer.push('EFFECT5');
				allMcNameVer.push('EFFECT4');
				allMcNameVer.push('EFFECT3');
				allMcNameVer.push('EFFECT2');
				allMcNameVer.push('EFFECT1');
				allMcNameVer.push('DEAD');
				allMcNameVer.push('ATTACK4');
				allMcNameVer.push('ATTACK3');
				allMcNameVer.push('ATTACK2');
				allMcNameVer.push('ATTACK1');
				allMcNameVer.push('MAGIC');
			}
			loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			throw new Error(nowMakeVo.assetsType + ':' + nowMakeVo.assetsId + L("有问题"));
		}

		public static function getInstance():AssetsMakeManager {
			if (instance == null) {
				instance=new AssetsMakeManager();
			}
			return instance;
		}

		/**
		 * 添加将要处理的资源
		 */
		public function pushWillMake(makeVo:MakeVo):void {
			AssetsLoaderListManager.getInstance().pushMakeVo(makeVo);
			checkMake();
		}

		/**
		 * 检查并处理
		 */
		private function checkMake():void {
			if (nowMakeVo == null && AssetsLoaderListManager.getInstance().getMakeVoLength() > 0) {
				nowMakeVo=AssetsLoaderListManager.getInstance().getMakeVo();
				loader.loadBytes(nowMakeVo.byteArray);
			}
		}

		/**
		 * 加载完成
		 */
		private function completeHandler(event:Event):void {
			if (loader.loaderInfo != null && loader.loaderInfo.bytes != null) {
				for (var i:int=0; i < 3; i++) {
					loader.loaderInfo.bytes[i]=int(Math.random() * 10);
				}
			}
			if (nowMakeVo.assetsType == AssetsLoaderManager.AVATAR) {
				makeAvatar();
			} else if (nowMakeVo.assetsType == AssetsLoaderManager.SKILL) {
				makeSkill();
			} else if (nowMakeVo.assetsType == AssetsLoaderManager.ENCHANTMENT) {
				makeEnchantment();
			}
		}

		/**
		 * 开始处理附魔资源
		 */
		private function makeEnchantment():void {
			var acitonId2BitmapVerDic:Dictionary=new Dictionary();
			var acitonId2XYArrDic:Dictionary=new Dictionary();

			for each (var className:String in allMcNameVer) {
				if (loader.contentLoaderInfo.applicationDomain.hasDefinition(className)) {
					var c:Class=loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
					var mc:MovieClip=new c();
					var arr:Array=DrawTool.draw(mc, loader);
					var targetArr:Array=getTargetArr(className);
					for each (var targetId:int in targetArr) {
						acitonId2BitmapVerDic[targetId]=arr[0];
						acitonId2XYArrDic[targetId]=arr[1];
					}
				}
			}

			//保存起来
			var assetsVo:AssetsVo=new AssetsVo();
			assetsVo.assetsId=nowMakeVo.assetsId;
			assetsVo.acitonId2BitmapVerDic=acitonId2BitmapVerDic;
			assetsVo.acitonId2XYArrDic=acitonId2XYArrDic;
			AssetsDataManager.getInstance().save(AssetsLoaderManager.ENCHANTMENT, assetsVo);

			acitonId2BitmapVerDic=null;
			acitonId2XYArrDic=null;
			nowMakeVo=null;
			checkMake();
		}

		/**
		 * 开始处理化身
		 */
		private function makeAvatar():void {
			var acitonId2BitmapVerDic:Dictionary=new Dictionary();
			var acitonId2XYArrDic:Dictionary=new Dictionary();

			for each (var className:String in allMcNameVer) {
				if (loader.contentLoaderInfo.applicationDomain.hasDefinition(className)) {
					var c:Class=loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
					var mc:MovieClip=new c();
					var arr:Array=DrawTool.draw(mc, loader);
					var targetArr:Array=getTargetArr(className);
					for each (var targetId:int in targetArr) {
						acitonId2BitmapVerDic[targetId]=arr[0];
						acitonId2XYArrDic[targetId]=arr[1];
					}
				}
			}

			//保存起来
			var assetsVo:AssetsVo=new AssetsVo();
			assetsVo.assetsId=nowMakeVo.assetsId;
			assetsVo.acitonId2BitmapVerDic=acitonId2BitmapVerDic;
			assetsVo.acitonId2XYArrDic=acitonId2XYArrDic;
			AssetsDataManager.getInstance().save(AssetsLoaderManager.AVATAR, assetsVo);

			acitonId2BitmapVerDic=null;
			acitonId2XYArrDic=null;
			nowMakeVo=null;
			checkMake();
		}

		/**
		 * 开始处理技能
		 */
		private function makeSkill():void {
			var c:Class=loader.contentLoaderInfo.applicationDomain.getDefinition('EFFECTBODY') as Class;
			var arr:Array=DrawTool.draw(new c(), loader);

			//保存起来
			var assetsVo:AssetsVo=new AssetsVo();
			assetsVo.assetsId=nowMakeVo.assetsId;
			assetsVo.bitmapDataVer=arr[0];
			assetsVo.XYVer=arr[1];
			AssetsDataManager.getInstance().save(AssetsLoaderManager.SKILL, assetsVo);

			nowMakeVo=null;
			checkMake();
		}

		private function getTargetArr(className:String):Array {
			switch (className) {
				case 'WALK':
					return [ConstValue.ACTION_WALK];
				case 'UNATTACKUP':
					return [ConstValue.ACTION_UNATTACKUP];
				case 'UNATTACKFLY':
					return [ConstValue.ACTION_UNATTACKFLY];
				case 'UNATTACK':
					return [ConstValue.ACTION_UNATTACK];
				case 'RUNATTACK':
					return [ConstValue.ACTION_RUNATTACK];
				case 'RUN':
					return [ConstValue.ACTION_RUN];
				case 'JUMPATTACK':
					return [ConstValue.ACTION_JUMPATTACK_WALK, ConstValue.ACTION_JUMPATTACK_RUN];
				case 'JUMP':
					return [ConstValue.ACTION_JUMP_WALK, ConstValue.ACTION_JUMP_DOUBLE_RUN, ConstValue.ACTION_JUMP_DOUBLE_WALK, ConstValue.ACTION_JUMP_RUN, ConstValue.ACTION_DOWN_WALK, ConstValue.ACTION_DOWN_RUN];
				case 'IDLE':
					return [ConstValue.ACTION_IDLE];
				case 'EFFECT5':
					return [ConstValue.ACTION_EFFECT5_WALK, ConstValue.ACTION_EFFECT5_RUN, ConstValue.ACTION_EFFECT5_JUMP];
				case 'EFFECT4':
					return [ConstValue.ACTION_EFFECT4_WALK, ConstValue.ACTION_EFFECT4_RUN, ConstValue.ACTION_EFFECT4_JUMP];
				case 'EFFECT3':
					return [ConstValue.ACTION_EFFECT3_WALK, ConstValue.ACTION_EFFECT3_RUN, ConstValue.ACTION_EFFECT3_JUMP];
				case 'EFFECT2':
					return [ConstValue.ACTION_EFFECT2_WALK, ConstValue.ACTION_EFFECT2_RUN, ConstValue.ACTION_EFFECT2_JUMP];
				case 'EFFECT1':
					return [ConstValue.ACTION_EFFECT1_WALK, ConstValue.ACTION_EFFECT1_RUN, ConstValue.ACTION_EFFECT1_JUMP];
				case 'DEAD':
					return [ConstValue.ACTION_DEAD];
				case 'ATTACK4':
					return [ConstValue.ACTION_ATTACK4];
				case 'ATTACK3':
					return [ConstValue.ACTION_ATTACK3];
				case 'ATTACK2':
					return [ConstValue.ACTION_ATTACK2];
				case 'ATTACK1':
					return [ConstValue.ACTION_ATTACK1];
				case 'MAGIC':
					return [ConstValue.ACTION_MAGIC];
			}
			return null;
		}

		public function dispose():void {
		}
	}
}
