package core.quadTrees {
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 四叉树的节点
	 * @author zhouzhanglin
	 */
	public class Node {
		//四个子节点  
		private var oneNode:Node=null;
		private var twoNode:Node=null;
		private var threeNode:Node=null;
		private var fourNode:Node=null;
		//此节点的范围  
		public var rect:Rectangle=null;
		//此节点的父节点  
		public var parentNode:Node=null;
		//是否有子节点  
		public var hasChild:Boolean=true;
		//此节点下所有的对象集合  
		public var spriteList:Vector.<DisplayObject>=new Vector.<DisplayObject>();
		//此节点的子节点集合  
		public var childNodeList:Vector.<Node>=new Vector.<Node>();

		public function Node() {
			childNodeList.push(oneNode);
			childNodeList.push(twoNode);
			childNodeList.push(threeNode);
			childNodeList.push(fourNode);
		}

		/**
		 * 判断点是否在此节点中
		 * @param point
		 * @return
		 */
		public function checkIsPointInNode(point:Point):Boolean {
			if (point.x >= this.rect.x && point.y >= this.rect.y && point.x < this.rect.x + this.rect.width && point.y < this.rect.y + this.rect.height) {
				return true;
			}
			return false;
		}

		/**
		 * 判断是否是叶子节点
		 * @param node
		 * @return
		 */
		public function isLeaf(node:Node):Boolean {
			if (this.parentNode != null && node.parentNode != null && this.parentNode == node.parentNode) {
				return true;
			}
			return false;
		}

		public function dispose():void {
			if (childNodeList) {
				for each (var node:Node in childNodeList) {
					if (node) {
						node.dispose();
					}
				}
			}

			if (spriteList) {
				for each (var sprite:DisplayObject in spriteList) {
					sprite=null;
				}
				spriteList=new Vector.<DisplayObject>();
			}
		}
	}
}
