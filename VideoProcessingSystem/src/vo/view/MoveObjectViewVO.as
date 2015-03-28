package vo.view
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.OptionsModel;
	import model.ViewModel;

	[Bindable]
	public class MoveObjectViewVO {
		public var id:int;
		public var bitMap:BitmapData;
		public var time:Number;
		public var frame: BitmapData;
		public var selected : Boolean;
		public var optionModel : OptionsModel = OptionsModel.instance;
		public var viewModel: ViewModel = ViewModel.instance;
		
		public var x: Number;
		public var y: Number;
		
		public var conMenu: Boolean;
		
		public function MoveObjectViewVO(transport:*/*MoveObjectTransportVO*/, bitmapData:BitmapData){
			id = transport.id;
			frame = bitmapData;
			bitMap = new BitmapData(transport.width, transport.height, false, 0x000000);
			x= transport.x;
			y=transport.y;
			bitMap.copyPixels(bitmapData, new Rectangle(transport.x-optionModel.offset, transport.y-optionModel.offset, transport.width, transport.height), new Point());
			time = transport.time;
			setRect(x,y,0xffff0000);
		}
		
		public function setRect(x: Number, y: Number,color:uint):void{
			for (var i: int = x-optionModel.offset; i <= x+optionModel.offset; i++) 
			{
				for (var j: int = y-optionModel.offset; j <= y+optionModel.offset; j++) 
				{
					if ((i<x-optionModel.offset+2 || i>x+optionModel.offset-2) && (j<y-optionModel.offset+2 || j>y+optionModel.offset-2)){
						viewModel.mainBitMap.setPixel32(i,j,color);
					}
				}
			}
		}
	}
}