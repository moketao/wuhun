package
{
	import flash.geom.Point;
	
	import starling.display.Sprite;
	
	public class Scene extends Sprite
	{

		public var mainLayer:Layer;
		public var layers:Vector.<Layer>;
		public function Scene()
		{
			layers = new Vector.<Layer>();
		}
		
		public function parse(mapOB:Object):void
		{
			if(numChildren)removeChildren(0,-1,true);
			var layerArr:Array = mapOB.layers;
			for (var i:int = 0; i < layerArr.length; i++) {
				var lob:Object = layerArr[i];
				var layer:Layer = new Layer(this,lob);
				layers.push(layer);
				if(layer.isMain) mainLayer = layer;
			}
		}
		
		public function moveLayers(cameraPos:Point,mainLayerW:int):void
		{
			var bfb:Number = cameraPos.x/mainLayerW;
			for (var i:int = 0; i < layers.length; i++) {
				layers[i].move(bfb);
			}
			
		}
	}
}