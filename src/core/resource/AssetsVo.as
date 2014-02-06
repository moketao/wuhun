package core.resource {
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public class AssetsVo {
		public var assetsId:int; //有可能是化身的资源id 也有可能是技能的资源id

		public var acitonId2BitmapVerDic:Dictionary; //化身用
		public var acitonId2XYArrDic:Dictionary; //化身用

		public var bitmapDataVer:Vector.<BitmapData>; //化身用
		public var XYVer:Vector.<Vector.<int>>; //化身用

		public var old:int; //过时度

		public var enchantingLv:int; //附魔等级  7=b   11=c   15=d
	}
}
