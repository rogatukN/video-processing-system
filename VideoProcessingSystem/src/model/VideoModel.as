package model
{
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import appConst.Const;
	
	import vo.Etalon;
	import vo.MoveObject;

	/*[Bindable]*/
	public class VideoModel
	{
		public var offset : int = 13;
		
		public var video : Video;
		public var videoArea : Sprite;
		public var nc: NetConnection;
		public var ns: NetStream;
		
		public var foreignObjects : Array = [];
		public var detectObjects : Array = [];
		public var points: Array = [];
		
		public var etalonDirectory: Etalon = new Etalon(Const.PORIG_ETALON);
		public var foreignClastersDirectory: Etalon = new Etalon(Const.PORIG_FOREIGN_ETALON);
		
		public var clientEtalon: Array = [];
		
		public var allowReceiveData : Boolean = true;
		
		public var detectionEtalon: MoveObject;
		public var isDetectedObject : MoveObject;
		public var detectionData : Array = [];
		
		private static var _instance : VideoModel = new VideoModel();
		
		public function VideoModel(){
			if (_instance != null){
				throw new Error("VideoModel can only be accesed through VideoModel.instance");
			}
		}
		
		public static function get instance():VideoModel{
			return _instance;
		}
	}
}