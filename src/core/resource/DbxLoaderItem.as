package core.resource {
	import core.interfaces.IResource;

	public class DbxLoaderItem {
		public var resource:IResource; //资源
		public var url:String; //相对url
		public var type:String //swf或者png
		public var priority:int;
		public var isLoading:Boolean=false;
		public var isComplete:Boolean=false;

		public function DbxLoaderItem() {
		}
	}
}
