package model
{
	import flash.display.BitmapData;

	[Bindable]
	public interface IFrame
	{
		function set bitMap(value: BitmapData):void;
		function get bitMap():BitmapData;
	}
}