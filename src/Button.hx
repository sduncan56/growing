package;
import luxe.collision.Collision;
import luxe.Component;
import luxe.components.sprite.SpriteAnimation;
import luxe.options.ComponentOptions;
import luxe.Sprite;
import luxe.Vector;


class Button extends Component
{
	public var mouse:Vector;

	private var sprite:Sprite;
	
	var state1:String;
	var state2:String;
	
	var states:Map<Int, String>;
	var curState:Int;
	
	var eventName:String;
	
	public function new(_state1:String, _state2:String, _eventname:String, ?_options:ComponentOptions)
	{
		super(_options);
		
		state1 = _state1;
		state2 = _state2;
		
		states = [1 => _state1, 2 => _state2];
		curState = 2;
		
		eventName = _eventname;
	}
	
	override function init()
	{
		mouse = new Vector(0, 0);
		
		sprite = cast entity;
	}
	
	override function update(dt:Float )
	{
		if (Luxe.input.inputreleased('mouseleft')) {
			
			if (sprite.point_inside_AABB(Luxe.camera.screen_point_to_world(mouse))) {
				var spriteAnim:SpriteAnimation = cast sprite.get('anim');
				if (curState == 1) {
					spriteAnim.animation = states[2];
					curState = 2;
				} else if (curState == 2) {
					spriteAnim.animation = states[1];
					curState = 1;
				}
				Luxe.events.fire(eventName, { to:curState } );

			}
		}
		
	}
	
}