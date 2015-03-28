package vo.transport
{
	import flash.utils.ByteArray;

	[RemoteClass(alias="vo.transport.MoveObjectTransportVO")]
	public class MoveObjectTransportVO {
		public var id:int;
		public var time:Number;
		public var x:int;
		public var y:int;
		public var width:Number;
		public var height:Number;
		public var sigma:Number;
		public var byteArray: ByteArray;
	}
}