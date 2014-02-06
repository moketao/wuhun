package core.resource {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	public class ResourceConvert {
		public function ResourceConvert() {
		}

		private static function getFrameIndexList(frameStr:String):Array {
			var tempFrameLabelArr:Array;
			if (frameStr.search("-") != -1) {
				var startEndList:Array=frameStr.split("-");
				var startIndex:int=startEndList[0];
				var endIndex:int=startEndList[1];
				tempFrameLabelArr=[];
				for (var i:int=startIndex; i <= endIndex; i++) {
					tempFrameLabelArr.push(i);
				}
			} else {
				tempFrameLabelArr=frameStr.split(',');
			}
			return tempFrameLabelArr;
		}

		public static function fromMovieClip(applicationDomain:ApplicationDomain, movieClip:MovieClip, m_strResUrl:String, m_strLinkName:String, startFrame:int=0, endFrame:int=0):MovieClipData {
			Game.stage.quality=StageQuality.HIGH;
			if (startFrame == 0) {
				startFrame=1;
			}
			if (m_strResUrl == "icon/warsoul.swf") {
				movieClip=(movieClip.getChildAt(0) as MovieClip)
			}
			if (endFrame == 0) {
				endFrame=movieClip.totalFrames;
			}
			var mcNameArr:Array=movieClip.currentLabels;
			var frameMap:Dictionary=new Dictionary();
			var frameLinkNameDic:Dictionary=new Dictionary();
			var splitStr:String;
			for each (var frameLabel:FrameLabel in mcNameArr) {
				var frameArr:Vector.<int>=new Vector.<int>(); //有哪些帧用到了
				var tempFrameLabelArr:Array;
				var frameLinkName:String;
				if (frameLabel.name.search("%") != -1) {
					var frameLabelNameList:Array=frameLabel.name.split("%");
					frameLinkName=frameLabelNameList[0];
					splitStr=frameLabelNameList[1];
					tempFrameLabelArr=getFrameIndexList(splitStr);
					frameLinkNameDic[tempFrameLabelArr[0]]=frameLinkName;
				} else {
					tempFrameLabelArr=getFrameIndexList(frameLabel.name);
				}

				var length:int=tempFrameLabelArr.length;
				for (var k:int=1; k <= length; k++) {
					frameMap[tempFrameLabelArr[k]]=tempFrameLabelArr[0];
				}
			}

			var movieClipData:MovieClipData=new MovieClipData();
			var rect:Rectangle;
			for (var i:int=startFrame; i <= endFrame; i++) {
				movieClip.gotoAndStop(i);

				rect=movieClip.getBounds(movieClip);
				if (rect.height == 0 || rect.width == 0) {
					movieClipData.m_vectBitmapFrames.push(null);
				} else if (frameMap[i] != null) {
					movieClipData.m_vectBitmapFrames.push(movieClipData.m_vectBitmapFrames[frameMap[i] - 1]);
				} else {
					var bitmapFrame:BitmapFrame=new BitmapFrame();
					if (frameLinkNameDic[i]) {
						if (!applicationDomain.hasDefinition(frameLinkNameDic[i])) {
							throw new Error(m_strResUrl + L("缺少导出类") + frameLinkNameDic[i]);
						}
						var c:Class=applicationDomain.getDefinition(frameLinkNameDic[i]) as Class;
						bitmapFrame.bitmapData=new c();
					} else {
						bitmapFrame.bitmapData=new BitmapData(rect.width >> 0, rect.height >> 0, true, 0x00000000);
						bitmapFrame.bitmapData.draw(movieClip, new Matrix(1, 0, 0, 1, -rect.x >> 0, -rect.y >> 0), null, null, null, false);
					}

					bitmapFrame.rx=rect.x >> 0;
					bitmapFrame.ry=rect.y >> 0;
					movieClipData.m_vectBitmapFrames.push(bitmapFrame);
				}
			}
			stopAll(movieClip);
			frameMap=null;
			Game.stage.quality=StageQuality.LOW;
			return movieClipData;
		}

		/**
		 * 停止一个mc 包括里面嵌套的mc(递归)
		 * @param mc
		 */
		public static function stopAll(mc:MovieClip):void {
			mc.stop();
			for (var i:int=0; i < mc.numChildren; i++) {
				var displayObject:DisplayObject=mc.getChildAt(i) as DisplayObject;
				if (displayObject is MovieClip) {
					stopAll(displayObject as MovieClip);
				}
			}
		}
	}
}
