package;
import luxe.collision.shapes.Shape;
import luxe.Sprite;
import luxe.Vector;

typedef ClickEvent = {
	var to:Int;
}

typedef SpottedEvent = {
	var position:Vector;
	var treeName:String;
	var type:String;
	var object:Sprite;
	var node:Node;
}

typedef CreatedEvent = {
	//var shape:Shape;
	var sprite:Sprite;
	var treeName:String;

}

typedef WiltedEvent = {
	var id:Int;
}

typedef ReachedEvent = {
	var treeName:String;
	var moveType:String;
}

typedef CaterSpawnEvent = {
	var branch:Node;
}