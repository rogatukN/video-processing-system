package vo
{
	import appConst.HistogramType;

	public class RGBHistograms
	{
		private var _mainHistogram : Histogram;
		private var _r : Histogram;
		private var _g : Histogram;
		private var _b : Histogram;
		private var _modaCount : int = -1;
		private var _modaType : String;
		
		public function get modaCount():int
		{
			if (_modaCount==-1){
				_modaCount = _r.modaArray.length;
				if (_modaCount<_g.modaArray.length){
					_modaType = HistogramType.R_TYPE;
				}else{
					_modaType = HistogramType.G_TYPE;
					_modaCount = _g.modaArray.length;
				}
				if (_b.modaArray.length<_modaCount){
					_modaType = HistogramType.B_TYPE;
					_modaCount = _b.modaArray.length;
				}
			}
			return _modaCount;
		}
		
		public function get modaType():String
		{
			return _modaType;
		}

		public function getHistogrmaByType(value : String):Histogram
		{
			switch(value)
			{
				case HistogramType.R_TYPE:
				{
					return _r;
				}
				case HistogramType.G_TYPE:
				{
					return _g;
				}
				case HistogramType.B_TYPE:
				{
					return _b;
				}
				case HistogramType.RGB_SER_TYPE:
				{
					return _mainHistogram;
				}
			}
			return _mainHistogram;
		}
		
		public function getHistogrmaByIndex(value : int):Histogram
		{
			switch(value)
			{
				case 0:
				{
					return _r;
				}
				case 1:
				{
					return _g;
				}
				case 2:
				{
					return _b;
				}
				case 3:
				{
					return _mainHistogram;
				}
			}
			return _mainHistogram;
		}
		
		public function setHistogrmaByType(value : Histogram, type : String):void
		{
			switch(type)
			{
				case HistogramType.R_TYPE:
				{
					_r = value;
					break;
				}
				case HistogramType.G_TYPE:
				{
					_g = value;
					break;
				}
				case HistogramType.B_TYPE:
				{
					_b = value;
					break;
				}
				case HistogramType.RGB_SER_TYPE:
				{
					_mainHistogram = value;
					break;
				}
			}
		}
		
		public function get mainHistogram():Histogram
		{
			return _mainHistogram;
		}

		public function set mainHistogram(value:Histogram):void
		{
			_mainHistogram = value;
		}

		public function get b():Histogram
		{
			return _b;
		}

		public function set b(value:Histogram):void
		{
			_b = value;
		}

		public function get g():Histogram
		{
			return _g;
		}

		public function set g(value:Histogram):void
		{
			_g = value;
		}

		public function get r():Histogram
		{
			return _r;
		}

		public function set r(value:Histogram):void
		{
			_r = value;
		}

	}
}