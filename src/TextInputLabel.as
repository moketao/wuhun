package
{
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class TextInputLabel extends LayoutGroupListItemRenderer
	{

		public var label:TextField;
		public var textInput:TextInput;
		
		/**Label和Input的分界线X坐标（中间线）**/
		private var mid:int;
		/**Label和Input相加的宽度**/
		private var w:int;
		private var h:int;
		private var defaultTxt:String;
		private var saveTxt:String;
		private var labelStr:String;


		public function TextInputLabel(w:int,h:int,mid:int,labelStr:String,_deafaultTxt:String="")
		{
			super();
			this.h = h;
			this.w = w;
			this.labelStr = labelStr;
			this.mid = mid;
			if(_deafaultTxt!=""){
				defaultTxt = _deafaultTxt;
				saveTxt = SO(_deafaultTxt);
			}
			textInput = new TextInput();
		}
		public static function SO(key:String, val:*=null):*
		{
			var so:SharedObject = SharedObject.getLocal("wuhun");
			if(val!=null) so.data[key] = val;
			return so.data[key];
		}
		override protected function initialize():void
		{
			super.initialize();
			layout = new AnchorLayout();
			
			var a2:AnchorLayoutData = new AnchorLayoutData();
			a2.left = mid;
			a2.verticalCenter = 0;
			textInput.layoutData = a2;
			textInput.setSize(w-mid,h);
			if(defaultTxt) textInput.text = defaultTxt;
			if(saveTxt) textInput.text = saveTxt;
			addChild(textInput);
			
			label = new TextField(mid,h,labelStr,"微软雅黑",int(h*.5),0x666666);
			label.hAlign = HAlign.RIGHT;
			label.text = labelStr;
			label.x = 0;
			label.y = 0;
			addChild(label);
			
			textInput.addEventListener(FeathersEventType.FOCUS_IN,onFocusIn);
			textInput.addEventListener(FeathersEventType.FOCUS_OUT,onFocusOut);
		}
		private function onFocusIn(e:*):void
		{
			if(defaultTxt){
				if(textInput.text==defaultTxt && textInput.text!=""){
					textInput.text = "";
				}
			}
		}
		private function onFocusOut(e:*):void
		{
			if(defaultTxt){
				if(textInput.text==""){
					textInput.text = defaultTxt;
				}else{
					SO(defaultTxt,textInput.text);
				}
			}
		}
	}
}