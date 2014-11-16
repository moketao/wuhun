package core.platformInterface {
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * 平台接口
	 */
	public class PlatformInterface {
		public function PlatformInterface() {
		}

		/**
		 *  充值提示
		 */
		public static function rechargeAlert():void {
			//RechargeAlert.getInstance().show();
		}

		/**
		 * 重新登录
		 */
		public static function relogin():void {
			callQQInterface("relogin", {});
		}

		/**
		 * 推荐添加平台好友
		 */
		public static function recommendPal():void {
			callQQInterface("recommendPal", {});
		}

		/**
		 * 应用内添加平台好友
		 * @param openid 被添加的好友openid
		 *
		 */
		public static function addPal(openid:String):void {
			callQQInterface("addPal", {openid: openid});
		}

		/**
		 * 邀请好友开通
		 * @param msg  邀请弹框中显示的消息
		 * @param img  邀请配图的URL，用于在邀请feeds中展示。图片尺寸最大不超过120*120 px。若不传则默认在弹框中显示应用的icon。例如"http://qzonestyle.gtimg.cn/qzonestyle/act/qzone_app_img/app353_353_75.png"
		 * @param source 邀请好友成功后，被邀请方通过邀请链接进入应用时会携带该参数并透传给应用，用于识别用户来源。 例如"domain=s4.app12345.qqopenapp.com"
		 */
		public static function invite(msg:String, img:String):void {
			var source:String="domain=" + G.hostUrl;
			callQQInterface("invite", {msg: msg, img: img, source: source});
		}

		/**
		 *  召唤老朋友
		 * @param title  应用奖励给发起召回的用户的奖品的名称。
		 * @param receiveImg  应用奖励给发起召回的用户的奖品的图片的URL。图片规格：65×65px。
		 * @param sendImg  赠送给好友的礼物的图片。图片规格：65×65px。
		 * @param msg  召回老友时的默认赠言，长度限制：控制在35个汉字以内。
		 */
		public static function reactive(title:String, receiveImg:String, sendImg:String, msg:String):void {
			callQQInterface("reactive", {title: title, receiveImg: receiveImg, sendImg: sendImg, msg: msg});
		}

		/**
		 * 应用分享-游戏故事
		 * @param title 分享的标题
		 * @param summary  故事摘要，最多不超过50个汉字
		 * @param msg  默认展示在输入框里的分享理由，最多120个汉字
		 * @param img  图片的URL，建议为应用的图标或者与分享相关的主题图片，规格为120*120 px
		 * @param source  用于进入应用时CanvasUrl中的app_custom参数的值 例如："ref=story&act=default"
		 */
		public static function sendStory(title:String, summary:String, msg:String, img:String, source:String):void {
			callQQInterface("sendStory", {title: title, summary: summary, msg: msg, source: source, img: img});
		}

		/**
		 * 应用内分享
		 * @param desc 默认展示在分享弹框的输入框里的分享理由，分享理由要简短而有吸引力
		 * @param summary  应用简要描述。
		 * @param title  分享的标题
		 * @param pics  图片的URL。建议为应用的图标或者与分享相关的主题图片，规格为120*120 px
		 */
		public static function share(desc:String, summary:String, title:String, pics:String):void {
			callQQInterface("share", {title: title, summary: summary, desc: desc, pics: pics});
		}

		/**
		 *	跳转到个人首页
		 */
		public static function toHome():void {
			callQQInterface("toHome", {self: true});
		}

		/**
		 * 跳转到好友主页
		 * @param openid 好友的openid
		 *
		 */
		public static function toFriendHome(openid:String):void {
			callQQInterface("toFriendHome", {openid: openid, self: true});
		}

		/**
		 *  支付弹框
		 * @param url_param  Q点购买物品的url参数
		 *
		 */
		public static function buy(url_param:String):void {
			callQQInterface("buy", {disturb: false, sandbox: false, param: url_param});
		}

		/**
		 * Q点充值弹框
		 *
		 */
		public static function recharge(btn_id:int=0):void {
			if (G.recharge != "") {
				navigateToURL(new URLRequest(G.recharge), "_blank");
			} else {
				//Message.getInstance().showMessage([L("充值功能暂未开放")+"！"]);
			}
		}

		/**
		 * Q点查询弹框
		 *
		 */
		public static function checkBalance():void {
			callQQInterface("checkBalance", {});
		}

		/**
		 * 发送请求或赠送礼物
		 * @param receiver 接收者OpenID的数组
		 * @param title 免费礼物的名称
		 * @param msg 	送礼或请求的默认赠言，请控制在35个汉字以内。
		 * @param source  图片的URL，规格为65*65 px。
		 * @param desc	request的内容或freegift的物品描述
		 * @param callback	请传入处理某一条请求时的回调URL（暂时没用）
		 * @param type 调用类型，这里可传入request(应用未指定好友)或freegift(应用指定好友)
		 */
		public static function sendRequest(receiver:Array, title:String, msg:String, source:String, desc:String, callback:String, type:String="request"):void {
			callQQInterface("sendRequest", {receiver: receiver, title: title, msg: msg, source: source, desc: desc, callback: callback, type: type});
		}

		/**
		 * 开通黄钻
		 * @param token 领取道具的token
		 * @param actid 开通包月送礼包的营销活动ID
		 * @param zoneid 在管理中心“支付结算”tab的“营销接入”下，在“发货配置”中配置好的分区ID
		 * @param openid 根据APPID以及用户QQ号码生成用户ID
		 * @param version 表示使用的OpenAPI版本
		 * @param paytime 用付费模式
		 * @param defaultMonth VIP的开通时长，单位为月
		 */
		public static function openVipGift(token:String, actid:String, zoneid:int, openid:String, version:String='v3'):void {
			callQQInterface("openVipGift", {token: token, actid: actid, zoneid: zoneid, openid: openid, version: version});
		}

		/**
		 * 道具领取弹框
		 * @param actid 赠送道具/物品的营销活动ID
		 * @param token 领取道具/物品的token
		 * @param mid 识别token是由哪台机器分配的识别号
		 * @param sandbox 表示是否使用沙箱测试环境。应用发布前，请务必注释掉该行。
		 */
		public static function showVipGift(actid:String, token:String, mid:String, sandbox:Boolean=false):void {
			callQQInterface("showVipGift", {actid: actid, token: token, mid: mid, sandbox: sandbox});
		}

		/**
		 * 抽奖弹框
		 * @param zoneid 表示大区ID（例如域名为：s3.app12345.qqopenapp.com，则大区ID为3 ）
		 * @param openid 用户的OpenID
		 * @param version 表示使用的OpenAPI版本
		 * @param sandbox 表示是否使用沙箱测试环境。应用发布前，请务必注释掉该行。
		 */
		public static function lottery(zoneid:String, openid:String, version:String="v3", sandbox:Boolean=false):void {
			callQQInterface("lottery", {zoneid: zoneid, openid: openid, version: version, sandbox: sandbox});
		}
		/**
		 * 调用QQ接口
		 * @param action
		 * @param param
		 */
		private static function callQQInterface(action:String, param:Object):void {
			try {
				ExternalInterface.call("getInfoFromQQ", action, param);
			} catch (error:Error) {

			}
		}
	}
}
