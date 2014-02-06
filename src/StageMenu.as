package {
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	public class StageMenu {

		private static var sp:Sprite;

		public function StageMenu(_sp:Sprite) {
			sp=_sp;
			clearMenu();
		}

		public static function clearMenu():void {
			var cm:ContextMenu=new ContextMenu();
			sp.contextMenu=cm;
			sp.contextMenu.builtInItems.forwardAndBack=false;
			sp.contextMenu.builtInItems.print=false;
			sp.contextMenu.builtInItems.quality=false;
			sp.contextMenu.builtInItems.zoom=false;
			sp.contextMenu.builtInItems.save=false;
			sp.contextMenu.builtInItems.loop=false;
		}

		public static function addMenu(menuName:String, func:Function=null):void {
			var i:ContextMenuItem=new ContextMenuItem(menuName);
			sp.contextMenu.customItems.push(i);
			if (func)
				i.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, func);
		}
	}
}
