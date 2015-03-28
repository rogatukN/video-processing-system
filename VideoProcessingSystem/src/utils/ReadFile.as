package utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	
	[Event(name="complete", type="flash.events.Event")]
	public class ReadFile extends Sprite
	{
		private var fileRef: FileReference;
		private var data : ByteArray;
		private var array : Array = []; 
		public var vectorsArray : Array; 
		private var numVector : int = new int;
		//private static const PATH : String = "C:/Users/Настя/Desktop/VideoData/";
		private static const PATH : String = "";
		
		public function ReadFile(path : String = null)
		{
			//if (!path){
				fileRef = new FileReference();
				fileRef.addEventListener(Event.SELECT, onFileSelected);
				var textTypeFilter : FileFilter = new FileFilter("TextFiles (*.txt)","*.txt");
				fileRef.browse([textTypeFilter]);
			/*}else{
				var ldr:URLLoader = new URLLoader();
				var request:URLRequest = new URLRequest(PATH+path+'.txt');
				ldr.addEventListener(Event.COMPLETE, onLoad);
				ldr.load(request);
			}*/
		}
		
		private function onLoad(e:Event):void
		{
			var ldr:URLLoader = URLLoader(e.target);
			getArray(ldr.data);
		}
		
		public function onFileSelected (evt : Event):void{
			fileRef.addEventListener(Event.COMPLETE, onComplete);
			fileRef.load();
		}
		
		private function onComplete(evn : Event):void
		{
			data = fileRef.data;
			var str : String = data.toString();
			getArray(str);
		}
		
		
		private function getArray (str : String):void{
			var value : String = new String;
			for (var i:int = 0; i < str.length; i++) 
			{
				if (str.charCodeAt(i) != 13){
					if (str.charCodeAt(i) != 32 && str.charCodeAt(i) != 10){
						value=value + str.charAt(i);
					}
					else{
						if (value != ''){
							array.push(new Number(value));
							value = new String;
							numVector++;
						}	
					}
				}
				else{
					if (value != ''){
						array.push(new Number(value));
						value = new String;
						numVector = 0;
					}	
				}
			}
			array.push(new Number(value));
			getVectors();
			dispatchEvent(new Event('complete'));
		}
		
		private function getVectors():void
		{
			vectorsArray = [];
			for (var k:int = 0; k <= numVector; k++) 
			{
				var vector : Array = [];
				vectorsArray.push(vector);
			}
			var n : int = 0;
			for (var j:int = 0; j < Math.round(array.length/(numVector+1)); j++) 
			{
				for (var i:int = 0; i < vectorsArray.length; i++) 
				{
					var num : Number = new Number(array[n]);
					(vectorsArray[i] as Array).push(num);
					n++;
				}	
			}
			
		}
	}
}