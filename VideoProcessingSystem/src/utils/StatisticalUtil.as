package utils
{
	import appConst.HistogramType;
	
	import vo.ClusterVO;
	import vo.Histogram;
	import vo.RGBHistograms;
	import vo.RgbData;
	import vo.RgbItem;

	public class StatisticalUtil
	{ 	
		
		public static function histogramEstimateBy(rgb : RgbData,hisType : String):Array
		{	var kil : int = 0;
			var data : Array = [];
			data.length = 256
			for (var k:int = 0; k < 256; k++) 
			{
				data[k]=0;
			}
			for (var i:int = 0; i < rgb.width; i++) 
			{
				if (i>0){
					for (var j:int = 0; j < rgb.height; j++) 
					{ 
						if (j>0){
							switch(hisType)
							{
								case HistogramType.R_TYPE:
								{
									data[rgb.getRGB(i,j).r]++;
									break;
								}
								case HistogramType.G_TYPE:
								{
									data[rgb.getRGB(i,j).g]++;
									break;
								}
								case HistogramType.B_TYPE:
								{
									data[rgb.getRGB(i,j).b]++;
									break;
								}
								case HistogramType.RGB_SER_TYPE:
								{
									var index : int = Math.round((rgb.getRGB(i,j).r+rgb.getRGB(i,j).g+rgb.getRGB(i,j).b)/3);
									data[index]++;
									break;
								}
							}
							kil++;
						}
					}	
				}
			}
			for (var m:int = 0; m < 256; m++) 
			{
				data[m] = data[m]/kil;
			}
			return data
		}
		
		public static function getSimplyHistograms(data : Array):ClusterVO
		{	
			var rgbHistograma : RGBHistograms = new RGBHistograms();
			var r : Array = new Array();
			r.length = 256;
			var g : Array = new Array();
			g.length = 256;
			var b : Array = new Array();
			b.length = 256;
			var all : Array = new Array();
			all.length = 256;
			var kil : int = 0;
			for (var i:int = 0; i < 256; i++) 
			{
				r[i] = 0;
				g[i] = 0;
				b[i] = 0;
				all[i]=0;
			}
			for each (var rgb:RgbItem in data) 
			{
				r[rgb.r]++;
				g[rgb.g]++;
				b[rgb.b]++;
				var index : int = Math.round((rgb.r+rgb.g+rgb.b)/3);
				all[index]++;
				kil++;
			}
			for (i = 0; i < 256; i++) 
			{
				r[i] = r[i]/kil;
				g[i] = g[i]/kil;
				b[i] = b[i]/kil;
			}
			rgbHistograma.r = new Histogram(r);
			rgbHistograma.g = new Histogram(g);
			rgbHistograma.b = new Histogram(b);
			rgbHistograma.mainHistogram = new Histogram(all);
			var returnCluster : ClusterVO = new ClusterVO();
			returnCluster.rgbHistograms = rgbHistograma;
			return returnCluster;
		}
	
		public static function KvantN1(a:Number):Number{
			return Math.sqrt(Math.log(1/Math.pow((a/2),2)))-((2.515517+0.802853*Math.sqrt(Math.log(1/Math.pow((a/2),2)))+0.010328*Math.pow(Math.sqrt(Math.log(1/Math.pow((a/2),2))),2))/(1+1.432788*Math.sqrt(Math.log(1/Math.pow((a/2),2)))+0.1892659*Math.pow(Math.sqrt(Math.log(1/Math.pow((a/2),2))),2)+0.001308*Math.pow(Math.sqrt(Math.log(1/Math.pow((a/2),2))),3)))+0.00045;	
		}
		
		public static function KvantN2(a:Number):Number{
			if (a<=0.5){
				return -KvantN1(2*a);
			}else {
				return KvantN1(2*(1-a));	
			}
		}
		
		public static function KvantS(a:Number, Nuu:int):Number{
			return KvantN1(a)+(1/Nuu)*((1/4)*(Math.pow(KvantN1(a),3)+KvantN1(a)))+(1/Math.pow(Nuu,2))*((1/96)*(5*Math.pow(KvantN1(a),5)+16*Math.pow(KvantN1(a),3)+3*KvantN1(a)))+(1/Math.pow(Nuu,3))*((1/384)*(3*Math.pow(KvantN1(a),7)+19*Math.pow(KvantN1(a),5)+17*Math.pow(KvantN1(a),3)-15*KvantN1(a)))+(1/Math.pow(Nuu,4))*((1/92160)*(79*Math.pow(KvantN1(a),9)+779*Math.pow(KvantN1(a),7)+1482*Math.pow(KvantN1(a),5)-1920*Math.pow(KvantN1(a),3)-945*KvantN1(a)));	
		}
		
		public static function KvantP(a:Number,Nuu:int):Number{
			return Nuu*Math.pow(1-2/(9*Nuu)+KvantN1(2*a)*Math.sqrt(2/(9*Nuu)),3);
		}
		
		/*function KvantF(a:real;Nuu1,Nuu2:integer):real;
		var Dop,Dop1,Dop2: real;
		begin
		Dop:=1/Nuu1+1/Nuu2;
		Dop1:=1/Nuu1-1/Nuu2;
		Dop2:=KvantN1(2*a)*sqrt(Dop/2)-(1/6)*Dop1*(sqr(KvantN1(2*a))+2)+sqrt(Dop/2)*((Dop/24)*(sqr(KvantN1(2*a))+3*KvantN1(2*a))+(1/72)*(sqr(Dop1)/Dop)*(power(KvantN1(2*a),3)+11*KvantN1(2*a)))-(Dop*Dop1/120)*(power(KvantN1(2*a),4)+9*sqr(KvantN1(2*a))+8)+(power(Dop1,3)/(3240*Dop))*(3*power(KvantN1(2*a),4)+7*sqr(KvantN1(2*a))-16)+sqrt(Dop/2)*((sqr(Dop)/1920)*(power(KvantN1(2*a),5)+20*power(KvantN1(2*a),3)+15*KvantN1(2*a))-(power(Dop1,4)/2880)*(power(KvantN1(2*a),5)+44*power(KvantN1(2*a),3)+183*KvantN1(2*a))+power(Dop1,4)/(155520*sqr(Dop))*(9*power(KvantN1(2*a),5)-284*power(KvantN1(2*a),3)-1513*KvantN1(2*a)));
		KvantF:=exp(2*Dop2);
		end;*/
		
	}
}