package {
	import flash.display.Sprite;
	import flash.display.Stage;
	import core.View;
	public class Layer {
		public static var one:Layer;

		private static var rootSprite:Sprite;
		public static const TOP_LAYER:int	=5;
		public static const TIPS_LAYER:int	=4;
		public static const ALERT_LAYER:int	=3;
		public static const UI_LAYER:int	=2;
		public static const MAINUI_LAYER:int=1;
		public static const SCENE_LAYER:int	=0;
		public static const typeArr:Array = [SCENE_LAYER,MAINUI_LAYER,UI_LAYER,ALERT_LAYER,TIPS_LAYER,TOP_LAYER];
		public static var layerArr:Array = [];
		public function Layer() {
			if (one != null) {
				throw new Error("use LayerManager getInstance");
			}
		}

		public static function init(layer:Sprite):void {
			rootSprite=layer;
			Layer.getInstance();
			for (var i:int = 0; i < typeArr.length; i++) {
				var s:Sprite = new Sprite();
					layerArr.push(s);
					rootSprite.addChild(s);
			}
		}

		public static function getInstance():Layer {
			if (one == null) {
				one=new Layer();
			}
			return one;
		}

		public static function Resize():void {
			var stage:Stage=rootSprite.stage;
			//todo:
		}

		public static function add(v:View):void {
			var type:int = v.layerType;
		}

		public static function toTop(v:View):void {
			v.parent.addChild(v);
		}

		public static function getLayer(type:int):Sprite {
			return layerArr[type];
		}
	}
}
