package;
import luxe.Component;
import luxe.Sprite;
import luxe.tween.Actuate;
import luxe.Vector;

import EventDetails;




class Fly extends Flying
{
	var targetObject:Sprite;
	var targetNode:Node;
	
	override function init()
	{
		super.init();
		
		pickRandTarget();
		nextStep();
		
		
		
	}
	
	public function process()
	{
		switch targetType {
			case 'random':
				pickRandTarget();
			case 'fruit':
				sprite.events.fire('fruitreached', { treeName:targetTreeName, moveType:name } );
				targetObject.destroy();
				trace("fruit destroyed");
			case 'caterpillar':
				targetObject.destroy();
				trace(targetObject.name);
				trace("destroyed?");
				setTarget(new Vector(0, 0), 'random');
				//targetNode.caterpillar = null;
				//sprite.events.fire('caterpillarreached', { treeName:targetTreeName, moveType:name } );
				
			case 'highpoint':
				sprite.events.fire('highpointreached', { moveType:name } );
			case 'branch':
				sprite.events.fire('branchreached', { moveType:name } );
			case 'sit':
				return;
		}
		nextStep();
	}
	
	public function nextStep()
	{	
		if (target.x > sprite.pos.x) {
			sprite.flipx = true;
		} else {
			sprite.flipx = false;
		}
		
		Actuate.tween(sprite.pos, 3, {x:target.x, y:target.y}).onComplete(process);

	}
	

	override function objectSpotted(data:SpottedEvent)
	{
		if (targetType == 'random') {
		    target = data.position;
		    targetTreeName = data.treeName;
		    targetType = data.type;
			targetObject = data.object;
			nextStep();
		}
		if (data.type == 'caterpillar') {
			target = data.position;
			targetType = data.type;
			targetObject = data.object;
			targetNode = data.node;

			nextStep();
		}
	}

	public function setTarget(t:Vector, _targetType:String)
	{
		if (_targetType != 'random') {
			target = t;

		} else {
			pickRandTarget();
		}
		targetType = _targetType;
		
		nextStep();
	}
	


}