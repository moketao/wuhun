package
{
	import flash.utils.Dictionary;
	
	import data.PlayerData;
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class MyEntiy extends Entity
	{
		
		/**所有玩家*/
		public static var PlayerDic:Dictionary = new Dictionary();
		
		/**玩家自己的数据*/
		public var d:PlayerData = new PlayerData();
		
		/**临时玩家形象*/
		[Embed(source="sample-sprite.png")] private const PLAYER:Class;
		
		public function MyEntiy()
		{
			graphic = new Image(PLAYER);
		}
		public override function update():void{
			if(Input.check(Key.D)){
				d.dir = 0;
			}
			if(Input.check(Key.A)){
				d.dir = 180;
			}
			if(Input.check(Key.W)){
				d.dir = 90;
			}
			if(Input.check(Key.S)){
				d.dir = 275;
			}
		}
	}
}