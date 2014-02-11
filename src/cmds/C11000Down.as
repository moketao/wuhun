package cmds{
import com.moketao.socket.*;
	/** 服务器主动推送的消息 **/
	public class C11000Down implements ISocketDown{
		public var Str:String; //String，消息内容
		/** 服务器主动推送的消息 **/
		public function C11000Down(){}
		public function UnPackFrom(b:CustomByteArray):*{
			Str = b.readUTF();//String（消息内容）
			return this;
		}
	}
}
