package;

import luxe.Vector;
import luxe.components.sprite.SpriteAnimation;
import luxe.Sprite;
import phoenix.Texture;





class BirdManager
{
	var birds:Array<Sprite>;

	public function new() 
	{
		birds = new Array();
	}
	
	public function spawnBird()
	{
		var image:Texture = Luxe.resources.texture('assets/bird.png');
		image.filter_min = image.filter_mag = FilterType.nearest;
		
		var bird = new Sprite( {
		    name: 'bird',
			texture: image,
			pos: new Vector(Luxe.screen.mid.x, Luxe.screen.h - (Luxe.screen.h-100)),
			size: new Vector(70, 40),
			depth: 6
		});
		
		var animObject = Luxe.resources.json('assets/birdanim.json');
		
		var anim:SpriteAnimation = bird.add(new SpriteAnimation( { name:'anim' } ));
		anim.add_from_json_object(animObject.asset.json);
		anim.animation = 'fly';
		anim.play();
		
		bird.add(new Fly( { name:'fly' } ));
		bird.add(new Watcher('fruitcreated', 500, { name:'watcher' } ));
		bird.add(new BranchLander( { name:'branchlander' } ));

	
	}
	

}