package classes {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class redirectBox extends MovieClip {
		
		
		public function redirectBox(champion:Object, summoner:Object, realm:String) {
			_champion.text = champion.name;
			_summoner.text = summoner.summonerName;
			
			masteries.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				navigateToURL(new URLRequest("http://www.lolking.net/summoner/"+realm+"/"+summoner.summonerId+"#masteries"));
			});
			
			runas.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				navigateToURL(new URLRequest("http://www.lolking.net/summoner/"+realm+"/"+summoner.summonerId+"#runes"));
			});
			
			matches.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				navigateToURL(new URLRequest("http://www.lolking.net/summoner/"+realm+"/"+summoner.summonerId+"#matches"));
			});
			
			stats.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				navigateToURL(new URLRequest("http://www.lolking.net/summoner/"+realm+"/"+summoner.summonerId+"#ranked-stats"));
			});
			
			builds.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				navigateToURL(new URLRequest("http://www.probuilds.net/champions/"+champion.key));
			});
			
			counters.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				navigateToURL(new URLRequest("http://www.championselect.net/champions/"+champion.key));
			});
		}
	}
}
