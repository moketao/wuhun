package loading
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	public class Res
	{
		public var groupIndex			:Array = [];
		public var groupDic				:Dictionary = new Dictionary();
		public var groupFunctionDic		:Dictionary = new Dictionary();
		public var groupNow				:String = "";
		
		public var loader:BulkLoader = new BulkLoader("main");
		public function Res()
		{
			loader.addEventListener(BulkProgressEvent.COMPLETE,onGroupOK);
		}
		
		protected function onGroupOK(e:Event = null):void{
			for (var i:int = 0; i < group.length; i++) {
				var url:String = group[i];
				var item:LoadingItem = loader.get(url);
				trace("加载完成:",item.url.url);
				//todo: parse all data and save
			}
			if(groupFunction){
				groupFunction();
			}
			clear(groupNow);
			run();
		}
		
		private function clear(groupName:String):void{
			groupDic[groupName] = null;
			groupFunctionDic[groupName] = null;
			if(groupNow==groupName)groupNow = "";
			var index:int = groupIndex.indexOf(groupName);
			if(index!=-1)groupIndex.splice(index,1);
		}
		public function load(groupName:String,group:Array,callback:Function):void{
			groupDic[groupName] = group;
			groupFunctionDic[groupName] = callback;
			groupIndex.push(groupName);
			if(groupNow=="")groupNow = groupName;
			if(!loader.isRunning){
				run();
			}
		}
		public function get group():Array{
			return groupDic[groupNow];
		}
		public function get groupFunction():Function{
			return groupFunctionDic[groupNow];
		}
		private function run():void{
			if(groupIndex.length==0) return;
			for (var i:int = 0; i < group.length; i++) {
				var url:String = group[i];
				if(!loader.hasItem(url)){
					var type:String = BulkLoader.guessType(url);
					loader.add(url,{type:type});
				}else{
					trace("已经加载，跳过:"+url);
				}
			}
			loader.start();
			if(loader.isFinished){
				onGroupOK();//如果全部都在之前加载过，则loader.isFinished为true，可立即执行onGroupOK()。
			}
		}
	}
}