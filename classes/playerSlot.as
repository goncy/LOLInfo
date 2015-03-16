package  classes{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.greensock.TweenMax;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.filesystem.File;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	
	public class playerSlot extends MovieClip {
		
		private var redirecter;
		
		public function playerSlot(player:Object,version:String,champArray:Object,realm:String,badges:Object,obsKey:String,gameId:String,realms:Object,apiKey:String) {
			redirecter = new redirectBox(champArray[player.championId],player,realm);
			if(player.tier==="UNRANKED"){
				tierLogo.visible = false;
				playerLevel.text = "Nivel\n"+player.nivel;
			}else{
				division.gotoAndStop(player.tier);
				tierLogo.gotoAndStop(player.tier);
			}
			playerGs.text = addScore(player.gScore)+" GS";
			spell1.gotoAndStop(String(player.spell1));
			spell2.gotoAndStop(String(player.spell2));
			
			try{
				if(badges[player.summonerId]){
					badge.visible = true;
					badge.setTexto(badges[player.summonerId].razon.toUpperCase());
					badge.gotoAndStop(badges[player.summonerId].badgeName);
				}
			}catch(e:Error){
				trace(e);
			}
			
			if(player.teamId===100) summonerName.textColor = 0x49AAFF;
			if(player.teamId===200) summonerName.textColor = 0xFF1334;
			
			summonerName.text = player.summonerName;
			div.text = player.division;
			wins.text = "W: "+player.wins;
			losses.text = "L: "+player.losses;
			
			//Icon
			profileIcon.source = "http://ddragon.leagueoflegends.com/cdn/"+version+"/img/profileicon/"+player.profileIconId+".png";
			profileIcon.addEventListener(Event.COMPLETE, function(e:Event){
				e.target.content.smoothing = true;
				e.target.alpha = 0;
				TweenMax.to(e.target,1,{autoAlpha:1});
				e.target.visible = true;
			});
			
			//Champ
			champ.source = "http://ddragon.leagueoflegends.com/cdn/img/champion/loading/"+champArray[player.championId].key+"_0.jpg";
			champ.addEventListener(Event.COMPLETE, function(ev:Event){
				ev.target.content.smoothing = true;
				ev.target.alpha = 0;
				TweenMax.to(ev.target,1,{autoAlpha:1});
				ev.target.visible = true;
				dispatchEvent(new Event("splashCargado"));
				getChampTier(apiKey,player,realm);
			});
			
			goLk.addEventListener(MouseEvent.CLICK,function(lk:MouseEvent):void{
				redirecter.cerrar.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
					parent.parent.removeChild(redirecter);
				});
				parent.parent.addChild(redirecter);
			});
			
			goLkName.addEventListener(MouseEvent.CLICK,function(lkname:MouseEvent):void{
				redirecter.cerrar.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
					parent.parent.removeChild(redirecter);
				});
				parent.parent.addChild(redirecter);
			});
			
			spectate.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				var specAlert:spectateAlert = new spectateAlert(obsKey,gameId,realms[realm]);
				specAlert.addEventListener("specCerrado", function(e:Event):void{
					parent.parent.removeChild(specAlert);
				});
				parent.parent.addChild(specAlert);
			});
		}
		
		private function getChampTier(apiKey:String,player:Object,realm:String):void{
			var loaderHistory:URLLoader = new URLLoader();
			var requestHistory:URLRequest = new URLRequest();

			requestHistory.url = "https://"+realm+".api.pvp.net/api/lol/"+realm+"/v2.2/matchhistory/"+player.summonerId+"?championIds="+player.championId+"&api_key="+apiKey;
			loaderHistory.load(requestHistory);
					
			loaderHistory.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent){
				if(e.status===200){
					loaderHistory.addEventListener(Event.COMPLETE, function(e:Event){
						var history:Object = JSON.parse(e.target.data);
						if(history.matches){
							var champData = history.matches[0].participants[0].stats;
							var matchData = history.matches[0].participants[0].timeline;
							playerGs.text = addScore(player.gScore,champData,matchData)+" GS";
							cTier.gotoAndStop(calcularTier(champData,matchData));
							finCarga();
						}else{
							finCarga();
						}						
					});
				}else if(e.status===404){
					finCarga();
				}
			});
			
			loaderHistory.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent){
				finCarga();
			});
		}
		
		private function calcularTier(champData:Object,matchData:Object):Number{
			if(!matchData.role==="DUO_SUPPORT"){
				if(Number(champData.kills - champData.deaths + (champData.assists / 2)) > 15) return 5;
				if(Number(champData.kills - champData.deaths + (champData.assists / 2)) > 10) return 4;
				if(Number(champData.kills - champData.deaths + (champData.assists / 2)) > 7) return 3;
				if(Number(champData.kills - champData.deaths + (champData.assists / 2)) > 5) return 2;
				if(Number(champData.kills - champData.deaths + (champData.assists / 2)) < 5) return 1;
			}else{
				if(Number(champData.assists - champData.deaths + (champData.kills / 2)) > 15) return 8;
				if(Number(champData.assists - champData.deaths + (champData.kills / 2)) > 10) return 4;
				if(Number(champData.assists - champData.deaths + (champData.kills / 2)) > 7) return 3;
				if(Number(champData.assists - champData.deaths + (champData.kills / 2)) > 5) return 2;
				if(Number(champData.assists - champData.deaths + (champData.kills / 2)) < 5) return 1;
			}
			return 0;
		}
		
		private function finCarga(){
			dispatchEvent(new Event("infoCargada"));
		}
		
		private function addScore(score:Number,champData:Object=null,matchData:Object=null):int
		{
			var devolucion:int = 0;
			if(!matchData) return score;
			if(!matchData.role==="DUO_SUPPORT") devolucion = score + Number(champData.kills - champData.deaths + (champData.assists / 2));
			else devolucion = score + Number(champData.assists - champData.deaths + (champData.kills / 2));
			
			return devolucion;
		}
	}
}