package;
import luxe.Timer;
import luxe.Component;
import luxe.options.ComponentOptions;

import EventDetails;

class Autogrow extends Component
{
	var swapGrowthTimer:Timer;
	var swapFFTimer:Timer;
	
	var curGrowState:Int;
	var curFFState:Int;
	
	var flowerCount:Int;

	public function new(?_options:ComponentOptions) 
	{
		super(_options);
	}
	
	override function init()
	{
		swapGrowthTimer = new Timer(Luxe.core);
		swapFFTimer = new Timer(Luxe.core);
		
		curGrowState = 1;
		curFFState = 2;
		
		flowerCount = 0;
		
		balanced();
		
		
	}
	
	public function balanced()
	{
		swapGrowthTimer.schedule(1 + Math.random() * 10, swapGrowth);
		swapFFTimer.schedule(1 * Math.random() * 10, swapFF);
		
		Luxe.events.listen('flowercreated', flowerCreated);
	}
	
	
	public function swapState(state:Int)
	{
		if (state == 1) {
			return 2;
		} else if (state == 2) {
			return 1;
		}
		return 0;
	}
	
	public function swapGrowth()
	{
		Luxe.events.fire('changegrowstate' + entity.name, { to:curGrowState } );
		
		curGrowState = swapState(curGrowState);
		
		swapGrowthTimer.reset();
		swapGrowthTimer.schedule(1 + Math.random() * 10, swapGrowth);
	}
	
	public function swapFF()
	{
		Luxe.events.fire('changeffstate' + entity.name, { to:curFFState } );
	
		curFFState = swapState(curFFState);
		
		swapFFTimer.reset();
		swapFFTimer.schedule(2 * Math.random() * 10, swapFF);

		
	}
	
	public function flowerCreated(data:CreatedEvent)
	{
		if (data.treeName == entity.name) {
			flowerCount++;
		}
	}
	
}