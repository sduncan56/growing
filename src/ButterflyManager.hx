package;

import luxe.Vector;
import luxe.components.sprite.SpriteAnimation;
import luxe.Sprite;
import phoenix.Texture;

import EventDetails;

class ButterflyManager
{
	
	var butterflies:Array<Sprite>;
	var butterfliesNo:Int;
	
	var caterpillars:Array<Sprite>;
	var caterpillarsNo:Int;

	public function new() 
	{
		butterflies = new Array();
		butterfliesNo = 0;
		
		caterpillars = new Array();
		caterpillarsNo = 0;
		
		Luxe.events.listen('spawncaterpillar', spawnCaterpillar);
	}
	
	public function spawnGroup()
	{
		var spawnX:Int;
		var spawnY:Int;
		
		var threshold:Float = 1.0;
		var side = Math.round(Math.random());
		if (side == 0) {
			spawnX = 0;
			spawnY = 100;
		} else {
			spawnX = Luxe.screen.w;
			spawnY = 100;
		}
		
		
		while (true) {
			if (Math.random() < threshold) {		
				var pos:Vector = new Vector(spawnX - Math.random() * 20, spawnY + Math.random() * 40);			
				spawnButterfly(pos);
				//break;
				threshold -= 0.1;
			} else {
				break;
			}
		}
	}
	
	public function spawnButterfly(pos:Vector)
	{
		var image:Texture = Luxe.resources.texture('assets/butterfly.png');
		image.filter_min = image.filter_mag = FilterType.nearest;
		
		var butterfly = new Sprite( {
			    name:'butterfly'+butterfliesNo,
				texture: image,
				pos: pos,
				size: new Vector(32, 32),
				depth: 6
		});
		
		var animObject = Luxe.resources.json('assets/butterflyanim.json');
		
		var anim:SpriteAnimation = butterfly.add(new SpriteAnimation( { name:'anim' } ));
		anim.add_from_json_object(animObject.asset.json);
		anim.animation = 'fly';
		anim.play();
		
		butterfly.add(new Flutter(new Vector(20, 40), { name:'flutter' } ));
		butterfly.add(new Watcher( 'flowercreated', 300, { name:'watcher' } ));
		butterfly.add(new BranchLander( { name:'branchlander' } ));
		
		butterflies.push(butterfly);
		butterfliesNo++;
	}
	
	public function spawnCaterpillar(data:CaterSpawnEvent)
	{
		if (data.branch.caterpillar != null) {
		    return;
		}
		
		var image:Texture = Luxe.resources.texture('assets/caterpillar.png');
		image.filter_min = image.filter_mag = FilterType.nearest;		
		
		var caterpillar = new Sprite( {
			name:'caterpillar' + caterpillarsNo,
			texture:image,
			pos: data.branch.endPoint,
			size: new Vector(10, 2),
			depth: 6
		});
		
		var animObject = Luxe.resources.json('assets/caterpillaranim.json');
		
		var anim:SpriteAnimation = caterpillar.add(new SpriteAnimation( { name:'anim' } ));
		anim.add_from_json_object(animObject.asset.json);
		anim.animation = 'crawl';
		anim.play();
		
		caterpillars.push(caterpillar);
		caterpillarsNo++;
		
		data.branch.caterpillar = caterpillar;
	}
	
}