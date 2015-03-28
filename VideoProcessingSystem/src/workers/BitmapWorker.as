package workers
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	import controller.VideoController;
	
	import events.WorkerEvent;
	
	import model.VideoModel;
	
	import utils.OptionSetterUtils;
	
	import vo.MoveObject;
	import vo.SimplyTextura;
	
	public class BitmapWorker extends Sprite {
		protected var mainToBack:MessageChannel;
		protected var backToMain:MessageChannel;
		
		protected var imageBytes:ByteArray;
		protected var imageData:BitmapData;
		
		protected var videoModel:VideoModel = VideoModel.instance;
		protected var videoController:VideoController = VideoController.instance;
		protected var optionSetter:OptionSetterUtils = OptionSetterUtils.instance;
		
		public function BitmapWorker(){
			var worker:Worker = Worker.current;
			
			mainToBack = worker.getSharedProperty("mainToBack");
			backToMain = worker.getSharedProperty("backToMain");
			mainToBack.addEventListener(Event.CHANNEL_MESSAGE, onMainToBack);
			videoController.addEventListener(WorkerEvent.DETECTION_COMPLETE,onDetectionComplete);
			backToMain.send("INIT_COMPLETE");
		}
		
		protected function onDetectionComplete(event:WorkerEvent):void {
			var worker:Worker = Worker.current;
			worker.setSharedProperty("detectionData", videoModel.detectionData);
			videoModel.detectionData = [];
			backToMain.send("DETECTION_COMPLETE");
		}
		
		protected function onMainToBack(event:Event):void {
			var worker:Worker = Worker.current;
			if(mainToBack.messageAvailable){
				//Get the message type.
				var msg:* = mainToBack.receive();
				if(msg == "COMPUTE"){
					imageBytes = worker.getSharedProperty("imageBytes");
					var w:int = worker.getSharedProperty("imageWidth");
					var h:int = worker.getSharedProperty("imageHeight");
					var time:int = worker.getSharedProperty("imageTime");
					var index : int = worker.getSharedProperty("index");
					var id : Number = worker.getSharedProperty("id");
					videoController.computeFrame(id, imageBytes, w, h, time, index);
					worker.setSharedProperty("foreignObjects", MoveObject.moveObjectsToTaransportArray(videoModel.foreignObjects));
					worker.setSharedProperty("collectedEtalon", SimplyTextura.simplyTexturaToTaransportArray(videoModel.detectObjects));
					backToMain.send("COMPUTE_COMPLETE");
				}else if(msg == "OFFSET"){
					videoModel.offset = worker.getSharedProperty("offset");
				}else if(msg == "ETALON"){
					optionSetter.clientTextura = worker.getSharedProperty("etalon");
				}else if(msg == "ALLOWRECEIVE"){
					videoModel.allowReceiveData = worker.getSharedProperty("allowReceive");
				}else if(msg == "DETECTIONETALON"){
					var etalon : ByteArray = worker.getSharedProperty("detectionEtalon");
					var wEtalon: Number = worker.getSharedProperty("detectionEtalonW");
					var hEtalon: Number = worker.getSharedProperty("detectionEtalonH");
					optionSetter.setDetectionEtalon(etalon,wEtalon,hEtalon);
				}
			}
		}
	}
}