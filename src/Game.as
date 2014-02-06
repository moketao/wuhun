package {

	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.net.FileReference;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import core.View;
	import core.load.AssetsLoaderManager;
	import core.timer.Ticker;

	public class Game {
		public static var stage:Stage;
		public static var layerManager:Layer;
		public static var ticker:Ticker;
		public static var m_bIsLocked:Boolean=false;

		private static var isGameViewInited:Boolean=false;
		public static var isResLoaded:Boolean=false;
		public static var isAntiAddition:Boolean=false;

		public static var preIMEMode:String="";
		public static var stageWidth:Number;
		public static var stageHeight:Number;

		private static var gs:Sound; //

		public function Game() {
		}

		public static function init(_stage:Stage):void {
			stage=_stage;
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;

			ticker=new Ticker();
			stage.stageFocusRect=false;

			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
			stage.addEventListener(Event.DEACTIVATE, deactiveHandler);
			stage.addEventListener(Event.ACTIVATE, activeHandler);
			stage.addEventListener(Event.RESIZE, onResize);

			resizeDic=new Dictionary();
			onResize();

			load();
		}

		private static function load():void {
			core.load.AssetsLoaderManager.getInstance().myload();
			setTimeout(addplayer, 500);
		}

		private static function addplayer():void {

		}

		private static function saveInfo():void {
			var file:FileReference=new FileReference();

			var date:int=(new Date().getTime()) / 1000;
			file.save(date.toString(), date.toString() + ".txt");
		}

		public static function onResize(e:Event=null):void {
			if (stage.stageWidth > G.MAX_STAGE_WIDTH) {
				stage.stageWidth=G.MAX_STAGE_WIDTH;
				stageWidth=G.MAX_STAGE_WIDTH;
			} else if (stage.stageWidth < G.MIN_STAGE_WIDTH) {
				stage.stageWidth=G.MIN_STAGE_WIDTH;
				stageWidth=G.MIN_STAGE_WIDTH;
			} else {
				stageWidth=stage.stageWidth;
			}


			if (stage.stageHeight > G.MAX_STAGE_HEIGHT) {
				stage.stageHeight=G.MAX_STAGE_HEIGHT;
				stageHeight=G.MAX_STAGE_HEIGHT;
			} else if (stage.stageHeight < G.MIN_STAGE_HEIGHT) {
				stage.stageHeight=G.MIN_STAGE_HEIGHT;
				stageHeight=G.MIN_STAGE_HEIGHT;
			} else {
				stageHeight=stage.stageHeight;
			}
			Layer.Resize();
		}

		private static function enterFrameHandler(e:Event):void {
			ticker.step();
		}

		private static function removeFromStage(e:Event):void {
			stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
			stage.removeEventListener(Event.DEACTIVATE, deactiveHandler);
			stage.removeEventListener(Event.ACTIVATE, activeHandler);
			stage.removeEventListener(Event.RESIZE, onResize);
			//todo:remove other eventListener
		}

		private static function onKeyDownHandler(e:KeyboardEvent):void {
			//Keys.getInstance().onKeyDownHandler(e);
		}

		private static function onKeyUpHandler(e:KeyboardEvent):void {
			//Keys.getInstance().onKeyUpHandler(e);
		}

		private static var isDeactive:Boolean=false;

		private static function deactiveHandler(e:Event):void {
			isDeactive=true;
			//todo:	战斗失去焦点 清理按键状态
		}

		public static var stop:Boolean=false;
		public static var logo:Bitmap;
		private static var resizeDic:Dictionary;

		private static function onSampleDataHandler(e:SampleDataEvent):void {
			e.data.position=e.data.length=4096 * 4;
		}


		public static function enterGame():void {

			//todo:	向后端请求信息

		}

		private static function activeHandler(e:Event):void {
			isDeactive=false;
		}

		public static function addResize(view:View):void {
			resizeDic[view]=view;
		}

		public static function removeResize(view:View):void {
			resizeDic[view]=null;
			delete resizeDic[view];
		}
	}
}
