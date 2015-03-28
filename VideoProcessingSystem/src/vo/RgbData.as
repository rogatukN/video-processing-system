package vo
{
	import flash.display.BitmapData;

	public class RgbData
	{
		private var _data : BitmapData;
		private var _width : int;
		private var _height: int;
		private var _dataArr : Array;
		
		public function RgbData(value : BitmapData)
		{
			_data = value;
			_height = _data.height;
			_width = _data.width;
			_dataArr = [];
			_dataArr.length = _width;
			var arr : Array;
			for (var i:int = 0; i < _width; i++) 
			{
				arr = [];
				arr.length = _height;
				_dataArr[i] = arr;
			}
		}
		public function get data():BitmapData{
			return _data;
		}
		
		public function setRGB(i:int,j:int,rgb : RgbItem):void{
			(_dataArr[i] as Array)[j] = rgb;
		}
		
		public function getRGB(i:int,j:int):RgbItem{
			if (!(_dataArr[i] as Array)[j]){
				(_dataArr[i] as Array)[j] = new RgbItem(_data.getPixel(i,j));
			}
			return RgbItem((_dataArr[i] as Array)[j]);
		}
		
		public function get width():int{
			return _width;
		}
		
		public function get height():int{
			return _height;
		}
	}
}