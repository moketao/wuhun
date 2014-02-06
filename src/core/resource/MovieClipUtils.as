package core.resource {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.setTimeout;

	import core.interfaces.ITicker;

	public class MovieClipUtils implements ITicker {
		private static var _instance:MovieClipUtils;
		private var targetMc:MovieClip;

		public function MovieClipUtils() {
		}

		public static function getInstance():MovieClipUtils {
			return _instance=_instance || new MovieClipUtils();
		}

		/**
		 * mc是name的根或者子级
		 */
		public static function getDefinition(mc:MovieClip, name:String):* {
			if (mc == null) {
				return null;
			}
			if (name == null || name == "") {
				return mc;
			}
			var object:Object;
			try {
				object=mc.loaderInfo.loader.contentLoaderInfo.applicationDomain.getDefinition(name);
			} catch (error:Error) {

			}
			mc.stop();
			if (object != null) {
				return new object();
			};
			var displayObject:DisplayObject=mc.getChildByName(name);
			if (displayObject != null) {
				return displayObject;
			};
			if (mc.numChildren > 0) {
				displayObject=(mc.getChildAt(0) as DisplayObjectContainer).getChildByName(name);
			};
			return displayObject;
		}

		public static function getBitmapData(mc:MovieClip, name:String):BitmapData {
			if (mc == null) {
				return null;
			}
			if (name == null || name == "") {
				return null;
			}
			var object:Object;
			try {
				object=mc.loaderInfo.loader.contentLoaderInfo.applicationDomain.getDefinition(name);
			} catch (error:Error) {

			}
			mc.stop();
			if (object != null) {
				return new object();
			};

			return null;
		}

		private var bPlayOver:Boolean;
		private var count:int;

		/**
		 * MC播放
		 * @param mc
		 * @param isLoop 是否循环播放
		 * @param isOver 是否一定要全部播放完
		 */
		public function playMc(mc:MovieClip, isLoop:Boolean, isOver:Boolean):void {
			if (count != 0) {
				if (bPlayOver == true) {
					targetMc=mc;
					if (isLoop == false) {
						targetMc.gotoAndPlay(1);
						startTick();
					}
				} else {
					if (isOver == false) {
						if (targetMc != mc) {
							targetMc.gotoAndStop(1);
							targetMc=mc;
							targetMc.gotoAndPlay(1);
							startTick();
						}
					} else {
						mc.gotoAndStop(mc.totalFrames);
					}
				}
			} else {
				targetMc=mc;
				if (isLoop == false) {
					targetMc.gotoAndPlay(1);
					startTick();
				}
			}
			count++;
		}

		public static function drawBorder(displayObj:DisplayObject, lineHeight:int=5, color:int=0xFFFF00):void {
			setTimeout(function():void {
				if (displayObj is DisplayObjectContainer) {
					drawContainerBorder(displayObj as DisplayObjectContainer, lineHeight, color);
				} else {
					var sprite:Sprite=new Sprite();
					var x:Number=displayObj.x;
					var y:Number=displayObj.y;
					var width:Number=displayObj.width;
					var height:Number=displayObj.height;
					displayObj.parent.addChild(sprite);
					sprite.x=x;
					sprite.y=y;
					sprite.addChild(displayObj);
					displayObj.x=0;
					displayObj.y=0;
					sprite.width=width;
					sprite.height=height;
					drawContainerBorder(sprite, lineHeight, color);
				}
			}, 2000);
		}

		private static function drawContainerBorder(container:DisplayObjectContainer, lineHeight:int=5, color:int=0xFFFF00):void {
			var width:Number=container.width;
			var height:Number=container.height;
			if (0 == width || 0 == height) {
				throw new Error("该对象的 宽：" + width + ", 高：" + height + ", 无法绘制边界.");
			}
			var topBorderSprite:Sprite=new Sprite();
			topBorderSprite.graphics.beginFill(color);
			topBorderSprite.graphics.drawRect(0, 0, width, lineHeight);
			topBorderSprite.graphics.endFill();
			container.addChild(topBorderSprite);

			var bottomBorderSprite:Sprite=new Sprite();
			bottomBorderSprite.graphics.beginFill(color);
			bottomBorderSprite.graphics.drawRect(0, height - lineHeight, width, lineHeight);
			bottomBorderSprite.graphics.endFill();
			container.addChild(bottomBorderSprite);

			var leftBorderSprite:Sprite=new Sprite();
			leftBorderSprite.graphics.beginFill(color);
			leftBorderSprite.graphics.drawRect(0, 0, lineHeight, height);
			leftBorderSprite.graphics.endFill();
			container.addChild(leftBorderSprite);

			var rightBorderSprite:Sprite=new Sprite();
			rightBorderSprite.graphics.beginFill(color);
			rightBorderSprite.graphics.drawRect(width - lineHeight, 0, lineHeight, height);
			rightBorderSprite.graphics.endFill();
			container.addChild(rightBorderSprite);
		}

		public function startTick():void {
			Game.ticker.addTicker(this);
		}

		public function stopTick():void {
			Game.ticker.removeTicker(this);
		}

		public function tick(tickerCount:uint):void {
			bPlayOver=false;
			if (targetMc != null && targetMc.currentFrame == targetMc.totalFrames) {
				bPlayOver=true;
				targetMc.gotoAndStop(targetMc.totalFrames);
				stopTick();
			}
		}
	}
}
