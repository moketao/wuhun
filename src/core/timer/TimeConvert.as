package core.timer {

	public class TimeConvert {
		public function TimeConvert() {
		}

		public static function timeConvert2(second:int):String {
			var m:int;
			if (second > 0) {
				m=Math.floor(second / 60);
			} else {
				m=0;
			}
			var s:int=second - 60 * m;
			return appendZero(m) + ":" + appendZero(s);
		}

		public static function timeConvert(second:int):String {
			var h:int=Math.floor(second / 3600);
			second=second - 3600 * h;
			var m:int;
			if (second > 0) {
				m=Math.floor(second / 60);
			} else {
				m=0;
			}
			var s:int=second - 60 * m;
			return appendZero(h) + ":" + appendZero(m) + ":" + appendZero(s);
		}

		public static function minutesSecond(second):String {
			var h:int=Math.floor(second / 3600);
			second=second - 3600 * h;
			var m:int;
			if (second > 0) {
				m=Math.floor(second / 60);
			} else {
				m=0;
			}
			var s:int=second - 60 * m;
			return appendZero(m) + ":" + appendZero(s);
		}

		public static function appendZero(v:int):String {
			var s:String=String(v);
			if (s.length == 1) {
				s="0" + s;
			}
			return s;
		}

		/**
		 * 根据秒算出天数，小时数，分钟数
		 * @param second
		 * @return
		 *
		 */
		public static function dayConvert(second:int):String {
			var day:int=second / (3600 * 24);
			var hour:int=(second % (3600 * 24)) / 3600;
			var minute:int=((second % (3600 * 24)) % 3600) / 60;
			var timeStr:String="";
			if (day) {
				timeStr+=day + L("天");
			}
			if (hour) {
				timeStr+=hour + L("小时");
			}
			if (day) {
				return timeStr;
			}
			if (minute) {
				timeStr+=(minute + L("分钟"));
			}
			if (timeStr == "") {
				timeStr+=(1 + L("分钟"));
			}
			return timeStr;
		}

		public static function dayConvert2(second:int):String {
			var time:Date=new Date(second * 1000);
			var year:int=time.fullYear;
			var month:int=time.month + 1;
			var date:int=time.date;
			return month + L("月") + date + L("日");
		}

		public static function timeConvert3(second:int):String {
			var time:Date=new Date(second * 1000);
			var year:int=time.fullYear;
			var month:int=time.month + 1;
			var date:int=time.date;
			var hour:int=time.hours;
			var min:int=time.minutes;
			return month + "-" + date + " " + hour + "：" + min;
		}

		public static function timeConvert4(second:int):String {
			var time:Date=new Date(second * 1000);
			var year:int=time.fullYear;
			var month:int=time.month + 1;
			return year + L("年") + month + L("月");
		}

		/**
		 * 根据秒算出天数，小时数，分钟数
		 */
		public static function dayConvert5(second:int):String {
			var day:int=second / (3600 * 24);
			var hour:int=(second % (3600 * 24)) / 3600;
			var minute:int=((second % (3600 * 24)) % 3600) / 60;
			var timeStr:String="";
			if (day) {
				timeStr+=day + L("天");
			}
			if (hour) {
				timeStr+=hour + L("小时");
			}
			if (minute) {
				timeStr+=(minute + L("分钟"));
			}
			if (timeStr == "") {
				timeStr+=(1 + L("分钟"));
			}
			return timeStr;
		}

	}
}
