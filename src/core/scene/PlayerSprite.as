package core.scene {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	import core.interfaces.ITicker;
	import core.load.AssetsDataManager;

	import core.resource.AssetsVo;

	public class PlayerSprite extends Sprite implements ITicker {
		public var bodySprite:Sprite;
		public var allSprite:Sprite;
		private var playerBitmap:Bitmap;

		private var a:AssetsVo;

		public function PlayerSprite() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
			allSprite=new Sprite();
			bodySprite=new Sprite();
			playerBitmap=new Bitmap();
			bodySprite.addChild(playerBitmap);
			allSprite.addChild(bodySprite);
			addChild(allSprite);
			var assetsVo:AssetsVo=AssetsDataManager.getInstance().getAssets_AVATAR(200, 1);

			//显示
			var d:AssetsDataManager=AssetsDataManager.getInstance();
			a=d.getAssets_AVATAR(200, 1);
			startTick();
		}

		public function startTick():void {
			Game.ticker.addTicker(this);
		}

		public function stopTick():void {
			Game.ticker.removeTicker(this);
		}
		private var actionID:int=1;
		private var frameID:int=0;
		private static var frameSkipDefault:int=2;
		private var frameSkip:int=0;

		public function tick(tickCount:uint):void {
			if (canSkip())
				return;

			frameID++;
			if (frameID >= 36)
				frameID=0;

			var bd:BitmapData=a.acitonId2BitmapVerDic[actionID][frameID];
			if (playerBitmap.bitmapData == bd)
				return;

			playerBitmap.bitmapData=bd;
			playerBitmap.x=a.acitonId2XYArrDic[actionID][frameID][0];
			playerBitmap.y=a.acitonId2XYArrDic[actionID][frameID][1];
		}

		private function canSkip():Boolean {
			frameSkip--;
			if (frameSkip > 0) {
				return true;
			} else {
				frameSkip=frameSkipDefault;
			}
			return false;
		}

		public function clear():void {
		}
	}
}

