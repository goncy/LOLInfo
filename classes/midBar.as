package classes{
	
	import flash.display.MovieClip;
	
	
	public class midBar extends MovieClip {
		
		
		public function midBar(partida:Object) {
			// constructor code
			if(partida.matchInfo.queueType) map.text = partida.matchInfo.mapName.toUpperCase() + " ("+partida.matchInfo.queueType+")";
			else map.text = partida.matchInfo.mapName.toUpperCase();
			
			var totalScore:int = Math.round(getScore(partida,"a") + getScore(partida,"b"));
			var teamAscore:int = Math.round((getScore(partida,"a") * 100) / totalScore);
			var teamBscore:int = Math.round((getScore(partida,"b") * 100) / totalScore);
			
			ascore.text = teamAscore+"%";
			bscore.text = teamBscore+"%";
			
			var itirator:int = 0;
			
			if(partida.teamA.bans) for each(var banA in partida.teamA.bans){
				var banteamA:bannedChamp = new bannedChamp(partida.champArray[banA].key,partida.serverInfo.lastVersion);
				banteamA.y = 33;
				banteamA.x = 75+(itirator*35);
				itirator++;
				addChild(banteamA);
			}		
			
			if(partida.teamB.bans) for each(var banB in partida.teamB.bans){
				var banteamB:bannedChamp = new bannedChamp(partida.champArray[banB].key,partida.serverInfo.lastVersion);
				banteamB.y = 33;
				banteamB.x = 468+(itirator*35);
				itirator++;
				addChild(banteamB);
			}
		}
		
		private function getScore(partida,team):int{
			var devolucion:int = 0;
			switch(team){
				case "a":
					for each(var jugadorA in partida.teamA.players){
						devolucion += jugadorA.gScore;
					}
				break;
				case "b":
					for each(var jugadorB in partida.teamB.players){
						devolucion += jugadorB.gScore;
					}
				break;
			}
			return devolucion;
		}
	}
	
}
