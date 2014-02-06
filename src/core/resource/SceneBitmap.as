package core.resource {
	import core.interfaces.IResource;
	import core.utils.MovieClipUtils;
	import core.utils.ResourceUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	/**
	 * 地图Bitmap

	 *
	 */
	public class SceneBitmap extends Bitmap implements IResource {
		private var m_bIsComplete:Boolean=false;
		private var m_strResUrl:String;
		private var m_strLinkName:String;
		private var m_funCallBack:Function;
		private var m_bIsLoading:Boolean=false;
		public var m_bCanRelease:Boolean=false;

		public function SceneBitmap(url:String, linkName:String="", canRelease:Boolean=false) {
			m_bCanRelease=canRelease;
			load(url, linkName, null);
		}

		public function clear():void {
			if (m_bCanRelease) {
				ResourceManager.getInstance().releaseResource(m_strResUrl, m_strLinkName, this);
				m_funCallBack=null;
				m_bIsLoading=false;
				m_bIsComplete=false;
			}
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

		/**
		 *
		 * @param url
		 * @param linkName
		 *
		 */
		public function load(url:String, linkName:String="", callBack:Function=null):void {
			if (url != m_strResUrl || linkName != m_strLinkName) {
				ResourceManager.getInstance().releaseLoadingResource(m_strResUrl, this);
				m_bIsLoading=false;
				m_bIsComplete=false;
			}
			if (m_bIsLoading) {
				return;
			}
			if (m_bIsComplete == false) {
				m_funCallBack=callBack;
				m_strResUrl=url;
				m_strLinkName=linkName;
				ResourceManager.getInstance().load(this, m_strResUrl, PriorityDefine.SCENE);

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
					this.bitmapData=MovieClipUtils.getDefinition(content, m_strLinkName) || checkBitmapData(content);
				} else {
					this.bitmapData=content;
				}
				//bitmapData.getPixel(0, 0);
				ResourceManager.getInstance().storeResource(m_strResUrl, m_strLinkName, bitmapData);
			}
			if (bitmapData.width == 0 || bitmapData.height == 0) {
				throw new Error("无效的地图图片" + m_strResUrl + "," + m_strLinkName);
			}
			m_bIsComplete=true;
			if (m_funCallBack != null) {
				m_funCallBack();
				m_funCallBack=null;
			}
			m_bIsLoading=false;
		}


		private function checkBitmapData(content_value:MovieClip):BitmapData {
			if (content_value.width == 0 && content_value.height == 0) {
				throw new Error(m_strResUrl + '的' + m_strLinkName + '有问题 不是没有图 就是数据错了 你确定?! 找林宁!');
			}
			return ResourceUtils.draw(content_value);
		}
	}
}
