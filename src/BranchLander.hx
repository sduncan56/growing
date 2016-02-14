package;
import luxe.Component;
import luxe.Sprite;
import luxe.Timer;
import luxe.Vector;

import luxe.options.ComponentOptions;

import EventDetails;

class BranchLander extends Component
{
	var sprite:Sprite;
	
	var targetTreeName:String;
	
	var timer:Timer;
	
	var flutter:Flutter;
	
	var targetBranch:Node;
	var moveType:String;
	
	var updateTargetPos:Bool;

	public function new(?_options:ComponentOptions)
	{
		super(_options);
	}
	
	override function init()
	{
		sprite = cast entity;
		targetBranch = null;
		
		sprite.events.listen('flowerreached', objectReached);
		sprite.events.listen('highpointreached', highpointReached);
		sprite.events.listen('branchreached', branchReached);
		sprite.events.listen('fruitreached', fruitReached);
		
		updateTargetPos = false;
		
		timer = new Timer(Luxe.core);
	}
	
	override function update(dt:Float)
	{
		if (updateTargetPos) {
		    var move:Dynamic = cast sprite.get(moveType);
		    move.setTarget(targetBranch.endPoint, 'branch');			
		}
	}
	
	public function objectReached(data:ReachedEvent)
	{
		//either a flutter or swoop/whatever bird is
		var move:Dynamic = cast sprite.get(data.moveType);
		
		//this is dirty and awful and sucks.
		if (data.treeName == 'tree') {
			targetTreeName = 'enemytree';
		} else if (data.treeName == 'enemytree') {
			targetTreeName = 'tree';
		}
		
		move.setTarget(new Vector(sprite.pos.x + 20, sprite.pos.y - 200), 'highpoint');
		
	}
	
	public function fruitReached(data: ReachedEvent)
	{
		var move:Dynamic = cast sprite.get(data.moveType);
		
		targetTreeName = data.treeName;
		
		var tree:Tree = cast Luxe.scene.get(targetTreeName); 
		trace(tree.name);
		var nodes = tree.getAllNodes();
		var i = 0;
		var caterpillars:Bool = false;
		for (node in nodes) {
			if (node.caterpillar != null) {
				trace("caterpillarfood");
				//move.setTarget(node.endPoint, 'caterpillarpoint');
				sprite.events.fire('objectspotted', { position:node.endPoint,
				                                    type:'caterpillar',
				                                    object:node.caterpillar,
				                                    node:node } );
				caterpillars = true;
				break;
			} 


		}
		if (caterpillars == false)
		    move.setTarget(new Vector(0, 0), 'random');
			
		
	}
	
	public function highpointReached(data:ReachedEvent)
	{
		var tree:Tree = cast Luxe.scene.get(targetTreeName);
		
		var extremities:Array<Node> = tree.getExtremities();
		
		targetBranch = extremities[Std.random(extremities.length)];
		updateTargetPos = true;
		moveType = data.moveType;
		var move:Dynamic = cast sprite.get(data.moveType);
		move.setTarget(targetBranch.endPoint, 'branch');
		
		
	}
	
	public function branchReached(data:ReachedEvent)
	{
		//if we're a motherfucking butterfly
		if (data.moveType == 'flutter') {
			if (!sprite.has('flutter')) return;
			var f:Flutter = cast sprite.get('flutter');
			f.setTarget(new Vector(0,0), 'sit');
			//sprite.remove('flutter');
			timer.schedule(5, resume);
			
		}
		if (data.moveType == 'fly') {
			timer.schedule(5, flyResume);
		}
	}
	
	public function resume()
	{
		//sprite.add(flutter);
		updateTargetPos = false;
		Luxe.events.fire('spawncaterpillar', { branch:targetBranch } );
		var f:Flutter = cast sprite.get('flutter');
		f.setTarget(new Vector(0, 0), 'random');
		
		
		
	}
	
	public function flyResume()
	{
		var f:Fly = cast sprite.get('fly');
		f.setTarget(new Vector(0, 0), 'random');
	}
	
	
}