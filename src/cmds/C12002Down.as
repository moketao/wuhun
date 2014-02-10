package cmds{
import com.moketao.socket.*;
	/** 服务器主动向周围玩家推送掉线玩家的SID **/
	public class C12002Down implements ISocketDown{
		public var SID:String; //String，掉线玩家的SID
		/** 服务器主动向周围玩家推送掉线玩家的SID **/
		public function C12002Down(){}
		public function UnPackFrom(b:CustomByteArray):*{
			SID = b.readUTF();//String（掉线玩家的SID）
			return this;
		}
	}
}
