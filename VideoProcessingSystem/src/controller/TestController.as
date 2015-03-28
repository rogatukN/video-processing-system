package controller
{
	import mx.collections.ArrayCollection;
	
	import appConst.Const;
	
	import vo.FrameVO;
	import vo.PointDetectVO;
	import vo.RgbItem;

	public class TestController
	{
		public function TestController()
		{
		}
		
		[Bindable]
		public var points: ArrayCollection = new ArrayCollection();
		
		public function getPixels(arr: ArrayCollection):void{
			var point: PointDetectVO;
			var pointOnFrame: ArrayCollection;
			for each (var frame:FrameVO in arr) 
			{
				if (frame.bitMap.getPixel(0,0).toString(16) != "ffffff"){
					if (points.length==0){
						pointOnFrame = new ArrayCollection();
						for (var i:int = 0; i < 5; i++) 
						{
							for (var j:int = 0; j < 5; j++) 
							{
								point = new PointDetectVO();
								point.x = 50*(i+1);
								point.y = 40*(j+1);
								point.color = new RgbItem(frame.bitMap.getPixel(point.x,point.y)).color;
								pointOnFrame.addItem(point);
								frame.bitMap.setPixel(point.x,point.y,0xff0000);	
								frame.bitMap.setPixel(point.x-1,point.y,0xff0000);
								frame.bitMap.setPixel(point.x+1,point.y,0xff0000);
								frame.bitMap.setPixel(point.x,point.y-1,0xff0000);
								frame.bitMap.setPixel(point.x,point.y+1,0xff0000);
							}
						}
						points.addItem(pointOnFrame);
					}else{
						var lastPoints: ArrayCollection = new ArrayCollection(pointOnFrame.source);
						pointOnFrame = new ArrayCollection();
						var min: Number;
						var riz: Number;
						var color: Number;
						var value: Number;
						var x: Number;
						var y: Number;
						var newpoint: PointDetectVO;
						for each (point in lastPoints) 
						{
							min = 1000000000;
							x = NaN;
							y = NaN;
							color = NaN;
							for (var k1:int = point.x-20; k1 < point.x+20; k1++) 
							{
								for (var k2:int = point.y-20; k2 < point.y+20; k2++) 
								{
									if (k1>=0 && k2>=0 && k1<Const.VIDEO_WIDTH && k2<Const.VIDEO_HIGHT){
										value = new RgbItem(frame.bitMap.getPixel(k1,k2)).color;
										riz= Math.abs(value-point.color);
										if (riz<min){
											x=k1;
											y=k2;
											color = value;
											min = riz;
										}
									}
								}
							}
							newpoint = new PointDetectVO();
							newpoint.x = x;
							newpoint.y = y;
							newpoint.color = color;
							pointOnFrame.addItem(newpoint);
							frame.bitMap.setPixel(newpoint.x,newpoint.y,0xff0000);
							frame.bitMap.setPixel(newpoint.x-1,newpoint.y,0xff0000);
							frame.bitMap.setPixel(newpoint.x+1,newpoint.y,0xff0000);
							frame.bitMap.setPixel(newpoint.x,newpoint.y-1,0xff0000);
							frame.bitMap.setPixel(newpoint.x,newpoint.y+1,0xff0000);
						}
						points.addItem(pointOnFrame);
					}
				}
			trace('done');
			}
			
		}
	}
}