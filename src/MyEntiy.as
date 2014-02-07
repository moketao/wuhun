package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class MyEntiy extends Entity
	{
		[Embed(source="sample-sprite.png")] private const PLAYER:Class;
		public function MyEntiy()
		{
			var img:Image = new Image(PLAYER);
			this.graphic = img;
		}
		public override function update():void{
			var speed:int = 5;
			if(Input.check(Key.D)){
				x+=speed;
			}
			if(Input.check(Key.A)){
				x-=speed;
			}
			if(Input.check(Key.W)){
				y-=speed;
			}
			if(Input.check(Key.S)){
				y+=speed;
			}
			trace(FP.stage.frameRate);
		}
	}
}