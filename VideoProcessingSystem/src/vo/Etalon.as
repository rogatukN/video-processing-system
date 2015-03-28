package vo
{
	import flash.geom.Point;

	public class Etalon
	{
		private var _r : Array = [];
		private var _g : Array = [];
		private var _b : Array = [];
		private var _porig : Number;
		public function Etalon(porig: Number)
		{
			_porig = porig;
			var serlength : int = Math.ceil(255/_porig);
			var siglength : int = Math.ceil(255/_porig);
			var arr : Array;
			for (var i:int = 0; i < siglength; i++) 
			{
				arr = [];
				arr.length = serlength;
				_r.push(arr);
				_g.push(arr);
				_b.push(arr);
			}
		}
		
		public function addEtalon(value: RGBHistograms):void{
			var point : Point = getRIndex(value);
			(_r[point.x] as Array)[point.y] = true;
			point = getGIndex(value);
			(_g[point.x] as Array)[point.y] = true;
			point = getBIndex(value);
			(_b[point.x] as Array)[point.y] = true;
		}
		
		public function getValueByRIndexes(value: RGBHistograms):Boolean{
			var point : Point = getRIndex(value);
			return (_r[point.x] as Array)[point.y];
		}
		
		public function getValueByGIndexes(value: RGBHistograms):Boolean{
			var point : Point = getGIndex(value);
			return (_g[point.x] as Array)[point.y];
		}
		
		public function getValueByBIndexes(value: RGBHistograms):Boolean{
			var point : Point = getBIndex(value);
			return (_b[point.x] as Array)[point.y];
		}
		
		public function getRIndex(value: RGBHistograms):Point{
			return  new Point(Math.round(value.r.sigma/_porig), Math.round(value.r.ser/_porig));
		}
		
		public function getGIndex(value: RGBHistograms):Point{
			return  new Point(Math.round(value.g.sigma/_porig), Math.round(value.g.ser/_porig));
		}
		
		public function getBIndex(value: RGBHistograms):Point{
			return  new Point(Math.round(value.b.sigma/_porig), Math.round(value.b.ser/_porig));
		}
	}
}