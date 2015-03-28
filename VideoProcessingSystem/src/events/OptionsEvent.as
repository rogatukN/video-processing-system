package events
{
	import flash.events.Event;
	
	public class OptionsEvent extends Event
	{
		public static const OFFSET_CHANGE : String = "OFFSET_CHANGE";
		public static const LOAD_ETALON : String = "LOAD_ETALON";
		public static const ALLOW_RECEIVE_ETALON : String = "ALLOW_RECEIVE_ETALON";
		public static const CLIENT_ETALON : String = "CLIENT_ETALON";
		public static const DETECT_SELECTED : String = "DETECT_SELECTED";
		
		public static const GET_COLLECTED_ETALON : String = "GET_COLLECTED_ETALON";
		
		public var data : *;
		public function OptionsEvent(type:String, data: *=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}