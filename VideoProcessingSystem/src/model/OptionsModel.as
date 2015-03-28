package model
{	
	import mx.collections.ArrayCollection;
	
	import states.ModeStates;
	
	import vo.MoveObject;

	[Bindable]
	public class OptionsModel
	{
		public var mainModeState : String = ModeStates.AUTO;
		public var optionsVisible : Boolean;
		
		public var allowReceiveData : Boolean = true;
		public var collectedEtalon : ArrayCollection = new ArrayCollection();
		public var etalon : ArrayCollection = new ArrayCollection();
		public var clientEtalon: ArrayCollection = new ArrayCollection();
		
		public var loadedSampler: ArrayCollection = new ArrayCollection();
		
		public var offset : int = 13;
		
		public var gistograma1: MoveObject;
		public var gistograma2: MoveObject;
		
		private static var _instance : OptionsModel = new OptionsModel();
		
		public function OptionsModel(){
			if (_instance != null){
				throw new Error("OptionsModel can only be accesed through OptionsModel.instance");
			}
		}
		
		public static function get instance():OptionsModel{
			return _instance;
		}
	}
}