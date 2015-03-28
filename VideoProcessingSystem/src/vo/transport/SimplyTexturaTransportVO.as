package vo.transport
{
	import flash.utils.ByteArray;

	[RemoteClass(alias="vo.transport.SimplyTexturaTransportVO")]
	public class SimplyTexturaTransportVO
	{
		public var id:int;
		public var x:int;
		public var y:int;
		public var width:Number;
		public var height:Number;
		public var byteArray: ByteArray;
	}
}