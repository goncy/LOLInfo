package com.lolinfoapi
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.errors.IOError;
	import flash.events.HTTPStatusEvent;

	public class LOLInfoApi extends Sprite 
	{
		//Server info
		private var apiKey:String;
		public var serverInfo:Object = {};
		//User info
		public var Ssummoner:Object = new Object();
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
			
			loaderChamp.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent){
				if(e.status===200){
					loaderChamp.addEventListener(Event.COMPLETE, function(e:Event){
						var champs:Object = JSON.parse(e.target.data);
						serverInfo.lastVersion = champs.version;
						champArray = champs.data;
						trace("Carga de champs completa");
						dispatchEvent(new Event("champsCompleta"));
					});
				}else if(e.status===404){
					dispatchEvent(new Event("champsError"));
				};
			});
			
			loaderChamp.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("champsError"));
			});
		}
		
		public function getSumInfo():void
		{
			var loaderSumInfo:URLLoader = new URLLoader();
			var requestSumInfo:URLRequest = new URLRequest();

			requestSumInfo.url = "https://"+Ssummoner.realm+".api.pvp.net/api/lol/"+Ssummoner.realm+"/v1.4/summoner/by-name/"+Ssummoner.summonerName+"?api_key="+apiKey;
			loaderSumInfo.load(requestSumInfo);
			
			loaderSumInfo.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent){
				if(e.status===200){
					loaderSumInfo.addEventListener(Event.COMPLETE, function(e:Event){
						var sumInfo:Object = JSON.parse(e.target.data);
						for(var key:String in sumInfo) Ssummoner.id = sumInfo[key].id;
						dispatchEvent(new Event("summonerCompleta"));
						retrieveMatch();
					});
				}else if(e.status===404){
					dispatchEvent(new Event("summonerError"));
				};
			});
			
			loaderSumInfo.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("summonerError"));
			});
		}
		
		private function retrieveMatch():void
		{
			var loaderMatch:URLLoader = new URLLoader();
			var requestMatch:URLRequest = new URLRequest();
			
			var matchRealm = gameConstants.realms[Ssummoner.realm];

			requestMatch.url = "https://"+Ssummoner.realm+".api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/"+matchRealm+"/"+Ssummoner.id+"?api_key="+apiKey;
			loaderMatch.load(requestMatch);
			
			loaderMatch.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent){
				if(e.status===200){			
					loaderMatch.addEventListener(Event.COMPLETE, getMatch);
				}else if(e.status===404){
					dispatchEvent(new Event("matchError"));
				};
			});
			
			loaderMatch.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("matchIOError"));
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
			loaderTiers.load(requestTiers);

			loaderTiers.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent){
				if(e.status===200){		
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
						parseUnrankeds();
					});
				}else if(e.status===404){
					parseUnrankeds();
					dispatchEvent(new Event("tiersError"));
				};
				
				function parseUnrankeds(){
					var loaderLevels:URLLoader = new URLLoader();
					var requestLevels:URLRequest = new URLRequest();
					
					requestLevels.url = "https://"+Ssummoner.realm+".api.pvp.net/api/lol/"+Ssummoner.realm+"/v1.4/summoner/"+playersId.toString()+"?api_key="+apiKey;
					loaderLevels.load(requestLevels);

					loaderLevels.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent){
						if(e.status===200){		
							loaderLevels.addEventListener(Event.COMPLETE, function(eLevels:Event){
								var levelsData:Object = JSON.parse(eLevels.target.data);

								for (var levelClass in levelsData){
									var levelId = int(levelClass);
									var indexPlayer = playersId.indexOf(levelId);
									
									players[indexPlayer].tier = "UNRANKED";
									players[indexPlayer].nivel = levelsData[levelId].summonerLevel;
									players[indexPlayer].spell1 = gameConstants.spells[players[indexPlayer].spell1Id];
									players[indexPlayer].spell2 = gameConstants.spells[players[indexPlayer].spell2Id];
									players[indexPlayer].division = "";
									players[indexPlayer].lp = 0;
									players[indexPlayer].wins = 0;
									players[indexPlayer].losses = 0;
									players[indexPlayer].gScore = 30+33*players[indexPlayer].nivel;
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
								
								trace("Carga match completa");
								dispatchEvent(new Event("matchCompleta"));
							});
						}else if(e.status===404){
							dispatchEvent(new Event("tiersError"));
						}						
					});
					
					loaderLevels.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
						dispatchEvent(new Event("matchCompleta"));
					});
				}
			});
						
			loaderTiers.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("tiersError"));
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
			var maxLvlBase:Number = 990;
			var baseScore:Number = 30;
			var divisionScore:Number = 600;
			var matchesDif:Number = Number(player.wins) - Number(player.losses);
			score = baseScore;
			
			score += getDiv(player.division)*150;
			score += matchesDif * 5;
			score += player.lp;
			score += maxLvlBase;
						
			switch(player.tier){
				case "BRONZE":
					score += baseScore*1;
					score += divisionScore*1;
				break;
				case "SILVER":
					score += baseScore*2;
					score += divisionScore*2;
				break;
				case "GOLD":
					score += baseScore*3;
					score += divisionScore*3;
				break;
				case "PLATINUM":
					score += baseScore*4;
					score += divisionScore*4;
				break;
				case "DIAMOND":
					score += baseScore*5;
					score += divisionScore*5;
				break;
				case "MASTER":
					score += baseScore*6;
					score += divisionScore*6;
				break;
				case "CHALLENGER":
					score += baseScore*7;
					score += divisionScore*7;
				break;
			}
			return score;
		}
		
		function getDiv(division:String):Number
		{
			var devolucion:Number;
			
			switch(division){
				case "V":
					devolucion = 1;
				break;
				case "IV":
					devolucion = 2;
				break;
				case "III":
					devolucion = 3;
				break;
				case "II":
					devolucion = 4;
				break;
				case "I":
					devolucion = 5;
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