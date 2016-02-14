package;

import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.Sprite;



class Grower extends Component
{
	var rules:Array<String>;
	
	var typeRules:Map<String, String>;
	
    var base:Node;
	public var n:Int;
	
	var lowestPoint:Float;
	
	public function new(_rules, _base:Node, _lowestPoint:Float, ?_options:ComponentOptions) 
	{
		super(_options);
		
		rules = _rules;
		
		base = _base;
		
		lowestPoint = _lowestPoint;
		
		typeRules = new Map();
		
		n = 0;
	}
	
	override function init()
	{
		for (rule in rules) {
			typeRules.set(rule.charAt(0), rule.substr(1));
		}
		
	}
	
	override function update(dt:Float)
	{
		
	}
	
	public function checkObstacles(branch:Node) 
	{
	    if (branch.flower != null) {
			if (branch.flower.destroyed) {
				branch.flower = null;
			}     
			return false;
		}
		if (branch.caterpillar != null) {
			if (branch.caterpillar.destroyed) {
				branch.caterpillar = null;
				trace("really really dead");
			}
			return false;
				
		}
		if (branch.fruit != null) {
			if (branch.fruit.destroyed) {
				trace("dead");
				branch.fruit = null;
			}
		}
		return true;
	}
	
	public function lengthenBranches()
	{
	    var allBranches:Array<Node> = base.getAllDescendants(new Array<Node>());
		
		for (branch in allBranches) {
			if (!checkObstacles(branch)) {
				continue;
			}
						
			if (branch.endPoint.y >= lowestPoint) {
				branch.stopGrowingDown();
			}
			
			if (branch.growing == false) {
				continue;
			}
			
			if (branch.length < 40) {
				branch.length += branch.length/20;
			} else if (branch.length > 40 && branch.length < 100) {
				branch.length += branch.length / 60;
			}
			
			branch.length += 5;
			
		}
		
		
	}
	
	public function addBranches()
	{
		var extremities:Array<Node> = base.getExtremities();
				
		for (branch in extremities) {
			if (!checkObstacles(branch)) {
				continue;
			}
	

			if (branch.endPoint.y >= lowestPoint) {
				continue;
			}
			
			var rule:String = typeRules.get(branch.type);
			
			var angle = branch.angle;
			var length = branch.length / 2;
			
			if (length < 1) {
				continue;
			}
			
			for (i in 0...rule.length) {
				switch rule.charAt(i) {
					case ']':
						angle+=45;
					case '[':
						angle -= 45;
					case 'A':
						var child:Node = new Node(branch, 'A', angle, length, branch.endPoint);
						branch.children.push(child);
						//entity.events.fire('branchadded', {parent:branch.parent, 
					case 'B':
						var child:Node = new Node(branch, 'B', angle, length, branch.endPoint);
						branch.children.push(child);
				}
			}

		}
		n++;
	}
	
}