package classes {
	
	import flash.display.MovieClip;
	
	
	public class bgChanger extends MovieClip {
		
		public static var bgManager;
		
		public function bgChanger() {
			// constructor code
			bgManager = this;
		}
		
		public static function changeBgPrev():void
		{
			bgManager.prevFrame();
		}
		
		public static function changeBgNext():void
		{
			bgManager.nextFrame();
		}
	}
	
}
