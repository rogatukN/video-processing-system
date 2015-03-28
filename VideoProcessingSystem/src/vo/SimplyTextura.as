package vo
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import vo.transport.SimplyTexturaTransportVO;

	public class SimplyTextura
	{
		public static function simplyTexturaToTaransportArray(array:Array):Array{
			var res:Array = [];
			for each (var textura:SimplyTextura in array) {
				res.push(textura.toTransportObject());
			}
			return res;
		}
		
		private static var idCounter:int;
		private var _rgbHistograms : RGBHistograms;
		private var _bmp : BitmapData;
		private var _coordinates: Point;
		public var id:Number;
		
		public function SimplyTextura(value : RGBHistograms)
		{
			_rgbHistograms = value;
			id = idCounter++;
		}
		
		public function toTransportObject():SimplyTexturaTransportVO{
			var transport:SimplyTexturaTransportVO = new SimplyTexturaTransportVO();
			transport.id = id;
			transport.height = _bmp.height;
			transport.width = _bmp.width;
			transport.x = coordinates.x;
			transport.y = coordinates.y;
			var byteArr:ByteArray = new ByteArray();
			_bmp.copyPixelsToByteArray(_bmp.rect, byteArr);
			byteArr.shareable = true;
			transport.byteArray = byteArr;
			return transport;
		}
		
		public function get rgbHistograms():RGBHistograms
		{
			return _rgbHistograms;
		}

		public function get bmp():BitmapData
		{
			return _bmp;
		}

		public function set bmp(value:BitmapData):void
		{
			_bmp = value;
		}
		
		public function get coordinates():Point
		{
			return _coordinates;
		}
		
		public function set coordinates(value:Point):void
		{
			if (value == _coordinates){
				return;
			}
			_coordinates = value;
		}

	}
}