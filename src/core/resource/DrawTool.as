package core.resource {
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class DrawTool {
		public function DrawTool() {
		}

		/**
		 * 绘制
		 */
		public static function draw(mc:MovieClip, loader:Loader):Array {
			var bitmapDataVer:Vector.<BitmapData>=new Vector.<BitmapData>(mc.totalFrames, true);
			var xyVer:Vector.<Vector.<int>>=new Vector.<Vector.<int>>(mc.totalFrames, true);
			var mcNameArr:Array=mc.currentLabels;

			Game.stage.quality=StageQuality.HIGH;
			for each (var frameLabel:FrameLabel in mcNameArr) {
				var strArr:Array=frameLabel.name.split('%');
				var tempFrameLabelArr:Array;
				var bitmapData:BitmapData=null;
				if (strArr.length == 2) //如果找到了   
				{
					bitmapData=new (loader.contentLoaderInfo.applicationDomain.getDefinition(strArr[0]) as Class);
					tempFrameLabelArr=(strArr[1] as String).split(',');
				} else {
					tempFrameLabelArr=(strArr[0] as String).split(',');
				}
				var frameArr:Vector.<int>=new Vector.<int>(); //帧标签
				for each (var tempStr:String in tempFrameLabelArr) {
					var searchIndex:int=tempStr.search('-');
					if (searchIndex == -1) //如果没有-符号
					{
						frameArr.push(int(tempStr));
					} else //如果有
					{
						var fanweiArr:Array=tempStr.split('-');
						var startindex:int=fanweiArr[0];
						while (startindex <= fanweiArr[1]) {
							frameArr.push(int(startindex));
							startindex++;
						}
					}
				}

				mc.gotoAndStop(frameLabel.name);

				var rect:Rectangle=mc.getBounds(mc);
				var x:int=Math.round(rect.x); //mc相对于bitmap 的位置
				var y:int=Math.round(rect.y);

				if (bitmapData == null) {
					bitmapData=new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0);
					bitmapData.draw(mc, new Matrix(1, 0, 0, 1, -x, -y)); //无论原件的中心点在何位置，将渲染好的图像中心点置于左上
				}

				var ver:Vector.<int>=new Vector.<int>(2, true);
				ver[0]=x;
				ver[1]=y;

				for each (var index:int in frameArr) {
					bitmapDataVer[index - 1]=bitmapData;
					xyVer[index - 1]=ver;
				}
			}
			Game.stage.quality=StageQuality.LOW;
			return [bitmapDataVer, xyVer];
		}
	}
}
