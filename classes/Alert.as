package classes {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	
	
	public class Alert extends MovieClip {
		
		
		public function Alert(info:Object) {
			// constructor code
			this.alpha = 0;
			title.text = info.informacion.Titulo;
			body.htmlText = info.informacion.Texto;
			TweenMax.to(this, 0.5, {autoAlpha:1});
		}
	}
	
}
