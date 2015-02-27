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
					segundaVentana.codigo.text = "\""+path+"\" \"8394\" \"LoLLauncher.exe\" \"\" \"spectator "+getPlataform(realm)+" "+obsKey+" "+gameId+" "+realm;
					segundaVentana.codigo2.text = "\""+path+"\" \"8394\" \"LoLLauncher.exe\" \"\" \"spectator "+getPlataform(realm)+" "+obsKey+" "+gameId+" "+realm;
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
		
		private function getPlataform(realm:String):String
		{
			switch(realm){
				case "NA1":
					return "spectator.na.lol.riotgames.com:80";
				break;
				case "EUW1":
					return "spectator.euw1.lol.riotgames.com:80";
				break;
				case "EUN1":
					return "spectator.eu.lol.riotgames.com:8080";
				break;
				case "KR":
					return "spectator.kr.lol.riotgames.com:80";
				break;
				case "OC1":
					return "spectator.oc1.lol.riotgames.com:80";
				break;
				case "BR1":
					return "spectator.br.lol.riotgames.com:80";
				break;
				case "LA1":
					return "spectator.la1.lol.riotgames.com:80";
				break;
				case "LA2":
					return "spectator.la2.lol.riotgames.com:80";
				break;
				case "RU":
					return "spectator.ru.lol.riotgames.com:80";
				break;
				case "TR1":
					return "spectator.tr.lol.riotgames.com:80";
				break;
			}
			return "";
		}
	}
	
}