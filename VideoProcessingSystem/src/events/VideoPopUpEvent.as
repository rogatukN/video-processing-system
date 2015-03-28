package events
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class VideoPopUpEvent extends Event
	{
		public static const OPEN_POP_UP:String = "OPEN_POP_UP";
		public static const ClOSE_POP_UP:String = "ClOSE_POP_UP";
		
		public static const OPEN_SLIDE_POP_UP:String = "OPEN_SLIDE_POP_UP";
		public static const ClOSE_SLIDE_POP_UP:String = "ClOSE_SLIDE_POP_UP";
		
		public var bitmapdata:BitmapData;
		public var slides: ArrayCollection;
		
		public function VideoPopUpEvent(type:String, bitmapdata: BitmapData = null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.bitmapdata = bitmapdata;
		}
	}
}