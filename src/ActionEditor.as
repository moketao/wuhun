package
{
	import flash.geom.Rectangle;
	
	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingCitrusEngine;
	
	import feathers.controls.Alert;
	import feathers.controls.ButtonGroup;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Panel;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MetalWorksMobileTheme2;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class ActionEditor extends Panel
	{
		private static var _one:ActionEditor;
		public var _ce:CitrusEngine;
		public static var res:AssetManager;

		private var urltexture:TextInputLabel;

		private var pngfilter:TextInputLabel;
		public static function get one():ActionEditor
		{
			if(_one==null){
				_one = new ActionEditor();
				_one.headerProperties.title = "ActionEditor";
			}
			return _one;
		}
		
		private function ui():void
		{
			_ce.playing = false;
			
			//this
			layout = new VerticalLayout();
			verticalScrollPolicy = Panel.SCROLL_POLICY_OFF;
			horizontalScrollPolicy = Panel.SCROLL_POLICY_OFF;
			
			//setting
			var settings:LayoutGroup = new LayoutGroup();
			settings.setSize(_ce.screenWidth,33);
			settings.layout = new HorizontalLayout();
			urltexture = new TextInputLabel(250,25,50,"PngUrl","PngUrl");
			pngfilter = new TextInputLabel(250,25,50,"过滤","");
			pngfilter.textInput.addEventListener(Event.CHANGE,onFilterChange);
			settings.addChild(urltexture);
			settings.addChild(pngfilter);
			addChild(settings);
			
			//menu
			menu = new ButtonGroup();
			menu.setSize(_ce.screenWidth,25);
			menu.dataProvider = new ListCollection([
				{ label: "加载", triggered: loadTexture },
				{ label: "导入到舞台", triggered: importToStage },
				{ label: "播放", triggered: play },
				{ label: "导出JSON", triggered: toJSON },
				{ label: "x", triggered: close }
			]);
			menu.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			addChild(menu);
			
			//main
			main = new LayoutGroup();
			var mainlayout:HorizontalLayout = new HorizontalLayout();
			main.layout = mainlayout;
			mainHeight = _ce.screenHeight-33-25-24;
			main.setSize(_ce.screenWidth,mainHeight);
			addChild(main);
			
			xStage = new XStage(main,_ce.screenWidth-2,mainHeight,0x000000,0x000000);
			
			//pngShower
			var layout2:TiledRowsLayout = new TiledRowsLayout();
			layout2.gap = 2;
			layout2.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			layout2.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			layout2.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			layout2.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			pngShower = new XDragPanel("PicSel");
			pngShower.layout = layout2;
			pngShower.x = pngShower.y = 3;
			pngShower.setSize(_ce.screenWidth*.3,mainHeight-6);
			xStage.addChild( pngShower );
			
			xClips = new XTimeClipStage(xStage,"Clips",_ce.screenWidth*.690,200);
			xClips.x = _ce.screenWidth*.3+6;
			xClips.y = 3;
		}
		
		private function play():void
		{
			//
		}
		private function toJSON():void
		{
			var str:String = xClips.toJSON();
			Alert.show(str,"生成的JSON", new ListCollection([ { label: "OK" }]));
		}
		private function importToStage():void
		{
			var clips:Array = [];
			for (var i:int = 0; i < pngShower.numChildren; i++) {
				var img:XImg = pngShower.getChildAt(i) as XImg;
				if(img && img.hasSel){
					var clip:XTimeClip = new XTimeClip(img.clone(18));
					clips.push(clip);
				}
			}
			clips.sort(sortClip);
			xClips.addClips(clips);
		}
		private function sortClip(a:XTimeClip,b:XTimeClip):int
		{
			if(a.name>b.name) return 1;
			if(a.name<b.name) return -1;
			return 0;
		}
		private function onFilterChange(e:*):void
		{
			showAtlas();
		}
		private var tArr:Vector.<TextureAtlas> = new Vector.<TextureAtlas>;
		private var atlasNow:TextureAtlas;

		private var pngShower:XDragPanel;

		private var menu:ButtonGroup;
		public static var theme:MetalWorksMobileTheme2;

		private var main:LayoutGroup;

		private var xStage:XStage;

		private var mainHeight:Number;

		private var xClips:XTimeClipStage;
		private function loadTexture():void
		{
			var png:String = urltexture.textInput.text;
			var xml:String = png.replace(".png",".xml");
			if(png==""){
				Alert.show("PngUrl必须填写","提示", new ListCollection([ { label: "OK" }])); return;
			}
			res.enqueue(xml);
			res.enqueue(png);
			res.loadQueue(function(r:Number):void{
				if(r==1){
					Alert.show("加载完成", "提示", new ListCollection([ { label: "OK" ,triggered:onTri}]));
					function onTri():void{
						var a:TextureAtlas = res.getTextureAtlas("h18");
						tArr.push(a);
						atlasNow = a;
						showAtlas();
					}
				}
			});
		}
		
		private function showAtlas():void
		{
			if(!atlasNow){
				Alert.show("请先加载", "提示", new ListCollection([ { label: "OK" }]));
				return;
			}
			pngShower.removeChildren(0,-1,true);
			var nam:Vector.<String> = new Vector.<String>;
			atlasNow.getNames("",nam);
			var f:String = pngfilter.textInput.text;
			for (var i:int = 0; i < nam.length; i++) {
				if(f!=""){
					if(nam[i].indexOf(f)<0) continue;
				}
				var t:Texture = atlasNow.getTexture(nam[i]);
				var frame:Rectangle = atlasNow.getFrame(nam[i]);
				var r:Rectangle = atlasNow.getRegion(nam[i]);
				var xImg:XImg = new XImg(t,nam[i],frame,r,80);
				pngShower.addChild(xImg);
			}
		}
		
		private function close():void
		{
			show();
		}
		
		public function ActionEditor()
		{
			super();
			_ce = CitrusEngine.getInstance() as StarlingCitrusEngine;
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
			res = new AssetManager();
			ui();
		}
		
		private function onAdd(e:*):void
		{
			this.alpha = .95;
			setSize(_ce.stage.stageWidth,_ce.stage.stageHeight);
		}
		
		public function show():void
		{
			if(this.parent){
				this.removeFromParent();
				_ce.playing = true;
			}else{
				Starling.current.stage.addChild(this);
				_ce.playing = false;
			}
		}
	}
}