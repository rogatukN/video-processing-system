package utils
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	[Event(name="samplerLoadComplete", type="flash.events.Event")]
	public class SamplerLoader extends EventDispatcher
	{
		public function SamplerLoader() 
		{
			file = new FileReference();
			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			file.addEventListener(Event.COMPLETE, completeHandler);
			file.browse(getTypes());
		}
		
		private var file:FileReference;
		public var data : BitmapData;
		
		private function getTypes():Array {
			var allTypes:Array = new Array(getImageTypeFilter());
			return allTypes;
		}
		
		private function getImageTypeFilter():FileFilter{
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}
		
		private function selectHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			file.load()
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		
		private function completeHandler(event:Event):void {
			var loader:Loader = new Loader();
			loader.loadBytes(file.data);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
		}     
		
		private function loaderComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			data = new BitmapData(loaderInfo.width, loaderInfo.height, false, 0xFFFFFF);
			data.draw(loaderInfo.loader);
			dispatchEvent(new Event('samplerLoadComplete'));
		}
	}
}