package core.resource {
	import com.deng.fzip.FZip;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ZipFile extends EventDispatcher {

		public static const ZIP_SUCCESS:String="ZIPSUCCESS";
		public static const ZIP_FAILED:String="ZIPFAILED";

		private var m_stZip:FZip;
		private var fileDic:Dictionary;

		public function ZipFile() {
			this.m_stZip=new FZip();
		}

		public function loadByte(byteArray:ByteArray):void {
			var len:int=byteArray.readInt();
			var encrpytBytes:ByteArray=new ByteArray();
			byteArray.readBytes(encrpytBytes, 0, byteArray.bytesAvailable);
			this.m_stZip.addEventListener(Event.COMPLETE, this.onCompleteHandler);
			this.m_stZip.addEventListener(IOErrorEvent.IO_ERROR, this.onErrorHandler);
			this.m_stZip.loadBytes(encrpytBytes);
		}

		public function getFiles():Array {
			return m_stZip.getFiles();
		}

		public function getFile(name:String):Object {
			var xml:XML;
			if (this.fileDic[name] != null) {
				return (this.fileDic[name]);
			}
			if (m_stZip.getFileByName(name) == null) {
				return null;
			}
			var byteArray:ByteArray=this.m_stZip.getFileByName(name).content;
			if (byteArray == null) {
//                Logger.debugString(Logger.LOG_WARNING, ("Get File failed,file name = " + name));
				return null;
			}
			if (name.match(".xml") != null) {
				xml=new XML(byteArray);
				this.fileDic[name]=xml;
				return xml;
			}
			this.fileDic[name]=byteArray;
			return byteArray;
		}

		private function onCompleteHandler(_arg1:Event):void {
			this.fileDic=new Dictionary();
			dispatchEvent(new Event(ZIP_SUCCESS));
		}

		private function onErrorHandler(_arg1:Event):void {
			dispatchEvent(new Event(ZIP_FAILED));
		}


	}
}

