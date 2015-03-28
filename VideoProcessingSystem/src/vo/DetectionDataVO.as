package vo
{
	public class DetectionDataVO
	{
		public var frameId: Number;
		public var x: Number;
		public var y: Number;
		public var x1: Number;
		public var y1: Number;
		public var flag: Boolean;
		
		public function DetectionDataVO(frameId: Number, x: Number, y: Number, x1: Number, y1: Number,flag = true)
		{
			this.frameId = frameId;
			this.x = x;
			this.y = y;
			this.x1 = x1;
			this.y1 = y1;
			this.flag = flag;
		}
	}
}