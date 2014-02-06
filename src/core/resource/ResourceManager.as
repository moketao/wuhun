package core.resource {
	import com.bulkLoader.BulkLoader;
	import com.bulkLoader.BulkProgressEvent;
	import com.bulkLoader.loadingTypes.LoadingItem;
	import com.deng.fzip.FZipFile;

	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.ObjectEncoding;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	import core.interfaces.IResource;
	import core.singleton.SingletonClass;

	/**
	 * 资源管理中心
	 */
	public class ResourceManager extends SingletonClass {
		public static const NAME:String="ResourceManager";

		private var callBack:Function;

		public static var CDN:String="";
		public static var CONFIGV:String="20120928"; //版本
		public static var m_strDevice:String="assets/";

		private static var _instance:ResourceManager;

		//private var m_xyCookie:Cookie;
		private var ABulkLoader:BulkLoader;
		private var m_xyZipFile:ZipFile;
		//private var languageZipFile:ZipFile;
		private var m_xyBytesLoader:BytesLoader;

		//private var m_vecLoaderQueue:Vector.<DbxLoaderItem>=new Vector.<DbxLoaderItem>; //下载列队
		private var loadItemDic:Dictionary=new Dictionary();
		private var loadItemQueue:Vector.<String>=new Vector.<String>();


		private var m_xyResourceCahce:Dictionary;

		private var loadResQueue:Array;

		private var queueLoadingDic:Dictionary;

		public function ResourceManager() {
			super(NAME);
			queueLoadingDic=new Dictionary();
			this.ABulkLoader=new BulkLoader("DBX_XY");
			//this.m_xyVersionManager = VersionManager.getInstance();
			this.m_xyBytesLoader=new BytesLoader();
			//this.m_xyCookie = new Cookie("DBX_XY", null, 1000000000);//0x0400 = 1024
			//this.m_xyBytesLoader.addEventListener(Event.COMPLETE, this.onBytesLoaderLoaded);
			m_xyZipFile=new ZipFile();
			//languageZipFile = new ZipFile();
			m_xyResourceCahce=new Dictionary();
			loadResQueue=new Array();
			//startCookie();
		}

		public static function getInstance():ResourceManager {
			if (_instance == null) {
				_instance=new ResourceManager();
			}
			return _instance;
		}

		public function getItemsTotal():int {
			return ABulkLoader.itemsTotal;
		}

		public function getItemsLoaded():int {
			return ABulkLoader.itemsLoaded;
		}

		public function addCallBack(handler:Function):void {
			this.ABulkLoader.addEventListener(BulkLoader.COMPLETE, handler);
		}

		public function removeCallBack(handler:Function):void {
			this.ABulkLoader.removeEventListener(BulkLoader.COMPLETE, handler);
		}

		public function storeResource(resUrl:String, linkName:String, resource:*):void {
			m_xyResourceCahce[resUrl + "_" + linkName]=resource;
		}

		public function hasResource(resUrl:String, linkName:String):Boolean {
			return m_xyResourceCahce[resUrl + "_" + linkName] != null;
		}

		public function getResource(resUrl:String, linkName:String):* {
			return m_xyResourceCahce[resUrl + "_" + linkName];
		}



		public function startLoading(loadMagic:Boolean, func:Function):void {
			callBack=func;
			//todo:加载资源

			this.ABulkLoader.addEventListener(BulkLoader.COMPLETE, this.onAllItemsLoaded);
			this.ABulkLoader.addEventListener(BulkLoader.PROGRESS, this.onAllItemsProgress);
			this.ABulkLoader.addEventListener(BulkLoader.ERROR, this.onAllError);
			this.ABulkLoader.start();
			if (this.ABulkLoader.isFinished) {
				this.onAllItemsLoaded(null);
			}
		}

		/**
		 * 加载队列
		 * @param url
		 *
		 */
		public function loadQueue(url:String):void {
			if (getContent(url) != null) {
				return;
			}
			if (loadResQueue.indexOf(url) == -1 && queueLoadingDic[url] != true) {
				loadResQueue.push(url);
				startLoadQueue();
			}
		}



		public function removeLoadQueue(url:String):void {
			var index:int=loadResQueue.indexOf(url)
			if (index != -1) {
				loadResQueue.splice(index, 1);
			}
		}

		private function startLoadQueue():void {
			if (isFinish()) {
				if (loadResQueue.length > 0) {
					var url:String=loadResQueue.shift();
					queueLoadingDic[url]=true;
					loadResource(url, 100);
				}
			}
		}

		/**
		 *加载入口
		 * @param str  未加cdnroot、不包括根目录的地址
		 * @param priority 优先级
		 *
		 */
		public function load(resource:IResource, url:String, priority:int=100):void {
			if (resource.isComplete()) {
				return;
			}
			if (resource.isLoading()) {
				return;
			}
			if (getContent(url) != null) {
				resource.setContent(getContent(url));
				return;
			}
			resource.setLoading();
			var loaderItem:DbxLoaderItem=new DbxLoaderItem();
			loaderItem.resource=resource;
			loaderItem.url=url;
			loaderItem.priority=priority;
			loaderItem.isLoading=true;
			loaderItem.isComplete=false;

			if (loadItemDic[url] == null) {
				loadItemDic[url]=[];
				loadItemDic[url].push(loaderItem);
			} else {
				loadItemDic[url].push(loaderItem);
			}
			if (loadItemQueue.length == 0) {
				if (loadItemQueue.indexOf(url) == -1) {
					loadItemQueue.push(url);
				}
				loadResource(loaderItem.url, loaderItem.priority);
			} else {
				if (loadItemQueue.indexOf(url) == -1) {
					loadItemQueue.push(url);
				}
			}

			//checkLoadResource();
		}

		private function checkLoadResource(url:String):void {
			var list:Array=loadItemDic[url];
			if (list != null) {
				var length:int=list.length;
				var content:*=this.getContent(url);
				if (content != null) {
					for (var i:int=0; i < length; i++) {
						var loaderItem:DbxLoaderItem=list[i];
						loaderItem.isComplete=true;
						loaderItem.resource.setContent(content);
						loaderItem.resource=null;
					}
				}
				var index:int=loadItemQueue.indexOf(url);
				if (index != -1) {
					loadItemQueue.splice(index, 1);
				}
				loadItemDic[url]=null;
				delete loadItemDic[url];
			}
			loadNext();
		}

		private function loadNext():void {
			if (loadItemQueue.length > 0) {
				var url:String=loadItemQueue.shift();
				var list:Array=loadItemDic[url];
				if (list && list.length > 0) {
					var loaderItem:DbxLoaderItem=list[0];
					loadResource(loaderItem.url, loaderItem.priority);
				} else {
					releaseLoadingResource(url);
					loadNext();
				}
			}
		}

		public function releaseLoadingResource(url:String, resource:IResource=null):void {
			if (resource && resource.isLoading() == false) {
				return;
			}
			if (url == "" || url == null) {
				return;
			}
			var list:Array=loadItemDic[url];
			if (list != null) {
				for (var i:int=0; i < list.length; ) {
					var loaderItem:DbxLoaderItem=list[i];
					if (loaderItem.resource == resource || resource == null) {
						loaderItem.resource=null;
						list.splice(i, 1);
					} else {
						i++;
					}
				}
				if (list.length == 0) {
					var index:int=loadItemQueue.indexOf(url);
					if (index != -1) {
						loadItemQueue.splice(index, 1);
					}
					loadItemDic[url]=null;
					delete loadItemDic[url];
				}

			}
		}

		/**
		 * 释放资源
		 * @param url
		 * @param resource
		 *
		 */
		public function releaseResource(url:String, linkName:String, resource:IResource=null):void {
			if (url == "" || url == null) {
				return;
			}
			releaseLoadingResource(url, resource);
			if (resource.canGc()) {
				if (m_xyResourceCahce[url + "_" + linkName] != null) {
					delete m_xyResourceCahce[url + "_" + linkName];
				}
				removeContent(url);
			}
		}

		private function loadResource(resUrl:String, priority:int):void {
			var cookieData:Array;
			var loadingItem:LoadingItem;
			if (this.ABulkLoader.getContent(resUrl) == null && this.ABulkLoader.hasItem(resUrl) == false) {
				loadingItem=this.ABulkLoader.add(m_strDevice + resUrl + "?" + this.getVersion(resUrl), {"id": resUrl, "priority": priority});
				loadingItem.addEventListener(BulkLoader.COMPLETE, this.onCompleteHandler);
				this.ABulkLoader.start();
			} else {
				delete queueLoadingDic[resUrl];

			}

		}

		public function getVersion(resUrl:String):String {
			//todo 
			return "";
		}

		/**
		 * 根据Url 获取资源
		 * @param resUrl
		 * @return
		 *
		 */
		public function getContent(resUrl:String):* {
			var content:Object=null;
			content=this.m_xyBytesLoader.getItem(resUrl);
			if (content != null) {
				return content;
			}
			content=this.ABulkLoader.getContent(resUrl);
			return (content);
		}

		public function getSwfContent(swfRes:String, linkName:String):* {
			var content:MovieClip=getContent(swfRes);
			if (content != null) {
				return MovieClipUtils.getDefinition(content, linkName);
			}
			return null;
		}

		/**
		 * 从内存中删除资源
		 * @param resUrl
		 *
		 */
		private function removeContent(resUrl:String):void {
			m_xyBytesLoader.removeItem(resUrl);
			ABulkLoader.remove(resUrl);
		}

		private function onCompleteHandler(e:Event):void {
			if (e.target.bytesLoaded != e.target.bytesTotal) {
				//SurveyManager.getInstance().sendError(Config.SessionKey+" resource "+e.target.id+"load uncomplete, bytesLoaded = " + e.target.bytesLoaded+",bytesTotal = " + e.target.bytesTotal);
				removeContent(e.target.id);
//				loadResource(e.target.id,e.target.priority);
				delete queueLoadingDic[e.target.id];
				releaseLoadingResource(e.target.id);
				this.checkLoadResource(e.target.id);
				return;
			}
			delete queueLoadingDic[e.target.id];
			this.checkLoadResource(e.target.id);

		/*if (this.m_xyCookie.isPermitted && e != null && (e.target is ImageItem))
		{
			var imageItem:ImageItem = e.target as ImageItem;
			var resKey:String = imageItem.id;
			var content:MovieClip = (imageItem.content as MovieClip);
			if (content != null)
			{
				this.m_xyCookie.setData(resKey, [this.getVersion(imageItem.id), content.loaderInfo.bytes]);
			};
		};*/
		}

		/*private function onBytesLoaderLoaded(e:Event):void
		{
			this.checkLoadResource();
			startLoadQueue();
		}*/

		private var hasLoadConfig:Boolean=false;

		private function onAllItemsLoaded(e:Event):void {
			ABulkLoader.removeEventListener(BulkLoader.COMPLETE, this.onAllItemsLoaded);
			if (hasLoadConfig == false) {
				hasLoadConfig=true;
				var bytes:ByteArray=ABulkLoader.getContent("/config.xy");
				this.m_xyZipFile.addEventListener(ZipFile.ZIP_SUCCESS, this.onZipSuccessHandler);
				m_xyZipFile.loadByte(bytes);
				ABulkLoader.remove("/config.xy");
			}
			startLoadQueue();
		}

		private function onZipSuccessHandler(e:Event):void {
			this.m_xyZipFile.removeEventListener(ZipFile.ZIP_SUCCESS, this.onZipSuccessHandler);
			var filesList:Array=m_xyZipFile.getFiles();
			for (var i:int=0; i < filesList.length; i++) {
				var file:FZipFile=filesList[i] as FZipFile;
				var bytes:ByteArray=file.content;
				bytes.inflate();
				bytes.endian=Endian.BIG_ENDIAN;
				bytes.objectEncoding=ObjectEncoding.AMF3;
				var dic:Dictionary=bytes.readObject();
				switch (file.filename) {
					case "map.data":
//						SceneManager.getInstance().parseMapData(dic);
						break;
					case "monster.data":
//						SceneManager.getInstance().parseMonster(dic);
						break;
					default:
						break;
				}
			}
			configDataLoaded=true;
			if (callBack) {
				callBack();
				callBack=null;
			}
			//sendNotification(CONFIG_DATA_LOADED);

		}

		public static var configDataLoaded:Boolean=false;

		private function onAllItemsProgress(e:BulkProgressEvent):void {
			//
		}

		private function onAllError(e:ErrorEvent):void {
			//SystemMessageAlert.addMessage("加载资源出错，请刷新再试");
		}

		/**
		 * 主文件版本 （传进来的版本，使用这个版本号的资源不存在版本控制）
		 * @return
		 *
		 */
		private function getMainVerion():String {
			return CONFIGV;
		}

		/**
		 *  在加载中
		 * @return
		 *
		 */
		public function isRunning():Boolean {
			return (this.ABulkLoader.isRunning);
		}

		public function isFinish():Boolean {
			return !this.ABulkLoader.isRunning;
		}

	}
}
