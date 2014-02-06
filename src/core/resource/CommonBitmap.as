package core.resource {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import core.interfaces.IResource;

	/**
	 * 通用图片
	 */
	public class CommonBitmap extends Bitmap implements IResource {
		private var m_bIsComplete:Boolean=false;
		public var m_strResUrl:String;
		public var m_strLinkName:String;
		public var m_funCallBack:Function=null;
		private var m_bIsLoading:Boolean=false;

		public function CommonBitmap(url:String=null, linkName:String="", callBack:Function=null) {
			load(url, linkName, callBack);
		}

		public function clear():void {
			if (canGc()) {
				ResourceManager.getInstance().releaseResource(m_strResUrl, m_strLinkName, this);
				m_funCallBack=null;
				m_bIsLoading=false;
				m_bIsComplete=false;
			}
		}

		public function canGc():Boolean {
			return false;
		}

		public function isComplete():Boolean {
			return m_bIsComplete;
		}

		public function isLoading():Boolean {
			return m_bIsLoading;
		}

		/**
		 *
		 * @param url
		 * @param linkName
		 *
		 */
		public function load(url:String, linkName:String="", callBack:Function=null):void {
			if (url == null || url == "") {
				return;
			}
			if (url != m_strResUrl || linkName != m_strLinkName) {
				ResourceManager.getInstance().releaseLoadingResource(m_strResUrl, this);
				m_bIsLoading=false;
				m_bIsComplete=false;
			} else if (m_bIsComplete) {
				if (callBack) {
					callBack();
				}
			}
			if (m_bIsLoading) {
				return;
			}
			if (m_bIsComplete == false) {
				m_funCallBack=callBack;
				m_strResUrl=url;
				m_strLinkName=linkName;
				ResourceManager.getInstance().load(this, m_strResUrl, PriorityDefine.UI);
			}
		}

		public function setLoading():void {
			m_bIsLoading=true;
		}

		public function setContent(content:*):void {

			if (ResourceManager.getInstance().hasResource(m_strResUrl, m_strLinkName)) {
				bitmapData=ResourceManager.getInstance().getResource(m_strResUrl, m_strLinkName);
			} else {
				if (content is MovieClip) {
					try {
						this.bitmapData=MovieClipUtils.getDefinition(content, m_strLinkName) || ResourceUtils.draw(content);
					} catch (error:Error) {
						if (G.IS_DEBUG) {
							throw new Error("缺少图片" + m_strResUrl + "," + m_strLinkName);
						}
					}
				} else {
					this.bitmapData=content;
				}
				ResourceManager.getInstance().storeResource(m_strResUrl, m_strLinkName, bitmapData);
			}

			m_bIsComplete=true;
			if (m_funCallBack != null) {
				m_funCallBack();
				m_funCallBack=null;
			}
			m_bIsLoading=false;
		}

		public function getResUrl():String {
			return m_strResUrl;
		}
	}
}
