package utils
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import appConst.HistogramType;
	
	import model.VideoModel;
	
	import vo.ClusterVO;
	import vo.Histogram;
	import vo.MoveObject;
	import vo.RGBHistograms;
	import vo.SimplyTextura;

	public class OptionSetterUtils
	{
		
		public var videoModel : VideoModel = VideoModel.instance;
		
		public function set clientTextura(value : Array):void{
			videoModel.clientEtalon=[];
			for each (var k:Array in value) 
			{
				var rgbHist : RGBHistograms = new RGBHistograms();
				var r : Histogram = new Histogram(k[0] as Array);
				var g : Histogram = new Histogram(k[1] as Array);
				var b : Histogram = new Histogram(k[2] as Array);
				rgbHist.setHistogrmaByType(r,HistogramType.R_TYPE);
				rgbHist.setHistogrmaByType(g,HistogramType.G_TYPE);
				rgbHist.setHistogrmaByType(b,HistogramType.B_TYPE);
				var textura : SimplyTextura = new SimplyTextura(rgbHist);
				videoModel.clientEtalon.push(new SimplyTextura(rgbHist));
			}
		}
		
		public function setDetectionEtalon(value : ByteArray, w: Number, h: Number):void{
			var foto:BitmapData = new BitmapData(w, h, false, 0x0);
			value.position = 0;
			foto.setPixels(foto.rect, value);
			var moveObject : MoveObject = new MoveObject(foto,new Point());
			preProcesingDetectionData(moveObject);
		}
		
		private function preProcesingDetectionData(value: MoveObject):void{
			for each (var cluster:ClusterVO in value.clusters) 
			{
				if (cluster.xSig>5 || cluster.ySig>5){
					cluster.isTextura = true;
				}
			}
			/*for each (var testcluster:ClusterVO in value.clusters) 
			{
				var rIndex : Point = videoModel.etalonDirectory.getRIndex(testcluster.rgbHistograms);
				var gIndex : Point = videoModel.etalonDirectory.getGIndex(testcluster.rgbHistograms);
				var bIndex : Point = videoModel.etalonDirectory.getBIndex(testcluster.rgbHistograms);
				for each (var inoridObj:MoveObject in videoModel.foreignObjects) 
				{
					for each (var cluster:ClusterVO in inoridObj.clusters) 
					{
						if (!cluster.isTextura){
							if (compareWithCluster(cluster.rgbHistograms,rIndex,gIndex,bIndex)){
								cluster.isTextura = true;
							}
						}
					}
				} 	
			}*/
			videoModel.detectionEtalon = value;
		}
		
		private function compareWithCluster(cluster: RGBHistograms, rIndex: Point, gIndex: Point, bIndex: Point):Boolean{
			var point: Point = videoModel.etalonDirectory.getRIndex(cluster);
			if (point.x != rIndex.x && point.y != rIndex.y){
				return false;
			}
			point = videoModel.etalonDirectory.getGIndex(cluster);
			if (point.x != gIndex.x && point.y != gIndex.y){
				return false;
			}
			point = videoModel.etalonDirectory.getBIndex(cluster);
			if (point.x != bIndex.x && point.y != bIndex.y){
				return false;
			}
			return true;
		}
		
		private function compareWithEtalon(value : RGBHistograms):Boolean{
			return (videoModel.etalonDirectory.getValueByRIndexes(value) && videoModel.etalonDirectory.getValueByGIndexes(value) && videoModel.etalonDirectory.getValueByBIndexes(value));
		}
		
		private static var _instance : OptionSetterUtils = new OptionSetterUtils();
		
		public function OptionSetterUtils(){
			super();
			if (_instance != null){
				throw new Error("OptionSetterUtils can only be accesed through OptionSetterUtils.instance");
			}
		}
		
		public static function get instance():OptionSetterUtils{
			return _instance;
		}
	}
}