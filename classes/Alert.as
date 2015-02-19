package classes {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.greensock.TweenMax;
	
	
	public class Alert extends MovieClip {
		
		private var alerta = this;
		
		public function Alert(info:Object) {
			// constructor code
			alerta.alpha = 0;
			title.text = info.informacion.Titulo;
			body.htmlText = info.informacion.Texto;
			TweenMax.to(alerta, 0.5, {autoAlpha:1});
			cerrar.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				TweenMax.to(alerta,0.5,{autoAlpha:0,onComplete:function(){dispatchEvent(new Event("alertOculto"))}});
			});
		}
	}
}
