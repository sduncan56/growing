package;
import luxe.Component;
import luxe.components.sprite.SpriteAnimation;
import luxe.Sprite;
import luxe.Timer;

import luxe.options.ComponentOptions;

class Wilt extends Component
{
	var lifetime:Float;
	var wiltTime:Float;
	var noOfStages:Int;
	var stage:Int;
	
	var lifeTimer:Timer;
	
	var flowerID:Int;
	
	var sprite:Sprite;
	
	var treeName:String;
	
	var deadEvent:String;
	
	public function new(_lifetime:Float, _wilttime:Float, _noOfStages:Int, _flowerID:Int, _treeName:String,
	    _deadEvent:String, ?_options:ComponentOptions) 
	{
		super(_options);
		
		lifetime = _lifetime;
		wiltTime = _wilttime;
		noOfStages = _noOfStages;
		flowerID = _flowerID;
		treeName = _treeName;
		deadEvent = _deadEvent;
		
		stage = 0;
	}
	
	override function init()
	{
		sprite = cast entity;
		
		lifeTimer = new Timer(Luxe.core);
		
		lifeTimer.schedule(lifetime, begin);
	}
	
	public function begin()
	{
		lifeTimer.reset();
		lifeTimer.schedule(wiltTime / noOfStages, wilt, true);
	}
	
	public function wilt()
	{
		stage++;
		
		if (stage > noOfStages)
		{
			Luxe.events.fire(deadEvent+treeName, { id:flowerID } );
			lifeTimer.reset();
			return;
		}
		
		var anim:SpriteAnimation = cast sprite.get('anim');
		anim.animation = "wilt" + stage;
		
		
	}
}