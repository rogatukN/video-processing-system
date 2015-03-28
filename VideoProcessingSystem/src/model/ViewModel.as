package model
{
	import flash.display.BitmapData;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public final class ViewModel {
		
		public var mainBitMap:BitmapData;
		public var foreignObjects1:ArrayCollection = new ArrayCollection();
		public var foreignObjects2:ArrayCollection = new ArrayCollection();
		public var frames: ArrayCollection = new ArrayCollection();
		public var detectionFrames: ArrayCollection = new ArrayCollection();
		
		
		private static var _instance:ViewModel;
		
		public static function get instance():ViewModel{
			if(!_instance){
				_instance = new ViewModel(new SingletonHalper());
			}
			return _instance;
		}
		
		public function ViewModel(arg:SingletonHalper)
		{
			if(arg == null){
				throw new Error("Use instance");
			}
		}
	}
}

internal class SingletonHalper{}