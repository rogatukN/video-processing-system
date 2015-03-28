package utils
{
	import flash.display.BitmapData;
	
	import appConst.Const;
	
	import model.VideoModel;
	
	import vo.RgbData;
	import vo.RgbItem;

	public class Filters
	{	
		public static var videoModel : VideoModel = VideoModel.instance;
		private static var _expand : RgbData;
		
		public static function SplineL20 (data : RgbData) : RgbData
		{	
			_expand = getExpand(data);
			var bmp : BitmapData = new BitmapData(data.width,data.height);
			var rgbData : RgbData = new RgbData(bmp);
			for (var i:int = 0; i < data.width; i++) 
			{
				for (var j:int = 0; j < data.height; j++) 
				{
					rgbData.setRGB(i,j,L20(_expand,i+1,j+1));
				}
			}
			return rgbData;
		}
		
		public static function SplineL30 (data : RgbData) : RgbData
		{	
			_expand = getExpand(data);
			var bmp : BitmapData = new BitmapData(data.width,data.height);
			var rgbData : RgbData = new RgbData(bmp);
			for (var i:int = 0; i < data.width; i++) 
			{
				for (var j:int = 0; j < data.height; j++) 
				{
					rgbData.setRGB(i,j,L30(_expand,i+1,j+1));
				}
			}
			return rgbData;
		}
		
		public static function SplineH20 (data : RgbData) : RgbData
		{	
			_expand = getExpand(data);
			var bmp : BitmapData = new BitmapData(data.width,data.height);
			var rgbData : RgbData = new RgbData(bmp);
			for (var i:int = 0; i < data.width; i++) 
			{
				for (var j:int = 0; j < data.height; j++) 
				{
					rgbData.setRGB(i,j,H20(_expand,i+1,j+1));
				}
			}
			return rgbData;
		}
		
		private static function L20(data : RgbData, i: Number, j : Number): RgbItem
		{
			var rgb : RgbItem = new RgbItem();
			rgb.r=Math.round((data.getRGB(i-1,j-1).r+6*data.getRGB(i-1,j).r+data.getRGB(i-1,j+1).r+
				6*data.getRGB(i,j-1).r+36*data.getRGB(i,j).r+6*data.getRGB(i,j+1).r+
				data.getRGB(i+1,j-1).r+6*data.getRGB(i+1,j).r+data.getRGB(i+1,j+1).r)/64);
			rgb.g=Math.round((data.getRGB(i-1,j-1).g+6*data.getRGB(i-1,j).g+data.getRGB(i-1,j+1).g+
				6*data.getRGB(i,j-1).g+36*data.getRGB(i,j).g+6*data.getRGB(i,j+1).g+
				data.getRGB(i+1,j-1).g+6*data.getRGB(i+1,j).g+data.getRGB(i+1,j+1).g)/64);
			rgb.b=Math.round((data.getRGB(i-1,j-1).b+6*data.getRGB(i-1,j).b+data.getRGB(i-1,j+1).b+
				6*data.getRGB(i,j-1).b+36*data.getRGB(i,j).b+6*data.getRGB(i,j+1).b+
				data.getRGB(i+1,j-1).b+6*data.getRGB(i+1,j).b+data.getRGB(i+1,j+1).b)/64);
			return rgb;	
		}
		
		private static function L30(data : RgbData, i: Number, j : Number):RgbItem
		{
			var rgb : RgbItem = new RgbItem();
			rgb.r=Math.round((data.getRGB(i-1,j-1).r+4*data.getRGB(i-1,j).r+data.getRGB(i-1,j+1).r+
				4*data.getRGB(i,j-1).r+16*data.getRGB(i,j).r+4*data.getRGB(i,j+1).r+
				data.getRGB(i+1,j-1).r+4*data.getRGB(i+1,j).r+data.getRGB(i+1,j+1).r)/36);
			rgb.g=Math.round((data.getRGB(i-1,j-1).g+4*data.getRGB(i-1,j).g+data.getRGB(i-1,j+1).g+
				4*data.getRGB(i,j-1).g+16*data.getRGB(i,j).g+4*data.getRGB(i,j+1).g+
				data.getRGB(i+1,j-1).g+4*data.getRGB(i+1,j).g+data.getRGB(i+1,j+1).g)/36);
			rgb.b=Math.round((data.getRGB(i-1,j-1).b+4*data.getRGB(i-1,j).b+data.getRGB(i-1,j+1).b+
				4*data.getRGB(i,j-1).b+16*data.getRGB(i,j).b+4*data.getRGB(i,j+1).b+
				data.getRGB(i+1,j-1).b+4*data.getRGB(i+1,j).b+data.getRGB(i+1,j+1).b)/36);
			return rgb;	
		}
		
		private static function H20(data : RgbData, i: Number, j : Number): RgbItem
		{
			var rgb : RgbItem = new RgbItem();
			rgb.r=Math.round((-data.getRGB(i-1,j-1).r-6*data.getRGB(i-1,j).r-data.getRGB(i-1,j+1).r-
				6*data.getRGB(i,j-1).r+28*data.getRGB(i,j).r-6*data.getRGB(i,j+1).r-
				data.getRGB(i+1,j-1).r-6*data.getRGB(i+1,j).r-data.getRGB(i+1,j+1).r)/64);
			rgb.g=Math.round((-data.getRGB(i-1,j-1).g-6*data.getRGB(i-1,j).g-data.getRGB(i-1,j+1).g-
				6*data.getRGB(i,j-1).g+28*data.getRGB(i,j).g-6*data.getRGB(i,j+1).g-
				data.getRGB(i+1,j-1).g-6*data.getRGB(i+1,j).g-data.getRGB(i+1,j+1).g)/64);
			rgb.b=Math.round((-data.getRGB(i-1,j-1).b-6*data.getRGB(i-1,j).b-data.getRGB(i-1,j+1).b-
				6*data.getRGB(i,j-1).b+28*data.getRGB(i,j).b-6*data.getRGB(i,j+1).b-
				data.getRGB(i+1,j-1).b-6*data.getRGB(i+1,j).b-data.getRGB(i+1,j+1).b)/64);
			return rgb;
		}
		
		private static function H30(data : RgbData, i: Number, j : Number): RgbItem
		{
			var rgb : RgbItem = new RgbItem();
			rgb.r=Math.round((-data.getRGB(i-1,j-1).r-4*data.getRGB(i-1,j).r-data.getRGB(i-1,j+1).r-
				4*data.getRGB(i,j-1).r+20*data.getRGB(i,j).r-4*data.getRGB(i,j+1).r-
				data.getRGB(i+1,j-1).r-4*data.getRGB(i+1,j).r-data.getRGB(i+1,j+1).r)/36);
			rgb.g=Math.round((-data.getRGB(i-1,j-1).g-4*data.getRGB(i-1,j).g-data.getRGB(i-1,j+1).g-
				4*data.getRGB(i,j-1).g+20*data.getRGB(i,j).g-4*data.getRGB(i,j+1).g-
				data.getRGB(i+1,j-1).g-4*data.getRGB(i+1,j).g-data.getRGB(i+1,j+1).g)/36);
			rgb.b=Math.round((-data.getRGB(i-1,j-1).b-4*data.getRGB(i-1,j).b-data.getRGB(i-1,j+1).b-
				4*data.getRGB(i,j-1).b+20*data.getRGB(i,j).b-4*data.getRGB(i,j+1).b-
				data.getRGB(i+1,j-1).b-4*data.getRGB(i+1,j).b-data.getRGB(i+1,j+1).b)/36);
			return rgb;
		}
		
		//helper
		
		private static function getExpand(data : RgbData, value : int = 1):RgbData{
			var w : int = videoModel.offset*2+1+value*2;
			var h : int = videoModel.offset*2+1+value*2;
			var bit : BitmapData = new BitmapData(w,h);
			var rgb : RgbData  = new RgbData(bit);
			for (var i:int = 0; i < videoModel.offset*2+1; i++) 
			{
				for (var j:int = 0; j < videoModel.offset*2+1; j++) 
				{
					rgb.setRGB(value+i,value+j,data.getRGB(i,j));
				}
			}
			for (var k:int = value-1; k >= 0; k--) 
			{
				for (var i2:int = value; i2 < data.height+value; i2++) 
				{
					rgb.setRGB(k,i2,expand(data,k-value,i2-value,0));
					rgb.setRGB(w-1-k,i2,expand(data,w-1-k-2*value,i2-value,1));
				}
				
				for (i2 = value; i2 < data.width+value; i2++) 
				{
					rgb.setRGB(i2,k,expand(data,i2-value,k-value,2));
					rgb.setRGB(i2,h-1-k,expand(data,i2-value,h-1-k-2*value,3));
				}
				
				rgb.setRGB(k,k,expand(data,k,k,4));
				rgb.setRGB(k,h-1-k,expand(data,k-value,h-k-2*value,5));
				rgb.setRGB(w-1-k,k,expand(data,w-k-2*value,k-value,6));
				rgb.setRGB(w-1-k,h-1-k,expand(data,w-k-2*value,h-k-2*value,7));
			}
			return rgb;
		}
		
		private static function expand(data : RgbData,i:int,j:int,type:int):RgbItem{
			var rgb : RgbItem = new RgbItem();
			switch(type)
			{
				case 0:
				{
					rgb.r=(2*data.getRGB(i+1,j).r+data.getRGB(i+2,j).r-data.getRGB(i+4,j).r)/2;
					rgb.g=(2*data.getRGB(i+1,j).g+data.getRGB(i+2,j).g-data.getRGB(i+4,j).g)/2;
					rgb.b=(2*data.getRGB(i+1,j).b+data.getRGB(i+2,j).b-data.getRGB(i+4,j).b)/2;
					break;
				}
				case 1:
				{	rgb.r=(2*data.getRGB(i-1,j).r+data.getRGB(i-2,j).r-data.getRGB(i-4,j).r)/2;
					rgb.g=(2*data.getRGB(i-1,j).g+data.getRGB(i-2,j).g-data.getRGB(i-4,j).g)/2;
					rgb.b=(2*data.getRGB(i-1,j).b+data.getRGB(i-2,j).b-data.getRGB(i-4,j).b)/2;
					break;
				}
				case 2:
				{	rgb.r=(2*data.getRGB(i,j+1).r+data.getRGB(i,j+2).r-data.getRGB(i,j+4).r)/2;
					rgb.g=(2*data.getRGB(i,j+1).g+data.getRGB(i,j+2).g-data.getRGB(i,j+4).g)/2;
					rgb.b=(2*data.getRGB(i,j+1).b+data.getRGB(i,j+2).b-data.getRGB(i,j+4).b)/2;
					break;
				}
				case 3:
				{	rgb.r=(2*data.getRGB(i,j-1).r+data.getRGB(i,j-2).r-data.getRGB(i,j-4).r)/2;
					rgb.g=(2*data.getRGB(i,j-1).g+data.getRGB(i,j-2).g-data.getRGB(i,j-4).g)/2;
					rgb.b=(2*data.getRGB(i,j-1).b+data.getRGB(i,j-2).b-data.getRGB(i,j-4).b)/2;
					break;
				}
				case 4:
				{	rgb.r=(4*data.getRGB(i+1,j+1).r+2*data.getRGB(i+1,j+2).r-2*data.getRGB(i+1,j+4).r
					   +2*data.getRGB(i+2,j+1).r+data.getRGB(i+2,j+2).r-data.getRGB(i+2,j+4).r
					   -2*data.getRGB(i+4,j+1).r-data.getRGB(i+4,j+2).r+data.getRGB(i+4,j+4).r)/4;
					rgb.g=(4*data.getRGB(i+1,j+1).g+2*data.getRGB(i+1,j+2).g-2*data.getRGB(i+1,j+4).g
						+2*data.getRGB(i+2,j+1).g+data.getRGB(i+2,j+2).g-data.getRGB(i+2,j+4).g
						-2*data.getRGB(i+4,j+1).g-data.getRGB(i+4,j+2).g+data.getRGB(i+4,j+4).g)/4;
					rgb.b=(4*data.getRGB(i+1,j+1).b+2*data.getRGB(i+1,j+2).b-2*data.getRGB(i+1,j+4).b
						+2*data.getRGB(i+2,j+1).b+data.getRGB(i+2,j+2).b-data.getRGB(i+2,j+4).b
						-2*data.getRGB(i+4,j+1).b-data.getRGB(i+4,j+2).b+data.getRGB(i+4,j+4).b)/4;
					break;
				}
				case 5:
				{	
					rgb.r=(4*data.getRGB(i+1,j-1).r+2*data.getRGB(i+1,j-2).r-2*data.getRGB(i+1,j-4).r
					+2*data.getRGB(i+2,j-1).r+data.getRGB(i+2,j-2).r-data.getRGB(i+2,j-4).r
					-2*data.getRGB(i+4,j-1).r-data.getRGB(i+4,j-2).r+data.getRGB(i+4,j-4).r)/4;
					rgb.g=(4*data.getRGB(i+1,j-1).g+2*data.getRGB(i+1,j-2).g-2*data.getRGB(i+1,j-4).g
					   +2*data.getRGB(i+2,j-1).g+data.getRGB(i+2,j-2).g-data.getRGB(i+2,j-4).g
					   -2*data.getRGB(i+4,j-1).g-data.getRGB(i+4,j-2).g+data.getRGB(i+4,j-4).g)/4;
					rgb.b=(4*data.getRGB(i+1,j-1).b+2*data.getRGB(i+1,j-2).b-2*data.getRGB(i+1,j-4).b
					   +2*data.getRGB(i+2,j-1).b+data.getRGB(i+2,j-2).b-data.getRGB(i+2,j-4).b
					   -2*data.getRGB(i+4,j-1).b-data.getRGB(i+4,j-2).b+data.getRGB(i+4,j-4).b)/4;
					break;
				}
				case 6:
				{	
					rgb.r=(4*data.getRGB(i-1,j+1).r+2*data.getRGB(i-2,j+1).r-2*data.getRGB(i-4,j+1).r
						+2*data.getRGB(i-1,j+2).r+data.getRGB(i-2,j+2).r-data.getRGB(i-4,j+2).r
						-2*data.getRGB(i-1,j+4).r-data.getRGB(i-2,j+4).r+data.getRGB(i-4,j+4).r)/4;
					rgb.g=(4*data.getRGB(i-1,j+1).g+2*data.getRGB(i-2,j+1).g-2*data.getRGB(i-4,j+1).g
						+2*data.getRGB(i-1,j+2).g+data.getRGB(i-2,j+2).g-data.getRGB(i-4,j+2).g
						-2*data.getRGB(i-1,j+4).g-data.getRGB(i-2,j+4).g+data.getRGB(i-4,j+4).g)/4;
					rgb.b=(4*data.getRGB(i-1,j+1).b+2*data.getRGB(i-2,j+1).b-2*data.getRGB(i-4,j+1).b
						+2*data.getRGB(i-1,j+2).b+data.getRGB(i-2,j+2).b-data.getRGB(i-4,j+2).b
						-2*data.getRGB(i-1,j+4).b-data.getRGB(i-2,j+4).b+data.getRGB(i-4,j+4).b)/4;
					break;
				}
				case 7:
				{	
					rgb.r=(4*data.getRGB(i-1,j-1).r+2*data.getRGB(i-1,j-2).r-2*data.getRGB(i-1,j-4).r
						+2*data.getRGB(i-2,j-1).r+data.getRGB(i-2,j-2).r-data.getRGB(i-2,j-4).r
						-2*data.getRGB(i-4,j-1).r-data.getRGB(i-4,j-2).r+data.getRGB(i-4,j-4).r)/4;
					rgb.g=(4*data.getRGB(i-1,j-1).g+2*data.getRGB(i-1,j-2).g-2*data.getRGB(i-1,j-4).g
						+2*data.getRGB(i-2,j-1).g+data.getRGB(i-2,j-2).g-data.getRGB(i-2,j-4).g
						-2*data.getRGB(i-4,j-1).g-data.getRGB(i-4,j-2).g+data.getRGB(i-4,j-4).g)/4;
					rgb.b=(4*data.getRGB(i-1,j-1).b+2*data.getRGB(i-1,j-2).b-2*data.getRGB(i-1,j-4).b
						+2*data.getRGB(i-2,j-1).b+data.getRGB(i-2,j-2).b-data.getRGB(i-2,j-4).b
						-2*data.getRGB(i-4,j-1).b-data.getRGB(i-4,j-2).b+data.getRGB(i-4,j-4).b)/4;
					break;
				}
			}
			return rgb;
		}
		
	}
}