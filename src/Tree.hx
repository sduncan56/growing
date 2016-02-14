package;

import luxe.collision.shapes.Polygon;
import luxe.collision.shapes.Shape;
import luxe.components.sprite.SpriteAnimation;
import luxe.Events;
import luxe.Quaternion;
import luxe.Sprite;
import luxe.Timer;
import luxe.Vector;
import luxe.Entity;
import luxe.options.EntityOptions;
import luxe.Color;
import phoenix.Texture;

import EventDetails;


class Tree extends Entity
{
    var base:Node;
	
	var growTimer:Timer;
	var ffTimer:Timer;
	
	//var flowers:Array<Sprite>;
	var flowersNo:Int;
	
	var flowers:Map<Int, Sprite>;
	var fruits:Map<Int, Sprite>;
	
	var fruitNo:Int;
	
	var changeGrowTag:String;
	var changeFFTag:String;
	var flowerdeadTag:String;
	
	var extremities:Array<Node>;
	
	//, _changeGrowTag:String, _changeFFTag:String, _flowerdeadTag:String,
	
	public function new(_base:Node, ?_options:EntityOptions) 
	{
		super(_options);
		base = _base;
		

	}
	
	override function init()
	{
		growTimer = new Timer(Luxe.core);
		ffTimer = new Timer(Luxe.core);
		//growTimer.schedule(5, addBranches, true);
		growTimer.schedule(1, lengthenBranches, true);
		
		Luxe.events.listen('changegrowstate'+name, changeGrowState);
		Luxe.events.listen('changeffstate'+name, changeFFState);
		Luxe.events.listen('flowerdead' + name, removeFlower);
		Luxe.events.listen('fruitdead' + name, removeFruit);
		
		//flowers = new Array();
		flowers = new Map();
		flowersNo = 0;
		fruitNo = 0;
		
		fruits = new Map();
		
		extremities = new Array();

	}

	
	public function drawTree()
	{
		//var start = new Vector(Luxe.screen.width / 2, 400);
		
		base.draw();
	}
	
	public function lengthenBranches()
	{
		var grower:Grower = cast get('grower');
		
		if (grower != null) {
			grower.lengthenBranches();
		}
	}
	
	public function addBranches()
	{
		var grower:Grower = cast get('grower');
		
		if (grower != null && grower.n < 20) {
		    grower.addBranches();	
		}
	}
	
	public function growFruit()
	{
		var image:Texture = Luxe.resources.texture('assets/fruit.png');
		image.filter_min = image.filter_mag = FilterType.nearest;
		
		for (node in base.getAllDescendants(new Array<Node>())) {
			if (Math.random() > 0.7 && node.fruit == null && node.angle != 0 && node.length > 20) {
				var fruit:Sprite = new Sprite( {
					name:'fruit' + '_' + fruitNo + "_" + name,
					texture:image,
					pos: new Vector((node.endPoint.x + node.startPoint.x) / 2,
					                    (node.endPoint.y + node.startPoint.y) / 2+10),
					size: new Vector(32, 43),
					depth:7
				});
				
				
				
				fruit.add(new GrowSprite(0.3, { name:'growsprite' } ));
				fruit.add(new TreeInfo( { treeName:name, base:base }, { name:'treeinfo' } ));
				fruit.add(new Wilt(2, 1, 0, fruitNo, name, 'fruitdead', { name:'wilt' } ));
				
				var animObject = Luxe.resources.json('assets/fruitanim.json');
				
				var anim:SpriteAnimation = fruit.add(new SpriteAnimation( { name:'anim' } ));
				anim.add_from_json_object(animObject.asset.json);
				anim.animation = 'idle';
				//anim.play();
				
				
				
				node.fruit = fruit;
				
				fruits[fruitNo] = fruit;
				
				fruitNo++;
				
				Luxe.events.fire('fruitcreated', {sprite:fruit, treeName:name});
			}
		}
	}
	
	public function growFlowers()
	{
		var image:Texture = Luxe.resources.texture('assets/flower.png');
		image.filter_min = image.filter_mag = FilterType.nearest;
		
		for (node in base.getExtremities()) {
			if (Math.random() > 0.5 && node.flower == null && node.length > 15 && node.caterpillar == null) {
				var flower:Sprite = new Sprite( {
				    name:'flower'+'_'+flowersNo+"_"+name,
					texture: image,
					pos: node.endPoint,
					size: new Vector(14, 14),
					depth: 7
				});
				
				var animObject = Luxe.resources.json('assets/floweranim.json');
				
				var anim:SpriteAnimation = flower.add(new SpriteAnimation( { name:'anim' } ));
				anim.add_from_json_object(animObject.asset.json);
				anim.animation = 'grow';
				anim.play();
				
				flower.add(new TreeInfo( { treeName:name, base:base }, { name:'treeinfo' } ));
				flower.add(new Wilt(5, 10, 4, flowersNo, name, 'flowerdead', { name : 'wilt' } ));
				
				var rot = new Quaternion().setFromEuler(new Vector(0, 0, node.angle).radians());
				flower.set_rotation(rot);
				
				
				
				node.flower = flower;
				
				//flowers.push(flower);
				//flowers[flower] = node;
				flowers[flowersNo] = flower;
				
				flowersNo++;
				
				
				Luxe.events.fire('flowercreated', { sprite:flower, treeName:name } );
			}
		}
		
	}
		

	
	override function update(dt:Float)
	{	

		drawTree();
		

	}
	
	public function changeGrowState(data:ClickEvent)
	{
		if (data.to == 1) {
			growTimer.reset();
			growTimer.schedule(1, lengthenBranches, true);
		} else if (data.to == 2) {
			growTimer.reset();
			growTimer.schedule(5, addBranches, true);
			
		}
	}
	
	public function changeFFState(data:ClickEvent)
	{
		ffTimer.reset();
		if (data.to == 1) {
			ffTimer.schedule(3, growFlowers, true);
		} else if (data.to == 2) {
			ffTimer.schedule(6, growFruit, true);
		}
	}
	
	public function removeFlower(data:WiltedEvent)
	{
		
		flowers[data.id].destroy();
		//data.s.destroy();
		//flowers[data.sprite].flower = null;
		//flowers.remove(data.sprite);
		
		
		//flowers.remove(data.sprite);
	}
	
	public function removeFruit(data:WiltedEvent)
	{
		fruits[data.id].destroy();
	}
	
	public function addExtremity()
	{
		
	}
	
	//replace the code in here with something sane at a later date.
	public function getExtremities()
	{
		return base.getExtremities();
	}
	
	public function getAllNodes()
	{
		var nodes = base.getAllDescendants(new Array<Node>());

		
		return nodes;
	}
	
}