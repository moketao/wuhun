package loading
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	public class Res
	{
		public var groupNames			:Dictionary = new Dictionary();
		public var groupDic				:Dictionary = new Dictionary();
		public var functionDic		:Dictionary = new Dictionary();
		public var groupNow				:String = "";
		
		public var loader:BulkLoader = new BulkLoader("main");
		public function Res()
		{
			loader.addEventListener(BulkProgressEvent.COMPLETE,onLoadOK);
		}
		
		protected function onLoadOK(e:Event = null):void{
			var urlArr:Array = [];
			for (var i:int = 0; i < group.length; i++) {
				var url:String = group[i];
				var hasItem:Boolean = loader.hasItem(url);
				if(hasItem){
					urlArr.push(url);
				}
				trace("加载完成:",url);
				//todo: parse all data and save
			}
			clear(groupNow,urlArr);
			run();
		}
		
		private function clear(groupName:String,urlArr:Array = null):void{
			var groupArr:Array = groupDic[groupName];
			if(urlArr){
				for (var i:int = 0; i < urlArr.length; i++) {
					var url:String = urlArr[i];
					var k:int = groupArr.indexOf(url);
					groupArr.splice(k,1);
					functionDic[url]();
					functionDic[url]=null;
					delete functionDic[url];
				}
				groupDic[groupName] = groupArr;
			}
			if(groupArr.length==0){
				//清除整个组
				groupDic[groupName] = null;
				functionDic[groupName] = null;
				groupNames[groupName] = null;
				delete groupDic[groupName];
				
				delete groupNames[groupName];
			}
		}
		public function load(groupName:String,fileurls:Array,callback:Function):void{
			var arr:Array = checkHasGroup(groupName);
			for (var i:int = 0; i < fileurls.length; i++) {
				var url:String = fileurls[i];
				var index:int = arr.indexOf(url);
				if(index==-1){
					arr.push(url);
					functionDic[url] = callback;
				}
			}
			groupDic[groupName] = arr;
			groupNames[groupName] = groupName;
			if(groupNow=="")groupNow = groupName;
			run();
		}
		
		private function checkHasGroup(groupName:String):Array
		{
			if(!groupDic[groupName]){
				groupDic[groupName] = [];
			}
			return groupDic[groupName];
		}
		public function get group():Array{
			if(groupNow==""){
				for each (var n:String in groupNames) {
					groupNow = n;
					break;
				}
			}
			if(groupNow=="")return null;
			return groupDic[groupNow];
		}
		private function run():void{
			var len:int;
			for each (var j:int in groupNames) {
				len++;
			}
			if(len==0)return;
			var g:Array = group;
			if(g){
				for (var i:int = 0; i < g.length; i++) {
					var url:String = g[i];
					if(!loader.hasItem(url)){
						var type:String = BulkLoader.guessType(url);
						loader.add(url,{type:type});
					}else{
						trace("已经加载，跳过:"+url);
					}
				}
				loader.start();
				if(loader.isFinished){
					onLoadOK();//如果全部都在之前加载过，则loader.isFinished为true，可立即执行onGroupOK()。
				}
			}
		}
	}
}