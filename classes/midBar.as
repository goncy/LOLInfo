package classes{
	
	import flash.display.MovieClip;
	
	
	public class midBar extends MovieClip {
		
		
		public function midBar(partida:Object) {
			// constructor code
			if(partida.matchInfo.queueType) map.text = partida.matchInfo.mapName.toUpperCase() + " ("+partida.matchInfo.queueType+")";
			else map.text = partida.matchInfo.mapName.toUpperCase();
			ascore.text = partida.teamA.score+" GS";
			bscore.text = partida.teamB.score+" GS";
			
			var itirator:int = 0;
			
			if(partida.teamA.bans) for each(var banA in partida.teamA.bans){
				var banteamA:bannedChamp = new bannedChamp(partida.champArray[banA].key);
				banteamA.y = 33;
				banteamA.x = 75+(itirator*35);
				itirator++;
				addChild(banteamA);
			}		
			
			if(partida.teamB.bans) for each(var banB in partida.teamB.bans){
				var banteamB:bannedChamp = new bannedChamp(partida.champArray[banB].key);
				banteamB.y = 33;
				banteamB.x = 468+(itirator*35);
				itirator++;
				addChild(banteamB);
			}
		}
	}
	
}
