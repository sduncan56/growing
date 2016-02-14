package;

import luxe.collision.Collision;
import luxe.collision.shapes.Polygon;
import luxe.collision.shapes.Shape;
import luxe.Component;
import luxe.Sprite;
import luxe.tween.Actuate;
import luxe.Vector;

import luxe.options.ComponentOptions;

import EventDetails;

/**
 * ...
 * @author 
 */
class Flying extends Component
{
	var target:Vector;
	
	var sprite:Sprite;
	
	var targetTreeName:String;
	
	var targetType:String;
	
	public function new(?_options:ComponentOptions)
	{
		super(_options);
	}
	
	override function init()
	{
		target = new Vector();
		sprite = cast entity;
		
		sprite.events.listen('objectspotted', objectSpotted);


	}

	public function pickRandTarget()
	{
		var x:Int = Math.round(Math.random() * Luxe.screen.width);
		var y:Int = Math.round(Math.random() * Luxe.screen.height / 2);
		targetType = "random";
		
		target.set_xy(x, y);
	}

	public function atTarget(position:Vector, _target:Vector)
	{
		var targetArea:Polygon = Polygon.rectangle(_target.x - 10, _target.y - 10, 20, 20);

		if (Collision.pointInPoly(position, targetArea)) {
			return true;
		}
		return false;
	}
	
	public function objectSpotted(data:SpottedEvent)
	{
		
	}
	
	


	
}