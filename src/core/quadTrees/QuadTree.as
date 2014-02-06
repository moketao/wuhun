package core.quadTrees {
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 四叉树
	 */
	public class QuadTree {
		//四叉树的树深  
		private var _depth:int=0;

		//最大的范围  
		private var _maxRect:Rectangle=null;

		//根节点  
		private var _rootNode:Node=null;

		//节点集合  
		private var _nodeList:Vector.<Node>=null;

		/**
		 *  四叉树构造函数
		 * @param layerNum 四叉树的层数
		 * @param maxRect 最大的范围
		 */
		public function QuadTree(layerNum:int, maxRect:Rectangle) {
			this._depth=layerNum + 1; //四叉树的层数  
			_maxRect=maxRect;
			_nodeList=new Vector.<Node>();
			//初始化树的根节点  
			_rootNode=new Node();
			_rootNode.hasChild=true;
			_rootNode.rect=this._maxRect;
			initTree(_rootNode);
		}

		/**
		 * 初始化四叉树
		 * @node 树节点
		 */
		private function initTree(node:Node):void {
			//树深判断
			if (node == null || node.rect.width <= this._maxRect.width / Math.pow(2, _depth) || node.rect.height <= this._maxRect.height / Math.pow(2, _depth)) {
				node.hasChild=false;
				return;
			}
			_nodeList.push(node);
			//设置子节点  
			for (var i:int=0; i < node.childNodeList.length; i++) {
				node.childNodeList[i]=new Node();
				node.childNodeList[i].parentNode=node;
				node.childNodeList[i].rect=new Rectangle(node.rect.x + (i % 2) * node.rect.width * 0.5, node.rect.y + int(i > 1) * node.rect.height * 0.5, node.rect.width * 0.5, node.rect.height * 0.5);
				initTree(node.childNodeList[i]);
			}
		}

		/**
		 * 添加可视对象到树中
		 * @param sprite 类型为DisplayObject
		 */
		public function insert(sprite:DisplayObject):void {
			var childNode:Node=searchByPoint(new Point(sprite.x, sprite.y), _rootNode);
			childNode.spriteList.push(sprite);
		}

		/**
		 * 从树中删除对象
		 * @param sprite
		 */
		public function remove(sprite:DisplayObject):void {
			var childNode:Node=searchByPoint(new Point(sprite.x, sprite.y), _rootNode);
			for (var i:int=0; i < childNode.spriteList.length; i++) {
				if (childNode.spriteList[i] == sprite) {
					childNode.spriteList.splice(i, 1);
					break;
				}
			}
		}

		/**
		 * 通过矩形区域，查询显示对象
		 * @param rect 矩形区域
		 * @param exact true表示精确查询
		 * @return 该区域的显示对象集合
		 */
		public function searchByRect(rect:Rectangle, exact:Boolean):Vector.<DisplayObject> {
			var result:Vector.<DisplayObject>=new Vector.<DisplayObject>();
			if (_rootNode != null) {
				retrive(result, rect, _rootNode, exact);
			}
			return result;
		}

		/**
		 * 遍历节点和子节点，查找最终的对象
		 * @param result 查询结果
		 * @param rect 范围
		 * @param retriveRootNode
		 */
		private function retrive(result:Vector.<DisplayObject>, rect:Rectangle, retriveRootNode:Node, exact:Boolean):void {
			//如果没有交集，则返回  
			if (!rect.intersects(retriveRootNode.rect)) {
				return;
			}
			//判断是否有子节点，递归找子节点
			if (retriveRootNode.hasChild) {
				//遍历子节点  
				for each (var child:Node in retriveRootNode.childNodeList) {
					if (child.rect.intersects(rect)) {
						retrive(result, rect, child, exact);
					}
				}
			} else {
				//如果是最后的节点，则把里面的对象加入数组中  
				for each (var sprite:DisplayObject in retriveRootNode.spriteList) {
					if (exact) {
						var childRect:Rectangle=new Rectangle(sprite.x, sprite.y, sprite.width, sprite.height);
						if (childRect.intersects(rect)) {
							result.push(sprite);
						}
					} else {
						result.push(sprite);
					}
				}
			}
		}

		/**
		 * 通过坐标来找节点
		 * @param point
		 * @return
		 */
		private function searchByPoint(point:Point, node:Node):Node {
			if (node.hasChild) {
				if (node.checkIsPointInNode(point)) {
					//遍历子节点  
					for each (var child:Node in node.childNodeList) {
						if (child.checkIsPointInNode(point)) {
							node=searchByPoint(point, child);
						}
					}
				}
			}
			return node;
		}

		/**
		 * 从四叉树中移除所有
		 */
		public function removeAll():void {
			for each (var node:Node in _nodeList) {
				node.dispose();
			}
		}
	}
}
