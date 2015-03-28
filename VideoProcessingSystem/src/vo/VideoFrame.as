package vo
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import model.VideoModel;
	
	import utils.BitMapUtils;
	import utils.DistanceUtil;

	public class VideoFrame
	{
		private var _width : int;
		private var _height: int;
		private var _data : BitmapData;
		private var _moveObjects : Array;
		/*[Bindable]*/
		public var compareBMPData : BitmapData;
		/*[Bindable]*/
		public var filtersBMPData : BitmapData;
		private var _detectGistArray : Array;
		
		/*[Bindable]*/
		public var videoModel : VideoModel = VideoModel.instance;
	
		public function VideoFrame(value : BitmapData)
		{
			_data = value;
			_height = value.height;
			_width = value.width;
			_moveObjects = new Array();
		}
		
		public function get moveObjects():Array{
			return _moveObjects;
		}
		
		public function get data(): BitmapData{
			return _data;
		}
		
		public function findObjectLike(likeObject : MoveObject):void{
			var contrArray : Array = new Array();
			var moveObject : MoveObject;
			var point : Point;
			for (var i:int = -1; i < 2; i++) 
			{
				for (var j:int = 0; j < 5; j++) 
				{
					point = new Point(likeObject.coordinates.x+i*videoModel.offset,likeObject.coordinates.y+j*videoModel.offset)
					var bmp : BitmapData = BitMapUtils.getBitmapByPoint(_data,point,videoModel.offset);
					moveObject = new MoveObject(bmp,point);
					contrArray.push(moveObject);
				}
			}
			
			var findedObject : MoveObject = DistanceUtil.bySer(contrArray,likeObject.rgbHistograms.mainHistogram);
			//findedObject.gist = likeObject.gist;
			likeObject.coordinates = findedObject.coordinates;
			_moveObjects.push(findedObject);
		}
		
		public function setMoveObjectAt(point : Point):void{
			var bmp : BitmapData = BitMapUtils.getBitmapByPoint(_data,point,videoModel.offset);
			var moveObject : MoveObject= new MoveObject(bmp,point);
			_moveObjects.push(moveObject);
		}
	}
}