
package;

import luxe.Component;
import luxe.collision.shapes.Shape;
import luxe.collision.shapes.Polygon;
import luxe.Sprite;

class Hitbox extends Component
{
	public var box:Shape;	
	var sprite:Sprite;
	
	override function init() {
		sprite = cast entity;
		box = Polygon.rectangle(sprite.pos.x, sprite.pos.y, sprite.uv.w, sprite.uv.h);
		
	}
	
	override function update(dt:Float) {
		box.x = sprite.pos.x;
	    box.y = sprite.pos.y;
	}
}