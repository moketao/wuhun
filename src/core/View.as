package core {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;

	import core.interfaces.IHandler;
	import core.interfaces.IMsg;
	import core.interfaces.IResource;
	import core.interfaces.ISender;
	import core.resource.PriorityDefine;
	import core.resource.ResourceManager;


	public class View extends Sprite implements IResource, IHandler, ISender {
		public var m_bShow:Boolean=false;
		protected var m_bIsComplete:Boolean=false;
		protected var m_strResUrl:String;
		protected var m_strLinkName:String;
		protected var m_bIsLoading:Boolean=false;

		public var layerType:int;

		protected var m_bHasInit:Boolean;
		public var viewCopy:Bitmap;

		public function View(type:int) {
			this.tabEnabled=false;
			this.tabChildren=false;
			layerType=type;
			EAdd();
		}

		public function EAdd():void {
			EventCenter.add(EList(), this);
		}

		/**
		 * 消息处理
		 */
		public function EHandle(notice:IMsg):void {
			throw new Error(" this function should be override");
		}

		/**
		 * 列出所有感兴趣的侦听消息
		 */
		public function EList():Array {
			throw(new Error(" this function should be override"));
			return [E.CHANGE_MAP];
		}

		public function send(notificationName:String, body:Object=null):void {
			EventCenter.send(notificationName, body);
		}

		public function clear():void {
			EventCenter.remove(EList(), this);
		}

		public function canGc():Boolean {
			return false;
		}

		public function isComplete():Boolean {
			return false;
		}

		public function isLoading():Boolean {
			return false;
		}

		public function load(url:String, linkName:String="", callBack:Function=null):void {
			if (url == "") {
				return;
			}
			if (url != m_strResUrl || linkName != m_strLinkName) {
				ResourceManager.getInstance().releaseLoadingResource(m_strResUrl, this);
				m_bIsLoading=false;
				m_bIsComplete=false;
			}
			if (m_bIsLoading) {
				return;
			}
			if (m_bIsComplete == false) {
				m_strResUrl=url;
				m_strLinkName=linkName;

				ResourceManager.getInstance().load(this, m_strResUrl, PriorityDefine.UI);
			}
		}

		public function setLoading():void {
			m_bIsLoading=true;
		}

		public function isAvailable():Boolean {
			return false;
		}

		public function setContent(content:*):void {
			throw(new Error("this function should be override"));
		}

		public function show():void {

			this.m_bShow=true;

			if (this.parent == null) {
				Layer.add(this);
			}
			onAddedToStageHandler();
			Game.addResize(this);

		}

		public function hide(tween:Boolean=true):void {
			this.m_bShow=false;
			if (this.parent != null) {
				this.parent.removeChild(this);
			}
			onRemovedFromStageHandler();
			Game.removeResize(this);
		}

		public function onResize():void {
			this.x=(Game.stageWidth - this.width) / 2;
			this.y=(Game.stageHeight - this.height) / 2;
		}

		public function onAddedToStageHandler():void {

		}

		public function onRemovedFromStageHandler():void {

		}

		public function getName():String {
			return getQualifiedClassName(this);
		}

		/**
		 * J键跳过代码，需要override
		 */
		public function skip():void {
			throw new Error(getQualifiedClassName(this) + ".skip should be override");
		}
	}
}
