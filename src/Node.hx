
package;
import luxe.Color;
import luxe.Entity;
import luxe.options.EntityOptions;
import luxe.Sprite;
import luxe.Vector;

import luxe.utils.Maths;

class Node{
	public var children:Array<Node>;
	public var parent:Node;
	
	public var type:String;
	public var angle:Int;
	public var length:Float;
	
	public var flower:Sprite;
	public var caterpillar:Sprite;
	public var fruit:Sprite;
	
	public var startPoint:Vector;
	public var endPoint:Vector;
	
	public var growing:Bool;
	
	
	public function new(?_parent:Node, _type, _angle, _length, _startpoint)
	{	
		//type = _type;
		parent = _parent;
		type = _type;
		angle = _angle;
		length = _length;
		
		growing = true;
		
		flower = null;
		caterpillar = null;
		fruit = null;
		
		children = new Array();
		
		startPoint = _startpoint;
		
		endPoint = new Vector(startPoint.x + length * Math.sin(Maths.radians(angle)), 
		                        startPoint.y - length * Math.cos(Maths.radians(angle)));
	}
	
	
	public function getAllDescendants(nodes:Array<Node>)
	{
		nodes.push(this);
		for (child in children) {
			nodes.concat(child.getAllDescendants(nodes));
			
		}
		return nodes;
		
		
	}
	
	public function getExtremities()
	{
		var nodes:Array<Node> = getAllDescendants(new Array<Node>());
		
		var extremities:Array<Node> = new Array();
		
		for (node in nodes) {
			if (node.children.length == 0) {
				extremities.push(node);
			}
		}
		
		return extremities;
	}
	
	public function stopGrowingDown()
	{
		if (angle <= -90 && angle >= -270 ) {
			growing = false;
		}
		if (parent != null)
		    parent.stopGrowingDown();
	}


	
	public function draw()
	{							
		if (parent != null) {
			startPoint = parent.endPoint;
		}
		
		//trace(angle);
		
		endPoint.set_xy(startPoint.x + length * Math.sin(Maths.radians(angle)), 
		                        startPoint.y - length * Math.cos(Maths.radians(angle)));
								
		if (flower != null) {	
			flower.pos = endPoint;
		}
		if (caterpillar != null) {
			caterpillar.pos = endPoint;
		}
		if (fruit != null) {
			fruit.pos.set_xy((endPoint.x + startPoint.x) / 2,
					                    (endPoint.y + startPoint.y) / 2+10);
		}
		
		Luxe.draw.line( {
		    p0: startPoint,
			p1: endPoint,
			color: new Color(0.5, 0.2, 0.2, 1),
			depth:5,
			immediate:true
		});
		
		for (child in children) {
			child.draw();
		}
	
	}
}