package;
import luxe.Component;
import luxe.options.ComponentOptions;

//here to store information about the tree so that flowers and fruits can access it.

typedef Info = {
	var treeName:String;
	var base:Node;
}

class TreeInfo extends Component
{
	public var treeName:String;
	public var base:Node;

	public function new(_info:Info, ?_options:ComponentOptions) 
	{
		super(_options);
		
		treeName = _info.treeName;
		base = _info.base;
	}
	
	override function init()
	{
		
	}
	
}