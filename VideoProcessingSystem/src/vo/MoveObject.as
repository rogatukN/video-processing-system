package vo
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import appConst.FilterConsts;
	import appConst.HistogramType;
	
	import model.VideoModel;
	
	import utils.Filters;
	import utils.StatisticalUtil;
	
	import vo.transport.MoveObjectTransportVO;

	public class MoveObject
	{	
		public var videoModel : VideoModel = VideoModel.instance;
		private static var idCounter:int;
		
		public static function moveObjectsToTaransportArray(array:Array):Array{
			var res:Array = [];
			for each (var moveObject:MoveObject in array) {
				res.push(moveObject.toTransportObject());
			}
			return res;
		}
		
		public static function moveObjectsToTaransportArray2(array:Array):Array{
			var res:Array = [];
			for each (var moveObject:MoveObject in array) {
				res.push(moveObject.toTransportObject2());
			}
			return res;
		}
		
		
		private var _coordinates : Point;
		private var _data: BitmapData;
		private var _currentData: BitmapData;
		private var _rgb: RgbData;
		private var _clearedrgb: RgbData;
		private var _clusters: Array;ClusterVO;
		private var _clusterIndexes: Array;
		private var _rgbHistograms : RGBHistograms;
		private var _clearedrgbHistograms : RGBHistograms;
		public var time : Number;
		public var id:Number;
		public var testBitMap: BitmapData;
		
		public function MoveObject(bmp : BitmapData, point: Point)
		{
			_coordinates = point;
			_data = bmp;
			id = idCounter++;
		}
		
		public function toTransportObject():MoveObjectTransportVO{
			var transport:MoveObjectTransportVO = new MoveObjectTransportVO();
			transport.id = id;
			transport.height = bitMap.height;
			transport.width = bitMap.width;
			transport.x = coordinates.x;
			transport.y = coordinates.y;
			transport.time = time;
			return transport;
		}
		
		public function toTransportObject2():MoveObjectTransportVO{
			var transport:MoveObjectTransportVO = new MoveObjectTransportVO();
			transport.id = id;
			transport.height = bitMap.height;
			transport.width = bitMap.width;
			var byteArr:ByteArray = new ByteArray();
			bitMap.copyPixelsToByteArray(bitMap.rect, byteArr);
			byteArr.shareable = true;
			transport.byteArray = byteArr;
			return transport;
		}
		
		public function get clusters():Array
		{
			if (!_clusters){
				_clusters = [];
				_clusterIndexes = [];
				var clusters : Array = getClustersModa();	
				var gists : Array = [];
				var gistData : Array = [];
				var indexes : Array = [];
				for each (var cluster:Array in clusters) 
				{
					gistData = [];
					gists.push(gistData);
					
					indexes = [];
					_clusterIndexes.push(indexes);
				}
				var num : Number;
				var min : Number = 256;
				var clusterIndex : int;
				testBitMap = new BitmapData(videoModel.offset*2+1,videoModel.offset*2+1);
				for (var i:int = 0; i < rgb.width; i++) 
				{
					if (i>0){
						for (var j:int = 0; j < rgb.height; j++) 
						{ 
							if (j>0){
								min = 256;
								for (var k:int = 0; k < clusters.length; k++) 
								{
									var arr:Array = clusters[k] as Array;
									num = 0;
									num+=Math.abs((arr[0]as ModaVO).index-rgb.getRGB(i,j).r);
									if (num<min){
										min = num;
										clusterIndex = k;
									}
									num+=Math.abs((arr[1]as ModaVO).index-rgb.getRGB(i,j).g);
									if (num<min){
										min = num;
										clusterIndex = k;
									}
									num+=Math.abs((arr[2]as ModaVO).index-rgb.getRGB(i,j).b);
									if (num<min){
										min = num;
										clusterIndex = k;
									}
								}
								//testBitMap.setPixel(i,j,clusterIndex*10000);
								if(clusterIndex>3){
									testBitMap.setPixel(i,j,rgb.getRGB(i,j).uintValue);
								}
								gistData = gists[clusterIndex]as Array;
								indexes = _clusterIndexes[clusterIndex]as Array;
								gistData.push(rgb.getRGB(i,j));
								indexes.push(new Point(i,j));
							}
						}
					}
				}
				for (var i2:int = 0; i2 < gists.length; i2++) 
				{
					gistData = gists[i2] as Array;
					if (gistData.length != 0){
						var newCluster: ClusterVO = StatisticalUtil.getSimplyHistograms(gistData);
						indexes = _clusterIndexes[i2]as Array;
						var xSer: Number = 0;
						var ySer: Number = 0;
						for each (var point:Point in indexes) 
						{
							xSer+=point.x;
							ySer+=point.y;
						}
						xSer = xSer/indexes.length;
						ySer = ySer/indexes.length;
						newCluster.xSer = xSer;
						newCluster.ySer = ySer;
						var xSig: Number = 0;
						var ySig: Number = 0;
						for each (point in indexes) 
						{
							xSig+=Math.pow(point.x-xSer,2);
							ySig+=Math.pow(point.y-ySer,2);
						}
						newCluster.xSig=Math.sqrt(xSig/(indexes.length-1));
						newCluster.ySig=Math.sqrt(ySig/(indexes.length-1));
						_clusters.push(newCluster);
					}
				}
			}
			return _clusters;
		}
		
		public function get rgbHistograms():RGBHistograms
		{
			if (!_rgbHistograms){
				_rgbHistograms = new RGBHistograms();
				_rgbHistograms.r = new Histogram(StatisticalUtil.histogramEstimateBy(rgb,HistogramType.R_TYPE));
				_rgbHistograms.g = new Histogram(StatisticalUtil.histogramEstimateBy(rgb,HistogramType.G_TYPE));
				_rgbHistograms.b = new Histogram(StatisticalUtil.histogramEstimateBy(rgb,HistogramType.B_TYPE));
				_rgbHistograms.mainHistogram = new Histogram(StatisticalUtil.histogramEstimateBy(rgb,HistogramType.RGB_SER_TYPE));
			}
			return _rgbHistograms;
		}
		
		/*public function get clearedRGBHistograms():RGBHistograms
		{
			if (!_clearedrgbHistograms){
				_clearedrgb = new RgbData(testBitMap);
				_clearedrgbHistograms = new RGBHistograms();
				_clearedrgbHistograms.r = new Histogram(StatisticalUtil.histogramEstimateBy(_clearedrgb,HistogramType.R_TYPE));
				_clearedrgbHistograms.g = new Histogram(StatisticalUtil.histogramEstimateBy(_clearedrgb,HistogramType.G_TYPE));
				_clearedrgbHistograms.b = new Histogram(StatisticalUtil.histogramEstimateBy(_clearedrgb,HistogramType.B_TYPE));
				_clearedrgbHistograms.mainHistogram = new Histogram(StatisticalUtil.histogramEstimateBy(_clearedrgb,HistogramType.RGB_SER_TYPE));
			}
			return _clearedrgbHistograms;
		}*/

		public function get bitMap():BitmapData{
			return _data;
		}
		
		public function get currentBitMap():BitmapData{
			if (!_currentData){
				_currentData = new BitmapData(_data.width,_data.height);
				for (var i:int = 0; i < _data.width; i++) 
				{
					for (var j:int = 0; j < _data.height; j++) 
					{
						_currentData.setPixel(i,j,_rgb.getRGB(i,j).uintValue);
					}
				}
			}
			return _currentData;
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
		
		public function set rgb(value : RgbData):void{
			_rgb = value;
		}
		
		public function get rgb():RgbData{
			if (_rgb){
				return _rgb;
			}
			_rgb = new RgbData(_data);
			return _rgb;
		}
	
		public function setfilter(type : String,rgbData : RgbData = null):void{
			var rgbValue : RgbData = rgb;
			if (rgbData){
				rgbValue = rgbData;
			}
			switch(type)
			{
				case FilterConsts.L_20:
				{
					_rgb = Filters.SplineL20(rgbValue);
					break;
				}
					
				case FilterConsts.H_20:
				{
					_rgb = Filters.SplineH20(rgbValue);
					break;
				}
				case FilterConsts.L_30:
				{
					_rgb = Filters.SplineL30(rgbValue);
					break;
				}
				case FilterConsts.H_30:
				{
					//_rgb = Filters.SplineH30(rgbValue);
					break;
				}
			}
		}
		
		protected function getClustersModa():Array{
			var _clusterModaArr : Array = [];
			var cluster:Array;
			var clusterModa : Array;
			for (var i:int = 0; i < rgbHistograms.modaCount; i++) 
			{
				clusterModa = [];
				for (var j:int = 0; j < 3; j++) 
				{
					clusterModa.push(0);
				}
				_clusterModaArr.push(clusterModa);
				setClusterModa(rgbHistograms.r,0,_clusterModaArr);
				setClusterModa(rgbHistograms.g,1,_clusterModaArr);
				setClusterModa(rgbHistograms.b,2,_clusterModaArr);
			}
			return _clusterModaArr;
		}
		
		private function setClusterModa(value : Histogram, index : int, array : Array):void{
			var clustrIndex : int;
			var cluster:Array;
			if (value.modaArray.length == rgbHistograms.modaCount){
				for each (cluster in array) 
				{
					clustrIndex = array.indexOf(cluster);
					cluster[index] = value.modaArray[clustrIndex];
				}
			}else{
				var nearGist : Histogram = rgbHistograms.getHistogrmaByType(rgbHistograms.modaType) as Histogram;
				for each (cluster in array) 
				{
					clustrIndex = array.indexOf(cluster);
					var nearModa : ModaVO = nearGist.modaArray[clustrIndex] as ModaVO;
					var vidst : Number = 256;
					var findIndex : int;
					for each (var moda:ModaVO in value.modaArray) 
					{
						if (Math.abs(moda.index-nearModa.index)<vidst){
							vidst = Math.abs(moda.index-nearModa.index);
							findIndex = value.modaArray.indexOf(moda);
						}
					}
					cluster[index] = value.modaArray[findIndex];
				} 
			}
		}
	}
}