package events
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class ScreenShotEvent extends Event {
		
		public static const COMPUTE:String = "compute";
		public static const COMPLETE:String = "COMPLETE";
		
		public var bitmapdata:BitmapData;
		public var time:Number;
		public var index : int;
		
		public function ScreenShotEvent(type:String, bitmapdata:BitmapData, time:Number, index : int = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.bitmapdata = bitmapdata;
			this.time = time;
			this.index = index;
		}
		
		override public function clone():Event{
			return new ScreenShotEvent(type, bitmapdata, time, index, bubbles, cancelable);
		}
	}
}