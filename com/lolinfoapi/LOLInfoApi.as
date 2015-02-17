package com.lolinfoapi
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.errors.IOError;

	public class LOLInfoApi extends Sprite 
	{
		//Server info
		private var apiKey:String;
		public var serverInfo:Object = {};
		//User info
		public static var Ssummoner:Object = new Object();
		//Game info
		public var gameConstants:Object = new Object();
		public var matchInfo:Object = new Object();
		public var teamA:Object = {players:[], bans:[], score:0};
		public var teamB:Object = {players:[], bans:[], score:0};
		//Static info
		public var champArray:Object = new Object();
		
		public function LOLInfoApi(rApiKey:String):void 
		{
			apiKey = rApiKey;
			getConstants();
		}
		
		public function search(rName:String, rRealm:String):void
		{
			resetVars();
			
			Ssummoner.realm = rRealm;
			Ssummoner.summonerName = rName;
			getSumInfo();
		}
		
		private function getConstants():void
		{
			var loaderConst:URLLoader = new URLLoader();
			var requestConst:URLRequest = new URLRequest();
			
			requestConst.url = "assets/constants.json";
			loaderConst.load(requestConst);
			
			loaderConst.addEventListener(Event.COMPLETE, function(e:Event){
				var constants:Object = JSON.parse(e.target.data);
				gameConstants = constants;
				trace("Carga de constants completa");
				dispatchEvent(new Event("constCompleta"));
				getChampArray();
			});
			
			loaderConst.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("constError"));
				trace("Error cargando const");
				return;
			});
		}
		
		private function getChampArray():void
		{
			var loaderChamp:URLLoader = new URLLoader();
			var requestChamp:URLRequest = new URLRequest();

			requestChamp.url = "https://global.api.pvp.net/api/lol/static-data/las/v1.2/champion?dataById=true&=true&api_key="+apiKey;
			loaderChamp.load(requestChamp);
			
			loaderChamp.addEventListener(Event.COMPLETE, function(e:Event){
				var champs:Object = JSON.parse(e.target.data);
				serverInfo.lastVersion = champs.version;
				champArray = champs.data;
				trace("Carga de champs completa");
				dispatchEvent(new Event("champsCompleta"));
			});
			
			loaderChamp.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("champsError"));
				return;
			});
		}
		
		public function getSumInfo():void
		{
			var loaderSumInfo:URLLoader = new URLLoader();
			var requestSumInfo:URLRequest = new URLRequest();

			requestSumInfo.url = "https://"+Ssummoner.realm+".api.pvp.net/api/lol/"+Ssummoner.realm+"/v1.4/summoner/by-name/"+Ssummoner.summonerName+"?api_key="+apiKey;
			loaderSumInfo.load(requestSumInfo);
			
			loaderSumInfo.addEventListener(Event.COMPLETE, function(e:Event){
				var sumInfo:Object = JSON.parse(e.target.data);
				for(var key:String in sumInfo) Ssummoner.id = sumInfo[key].id;
				dispatchEvent(new Event("summonerCompleta"));
				retrieveMatch();
			});
			
			loaderSumInfo.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("summonerError"));
				return;
			});
		}
		
		private function retrieveMatch():void
		{
			var loaderMatch:URLLoader = new URLLoader();
			var requestMatch:URLRequest = new URLRequest();
			
			var matchRealm = gameConstants.realms[Ssummoner.realm];

			requestMatch.url = "https://"+Ssummoner.realm+".api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/"+matchRealm+"/"+Ssummoner.id+"?api_key="+apiKey;
			loaderMatch.load(requestMatch);
			
			loaderMatch.addEventListener(Event.COMPLETE, getMatch);
			
			loaderMatch.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("matchError"));
				return;
			});
		}
		
		private function getMatch(e:Event):void 
		{
			matchInfo = JSON.parse(e.target.data);
			matchInfo.mapName = gameConstants.maps[matchInfo.mapId];
			matchInfo.queueType = gameConstants.queues[matchInfo.gameQueueConfigId];

			var players:Array = new Array();
			var playersId:Array = new Array();
			
			for each(var champ in matchInfo.bannedChampions){
				if(champ.teamId===100) teamA.bans.push(champ.championId);
				if(champ.teamId===200) teamB.bans.push(champ.championId);
			};
			
			for(var i=0; i<matchInfo.participants.length; i++){
				players.push(matchInfo.participants[i]);
				playersId.push(matchInfo.participants[i].summonerId);
			};
			
			var loaderTiers:URLLoader = new URLLoader();
			var requestTiers:URLRequest = new URLRequest();
			
			requestTiers.url = "https://"+Ssummoner.realm+".api.pvp.net/api/lol/"+Ssummoner.realm+"/v2.5/league/by-summoner/"+playersId+"/entry?api_key="+apiKey;
			loaderTiers.addEventListener(Event.COMPLETE, function(eTiers:Event){
				var tiersData:Object = JSON.parse(eTiers.target.data);

				for (var tierClass in tiersData){
					var tierId = int(tierClass);
					var indexPlayer = playersId.indexOf(tierId);
					
					players[indexPlayer].tier = tiersData[tierClass][0].tier;
					players[indexPlayer].division = tiersData[tierClass][0].entries[0].division;
					players[indexPlayer].lp = tiersData[tierClass][0].entries[0].leaguePoints;
					players[indexPlayer].wins = tiersData[tierClass][0].entries[0].wins;
					players[indexPlayer].losses = tiersData[tierClass][0].entries[0].losses;
					players[indexPlayer].gScore = getScore(players[indexPlayer]);
					players[indexPlayer].spell1 = gameConstants.spells[players[indexPlayer].spell1Id];
					players[indexPlayer].spell2 = gameConstants.spells[players[indexPlayer].spell2Id];
					
					if(players[indexPlayer].teamId===100){
						teamA.players.push(players[indexPlayer]);
						teamA.score += players[indexPlayer].gScore;
					}else if(players[indexPlayer].teamId===200){
						teamB.players.push(players[indexPlayer]);
						teamB.score += players[indexPlayer].gScore;
					}
					
					players.splice(indexPlayer,1);
					playersId.splice(indexPlayer,1);
				}
				
				for(var i=0;i<players.length;i=0){
					players[i].tier = "UNRANKED";
					players[i].spell1 = gameConstants.spells[players[i].spell1Id];
					players[i].spell2 = gameConstants.spells[players[i].spell2Id];
					players[i].division = "";
					players[i].lp = 0;
					players[i].wins = 0;
					players[i].losses = 0;
					players[i].gScore = 10;
					if(players[i].teamId===100){
						teamA.players.push(players[i]);
						teamA.score += players[i].gScore;
					}else if(players[i].teamId===200){
						teamB.players.push(players[i]);
						teamB.score += players[i].gScore;
					}
					
					players.splice(i,1);
					playersId.splice(i,1);
				};
				trace("Carga match completa");
				dispatchEvent(new Event("matchCompleta"));
			});
			
			loaderTiers.load(requestTiers);
			
			loaderTiers.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("tiersError"));
				return;
			});
		}
		
		public function getTrace():void
		{
			trace("Partida: Duracion - "+matchInfo.gameLength+" Segundos, Modo: "+matchInfo.gameMode+" - "+matchInfo.gameType+", Mapa: "+gameConstants.maps[matchInfo.mapId]);
			trace("Equipo A: (gScore: "+teamA.score+")");
			if(teamA.bans) for each(var banA in teamA.bans) trace("Ban: "+champArray[banA].name);
			for each (var playerA in teamA.players) trace("Summoner ID: "+playerA.summonerId+", Name: "+playerA.summonerName+", Champion: "+champArray[playerA.championId].name+", Spells ID: "+playerA.spell1Id+" / "+playerA.spell2Id+", Division: "+playerA.tier+" "+playerA.division+"("+playerA.lp+" LP)"+", gScore: "+playerA.gScore+", W/L: "+playerA.wins+"/"+playerA.losses+", Imagen: http://ddragon.leagueoflegends.com/cdn/"+serverInfo.lastVersion+"/img/profileicon/"+playerA.profileIconId+".png,");
			trace("Equipo B: (gScore: "+teamB.score+")");
			if(teamB.bans) for each(var banB in teamB.bans) trace("Ban: "+champArray[banB].name);
			for each (var playerB in teamB.players) trace("Summoner ID: "+playerB.summonerId+", Name: "+playerB.summonerName+", Champion: "+champArray[playerB.championId].name+", Spells ID: "+playerB.spell1Id+" / "+playerB.spell2Id+", Division: "+playerB.tier+" "+playerB.division+"("+playerB.lp+" LP)"+", gScore: "+playerB.gScore+", W/L: "+playerB.wins+"/"+playerB.losses+", Imagen: http://ddragon.leagueoflegends.com/cdn/"+serverInfo.lastVersion+"/img/profileicon/"+playerB.profileIconId+".png,");
		}
		
		private function getScore(player:Object):int
		{
			var score:Number;
			var baseScore:Number = 10;
			var matchesDif:Number = Number(player.wins) - Number(player.losses);
			score = baseScore;
						
			switch(player.tier){
				case "BRONZE":
					score += baseScore*1;
					score += 10-getDiv(player.division)*2;
					score += matchesDif * 0.2;
				break;
				case "SILVER":
					score += baseScore*2;
					score += 10-getDiv(player.division)*2;
					score += matchesDif * 0.2;
				break;
				case "GOLD":
					score += baseScore*3;
					score += 10-getDiv(player.division)*2;
					score += matchesDif * 0.2;
				break;
				case "PLATINUM":
					score += baseScore*4;
					score += 10-getDiv(player.division)*2;
					score += matchesDif * 0.2;
				break;
				case "DIAMOND":
					score += baseScore*5;
					score += 10-getDiv(player.division)*2;
					score += matchesDif * 0.2;
				break;
				case "MASTER":
					score += baseScore*6;
					score += 10-getDiv(player.division)*2;
					score += matchesDif * 0.2;
				break;
				case "CHALLENGER":
					score += baseScore*7;
					score += 10-getDiv(player.division)*2;
					score += matchesDif * 0.2;
				break;
			}
			return score;
		}
		
		function getDiv(division:String):Number
		{
			var devolucion:Number;
			
			switch(division){
				case "V":
					devolucion = 5;
				break;
				case "IV":
					devolucion = 4;
				break;
				case "III":
					devolucion = 3;
				break;
				case "II":
					devolucion = 2;
				break;
				case "I":
					devolucion = 1;
				break;
			}
			
			return devolucion;
		}
		
		private function resetVars():void
		{
			Ssummoner = new Object();
			matchInfo = new Object();
			teamA = {players:[], bans:[], score:0};
			teamB = {players:[], bans:[], score:0};
		}
	}
}