package vo
{
	import flash.display.BitmapData;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class FrameVO
	{
		public var bitMap : BitmapData;
		public var time:Number;
		public var id:Number;
		
		//Jenya
		public var points: ArrayCollection;
		
		private static var idCounter: Number = -1;
		
		public function FrameVO()
		{
			idCounter++;
			id = idCounter;
		}
	}
}