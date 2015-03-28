package utils
{
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import appConst.Const;
	
	import model.OptionsModel;

	public class BitMapUtils
	{
		public static var optionModel : OptionsModel = OptionsModel.instance;
		public static function getBitmapByPoint(bitMap : BitmapData, point : Point, offset: int):BitmapData{
			var bit : BitmapData = new BitmapData(offset*2+1,offset*2+1);
			var rect : Rectangle = new Rectangle();
			rect.x = point.x-offset;
			rect.y = point.y-offset;
			rect.height = offset*2+1;
			rect.width = offset*2+1;
			bit.copyPixels(bitMap,rect,new Point());
			return bit;
		}
		
		public static function setCross(bitMap : BitmapData):void{
			for (var i:int = 0; i < 160; i++) 
			{
				bitMap.setPixel32(i*2,140,0xffff0000);
			}
			for (i = 0; i < 140; i++) 
			{
				bitMap.setPixel32(160,i*2,0xffff0000);
			}
		}
		
		public static function setCircle(bitMap : BitmapData, point : Point,color : uint = 0xffff0000):void{
			var min : Number = (optionModel.offset+10)*(optionModel.offset+10)-25;
			var max : Number = (optionModel.offset+10)*(optionModel.offset+10)+25;
			for (var i: int = -optionModel.offset-10; i <= optionModel.offset+10; i++) 
			{
				for (var j: int = -optionModel.offset-10; j <= optionModel.offset+10; j++) 
				{
					if (((i*i+j*j)<=max) && ((i*i+j*j)>=min)){
						bitMap.setPixel32(i+point.x,j+point.y,color);
					}
				}
			}
		}
		
		/*public static function getMoveObjectPointFrom11for14(value: int,index: int):Point{
			if (value%2==0){
				return new Point(Const.PADDING_FRAME+7+(value/2)*(2*optionModel.offset+1+7),(2*index+1)*Const.PADDING_FRAME);
			}
			return new Point(Const.PADDING_FRAME+13+Math.floor(value/2)*(2*optionModel.offset+1+13),(2*index+1)*Const.PADDING_FRAME+2*optionModel.offset+1);
		}
		
		public static function getMoveObjectPointFrom13for13(value: int,index: int):Point{
			if (value%2==0){
				return new Point(Const.PADDING_FRAME+4+(value/2)*(2*optionModel.offset+1+4),(2*index+1)*Const.PADDING_FRAME);
			}
			return new Point(Const.PADDING_FRAME+9+Math.floor(value/2)*(2*optionModel.offset+1+9),(2*index+1)*Const.PADDING_FRAME+2*optionModel.offset+1);
		}
		
		public static function getMoveObjectPointFrom15for12(value: int,index: int):Point{
			if (value%2==0){
				return new Point(Const.PADDING_FRAME+3+(value/2)*(2*optionModel.offset+1+3),(2*index+1)*Const.PADDING_FRAME);
			}
			return new Point(Const.PADDING_FRAME+7+Math.floor(value/2)*(2*optionModel.offset+1+7),(2*index+1)*Const.PADDING_FRAME+2*optionModel.offset+1);
		}
		
		public static function getMoveObjectPointFrom17for11(value: int,index: int):Point{
			if (value%2==0){
				return new Point(Const.PADDING_FRAME+2+(value/2)*(2*optionModel.offset+1+2),(2*index+1)*Const.PADDING_FRAME);
			}
			return new Point(Const.PADDING_FRAME+4+Math.floor(value/2)*(2*optionModel.offset+1+4),(2*index+1)*Const.PADDING_FRAME+2*optionModel.offset+1);
		}
		
		public static function getMoveObjectPointFrom21for10(value: int,index: int):Point{
			if (value%3==0){
				return new Point(Const.PADDING_FRAME+(value/3)*(2*optionModel.offset+1+12),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/3)*(2*optionModel.offset+1+12),(2*index+1)*Const.PADDING_FRAME+2*(2*optionModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+9+Math.floor(value/3)*(2*optionModel.offset+1+9),(2*index+1)*Const.PADDING_FRAME+2*optionModel.offset+1);
		}
		
		public static function getMoveObjectPointFrom26for9(value: int,index: int):Point{
			if (value%3==0){
				return new Point(Const.PADDING_FRAME+(value/3)*(2*optionModel.offset+1+6),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/3)*(2*optionModel.offset+1+10),(2*index+1)*Const.PADDING_FRAME+2*(2*optionModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+5+Math.floor(value/3)*(2*optionModel.offset+1+5),(2*index+1)*Const.PADDING_FRAME+2*optionModel.offset+1);
		}
		
		public static function getMoveObjectPointFrom32for8(value: int,index: int):Point{
			if (value%3==0){
				return new Point(Const.PADDING_FRAME+(value/3)*(2*optionModel.offset+1+4),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+5+Math.floor(value/3)*(2*optionModel.offset+1+5),(2*index+1)*Const.PADDING_FRAME+2*(2*optionModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+3+Math.floor(value/3)*(2*optionModel.offset+1+3),(2*index+1)*Const.PADDING_FRAME+2*optionModel.offset+1);
		}
		
		public static function getMoveObjectPointFrom41for7(value: int,index: int):Point{
			if (value%3==0){
				return new Point(Const.PADDING_FRAME+(value/3)*(2*optionModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/3)*(2*optionModel.offset+1+2),(2*index+1)*Const.PADDING_FRAME+2*(2*optionModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+Math.floor(value/3)*(2*optionModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME+2*optionModel.offset+1);
		}
		
		public static function getMoveObjectPointFrom55for6(value: int,index: int):Point{
			if (value%4==0){
				return new Point(Const.PADDING_FRAME+(value/4)*(2*optionModel.offset+1+3),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%3==0){
				return new Point(Const.PADDING_FRAME+4+Math.floor(value/4)*(2*optionModel.offset+1+4),(2*index+1)*Const.PADDING_FRAME+3*(2*optionModel.offset+1));
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/4)*(2*optionModel.offset+1+5),(2*index+1)*Const.PADDING_FRAME+2*(2*optionModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+2+Math.floor(value/4)*(2*optionModel.offset+1+2),(2*index+1)*Const.PADDING_FRAME+2*optionModel.offset+1);
		}
		
		public static function getMoveObjectPointFrom76for5(value: int,index: int):Point{
			if (value%4==0){
				return new Point(Const.PADDING_FRAME+(value/4)*(2*optionModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME);
			}else if (value%3==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/4)*(2*optionModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME+3*(2*optionModel.offset+1));
			}else if (value%2==0){
				return new Point(Const.PADDING_FRAME+Math.floor(value/4)*(2*optionModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME+2*(2*optionModel.offset+1));
			}
			return new Point(Const.PADDING_FRAME+Math.floor(value/4)*(2*optionModel.offset+1+1),(2*index+1)*Const.PADDING_FRAME+2*optionModel.offset+1);
		}*/
		
		public static function getMoveObjectPoint(value:int, index: int, offset: int):Point{
			var radius: Number = offset*2+1;
			var hCount: int = Math.floor(140/radius);
			var wCount: int = Math.floor(320/radius);
			
			var paddingTop: int = 140-(hCount*radius);
			var paddingLeft: int = Math.ceil((320-(wCount*radius))/2);
			
			var point:Point = new Point();
			point.x = (value%wCount)*radius+paddingLeft;
			point.y = Math.floor(value/wCount)*radius+paddingTop+index*140;
			return point;
		}
	}
}