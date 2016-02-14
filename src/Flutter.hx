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

class Flutter extends Flying
{
	var path:Array<Vector>;
	
	//the current along-the-way target
	var imTarget:Vector;
	
	var targetIsFlower:Bool;
		
	var jitter:Vector;
	
	public function new(_jitter:Vector, ?_options:ComponentOptions)
	{
		super(_options);
		
		jitter = _jitter;
	}
	
	override function init()
	{
		super.init();
		
		path = new Array();
		
		//sprite.events.listen('objectspotted', objectSpotted);
		
		targetIsFlower = false;
		
		
		pickRandTarget();
		createPathToTarget();
		nextStep();
	}
	
	

	public function createPathToTarget()
	{
		var xDir:Int = -1;
		var yDir:Int = -1;
		
        path = [];
		

		var point:Vector = new Vector(sprite.pos.x, sprite.pos.y);

		while (!atTarget(point, target)) {
			
		    if (point.x > target.x) {
			    xDir = -1;
		    } else {
			    xDir = 1;
		    }
		
		    if (point.y > target.y) {
			    yDir = -1;
		    } else {
			    yDir = 1;
		    }			
			
			var p:Vector = new Vector((point.x + Math.random() * jitter.x* xDir) , 
			                (point.y + Math.random() * jitter.y* yDir)) ;
				
			path.push(p);
			
			point = p;
		}
		
		path.reverse();
			
		
		
	}
	
	public function nextStep()
	{
		if (path.length == 0) {
			switch targetType {
				case 'flower':
				    sprite.events.fire('flowerreached', { treeName:targetTreeName, moveType:name } );
				    targetTreeName = "";
				case 'highpoint':
					sprite.events.fire('highpointreached', { moveType:name } );
				case 'branch':
					sprite.events.fire('branchreached', { moveType:name } );
				case 'random':
					pickRandTarget();
				case 'sit':
					return;
			}
			/*if (targetIsFlower) {
				sprite.events.fire('flowerreached', { treeName:targetTreeName } );
				targetTreeName = "";
			}*/
			
			
			createPathToTarget();
		}
		if (targetType == 'sit') return;
		
		imTarget = path.pop();
		Actuate.tween(sprite.pos, 0.5, {x:imTarget.x, y:imTarget.y}).onComplete(nextStep);
		
		
	}
	
	override function update(dt:Float)
	{

	}
	
	override function objectSpotted(data:SpottedEvent)
	{
		if (targetType == 'random') {
		    target = data.position;
		    targetTreeName = data.treeName;
		    targetType = data.type;
		    createPathToTarget();			
		}

		
		//targetIsFlower = true;
	}
	
	public function setTarget(t:Vector, _targetType:String)
	{
		if (_targetType != 'random') {
			target = t;

		} else {
			pickRandTarget();
		}
		targetType = _targetType;
		
		createPathToTarget();
		nextStep();
	}
	
	


	
}