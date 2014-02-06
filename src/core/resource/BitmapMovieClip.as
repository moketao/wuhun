package core.resource {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import core.interfaces.IResource;
	import core.interfaces.ITicker;

	/**
	 * 帧动画
	 * @author wangfei
	 */
	public class BitmapMovieClip extends Sprite implements IResource, ITicker {

		private var m_bCanRelease:Boolean=false;
		protected var m_bIsComplete:Boolean=false;
		protected var m_bIsLoading:Boolean=false;
		protected var m_funLoadComplete:Function;

		public var m_strResUrl:String;
		public var m_strLinkName:String;
		private var m_arrPose:Array;
		private var m_funcPlayEnd:Function;

		private var m_iStartFrame:int;
		private var m_iEndFrame:int;

		public var m_iCurrentFrame:int=0;
		public var m_iTotalFrame:int=0;
		private var m_xyMovieClipData:MovieClipData;
		private var m_bmpCurrent:Bitmap;
		public var m_iDelay:int=0;
		public var m_iDelayCount:int=0;
		protected var m_bIsLoop:Boolean=true;
		private var m_bIsLoadedAndPlay:Boolean=false;
		private var loadingVisible:Boolean=true;
		private var isVisible:Boolean=true;

		public var stepFunc:Function;

		public function BitmapMovieClip(delay:int=0, canRelease:Boolean=false, isLoadedAndPlay:Boolean=false, isLoop:Boolean=true) {
			m_bCanRelease=canRelease;
			m_iDelay=delay;
			m_bIsLoadedAndPlay=isLoadedAndPlay;
			m_bIsLoop=isLoop;
			m_bmpCurrent=new Bitmap(null, "auto", true);
			this.addChild(m_bmpCurrent);
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}

		public function setLoopState(isLoop:Boolean):void {
			m_bIsLoop=isLoop;
		}

		private function onAddedToStage(e:Event):void {
			if (isPlay) {
				play();
			}
		}

		private function onRemoveFromStage(e:Event):void {
			pause();
		}

		public function clear():void {
			m_funLoadComplete=null;
			stepFunc=null;
			if (m_bCanRelease) {
				ResourceManager.getInstance().releaseResource(m_strResUrl, m_strLinkName, this);
				m_bIsLoading=false;
				m_bIsComplete=false;
			}
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stopTick();
		}

		public function canGc():Boolean {
			return m_bCanRelease;
		}

		public function isComplete():Boolean {
			return m_bIsComplete;
		}

		public function isLoading():Boolean {
			return m_bIsLoading;
		}

		public function load(url:String, linkName:String="", callBack:Function=null):void {
			if (url == null) {
				return;
			}
			if ((url != m_strResUrl || linkName != m_strLinkName)) {
				ResourceManager.getInstance().releaseLoadingResource(m_strResUrl, this);
				m_bIsLoading=false;
				m_bIsComplete=false;
				//因为调用了该类的地方可能会使用到visible属性，为了不影响其流程，创建了此另一个可视参数
				//实现mc加载未完成的时候将其影藏
				loadingVisible=false;
				this.visible=this.isVisible;
				stopTick();
			}
			if (m_bIsLoading) {
				return;
			}
			if (m_bIsComplete == false) {
				m_strResUrl=url;
				m_strLinkName=linkName;
				m_funLoadComplete=callBack;
				ResourceManager.getInstance().load(this, m_strResUrl, PriorityDefine.UI);
			} else {
				if (callBack != null) {
					callBack();
				} else {
					if (m_bIsLoadedAndPlay) {
						gotoAndPlay(1, m_bIsLoop);
					}
				}
			}
		}

		override public function get visible():Boolean {
			return super.visible;
		}

		override public function set visible(value:Boolean):void {
			isVisible=value;
			super.visible=isVisible && loadingVisible;
		}

		public function setLoading():void {
			m_bIsLoading=true;
		}

		public function setContent(content:*):void {
			if (!(content is MovieClip)) {
				throw(new Error("Resource Error" + content.toString()));
				return;
			}
			loadingVisible=true;
			this.visible=this.isVisible;
			m_bIsComplete=true;
			m_bIsLoading=false;

			if (ResourceManager.getInstance().hasResource(m_strResUrl, m_strLinkName)) {
				m_xyMovieClipData=ResourceManager.getInstance().getResource(m_strResUrl, m_strLinkName);
			} else {
				var movieClip:MovieClip=MovieClipUtils.getDefinition(content, m_strLinkName);
				if (movieClip == null) {
					throw new Error(m_strResUrl + "，" + m_strLinkName + L("资源错误"));
				}
				m_xyMovieClipData=ResourceConvert.fromMovieClip(content.loaderInfo.loader.contentLoaderInfo.applicationDomain, movieClip, m_strResUrl, m_strLinkName);
				ResourceManager.getInstance().storeResource(m_strResUrl, m_strLinkName, m_xyMovieClipData);
			}
			m_iTotalFrame=m_xyMovieClipData.length;
			if (m_funLoadComplete != null) {
				m_funLoadComplete();
			}
			if (m_bIsLoadedAndPlay) {
				gotoAndPlay(1, m_bIsLoop);
			}
		}

		private var isPlay:Boolean=false;

		public function startTick():void {
			if (isTicking == 1)
				return;
			Game.ticker.addTicker(this);
			isTicking=1;
		}
		public var isTicking:int=-1;

		public function stopTick():void {
			if (isTicking == 0)
				return;
			Game.ticker.removeTicker(this);
			isTicking=0;
		}

		/**
		 * 暂停
		 *
		 */
		public function pause():void {
			stopTick();
		}

		/**
		 * 继续播放
		 *
		 */
		public function play():void {
			startTick();
		}

		public function gotoAndPlay(frame:int, isLoop:Boolean=true, startFrame:int=-1, endFrame:int=-1, endfunc:Function=null):void {
			if (m_xyMovieClipData == null)
				return;
			isPlay=true;
			this.m_bIsLoop=isLoop;
			m_iCurrentFrame=frame;
			if (startFrame == -1) {
				this.m_iStartFrame=1;
			} else {
				this.m_iStartFrame=startFrame;
			}
			if (endFrame == -1) {
				this.m_iEndFrame=m_iTotalFrame;
			} else {
				this.m_iEndFrame=endFrame;
			}
			this.m_funcPlayEnd=endfunc;
			setCurrentFrame(m_iCurrentFrame);
			startTick();
		}

		//添加gotostop
		public function gotoAndStop(frame:int, isLoop:Boolean=true, startFrame:int=-1):void {
			if (m_xyMovieClipData == null)
				return;
			this.m_bIsLoop=isLoop;
			m_iCurrentFrame=frame;
			if (startFrame == -1) {
				this.m_iStartFrame=1;
			} else {
				this.m_iStartFrame=startFrame;
			}
			setCurrentFrame(m_iCurrentFrame);
			isPlay=false;
			stopTick();
		}

		public function tick(tickerCount:uint):void {
			// TODO Auto Generated method stub
			if (m_iDelayCount > 0) {
				m_iDelayCount--;
				return;
			} else {
				m_iDelayCount=m_iDelay;
			}
			if (m_iCurrentFrame >= m_iEndFrame) {
				if (m_bIsLoop) {
					m_iCurrentFrame=m_iStartFrame;
				} else {
					if (m_funcPlayEnd != null) {
						m_funcPlayEnd();
					}
					isPlay=false;
					stopTick();
					return;
				}
			} else {
				m_iCurrentFrame++;
			}
			setCurrentFrame(m_iCurrentFrame);
			if (stepFunc) {
				stepFunc();
			}
		}


		private function setCurrentFrame(frameIndex:int):void {
			if (frameIndex < 1 || m_xyMovieClipData.length == 0) {
				return;
			}
			if (frameIndex > m_xyMovieClipData.length) {
				frameIndex=m_xyMovieClipData.length;
			}

			m_iCurrentFrame=frameIndex;
			if (m_xyMovieClipData == null || m_xyMovieClipData.m_vectBitmapFrames == null) {
				return;
			}
			var bitmapFrame:BitmapFrame=m_xyMovieClipData.m_vectBitmapFrames[m_iCurrentFrame - 1] as BitmapFrame;
			if (bitmapFrame == null)
				return;
			m_bmpCurrent.x=bitmapFrame.rx;
			m_bmpCurrent.y=bitmapFrame.ry;
			m_bmpCurrent.bitmapData=bitmapFrame.bitmapData;

		}

		public function get bitmap():Bitmap {
			return m_bmpCurrent;
		}

		public function get bitmapData():BitmapData {
			if (m_bmpCurrent == null) {
				return null;
			}
			return m_bmpCurrent.bitmapData;
		}

	}
}
