package core.resource {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 字节Loader

	 *
	 */
	public class BytesLoader extends EventDispatcher {

		private var m_dicBytesLoader:Dictionary;

		public function BytesLoader() {
			this.m_dicBytesLoader=new Dictionary();
		}

		public function addItem(url:String, byteArray:ByteArray):void {
			var loader:Loader;
			if (this.m_dicBytesLoader[url] == null) {
				loader=new Loader();
				this.m_dicBytesLoader[url]=loader;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onOneItemLoaded);
				loader.loadBytes(byteArray);
			}
		}

		public function getItem(url:String):DisplayObject {
			var l:Loader=m_dicBytesLoader[url];
			if (l != null && l.contentLoaderInfo.bytesTotal <= l.contentLoaderInfo.bytesLoaded) {
				return l.contentLoaderInfo.content;
			}
			return null;
		}

		public function removeItem(url:String):void {
			var l:Loader=m_dicBytesLoader[url];
			delete m_dicBytesLoader[url];
			if (l == null) {
				return;
			}
			try {
				l.unloadAndStop();
			} catch (error:Error) {

			}

		}

		private function onOneItemLoaded(e:Event):void {
			dispatchEvent(e);
		}


	}
} //package resource
