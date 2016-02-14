package;
import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.Sprite;
import luxe.tween.Actuate;
import luxe.Vector;

class GrowSprite extends Component
{
	
	var sprite:Sprite;
	
	var startSize:Float;

	public function new(_startSize, ?_options:ComponentOptions) 
	{
		super(_options);
		
		startSize = _startSize;
		
	}
	
	override function init()
	{
		sprite = cast entity;
		
		sprite.scale = new Vector(startSize, startSize);
		
		Actuate.tween(sprite.scale, 30, { x:1, y:1 } );
		
	}
	
}