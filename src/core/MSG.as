package core {
	import core.interfaces.IMsg;

	/**
	 * 具体的消息体内容
	 */
	public class MSG implements IMsg {
		private var name:String; //消息的具体名称
		private var body:Object;

		public function MSG(name:String, body:Object) {
			this.name=name;
			this.body=body;
		}

		public function getName():String {
			return name;
		}

		public function getBody():Object {
			return body;
		}
	}
}
