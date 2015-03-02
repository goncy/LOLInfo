package classes {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.greensock.TweenMax;
	
	
	public class sumInfoAlert extends MovieClip {
		
		var alert;
		
		public function sumInfoAlert(summoner:Object) {
			alert = this;
			
			maestrias.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				navigateToURL(new URLRequest("http://www.lolking.net/summoner/"+summoner.realm+"/"+summoner.id+"#masteries"));
			});
			
			runas.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				navigateToURL(new URLRequest("http://www.lolking.net/summoner/"+summoner.realm+"/"+summoner.id+"#runes"));
			});
			
			historial.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				navigateToURL(new URLRequest("http://www.lolking.net/summoner/"+summoner.realm+"/"+summoner.id+"#matches"));
			});
			
			estadisticas.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				navigateToURL(new URLRequest("http://www.lolking.net/summoner/"+summoner.realm+"/"+summoner.id+"#ranked-stats"));
			});
			
			title.text = summoner.summonerName;
			
			cerrar.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				TweenMax.to(alert,1,{autoAlpha:0,onComplete:function(){dispatchEvent(new Event("sumInfoCerrado"))}});
			});
		}
	}
	
}
