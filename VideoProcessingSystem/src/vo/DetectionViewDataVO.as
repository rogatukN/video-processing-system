package vo
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import appConst.Const;
	
	import model.IFrame;
	import model.OptionsModel;
	import model.ViewModel;
	
	import utils.BitMapUtils;

	[Bindable]
	public class DetectionViewDataVO implements IFrame
	{
		public var frameId: Number;
		public var x: Number;
		public var y: Number;
		public var findx: Number;
		public var findy: Number;
		public var bitMap: BitmapData;
		private var viewModel: ViewModel = ViewModel.instance;
		public var detectBitMap: BitmapData;
		public var flag: Boolean;
		public var optionModel : OptionsModel = OptionsModel.instance;
		
		public function DetectionViewDataVO(frameId: Number, x: Number, y: Number, x1: Number, y1: Number,flag: Boolean = true)
		{
			this.frameId = frameId;
			this.x = x;
			this.y = y;
			findx = x1;
			findy = y1;
			this.bitMap = getFrameByID(frameId).bitMap;
			this.flag = flag;
			/*for (var i:int = -1; i < 1; i++) 
			{
				for (var j:int = 0; j < 3; j++) 
				{	
					var point: Point = new Point(x+2*i*Const.OFFSET_OLD,y+2*j*Const.OFFSET_OLD)
					this.bitMap.setPixel32(point.x-Const.OFFSET_OLD,point.y-Const.OFFSET_OLD,0xffffffff);
					this.bitMap.setPixel32(point.x+Const.OFFSET_OLD,point.y-Const.OFFSET_OLD,0xffffffff);
					this.bitMap.setPixel32(point.x-Const.OFFSET_OLD,point.y+Const.OFFSET_OLD,0xffffffff);
					this.bitMap.setPixel32(point.x+Const.OFFSET_OLD,point.y+Const.OFFSET_OLD,0xffffffff);
				}
			}*/
			detectBitMap = BitMapUtils.getBitmapByPoint(bitMap,new Point(x1,y1),optionModel.offset);
			BitMapUtils.setCircle(this.bitMap,new Point(x1,y1));
			BitMapUtils.setCross(this.bitMap);
		}

		private function getFrameByID(id: Number):FrameVO{
			for each (var frame:FrameVO in viewModel.frames) 
			{
				if (frameId == frame.id){
					return frame;
				}
			}
			return null;
		}
	}
}