package vo.view
{
	import flash.display.BitmapData;
	
	import model.ViewModel;
	
	[Bindable]
	public class SimplyTexturaViewVO
	{
		public var id:int;
		public var bitMap:BitmapData;
		//public var viewModel: ViewModel = ViewModel.instance;
		
		public function SimplyTexturaViewVO(transport:*){
			id = transport.id;
			var foto:BitmapData = new BitmapData(transport.width, transport.height, false, 0x0);
			transport.byteArray.position = 0;
			foto.setPixels(foto.rect, transport.byteArray);
			bitMap = foto; 
			//setRect(transport.x,transport.y,0xffffff00);
		}
		
		/*public function setRect(x: Number, y: Number,color:uint):void{
			for (var i: int = x-optionModel.offset; i <= x+optionModel.offset; i++) 
			{
				for (var j: int = y-optionModel.offset; j <= y+optionModel.offset; j++) 
				{
					if ((i<x-optionModel.offset+2 || i>x+optionModel.offset-2) && (j<y-optionModel.offset+2 || j>y+optionModel.offset-2)){
						viewModel.mainBitMap.setPixel32(i,j,color);
					}
				}
			}
		}*/
	}
}