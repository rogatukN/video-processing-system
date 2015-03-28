package vo
{
	import flash.geom.Point;

	public class RgbItem
	{
		private var _data : uint;
		private var _color : String;
		private var _r : int;
		private var _g : int;
		private var _b : int;
		public var point : Point;
		
		public function RgbItem(value :uint = 0xffffff)
		{
			_data = value;
			_color = value.toString(16);
		}
		
		public function get uintValue():uint{
			return rgbToUint(_r,_g,_b);
		}
		
		public function get color():int{
			return r+g*256+b*65536;
			//return _data;
		}
		
		public function set r(value : int):void{
			if(value == _r){
				return;
			}
			if (value<0){
				_r = 256+value;
			}else{
				_r = value;
			}
		}
		
		public function get r():int{
			if (!_r){
				_r = parseInt(_color.substring(_color.length-2,_color.length),16);
			}
			return _r;
		}
		
		public function set g(value : int):void{
			if(value == _g){
				return;
			}
			if (value<0){
				_g = 256+value;
			}else{
				_g = value;
			}
		}
		
		public function get g():int{
			if (!_g){
				_g = parseInt(_color.substring(_color.length-4,_color.length-2),16);
			}
			return _g;
		}
		
		public function set b(value : int):void{
			if(value == _b){
				return;
			}
			if (value<0){
				_b = 256+value;
			}else{
				_b = value;
			}
		}
		
		public function get b():int{
			if (!_b){
				_b = parseInt(_color.substring(_color.length-6,_color.length-4),16);
			}
			return _b;
		}
		
		public function get ser():Number{
			return ((r+g+b)/3);
		}
		
		public static function intTOUint(value : Number):uint{
			var b : int = Math.floor(value/65536);
			value -= b*65536;
			var g : int = Math.floor(value/256);
			var r : int = value - g*256;
			return rgbToUint(r,g,b)
		}
		
		public static function rgbToUint(r : int, g: int, b: int):uint{
			if (r<0){
				r=256+r;
			}
			if (g<0){
				g=256+g;
			}
			if (b<0){
				b=256+b;
			}
			var rstr : String = r.toString(16);
			if (rstr.length == 1){
				rstr = '0'+rstr; 
			}
			var gstr : String = g.toString(16);
			if (gstr.length == 1){
				gstr = '0'+gstr; 
			}
			var bstr : String = b.toString(16);
			if (bstr.length == 1){
				bstr = '0'+bstr; 
			}
			var str : String ='0x'+rstr.slice(0,2)+gstr.slice(0,2)+bstr.slice(0,2);
			return uint(str);
		}
	}
}