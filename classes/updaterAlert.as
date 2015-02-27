package classes {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	
	public class updaterAlert extends MovieClip {
		
		private var updAlert;
		
		public function updaterAlert(appVer:Number,lastVer:Number,descarga:String,changelog:String) {
			updAlert = this;
			appVersion.text = String(appVer);
			lastVersion.text = String(lastVer);
			changeLog.htmlText = changelog;
			
			descargar.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				navigateToURL(new URLRequest(descarga), "_blank");
				TweenMax.to(updAlert,0.5,{autoAlpha:0,onComplete:function(){dispatchEvent(new Event("cerrarUpdaterAlert"))}});
			});
			
			cerrar.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				TweenMax.to(updAlert,0.5,{autoAlpha:0,onComplete:function(){dispatchEvent(new Event("cerrarUpdaterAlert"))}});
			});
		}
	}
	
}
