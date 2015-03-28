package utils
{
	import flash.geom.Point;
	
	import model.VideoModel;
	
	import vo.ClusterVO;
	import vo.Histogram;
	import vo.MoveObject;
	import vo.RGBHistograms;

	public class DistanceUtil
	{
		
		private static var vmodel : VideoModel = VideoModel.instance;
		
		public static function getW(arr : Array):MoveObject
		{
			var max : Number = 0;
			var minPori : MoveObject;
			var kil : int;
			trace('LENGTH',arr.length);
			for each (var object:MoveObject in arr) 
			{
				kil = 0;
				for (var i:int = 0; i < object.rgb.width; i++) 
				{
					for (var j:int = 0; j < object.rgb.height; j++) 
					{
						if (object.rgb.getRGB(i,j).color > 15000000){
							kil++
						}
					}
				}
				trace(kil);
				if (kil>max){
					max=kil;
					minPori = object;
				} 
			}
			return minPori;	
		}
		
		public static function bySer(arr : Array,preObject : Histogram):MoveObject
		{
			var min : Number = 1000000000000000000000;
			var minPori : MoveObject;
			var vid : Number;
			for each (var object:MoveObject in arr) 
			{
				vid = subtractionBySer(object.rgbHistograms.mainHistogram,preObject);
				if (vid<min){
					min=vid;
					minPori = object;
				} 
			}
			return minPori;
		}
		
		public static function bySer2(arr : Array,preObject : Histogram):MoveObject
		{
			var min : Number = 1000000000000000000000;
			var minPori : MoveObject;
			var vid : Number;
			for each (var object:MoveObject in arr) 
			{
				vid = subtractionBySer2(object.rgbHistograms.mainHistogram,preObject,min);
				if (vid<min){
					min=vid;
					minPori = object;
				} 
			}
			return minPori;
		}
		
		public static function bySer2W(arr : Array,preObject : Histogram):MoveObject
		{
			var max : Number = 0;
			var mxPori : MoveObject;
			var vid : Number;
			for each (var object:MoveObject in arr) 
			{
				vid = object.rgbHistograms.mainHistogram.ser;
				//vid = subtractionBySer2(object.rgbHistograms.mainHistogram,preObject,min);
				if (vid>max){
					max=vid;
					mxPori = object;
				} 
			}
			return mxPori;
		}
		
		public static function byCluster(arr : Array, etalon: MoveObject):MoveObject
		{
			var min : Number = 10000;
			var minPori : MoveObject;
			var vid : Number;
			for each (var object:MoveObject in arr) 
			{
				vid = 0;
				vid = compareClustersRGB(object.rgbHistograms.mainHistogram,etalon.clusters);
				if (vid<min){
					min=vid;
					minPori = object;
				} 
			}
			return minPori;	
		}
		
		public static function subtractionBySer(move1 : Histogram, move2 : Histogram, porigRiz : Number = 25):Number{
			var hist1 : Array;
			var hist2 : Array;
			var riz : Number;
			if (move2.ser>move1.ser){
				riz = Math.round(move2.ser-move1.ser);
				hist1 = move1.points;
				hist2 = move2.points;
			}else{
				riz = Math.round(move1.ser-move2.ser);
				hist1 = move2.points;
				hist2 = move1.points;	
			}
			
			var num : Number = 0;
			var point2:Point;
			var point1:Point;
			if (riz>porigRiz){
				riz=0;
			}
			for (var i:int = 0; i < hist2.length-riz; i++) 
			{
				point1 = hist1[i] as Point;
				point2 = hist2[i+riz] as Point;
				num+=Math.sqrt(Math.pow(point1.y - point2.y,2));
			}
			return num;
		}
		
		public static function subtractionBySer2(move1 : Histogram, move2 : Histogram, min: Number, porigRiz : Number = 255):Number{
			var hist1 : Array;
			var hist2 : Array;
			var riz : Number;
			if (move2.ser>move1.ser){
				riz = Math.round(move2.ser-move1.ser);
				hist1 = move1.points;
				hist2 = move2.points;
			}else{
				riz = Math.round(move1.ser-move2.ser);
				hist1 = move2.points;
				hist2 = move1.points;	
			}
			
			var num : Number = 0;
			var point2:Point;
			var point1:Point;
			if (riz>porigRiz){
				riz=0;
			}
			for (var i:int = 0; i < hist2.length-riz; i++) 
			{
				point1 = hist1[i] as Point;
				point2 = hist2[i+riz] as Point;
				num+=Math.sqrt(Math.pow(point1.y - point2.y,2));
				if (num>min){
					return num;
				}
			}
			return num;
		}
		
		public static function subtractionBySer3(move1 : Histogram, move2 : Histogram, min: Number, riz : Number = 0):Number{
			var hist1 : Array=move1.points;
			var hist2 : Array= move2.points;
			var num : Number = 0;
			var point2:Point;
			var point1:Point;
			for (var i:int = 0; i < hist2.length-riz; i++) 
			{
				point1 = hist1[i] as Point;
				point2 = hist2[i+riz] as Point;
				num+=Math.sqrt(Math.pow(point1.y - point2.y,2));
				if (num>min){
					trace('help');
					return num;
				}
			}
			return num;
		}
		
		public static function getMinforDetect(arr : Array, etalon: MoveObject):MoveObject
		{
			var min : Number = 10000;
			var minPori : MoveObject;
			var vid : Number;
			for each (var object:MoveObject in arr) 
			{
				vid = 0;
				vid = compareRGB2(object.rgbHistograms,etalon.rgbHistograms,0);
				if (vid<min){
					min=vid;
					minPori = object;
				} 
			}
			return minPori;	
		}
		
		public static function getMinforDetectRiz(arr : Array, etalon: MoveObject):MoveObject
		{
			var min : Number = 10000;
			var minPori : MoveObject;
			var vid : Number;
			for each (var object:MoveObject in arr) 
			{
				vid = 0;
				vid = sub(object.rgbHistograms.mainHistogram,etalon.rgbHistograms.mainHistogram);
				if (vid<min){
					min=vid;
					minPori = object;
				} 
			}
			return minPori;	
		}
		
		public static function sub(move1 : Histogram, move2 : Histogram):Number{
			var num : Number = 0;
			var point2:Point;
			var point1:Point;
			for (var i:int = 0; i < 256; i++) 
			{
				point1 = move1.points[i] as Point;
				point2 = move2.points[i] as Point;
				num+=Math.sqrt(Math.pow(point1.y - point2.y,2));
			}
			return num;
		}
		
		private static function compareRGB2(value1 : RGBHistograms, value2 : RGBHistograms, porigRiz: Number):Number{
			var riz : Number;
			var porig : Number;
			riz = DistanceUtil.subtractionBySer(value1.r,value2.r,porigRiz);
			porig = riz;
			riz = DistanceUtil.subtractionBySer(value1.g,value2.g,porigRiz);
			if (porig>riz){
				porig = riz
			}
			riz = DistanceUtil.subtractionBySer(value1.b,value2.b,porigRiz);
			if (porig>riz){
				porig = riz
			}
			return porig;
		}
		
		public static function subtraction(move1 : Histogram, move2 : Histogram, rizSigma : Number, rizSer: Number):Boolean{
			return (Math.abs(move1.sigma-move2.sigma)<rizSigma && Math.abs(move1.ser-move2.ser)<rizSer);
		}
		
		private static function compareClustersRGB(value: Histogram, etalonCluster: Array):Number{
			function hasPoint(j: int):Number{
				for each (var cluster:ClusterVO in etalonCluster) 
				{
					if (!cluster.isTextura){
						var etalonPoint: Point = cluster.rgbHistograms.mainHistogram.points[i] as Point;
						if (etalonPoint.y!=0){
							return etalonPoint.y;
						}
					}
				}
				return NaN;
			}
			var point: Point;
			var num: Number = 0;
			for (var i:int = 0; i < 256; i++) 
			{
				var etalonNum: Number= hasPoint(i);
				if (!isNaN(etalonNum)){
					point = value.points[i] as Point;
					num+=Math.sqrt(Math.pow(point.y - etalonNum,2));
				}
			}
			return num;
		}
	}
}