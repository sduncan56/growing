package;
import luxe.collision.Collision;
import luxe.collision.shapes.Polygon;
import luxe.collision.shapes.Ray;
import luxe.collision.shapes.Shape;
import luxe.Component;
import luxe.options.ComponentOptions;
import luxe.Sprite;
import luxe.Timer;
import luxe.Vector;

import EventDetails;
import luxe.utils.Maths;

class Watcher extends Component
{
	var eventID:String;
	var eventRemoveID:String;
	var reachedEventID:String;
	
	var objects:Array<Sprite>;
	
	var lookTimer:Timer;
	
	var sprite:Sprite;
	
	var maxViewDistance:Int;
	
	
	public function new(_eventid:String, _maxViewDistance:Int, ?_options:ComponentOptions)
	{
		super(_options);
		
		eventID = _eventid;
		
		objects = new Array();
		
		maxViewDistance = _maxViewDistance;
		
		//eventRemoveID = _eventRemoveID;

		
	}
	
	override function init()
	{
		lookTimer = new Timer(Luxe.core);
		lookTimer.schedule(0.5, look, true);
		
		sprite = cast entity;
		
		Luxe.events.listen(eventID, somethingCreated);
		//Luxe.events.listen(reachedEventID, somewhereReached);
		//Luxe.events.listen(eventRemoveID, somethingDestroyed);
	}
	
	public function look()
	{							
		var beams:Array<Ray> = new Array();
		var angle:Int = 20;
								
		for (i in 0...4) {
			var startPoint:Vector = new Vector(sprite.pos.x, sprite.pos.y);
			var endPoint:Vector = new Vector(startPoint.x + maxViewDistance * Math.sin(Maths.radians(angle)),
			                          startPoint.y * maxViewDistance * Math.cos(Maths.radians(angle)));
			var beam:Ray = new Ray(startPoint, endPoint);
			
			angle += 10;
			
			var shapes:Array<Shape> = new Array();
			var m:Map<Shape, Sprite> = new Map();
			
			for (object in objects)
			{
		        var shape:Shape = Polygon.rectangle(object.pos.x, object.pos.y, 
				                    object.uv.w, object.uv.h);
									
				shapes.push(shape);
				m.set(shape, object);
			}
			
			var spottedObjects = Collision.rayWithShapes(beam, shapes);
			
			for (object in spottedObjects) {
				var s:Sprite = m.get(object.shape);
				var names:Array<String> = s.name.split('_');
				var info:TreeInfo = cast s.get('treeinfo');
				sprite.events.fire('objectspotted', { position:object.shape.position, 
				                                      treeName:info.treeName,
													  type:names[0],
													  object:s
													  } );
				objects = [];
				return; //may make this more sophisticated later (evaluate objects for desirability) - for now, just finish.
			}
			
			
			//beams.push(beam);
		}
		

	}
	
	public function somethingCreated(data:CreatedEvent)
	{
		objects.push(data.sprite);
	}
	
	public function somethingDestroyed(data:WiltedEvent)
	{
		trace("moo");
		
	}
	

	

	
}