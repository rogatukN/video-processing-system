package events
{
	import flash.events.Event;
	
	public class WorkerEvent extends Event
	{
		public static const DETECTION_COMPLETE : String = "DETECTION_COMPLETE";
		
		public var data : *;
		public function WorkerEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}