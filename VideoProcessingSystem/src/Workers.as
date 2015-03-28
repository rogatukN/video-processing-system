/*******************************************************************************************************************************************
 * This is an automatically generated class. Please do not modify it since your changes may be lost in the following circumstances:
 *     - Members will be added to this class whenever an embedded worker is added.
 *     - Members in this class will be renamed when a worker is renamed or moved to a different package.
 *     - Members in this class will be removed when a worker is deleted.
 *******************************************************************************************************************************************/

package 
{
	
	import flash.utils.ByteArray;
	
	public class Workers
	{
		
		[Embed(source="../workerswfs/workers/BitmapWorker.swf", mimeType="application/octet-stream")]
		private static var workers_BitmapWorker_ByteClass1:Class;
		[Embed(source="../workerswfs/workers/BitmapWorker.swf", mimeType="application/octet-stream")]
		private static var workers_BitmapWorker_ByteClass2:Class;
		
		public static function get workers_BitmapWorker1():ByteArray
		{
			return new workers_BitmapWorker_ByteClass1();
		}
		
		public static function get workers_BitmapWorker2():ByteArray
		{
			return new workers_BitmapWorker_ByteClass2();
		}
		
	}
}
