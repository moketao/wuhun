package main2
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.view.ACitrusCamera;
	import citrus.view.starlingview.StarlingCamera;
	
	public class GameState extends StarlingState
	{
		[Embed(source="../map01.txt", mimeType="application/octet-stream")]  
		public var txtCls:Class; 
		private var cam:ACitrusCamera;
		private var camBounds:Rectangle;
		private var movBounds:Rectangle;
		public static var main_parallax:Number = 1;
		public function GameState()
		{
			super();
		}
		override public function initialize():void{
			super.initialize();
			
			var byteDataTxt:ByteArray = new txtCls();  
			var str:String = byteDataTxt.readUTFBytes(byteDataTxt.bytesAvailable);
			var mapOB:Object = JSON.parse(str);
			
			
			camBounds = new Rectangle(0,  0,   2048, 400);
			movBounds = new Rectangle(20, 300, 2028, 400);
			
			var layers:Array = mapOB.layers;
			var mainLayer:Object;
			var mainLayerIndex:int;
			for (var k:int = 0; k < layers.length; k++) {
				if(layers[k].isMain){
					mainLayer = layers[k];
					mainLayerIndex = k;
					camBounds.width = mainLayer.w;
					movBounds.width = mainLayer.w-20;
					break;
				}
			}
			for (var i:int = 0; i < layers.length; i++) {
				var layer:Object = layers[i];
				var pics:Array = layer.pics;
				for (var j:int = 0; j < pics.length; j++) {
					var pic:Object = pics[j];
					var c:CitrusSprite = new CitrusSprite("ob"+i+""+j,{x:pic.x, y:pic.y ,view:G.hostUrl+pic.name});
					if(layer.isMain){
						c.parallaxX = main_parallax;
					}else{
						c.parallaxX = main_parallax+((k-i)*0.15);
					}
					if(i<=mainLayerIndex){
						add(c);
					}else{
						setTimeout(function(cc:CitrusSprite):void{
							add(cc);
						},10,c);
					}
				}
			}
			
			var p:PlayerX = new PlayerX("me",{x:150,y:350},movBounds);
			p.parallaxX = main_parallax;
			add(p);
			
			//camera setup
			cam = view.camera as StarlingCamera;
			cam.parallaxMode = ACitrusCamera.PARALLAX_MODE_TOPLEFT;
			cam.boundsMode = ACitrusCamera.BOUNDS_MODE_AABB;
			cam.setUp(p,camBounds, new Point(0.2, 0.5), new Point(0.02, 0.02));
			cam.allowRotation = false;
			cam.allowZoom = false;
//			cam.deadZone = new Rectangle(0, 0, 100, 100);
			
//			cam.setZoom(1.2);
			cam.reset();
			
			cam.target = p;
			
		}
	}
}