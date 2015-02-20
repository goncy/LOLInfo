package classes {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	
	
	public class errorPop extends MovieClip {
		
		private var errorThis:MovieClip;
		
		public function errorPop() {
			errorThis = this;
			
			cerrar.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				TweenMax.to(errorThis,0.5,{autoAlpha:0,y:-30});
			});
		}
	}
	
}
