package states
{
	import mx.collections.ArrayCollection;

	public class ModeStates
	{
		public static const AUTO: String = 'auto';
		public static const CLIENT_HANDLET : String = 'розпізнавання'//'client';
		
		public static const PROVIDER : ArrayCollection = new ArrayCollection([AUTO,CLIENT_HANDLET]);
	}
}