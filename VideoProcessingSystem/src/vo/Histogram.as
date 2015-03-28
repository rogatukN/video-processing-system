package vo
{
	import flash.geom.Point;
	
	import appConst.Const;

	public class Histogram
	{
		private var _data : Array;
		private var _points : Array;
		private var _ser : Number;
		private var _modaCount : int;
		private var _modaArray : Array;
		private var _sigma : Number;
		private var _pirsona : Number;
		private var _asymmetry : Number;
		private var _excess : Number;
		private static const MODA_MIN : Number = 25;
		public static const ANOMAL_VALUE : Number = 0.005;
		
		private var _rozbutya : int;
		private var chastotu: Array;
		private var inter : int;
		private var poch : Number;
		
		public function Histogram(value : Array)
		{
			_data = value;
		}

		public function get data():Array
		{
			return _data;
		}
		
		public function get points():Array
		{	if (_points){
				return _points;
			}
			_points = [];
			_points.length = _data.length;
			var point : Point;
			for (var i:int = 0; i < _data.length; i++) 
			{
				point = new Point();
				point.y = Number(_data[i]);
				point.x = i;
				_points[i]=point;
			}
			return _points;
		}
		
		public function set rozbutya(value:int):void
		{
			_rozbutya = value;
			inter = Math.floor(256/_rozbutya);
			poch = (inter-1)*.5;
			chastotu = [];
			for (var j:int = 0; j < _rozbutya; j++) 
			{
				chastotu.push(0);
			}
			for (var i:int = 0; i < _data.length; i++) 
			{
				for (var k:int = 0; k < _rozbutya; k++) 
				{
					if (i>= k*inter && i<(k+1)*inter){
						chastotu[k]+=_data[i];
						break;
					}
				}
			}
			var test : Number = 0;
			for (var i2:int = 0; i2 < _rozbutya; i2++) 
			{
				test+=chastotu[i2];
			}
		}
		
		public function get ser():Number{
			if (isNaN(_ser)){
				_ser = 0;
				for (var i:int = 0; i < _data.length; i++) 
				{
					_ser+=(_data[i]*i);
				}
			}
			return _ser;
		}
		
		public function get modaArray():Array{
			if (!_modaArray){
				_modaArray = [];
				var item : ModaVO;
				rozbutya = 256;
				for (var i:int = 0; i < chastotu.length; i++) 
				{
					item = new ModaVO();
					item.index = (inter-1)*.5+inter*i;
					item.value = chastotu[i];
					_modaArray.push(item);
				}
				_modaArray = clearModaArr(_modaArray);
			}
			return _modaArray
		}
		
		public function get sigma():Number{
			if (isNaN(_sigma)){
				_sigma = 0;
				for (var i:int = 0; i < _data.length; i++) 
				{
					_sigma += Math.pow((i-ser),2)*_data[i];
				}
				_sigma = _sigma*_data.length/(_data.length-1);
				_sigma = Math.sqrt(_sigma);
			}
			return _sigma
		}
		
		public function get pirsona():Number{
			if (isNaN(_pirsona)){
				_pirsona = sigma/ser;
			}
			return _pirsona;
		}
		
		public function get asymmetry():Number{
			if (isNaN(_asymmetry)){
				_asymmetry = 0;
				for (var i:int = 0; i < _data.length; i++) 
				{
					_asymmetry += Math.pow((i-ser),3)*_data[i];
				}
				_asymmetry = _asymmetry/Math.pow(sigma,3);
				_asymmetry = _asymmetry*Math.sqrt(_data.length*(_data.length-1))/(_data.length-2);
			}
			return _asymmetry;
		}
		
		public function get excess():Number{
			if (isNaN(_excess)){
				_excess = 0;
				for (var i:int = 0; i < _data.length; i++) 
				{
					_excess += Math.pow((i-ser),4)*_data[i];
				}
				_excess = _excess/Math.pow(sigma,4);
				_excess = ((Math.pow(_data.length,2)-1)*((_excess-3)+(6/(_data.length+1))))/((_data.length-2)*(_data.length-3));
			}
			return _excess;
		}
		//helper
		
		private function clearModaArr(value : Array):Array
		{
			var newModaArr : Array = [];
			var preItem : ModaVO = new ModaVO;
			preItem.value = 0;
			preItem.index = -1;
			var nextItem : ModaVO;
			var item : ModaVO;
			var preFlag : Boolean;
			var nextFlag : Boolean;
			for (var i:int = 0; i < value.length; i++) 
			{
				preFlag = false;
				nextFlag = false;
				item = value[i] as ModaVO;
				if (i!=value.length-1){
					nextItem = value[i+1] as ModaVO;
				}else{
					nextItem = new ModaVO();
					nextItem.value = 0;
					nextItem.index = i+1;
				}
				if ((item.index - preItem.index)> Const.SIGMA*1.5){
					preFlag = true;
				}
				if ((nextItem.index - item.index)> Const.SIGMA*1.5){
					nextFlag = true;
				}
				if ((preFlag && nextFlag) || (!preFlag && !nextFlag && preItem.value<item.value && nextItem.value<item.value) || ((nextFlag && !preFlag && preItem.value<item.value) || (preFlag && !nextFlag && nextItem.value<=item.value))){
					newModaArr.push(item);
				}
				preItem = item;
			}
			if (newModaArr.length==0){
				return value;
			}
			if (newModaArr.length!=value.length){
				return clearModaArr(newModaArr);
			}
			return newModaArr;
		}
	}
}