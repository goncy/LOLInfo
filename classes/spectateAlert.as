package classes {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	import com.greensock.TweenMax;
	
	
	public class spectateAlert extends MovieClip {
		
		var specAlert;
		
		public function spectateAlert(obsKey:String,gameId:String,realm:String) {
			specAlert = this;
			buscar.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				var buscarArchivo:File = new File();
				buscarArchivo.addEventListener(Event.SELECT, function(e:Event):void{
					var path = e.target.nativePath;
					segundaVentana.visible = true;
					segundaVentana.codigo.text = "\""+path+"\" \"8394\" \"LoLLauncher.exe\" \"\" \"spectator spectator.la2.lol.riotgames.com:80 "+obsKey+" "+gameId+" "+realm;
					segundaVentana.codigo2.text = "\""+path+"\" \"8394\" \"LoLLauncher.exe\" \"\" \"spectator spectator.la2.lol.riotgames.com:80 "+obsKey+" "+gameId+" "+realm;
				});
				buscarArchivo.browse();
			});
			cerrar.addEventListener(MouseEvent.CLICK, cerrarAlert);
			segundaVentana.cerrar.addEventListener(MouseEvent.CLICK, cerrarAlert);
		}
		
		private function cerrarAlert(e:MouseEvent):void
		{
			TweenMax.to(specAlert,0.5,{autoAlpha:0,onComplete:function(){dispatchEvent(new Event("specCerrado"))}});
		}
	}
	
}