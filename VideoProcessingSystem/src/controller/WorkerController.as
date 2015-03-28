package controller
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import model.OptionsModel;
	import model.ViewModel;
	
	import vo.DetectionViewDataVO;
	import vo.FrameVO;
	import vo.view.MoveObjectViewVO;
	import vo.view.SimplyTexturaViewVO;

	public final class WorkerController{
		
		protected var mainToBack:MessageChannel;
		protected var backToMain:MessageChannel;
		
		protected var worker:Worker;
		protected var isRunning:Boolean;
		protected var index : int = 0;
		protected var currentTime:int;
		protected var currentBitmapData:BitmapData;
		
		protected var viewModel:ViewModel = ViewModel.instance;
		protected var optionsModel:OptionsModel = OptionsModel.instance;
		protected var videoC : VideoController = VideoController.instance;
		
		protected function initWorker(workerBytes:ByteArray):void{
			worker = WorkerDomain.current.createWorker(workerBytes);
			
			//Create message channel TO the worker
			mainToBack = Worker.current.createMessageChannel(worker);
			
			//Create message channel FROM the worker, add a listener.
			backToMain = worker.createMessageChannel(Worker.current);
			
			backToMain.addEventListener(Event.CHANNEL_MESSAGE, onBackToMain);
			//Now that we have our two channels, inject them into the worker as shared properties.
			//This way, the worker can see them on the other side.
			worker.setSharedProperty("backToMain", backToMain);
			
			worker.setSharedProperty("mainToBack", mainToBack);
			
			//Init worker with width/height of image
			/*worker.setSharedProperty("imageWidth", imWidth);
			
			worker.setSharedProperty("imageHeight", origImage.height);*/			
			
			//Convert image data to (shareable) byteArray, and share it with the worker.
			/*var imageBytes:ByteArray = new ByteArray();
			origImage.copyPixelsToByteArray(new Rectangle(imX, 0, imWidth, origImage.rect.height), imageBytes);*/
			
			//worker.setSharedProperty("imageBytes", imageBytes);
			
			//Lastly, start the worker.
			worker.start();
		}
		
		protected function onBackToMain(event:Event):void {
			var msg:String = backToMain.receive();
			if(msg == "COMPUTE_COMPLETE"){
				isRunning = false;
				var foreignObjectsTransport:Array = worker.getSharedProperty("foreignObjects");
				var newForeignObjects:ArrayCollection = new ArrayCollection();
				var foren : ArrayCollection;
				if (index==0){
					foren = viewModel.foreignObjects1;
				}else{
					foren = viewModel.foreignObjects2;
				}
				if(foreignObjectsTransport.length > 0){
					for each (var transportForeign:Object in foreignObjectsTransport) {
						var objectIndexForeign:int = getObjectIndexInCollection(transportForeign.id, foren)
						newForeignObjects.addItem((objectIndexForeign != -1)?foren.getItemAt(objectIndexForeign):new MoveObjectViewVO(transportForeign, currentBitmapData));
					}
				}
				if (index==0){
					viewModel.foreignObjects1.addAll(newForeignObjects);			
				}else{
					viewModel.foreignObjects2.addAll(newForeignObjects);	
				}
				videoC.screnShotVideo(index);
			}
			if(msg == "DETECTION_COMPLETE"){
				var detectionData:Array = worker.getSharedProperty("detectionData");
				var detectionViewData: ArrayCollection = new ArrayCollection();
				for each (var detectObject:* in detectionData) 
				{
					detectionViewData.addItem(new DetectionViewDataVO(detectObject.frameId,detectObject.x, detectObject.y, detectObject.x1, detectObject.y1,detectObject.flag));
				}
				viewModel.detectionFrames.addItem(detectionViewData);
			}
		}
		
		public function computeFrame(id: Number, bitmapdata:BitmapData, time:Number, index : int = 0):void{
			this.index = index;
			if(!worker){
				if (index == 0){
					initWorker(Workers.workers_BitmapWorker1);
				}else{
					initWorker(Workers.workers_BitmapWorker2);
				}
			}
			if(isRunning){
				trace("Fail");
				return;
			}
			isRunning = true;
			currentBitmapData = bitmapdata;			
			var byteArr:ByteArray = new ByteArray();
			bitmapdata.copyPixelsToByteArray(bitmapdata.rect, byteArr);
			byteArr.shareable = true;
			worker.setSharedProperty("imageBytes", byteArr);
			worker.setSharedProperty("imageWidth", bitmapdata.width);
			worker.setSharedProperty("imageHeight", bitmapdata.height);
			worker.setSharedProperty("imageTime", time);
			worker.setSharedProperty("index", index);
			worker.setSharedProperty("id", id);
			mainToBack.send("COMPUTE");
		}
		
		public function setOffset(value : int):void{
			worker.setSharedProperty("offset", value);
			mainToBack.send("OFFSET");
		}
		
		public function setClientEtalon(value: ArrayCollection):void{
			worker.setSharedProperty("etalon", value.source);
			mainToBack.send("ETALON");
		}
		
		public function setAllowReceiveEtalon(value: Boolean):void{
			worker.setSharedProperty("allowReceive", value);
			mainToBack.send("ALLOWRECEIVE");
		}
		
		public function setDetectionEtalon(value: BitmapData):void{
			var byteArr:ByteArray = new ByteArray();
			value.copyPixelsToByteArray(value.rect, byteArr);
			byteArr.shareable = true;
			worker.setSharedProperty("detectionEtalon", byteArr);
			worker.setSharedProperty("detectionEtalonW", value.width);
			worker.setSharedProperty("detectionEtalonH", value.height);
			mainToBack.send("DETECTIONETALON");
		}
		
		public function getCollectedEtalon():void{
			var collectedEtalonTransport:Array = worker.getSharedProperty("collectedEtalon");
			var newCollectedEtalon:ArrayCollection = new ArrayCollection();
			var etalon: ArrayCollection = optionsModel.collectedEtalon;
			if(collectedEtalonTransport.length > 0){
				for each (var transportEtalon:Object in collectedEtalonTransport) {
					var objectIndexEtalon:int = getObjectIndexInCollection(transportEtalon.id, etalon)
					newCollectedEtalon.addItem((objectIndexEtalon!= -1)?etalon.getItemAt(objectIndexEtalon):new SimplyTexturaViewVO(transportEtalon));
				}
			}
			optionsModel.collectedEtalon = newCollectedEtalon;
		}
		
		protected function getObjectIndexInCollection(id:int, collection:ArrayCollection):int{
			for (var i:int = 0; i < collection.length; i++) {
				if(collection.getItemAt(i).id == id){
					return i;
				}
			}
			return -1;
		}
	}
}

internal final class SingletonHalper{}