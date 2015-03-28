package controller
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import appConst.Const;
	
	import events.ScreenShotEvent;
	import events.WorkerEvent;
	
	import model.VideoModel;
	
	import utils.BitMapUtils;
	import utils.DistanceUtil;
	
	import vo.ClusterVO;
	import vo.DetectionDataVO;
	import vo.MoveObject;
	import vo.RGBHistograms;
	import vo.SimplyTextura;
	import vo.VideoFrame;

	[Event(name="DETECTION_COMPLETE", type="events.WorkerEvent")]
	public class VideoController extends EventDispatcher
	{
		public var videoModel : VideoModel = VideoModel.instance;
		[Bindable]
		public var counterFrame : int = 0;
		private var _startTime : Date;
		private var _lastTime: int;
		private var allTimeBetwenFrame: int = 0;
		
		public function startVideo(value : Sprite):void
		{
			//var camera:Camera = Camera.getCamera();
			videoModel.videoArea = value;
			videoModel.video = new Video();  
			value.addChild(videoModel.video);
			videoModel.nc = new NetConnection();
			videoModel.nc.connect(null);
			videoModel.ns = new NetStream(videoModel.nc);
			var obj : Object = new Object();
			videoModel.ns.client = obj;
			videoModel.video.attachNetStream(videoModel.ns);
			videoModel.ns.play(Const.VIDEO_PATH);
			_startTime = new Date();
			videoModel.video.width = Const.VIDEO_WIDTH;
			videoModel.video.height = Const.VIDEO_HIGHT;
			
			//videoModel.video.attachCamera(camera);
			
			videoModel.foreignObjects = [];
			var timer: Timer = new Timer(40, 1);
			timer.addEventListener(TimerEvent.TIMER,addScrenShot);
			//timer.start();
			screnShotVideo(0);
			screnShotVideo(1);
		}
		
		public var stack: Array = [];
		
		public function addScrenShot(event: Event):void{
			var foto : BitmapData = new BitmapData(Const.VIDEO_WIDTH,Const.VIDEO_HIGHT);
			foto.draw(videoModel.videoArea); 
			stack.push(foto);
			if (counterFrame == 0){
				stack.push(foto);
				screnShotVideo(0);
				screnShotVideo(1);
			}
		}
		
		public function screnShotVideo(index : int = 0):void{
			counterFrame++;
			//videoModel.mainBitMap.clear();
			var foto : BitmapData = new BitmapData(Const.VIDEO_WIDTH,Const.VIDEO_HIGHT);
			foto.draw(videoModel.videoArea); 
			/*var foto: BitmapData = stack.shift() as BitmapData;
			if (!foto){
				return;
			}*/
			var time : int = new Date().time - _startTime.time;
			var time1: int = _lastTime?time-_lastTime:_lastTime;
			_lastTime = time;
			allTimeBetwenFrame+=time1;
			dispatchEvent(new ScreenShotEvent(ScreenShotEvent.COMPUTE, foto, time, index));
			//trace(Math.floor(System.totalMemoryNumber/(1024*1024)),time,allTimeBetwenFrame/counterFrame);
			trace(stack.length, counterFrame, time,allTimeBetwenFrame/counterFrame, time/counterFrame);
		}
		
		public function computeFrame(id: Number, byteArr:ByteArray, width:Number, height:Number, time:Number, index: int = 0):void{
			if(byteArr == null || isNaN(width) || isNaN(height) || isNaN(time)){
				return;
			}
			var foto:BitmapData = new BitmapData(width, height, false, 0x0);
			byteArr.position = 0;
			foto.setPixels(foto.rect, byteArr);
			var videoBitMap : VideoFrame = new VideoFrame(foto);
			if (videoModel.isDetectedObject){
				detect(videoBitMap,id);
			}else{
				if (videoModel.detectionEtalon){
					recognition(id,videoBitMap,time,index);
				}else{
					auto(videoBitMap,time,index);
					//getPoints(videoBitMap,time,index);
				}
			}			
		}
		
		public function recognition(id: Number,videoBitMap: VideoFrame, time:Number, index: int = 0):void{
			var point : Point;
			var moveObj : MoveObject;
			var plotPoint : Point;
			
			for (var i:int = 0; i < 3; i++) 
			{
				for (var j:int = 0; j < 3; j++) 
				{
					point = new Point(15+Const.PADDING_FRAME+i*4*videoModel.offset,(2*index+1)*Const.PADDING_FRAME+2*j*videoModel.offset);
					var bmp : BitmapData = BitMapUtils.getBitmapByPoint(videoBitMap.data,point,videoModel.offset);
					moveObj = new MoveObject(bmp,point);
					moveObj.time = time;
					var simply: SimplyTextura = new SimplyTextura(moveObj.rgbHistograms);
					simply.bmp = bmp;
					simply.coordinates = point;
					//videoModel.detectObjects.push(simply);
					compareWithMoveDetactionEtalon(id,moveObj);
				}
			}
		}
		
		public function getPoints(videoBitMap: VideoFrame, time:Number, index: int = 0):void{
			var point : Point;
			var moveObj : MoveObject;
			var plotPoint : Point;
			for (var i:int = 0; i < 4; i++) 
			{
				for (var j:int = 0; j < 3; j++) 
				{
					if (j == 2){
						var con: int = 15;
						if (i==0){
							point = new Point(con, con);
						}else if (i==1){
							point = new Point(con, Const.VIDEO_HIGHT-Const.PADDING_FRAME-2);
						}else if (i==2){
							point = new Point(Const.VIDEO_WIDTH-2*videoModel.offset, con);
						}else{
							point = new Point(Const.VIDEO_WIDTH-2*videoModel.offset, Const.VIDEO_HIGHT-Const.PADDING_FRAME-2);
						}
						//point = new Point(Const.PADDING_FRAME, Const.VIDEO_WIDTH-2*Const.PADDING_FRAME);
					}else{
						point = new Point(Const.PADDING_FRAME+i*4*videoModel.offset,(2*index+1)*Const.PADDING_FRAME+j*videoModel.offset);
					}
					var bmp : BitmapData = BitMapUtils.getBitmapByPoint(videoBitMap.data,point,0);
				}
			}
		}
		
		public function auto(videoBitMap: VideoFrame, time:Number, index: int = 0):void{
			//trace('auto');
			var point : Point;
			var moveObj : MoveObject;
			var plotPoint : Point;
			//var con: int = 30;
			
			var percent: Number = .2;
			var radius: Number = videoModel.offset*2+1;
			var hCount: int = Math.floor(140/radius);
			var wCount: int = Math.floor(320/radius);
			var fullCount: int = hCount*wCount;
			var maxI: int = Math.round(percent*fullCount);
			
			for (var i:int = 0; i < maxI; i++) 
			{
				//point = getMoveObjectPointFrom76for5(i,index);
				point = getMoveObjectPoint(i, index, videoModel.offset);
			/*for (var i:int = 0; i < 4; i++) 
			{
				for (var j:int = 0; j < 2; j++) 
				{*/
					/*if (j == 2){
						/*if (i==0){
							point = new Point(con, con);
						}else if (i==1){
							point = new Point(con, Const.VIDEO_HIGHT-Const.PADDING_FRAME-2);
						}else if (i==2){
							point = new Point(Const.VIDEO_WIDTH-2*Const.OFFSET_OLD, con);
						}else{
							point = new Point(Const.VIDEO_WIDTH-2*Const.OFFSET_OLD, Const.VIDEO_HIGHT-Const.PADDING_FRAME-2);
						}*/
						//point = new Point(Const.PADDING_FRAME, Const.VIDEO_WIDTH-2*Const.PADDING_FRAME);
					//}else{*/
						//point = new Point(Const.PADDING_FRAME+i*4*videoModel.offset,(2*index+1)*Const.PADDING_FRAME+j*videoModel.offset);
					//}
					var bmp : BitmapData = BitMapUtils.getBitmapByPoint(videoBitMap.data,point,videoModel.offset);
					moveObj = new MoveObject(bmp,point);
					moveObj.time = time;
					if (videoModel.allowReceiveData){
						if (moveObj.rgbHistograms.r.sigma > Const.SIGMA || moveObj.rgbHistograms.g.sigma > Const.SIGMA || moveObj.rgbHistograms.b.sigma > Const.SIGMA){
							var simplyTextura : SimplyTextura = new SimplyTextura(moveObj.rgbHistograms);
							simplyTextura.bmp = moveObj.bitMap;
							simplyTextura.coordinates = moveObj.coordinates;
							videoModel.etalonDirectory.addEtalon(simplyTextura.rgbHistograms);
							compareWithForeignObjects(simplyTextura);
						}
					}
					if (moveObj.rgbHistograms.mainHistogram.sigma>Const.SIGMA*4){
						if (videoModel.allowReceiveData){
							compareWithTexturaAuto(moveObj);
						}else{
							compareWithTextura(moveObj);
						}
					}
				}
			//}
		}
		
		public function detect(videoBitMap: VideoFrame, id: Number):void
		{
			var _detectGistArray: Array = setDetectArray(videoBitMap);
			//var findedObject : MoveObject = DistanceUtil.byCluster(_detectGistArray,videoModel.detectionEtalon);
			//var findedObject : MoveObject = DistanceUtil.bySer2W(_detectGistArray,videoModel.detectionEtalon.rgbHistograms.mainHistogram);
			//var findedObject : MoveObject = DistanceUtil.bySer2(_detectGistArray,videoModel.detectionEtalon.rgbHistograms.mainHistogram);
			var findedObject : MoveObject = DistanceUtil.getMinforDetect(_detectGistArray,videoModel.detectionEtalon);
			//var findedObject : MoveObject = DistanceUtil.getMinforDetectRiz(_detectGistArray,videoModel.detectionEtalon);
			//var findedObject : MoveObject = DistanceUtil.getW(_detectGistArray);
			trace('FINDUBJECT',findedObject);
			if (findedObject && findedObject.coordinates.x>50 && findedObject.coordinates.x<Const.VIDEO_WIDTH-50 && findedObject.coordinates.y>50 && findedObject.coordinates.y<Const.VIDEO_HIGHT-50){
				videoModel.detectionData.push(new DetectionDataVO(id, videoModel.isDetectedObject.coordinates.x, videoModel.isDetectedObject.coordinates.y, findedObject.coordinates.x, findedObject.coordinates.y));
				videoModel.isDetectedObject = findedObject;
			}else{
				videoModel.isDetectedObject = null;
				dispatchEvent(new WorkerEvent(WorkerEvent.DETECTION_COMPLETE));
			}
		}
		
		private function setDetectArray(videoBitMap: VideoFrame):Array{
			var returnArr : Array = [];
			var moveObj : MoveObject;
			var point : Point;
			for (var i:int = -4; i < 1; i++) 
			{
				for (var j:int = 0; j < 4; j++) 
				{
					point = new Point(videoModel.isDetectedObject.coordinates.x+i*videoModel.offset,videoModel.isDetectedObject.coordinates.y+j*videoModel.offset)
					var bmp : BitmapData = BitMapUtils.getBitmapByPoint(videoBitMap.data,point,videoModel.offset);
					moveObj = new MoveObject(bmp,point);	
					returnArr.push(moveObj);
					
					var simply: SimplyTextura = new SimplyTextura(moveObj.rgbHistograms);
					simply.bmp = bmp;
					simply.coordinates = point;
					videoModel.detectObjects.push(simply);
				}
			}
			return returnArr;
		}
		
		public function pause():void
		{
			videoModel.ns.pause();
		}
		
		public function resume():void
		{
			videoModel.ns.resume();
		}
		
		
		protected function compareWithMoveDetactionEtalon(id: Number,value : MoveObject):void
		{
			var rIndex : Point;
			var gIndex : Point;
			var bIndex : Point;
			var counter: int = 0;
			var allCounter: int = 0;
			for each (var detCluster:ClusterVO in videoModel.detectionEtalon.clusters) 
			{
				/*rIndex = videoModel.etalonDirectory.getRIndex(detCluster.rgbHistograms);
				gIndex = videoModel.etalonDirectory.getGIndex(detCluster.rgbHistograms);
				bIndex = videoModel.etalonDirectory.getBIndex(detCluster.rgbHistograms);*/
				/*if (!detCluster.isTextura){
					if (compareWithEtalon(detCluster.rgbHistograms)){
						detCluster.isTextura = true;
					}
				}*/
				//if (!detCluster.isTextura){
					allCounter++;
					/*if (isHasCluster(value.clusters,rIndex,gIndex,bIndex)){
						counter++
					}*/
					if (isHasClusterBy(value.clusters,detCluster.rgbHistograms)){
						counter++
					}
				//}
			}
			var percent : Number = counter*100/allCounter;
			if (percent>=100){
				
				for each (var cluster:ClusterVO in videoModel.detectionEtalon.clusters) 
				{
					if (!cluster.isTextura){
						if (compareWithEtalon(cluster.rgbHistograms)){
							cluster.isTextura = true;
						}
					}
				}
				videoModel.detectionData.push(new DetectionDataVO(id, value.coordinates.x, value.coordinates.y, value.coordinates.x, value.coordinates.y));
				videoModel.isDetectedObject = value;
			}else if (percent>=85){
				videoModel.detectionData.push(new DetectionDataVO(id, value.coordinates.x, value.coordinates.y, value.coordinates.x, value.coordinates.y,false));
			}
		}
		
		private function isHasCluster(clusters: Array, rIndex: Point, gIndex: Point, bIndex:Point):Boolean{
			for each (var cluster:ClusterVO in clusters) 
			{
				if (compareWithCluster(cluster.rgbHistograms,rIndex,gIndex,bIndex)){
					return true;
				}
			}
			return false;
		}
		
		private function isHasClusterBy(clusters: Array, clusterEtalon: RGBHistograms):Boolean{
			for each (var cluster:ClusterVO in clusters) 
			{
				if (compareWithClusterBy(cluster.rgbHistograms,clusterEtalon)){
					return true;
				}
			}
			return false;
		}
		
		/*for client textura*/
		protected function compareWithTextura(value : MoveObject):void
		{
			var arr : Array = value.clusters;
			var porig : Number = Const.DINSTANCE;
			var riz : Number;
			var inoridnyFlag : Boolean = true;
			var etalon : Array;
			etalon = videoModel.clientEtalon;
			trace(videoModel.clientEtalon.length);
			for each (var textura:SimplyTextura in etalon) 
			{
				for each (var cluster:ClusterVO in value.clusters) 
				{
					if (cluster.rgbHistograms.r.ser<5){
						return;
					}
					/*if (cluster.rgbHistograms.r.data.length<25){
						cluster.isTextura = true;
					}*/
					if (!cluster.isTextura){
						if (compareRGB(textura.rgbHistograms,cluster.rgbHistograms,porig,30)){
							cluster.isTextura = true;
						}
					}
				}
			}
			for each (cluster in value.clusters) 
			{
				if (cluster.rgbHistograms.r.ser<5){
					return;
				}
				/*if (cluster.rgbHistograms.r.data.length<25){
					cluster.isTextura = true;
				}*/
				if (!cluster.isTextura){
					inoridnyFlag = false;
				}
			}
			if (inoridnyFlag){
			}else{
				videoModel.foreignObjects.push(value);
			} 
		}
		
		protected function compareWithForeignObjects(textura : SimplyTextura):void
		{
			var inoridnyFlag : Boolean;
			var rIndex : Point = videoModel.etalonDirectory.getRIndex(textura.rgbHistograms);
			var gIndex : Point = videoModel.etalonDirectory.getGIndex(textura.rgbHistograms);
			var bIndex : Point = videoModel.etalonDirectory.getBIndex(textura.rgbHistograms);
			for each (var inoridObj:MoveObject in videoModel.foreignObjects) 
			{
				inoridnyFlag = true;
				for each (var cluster:ClusterVO in inoridObj.clusters) 
				{
					if (!cluster.isTextura){
						if (compareWithCluster(cluster.rgbHistograms,rIndex,gIndex,bIndex)){
							cluster.isTextura = true;
						}else{
							inoridnyFlag = false;
						}
					}
				}
				if (inoridnyFlag){
					var index : int = videoModel.foreignObjects.indexOf(inoridObj);
					videoModel.foreignObjects.splice(index, 1);
				}
			} 
		}
		
		protected function compareWithTexturaAuto(value : MoveObject):void
		{
			for each (var cluster:ClusterVO in value.clusters) 
			{
				if (cluster.rgbHistograms.r.ser<5){
					return;
				}
				if (!cluster.isTextura){
					if (compareWithEtalon(cluster.rgbHistograms)){
						cluster.isTextura = true;
					}else{
						if (compareWithForeignClusters(cluster.rgbHistograms)){
							cluster.isTextura = true;
						}else{
							videoModel.foreignClastersDirectory.addEtalon(cluster.rgbHistograms);
						}
					}
				}
			}
			for each (cluster in value.clusters) 
			{
				if (cluster.rgbHistograms.r.ser<5){
					return;
				}
				if (!cluster.isTextura){
					videoModel.foreignObjects.push(value);
					return;
				}
			}
		}
		
		//helper
		
		private function compareWithForeignClusters(value : RGBHistograms):Boolean{
			return (videoModel.foreignClastersDirectory.getValueByRIndexes(value) || videoModel.foreignClastersDirectory.getValueByGIndexes(value) || videoModel.foreignClastersDirectory.getValueByBIndexes(value));
		}
		
		private function compareWithEtalon(value : RGBHistograms):Boolean{
			return (videoModel.etalonDirectory.getValueByRIndexes(value) && videoModel.etalonDirectory.getValueByGIndexes(value) && videoModel.etalonDirectory.getValueByBIndexes(value));
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
		
		private function compareWithClusterBy(cluster1: RGBHistograms, cluster2: RGBHistograms):Boolean{
			if (Math.abs(cluster1.r.ser-cluster2.r.ser)>Const.PORIG_ETALON && Math.abs(cluster1.r.sigma-cluster2.r.sigma)>Const.PORIG_ETALON){
				return false;
			}
			if (Math.abs(cluster1.g.ser-cluster2.g.ser)>Const.PORIG_ETALON && Math.abs(cluster1.g.sigma-cluster2.g.sigma)>Const.PORIG_ETALON){
				return false;
			}
			if (Math.abs(cluster1.b.ser-cluster2.b.ser)>Const.PORIG_ETALON && Math.abs(cluster1.b.sigma-cluster2.b.sigma)>Const.PORIG_ETALON){
				return false;
			}
			return true;
		}
		
		private function compareRGB(value1 : RGBHistograms, value2 : RGBHistograms, porigSer: Number = 10, porigSigma : Number = 20):Boolean{
			return (DistanceUtil.subtraction(value1.r,value2.r,porigSigma,porigSer) && DistanceUtil.subtraction(value1.g,value2.g,porigSigma,porigSer) && DistanceUtil.subtraction(value1.b,value2.b,porigSigma,porigSer));
		}
		
		/*private function compareRGB(value1 : RGBHistograms, value2 : RGBHistograms, porig: Number, porigRiz : Number):Boolean{
			var riz : Number;
			riz = DistanceUtil.subtractionBySer(value1.r,value2.r,porigRiz);
			if (riz>porig){
				return false;
			}
			riz = DistanceUtil.subtractionBySer(value1.g,value2.g,porigRiz);
			if (riz>porig){
				return false;
			}
			riz = DistanceUtil.subtractionBySer(value1.b,value2.b,porigRiz);
			if (riz>porig){
				return false;
			}
			return true;
		}*/
		
		private function getMoveObjectPointFrom10(value: int):Point{
			if (value<6){
				if (value%2==0){
					return new Point(Const.PADDING_FRAME,Const.PADDING_FRAME+((value/2)+1)*3*videoModel.offset);
				}else{
					return new Point(Const.VIDEO_WIDTH-Const.PADDING_FRAME,Const.PADDING_FRAME+((value+1)/2)*3*videoModel.offset);
				}
			}
			var _width : Number = Const.VIDEO_WIDTH - 2*Const.PADDING_FRAME - 2*videoModel.offset;
			var _gap : Number = (_width - 8*videoModel.offset)/5;
			return new Point(Const.PADDING_FRAME+2*videoModel.offset+_gap+(2*videoModel.offset+_gap)*(value-6),Const.PADDING_FRAME);
		}
		
		private function getMoveObjectPointFrom21(value: int):Point{
			if (value%3==0){
				return new Point(Const.PADDING_FRAME+(2*value/3)*videoModel.offset,Const.PADDING_FRAME);
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+2*((value/2)-1)*videoModel.offset,3*Const.PADDING_FRAME)
			}
			return new Point(Const.PADDING_FRAME+value*videoModel.offset,4.5*Const.PADDING_FRAME)
		}
		
		public function getMoveObjectPointFrom11for14(value: int,index: int):Point{
			if (value%2==0){
				return new Point(Const.PADDING_FRAME+7+(value/2)*(2*videoModel.offset+1+7),(2*index+1)*Const.PADDING_FRAME);
			}
			return new Point(Const.PADDING_FRAME+13+Math.floor(value/2)*(2*videoModel.offset+1+13),(2*index+1)*Const.PADDING_FRAME+2*videoModel.offset+1);
		}
		
		public function getMoveObjectPointFrom13for13(value: int,index: int):Point{
			if (value%2==0){
				return new Point(Const.PADDING_FRAME+4+(value/2)*(2*videoModel.offset+1+4),(2*index+1)*Const.PADDING_FRAME);
			}
			return new Point(Const.PADDING_FRAME+9+Math.floor(value/2)*(2*videoModel.offset+1+9),(2*index+1)*Const.PADDING_FRAME+2*videoModel.offset+1);
		}
		
		public function getMoveObjectPointFrom15for12(value: int,index: int):Point{
			if (value%2==0){
				return new Point(Const.PADDING_FRAME+3+(value/2)*(2*videoModel.offset+1+3),(2*index+1)*Const.PADDING_FRAME);
			}
			return new Point(Const.PADDING_FRAME+7+Math.floor(value/2)*(2*videoModel.offset+1+7),(2*index+1)*Const.PADDING_FRAME+2*videoModel.offset+1);
		}
		
		public function getMoveObjectPointFrom17for11(value: int,index: int):Point{
			if (value%2==0){
				return new Point(Const.PADDING_FRAME+2+(value/2)*(2*videoModel.offset+1+2),(2*index+1)*Const.PADDING_FRAME);
			}
			return new Point(Const.PADDING_FRAME+4+Math.floor(value/2)*(2*videoModel.offset+1+4),(2*index+1)*Const.PADDING_FRAME+2*videoModel.offset+1);
		}
		
		public function getMoveObjectPointFrom21for10(value: int,index: int):Point{
			if (value%3==0){
				return new Point(Const.PADDING_FRAME+(value/3)*(2*videoModel.offset+1+12),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/3)*(2*videoModel.offset+1+12),(2*index+1)*Const.PADDING_FRAME+2*(2*videoModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+9+Math.floor(value/3)*(2*videoModel.offset+1+9),(2*index+1)*Const.PADDING_FRAME+2*videoModel.offset+1);
		}
		
		public function getMoveObjectPointFrom26for9(value: int,index: int):Point{
			if (value%3==0){
				return new Point(Const.PADDING_FRAME+(value/3)*(2*videoModel.offset+1+6),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/3)*(2*videoModel.offset+1+10),(2*index+1)*Const.PADDING_FRAME+2*(2*videoModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+5+Math.floor(value/3)*(2*videoModel.offset+1+5),(2*index+1)*Const.PADDING_FRAME+2*videoModel.offset+1);
		}
		
		public function getMoveObjectPointFrom32for8(value: int,index: int):Point{
			if (value%3==0){
				return new Point(Const.PADDING_FRAME+(value/3)*(2*videoModel.offset+1+4),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+5+Math.floor(value/3)*(2*videoModel.offset+1+5),(2*index+1)*Const.PADDING_FRAME+2*(2*videoModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+3+Math.floor(value/3)*(2*videoModel.offset+1+3),(2*index+1)*Const.PADDING_FRAME+2*videoModel.offset+1);
		}
		
		public function getMoveObjectPointFrom41for7(value: int,index: int):Point{
			if (value%3==0){
				return new Point(Const.PADDING_FRAME+(value/3)*(2*videoModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/3)*(2*videoModel.offset+1+2),(2*index+1)*Const.PADDING_FRAME+2*(2*videoModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+Math.floor(value/3)*(2*videoModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME+2*videoModel.offset+1);
		}
		
		public function getMoveObjectPointFrom55for6(value: int,index: int):Point{
			if (value%4==0){
				return new Point(Const.PADDING_FRAME+(value/4)*(2*videoModel.offset+1+3),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%3==0){
				return new Point(Const.PADDING_FRAME+4+Math.floor(value/4)*(2*videoModel.offset+1+4),(2*index+1)*Const.PADDING_FRAME+3*(2*videoModel.offset+1));
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/4)*(2*videoModel.offset+1+5),(2*index+1)*Const.PADDING_FRAME+2*(2*videoModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+2+Math.floor(value/4)*(2*videoModel.offset+1+2),(2*index+1)*Const.PADDING_FRAME+2*videoModel.offset+1);
		}
		
		public function getMoveObjectPointFrom76for5(value: int,index: int):Point{
			if (value%4==0){
				return new Point(Const.PADDING_FRAME+(value/4)*(2*videoModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%3==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/4)*(2*videoModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME+3*(2*videoModel.offset+1));
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/4)*(2*videoModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME+2*(2*videoModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+Math.floor(value/4)*(2*videoModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME+2*videoModel.offset+1);
		}
		
		public function getMoveObjectPointFor5(value: int, index: int):Point{
			var paddingTop: int = 4;
			var paddingBottom: int = 4;
			var paddingLeft: int = 6;
			var paddingRight: int = 6;
			var fullCount: int = 336;
			var hCount: int = 12;
			var wCount: int = 28;
			var point:Point = new Point();
			point.x = (value%wCount)*11+paddingLeft;
			point.y = Math.floor(value/wCount)*11+paddingTop+index*140;
			return point;
		}
		
		public function getMoveObjectPointFor9(value: int, index: int):Point{
			var paddingTop: int = 4;
			var paddingBottom: int = 3;
			var paddingLeft: int = 8;
			var paddingRight: int = 8;
			var fullCount: int = 112;
			var hCount: int = 7;
			var wCount: int = 16;
			var point:Point = new Point();
			point.x = (value%wCount)*19+paddingLeft;
			point.y = Math.floor(value/wCount)*19+paddingTop+index*140;
			return point;
		}
		
		public function getMoveObjectPointFor14(value: int, index: int):Point{
			var paddingTop: int = 12;
			var paddingBottom: int = 12;
			var paddingLeft: int = 1;
			var paddingRight: int = 0;
			var fullCount: int = 44;
			var hCount: int = 4;
			var wCount: int = 11;
			var point:Point = new Point();
			point.x = (value%wCount)*29+paddingLeft;
			point.y = Math.floor(value/wCount)*29+paddingTop+index*140;
			return point;
		}
		
		/*public function getMoveObjectPoint(value:int, index: int, offset: int):Point{
			var radius: Number = offset*2+1;
			var hCount: int = Math.floor(140/radius);
			var wCount: int = Math.floor(320/radius);
			
			var paddingTop: int = 140-(hCount*radius);
			var paddingLeft: int = Math.ceil((320-(wCount*radius))/2);
			
			var point:Point = new Point();
			point.x = (value%wCount)*radius+paddingLeft;
			point.y = Math.floor(value/wCount)*radius+paddingTop+index*140;
			return point;
		}*/
		
		public function getMoveObjectPoint(value:int, index: int, offset: int):Point{
			var radius: Number = offset*2+1;
			var hCount: int = Math.floor(140/radius);
			var wCount: int = Math.floor(320/radius);
			
			var paddingTop: int = 140-(hCount*radius);
			var paddingLeft: int = Math.ceil((320-(wCount*radius))/2);
			
			var point:Point = new Point();
			point.x = 50+Math.random()*220;//(value%wCount)*radius+paddingLeft;
			point.y = 50+Math.random()*90//Math.floor(value/wCount)*radius+paddingTop+index*140;
			return point;
		}
		
		private var index: int = 1;
		/*protected function save(moveObject: MoveObject):void
		{
			var f: DataFile = new DataFile(index.toString());
			var strR : String = '';
			var rgb: RgbVO;
			for (var i:int = 0; i < outerDocument.selected2.rgb.width; i++) 
			{
				for (var j:int = 0; j < outerDocument.selected2.rgb.height; j++) 
				{ 
					rgb = outerDocument.selected2.rgb.getRGB(i,j);
					strR = rgb.r.toString()+' '+rgb.g.toString()+' '+rgb.b.toString();
					f.writeTextLine(strR);
				}
			}
			f.close();
			//var fl:File = File.desktopDirectory.resolvePath("snapshot.png");
			//var fl:File = new File("D:/бумажне/дисертація/data/EtalonData/file"+outerDocument.index+'.png');
			var fl:File = new File("C:/Users/Настя/Desktop/VideoData/"+outerDocument.index+'.png');
			outerDocument.index++;
			var fs:FileStream = new FileStream();
			var imgByteArray: ByteArray = new PNGEncoder().encode(data as BitmapData);
			try{
				
				fs.open(fl,FileMode.WRITE);
				fs.writeBytes(imgByteArray);
				fs.close();
			}catch(e:Error){
				trace(e.message);
			}
		}*/
		
		
		private static var _instance : VideoController = new VideoController();
		
		public function VideoController(){
			super();
			if (_instance != null){
				throw new Error("VideoController can only be accesed through VideoModel.instance");
			}
		}
		
		public static function get instance():VideoController{
			return _instance;
		}
	}
}