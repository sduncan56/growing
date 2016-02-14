package;

import luxe.Vector;
import luxe.Color;
import luxe.components.sprite.SpriteAnimation;
import luxe.Entity;
import luxe.Input;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.Sprite;
import phoenix.Texture;

class Main extends luxe.Game 
{
	var tree:Tree;
	var enemyTree:Tree;
	
	var birdManager:BirdManager;
	var butterflyManager:ButterflyManager;
	
	var growButton:Sprite;
	var ffButton:Sprite;
	
	var mouse:Vector;
	
	var moveCam:Int;
	

	override function ready() 
	{
        var parcel = new Parcel( {
			jsons:[ 
			    { id: 'assets/birdanim.json' },
				{ id: 'assets/growbuttonsanim.json' },
				{ id: 'assets/ffbuttonsanim.json' },
				{ id: 'assets/butterflyanim.json' },
				{ id: 'assets/floweranim.json' },
				{ id: 'assets/caterpillaranim.json' },
				{ id: 'assets/fruitanim.json' }
			],
			textures:[
			    {id:'assets/bird.png' },
				{id:'assets/growbuttons.png' },
				{id:'assets/ffbuttons.png' },
				{id:'assets/butterfly.png' },
				{id:'assets/flower.png' },
				{id:'assets/caterpillar.png' },
				{id:'assets/fruit.png' },
				{id:'assets/hill.png' }
			]	
		});
		
		new ParcelProgress( {
			parcel:parcel,
			background:new Color(0.6, 0.6, 0.6, 1),
			oncomplete:assetsLoaded
			
		});
		parcel.load();
		
		

		
	}
	
	public function assetsLoaded(_)
	{
		
		
		//trees
		var rules:Array<String> = ['A[B]', 'B]A[[A]]'];
		
		var base:Node = new Node(null, 'B', 0, 20, new Vector(Luxe.screen.width / 2-200, 400));
		
		tree = new Tree(base, {
			name: 'tree'
		});
				
		tree.add(new Grower(rules, base, 390, { name : 'grower' } ));
		
		//enemy tree
		
		var eBase:Node = new Node(null, 'B', 0, 20, new Vector(Luxe.screen.width / 2 + 200, 400));
		
		enemyTree = new Tree(eBase, {
			name: 'enemytree'
		});
		
		enemyTree.add(new Grower(rules, eBase, 390, { name:'grower' } ));
		enemyTree.add(new Autogrow( { name:'autogrow' } ));
		
		Luxe.renderer.clear_color = new Color(0.1, 0.1, 0.2, 1);	
		
		//birds
		
		birdManager = new BirdManager();
		butterflyManager = new ButterflyManager();
		
		birdManager.spawnBird();
		
		butterflyManager.spawnGroup();
		
		//buttons
		//grow branches/height button
		
		var gbtn:Texture = Luxe.resources.texture('assets/growbuttons.png');
		gbtn.filter_min = gbtn.filter_mag = FilterType.nearest;
		
		growButton = new Sprite( {
		    name: 'button1',
			texture: gbtn,
			pos: new Vector(100, 300),
			size: new Vector(100, 52),
			depth: 7
		});
		
		growButton.add(new Hitbox({name:'hitbox'}));
		growButton.add(new Button('branches', 'height', 'changegrowstate'+tree.name, {name:'button'}));
		
		var growAnim:SpriteAnimation = growButton.add(new SpriteAnimation( { name:'anim' } ));
		growAnim.add_from_json_object(Luxe.resources.json('assets/growbuttonsanim.json').asset.json);
		growAnim.animation = "branches";
		growAnim.play();
		
		//fruit/flowers button
		
		var ffbtn:Texture = Luxe.resources.texture('assets/ffbuttons.png');
		ffbtn.filter_min = ffbtn.filter_mag = FilterType.nearest;
		
		ffButton = new Sprite( {
		    name: 'button2',
			texture: ffbtn,
			pos: new Vector(100, 400),
			size: new Vector(72, 72),
			depth: 7
		});
		
		ffButton.add(new Button('fruit', 'flowers', 'changeffstate'+tree.name, { name:'button' } ));
		
		var ffAnim:SpriteAnimation = ffButton.add(new SpriteAnimation( { name:'anim' } ));
		ffAnim.add_from_json_object(Luxe.resources.json('assets/ffbuttonsanim.json').asset.json);
		ffAnim.animation = "flowers";
		ffAnim.play();
		
		//hill
		var hillImg:Texture = Luxe.resources.texture('assets/hill.png');
		hillImg.filter_min = hillImg.filter_mag = FilterType.nearest;
		
		var hill:Sprite = new Sprite( {
			name:'hill',
			texture:hillImg,
			pos:new Vector(400, 500),
			size: new Vector(1143, 377),
			depth:1
		});
		
		//events
		
		Luxe.input.bind_mouse('mouseleft', MouseButton.left);
		
		mouse = new Vector(0, 0);
		
		moveCam = 0;
		
		
		
	}

	override function onkeyup(e:KeyEvent) 
	{
		if(e.keycode == Key.escape)
			Luxe.shutdown();
			
		if (e.keycode == Key.enter) {
			
		}
	}
	
	public function moveCamera(dir:Int)
	{
		

		if (Luxe.camera.pos.y <= 0 ){
		    Luxe.camera.pos.y -= dir;
		    ffButton.pos.y -= dir;
		    growButton.pos.y -= dir;
		}
		if (Luxe.camera.pos.y > 0) {
			Luxe.camera.pos.y = 0;
			ffButton.pos.y += dir;
			growButton.pos.y += dir;
		}
		
		
		
		

	}
	
	override function onmousemove(e:MouseEvent) 
	{
		
		mouse.set_xy(e.x, e.y);
		
		if (mouse.y <= 100) {
			moveCam = 1;
		} else if (mouse.y >= Luxe.screen.height - 100) {
			moveCam = -1;
		} else {
			moveCam = 0;
		}
	}

	override function update(dt:Float) 
	{
		if (tree == null) {
		    return;
		}
		
		/*var buttons:Array<Entity> = Luxe.scene.get_named_like('button', new Array<Entity>());
		for (button in buttons) {
			trace("here?");
			button.get('button').mouse = mouse;
		}*/
		
		growButton.get('button').mouse = mouse;
		ffButton.get('button').mouse = mouse;
		
		moveCamera(moveCam);
	}
}
