package com.lolinfoapi {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.HTTPStatusEvent;
	
	public class infoSearch extends Sprite{
		
		private var apiKey:String;
		public var userInfo:Object;
		public var appInfo:Object;

		public function infoSearch(rApiKey:String) {
			apiKey = rApiKey;
		}
		
		public function searchSummoner(summoner:String, realm:String):void
		{
			var loaderSumInfo:URLLoader = new URLLoader();
			var requestSumInfo:URLRequest = new URLRequest();
			
			realm = realm.toLowerCase();

			requestSumInfo.url = "https://"+realm+".api.pvp.net/api/lol/"+realm+"/v1.4/summoner/by-name/"+summoner+"?api_key="+apiKey;
			loaderSumInfo.load(requestSumInfo);
			
			loaderSumInfo.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent){
				if(e.status===200){
					loaderSumInfo.addEventListener(Event.COMPLETE, function(e:Event){
						var sumInfo:Object = JSON.parse(e.target.data);
						for(var key:String in sumInfo) userInfo = sumInfo[key];
						userInfo.realm = realm.toUpperCase();
						getSummonerTier(realm);
					});
				}else if(e.status===404){
					dispatchEvent(new Event("userInfoError"));
				}
			});
			
			loaderSumInfo.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("userInfoError"));
			});
		}
		
		private function getSummonerTier(realm:String):void
		{
			var loaderTier:URLLoader = new URLLoader();
			var requestTier:URLRequest = new URLRequest();
			
			requestTier.url = "https://"+realm+".api.pvp.net/api/lol/"+realm+"/v2.5/league/by-summoner/"+userInfo.id+"/entry?api_key="+apiKey;
			loaderTier.load(requestTier);
			
			loaderTier.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent){
				if(e.status===200){
					loaderTier.addEventListener(Event.COMPLETE, function(e:Event){
						var sumTier:Object = JSON.parse(e.target.data);
						for(var key:String in sumTier){
							userInfo.tier = sumTier[key][0].tier;
							userInfo.division = sumTier[key][0].entries[0].division;
						}
						dispatchEvent(new Event("userInfoCompleta"));
					});
				}else if(e.status===404){
					userInfo.tier = "UNRANKED";
					userInfo.division = "";
					dispatchEvent(new Event("userInfoCompleta"));
				};
			});

			loaderTier.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("userError"));
			});
		}
		
		public function getAppInfo():void
		{
			var loaderInformacion:URLLoader = new URLLoader();
			var requestInformacion:URLRequest = new URLRequest();

			requestInformacion.url = "https://raw.githubusercontent.com/goncy/LOLInfo/master/informacion.json";
			loaderInformacion.load(requestInformacion);
			
			loaderInformacion.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent){
				if(e.status===200){
					loaderInformacion.addEventListener(Event.COMPLETE, function(e:Event):void{
						var informacion:Object = JSON.parse(e.target.data);
						appInfo = informacion;
						trace("Carga de app info completa");
						dispatchEvent(new Event("appInfoCompleta"));
					});
				}else if(e.status===404){
					dispatchEvent(new Event("appInfoError"));
				}
			});
			
			loaderInformacion.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("appInfoError"));
			});
		}
		
		public function getBadges():void
		{
			var loaderBadges:URLLoader = new URLLoader();
			var requestBadges:URLRequest = new URLRequest();

			requestBadges.url = "https://raw.githubusercontent.com/goncy/LOLInfo/master/badges.json";
			loaderBadges.load(requestBadges);
			
			loaderBadges.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent){
				if(e.status===200){
					loaderBadges.addEventListener(Event.COMPLETE, function(e:Event):void{
						var Badges:Object = JSON.parse(e.target.data);
						appInfo.badges = Badges;
						trace("Carga de badges completa");
						dispatchEvent(new Event("badgesCompleta"));
					});
				}else if(e.status===404){
					dispatchEvent(new Event("badgesError"));
				}
			});
			
			loaderBadges.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("badgesError"));
			});
		}
	}
}