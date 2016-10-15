package 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.view.ACitrusCamera;
	import citrus.view.starlingview.StarlingCamera;
	
	import feathers.themes.MetalWorksMobileTheme2;
	
	import starling.textures.TextureSmoothing;
	
	public class GameState extends StarlingState
	{
		[Embed(source="map01.txt", mimeType="application/octet-stream")]  
		public var txtCls:Class; 
		private var cam:ACitrusCamera;
		private var camBounds:Rectangle;
		private var movBounds:Rectangle;
		public static var MAIN_parallax:Number = 1;

		public static var theme:MetalWorksMobileTheme2;
		public function GameState()
		{
			super();
		}
		override public function initialize():void{
			super.initialize();
			
			theme = new MetalWorksMobileTheme2(false);
			
			_ce.console.addCommand("aa",function():void{
				ActionEditor.one.show();
				ActionEditor.theme = theme;
			});
			
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
					var c:CitrusSprite = new CitrusSprite("ob"+i+""+j,{x:pic.x, y:pic.y ,view:G.hostUrl+pic.name,smoothing:TextureSmoothing.NONE});
					if(layer.isMain){
						c.parallaxX = MAIN_parallax;
					}else{
						c.parallaxX = MAIN_parallax+((k-i)*0.15);
					}
					if(i<=mainLayerIndex){
						add(c);
					}else{
						setTimeout(function(cc:CitrusSprite):void{
							cc.group = 99;
							add(cc);
						},10,c);
					}
				}
			}
			
			var p:PlayerX = new PlayerX("me",{
				x:150,
				y:350,
				oy:232,
				isMe:true,
				actionNames:["idle", "run" ,"att01" ,"att02" ,"att03" ,"att04" ,"att05"],
				actionFPSs:	[  5,	  12   ,   8    ,   8    ,   8    ,   8    ,  8    ]
			},movBounds);
			p.parallaxX = MAIN_parallax;
			add(p);
			
			var g:PlayerX = new PlayerX("g001",{
				x:1050,
				y:350,
				oy:50,
				action0:"idle",
				actionNames:["idle" , "run" ,"att01" ,"hit"],
				actionFPSs:	[  4    ,  4    ,   8    ,  4  ]
			},movBounds);
			g.parallaxX = MAIN_parallax;
			add(g);
			
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