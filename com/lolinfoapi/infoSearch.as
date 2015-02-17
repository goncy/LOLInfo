package com.lolinfoapi {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
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

			requestSumInfo.url = "https://"+realm+".api.pvp.net/api/lol/"+realm+"/v1.4/summoner/by-name/"+summoner+"?api_key="+apiKey;
			loaderSumInfo.load(requestSumInfo);
			
			loaderSumInfo.addEventListener(Event.COMPLETE, function(e:Event){
				var sumInfo:Object = JSON.parse(e.target.data);
				for(var key:String in sumInfo) userInfo = sumInfo[key];
				userInfo.realm = realm.toUpperCase();
				dispatchEvent(new Event("userInfoCompleta"));
			});
			
			loaderSumInfo.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("userInfoError"));
			});
		}
		
		public function getAppInfo():void
		{
			var loaderInformacion:URLLoader = new URLLoader();
			var requestInformacion:URLRequest = new URLRequest();

			requestInformacion.url = "https://raw.githubusercontent.com/goncy/LOLInfo/master/informacion.json";
			loaderInformacion.load(requestInformacion);
			
			loaderInformacion.addEventListener(Event.COMPLETE, function(e:Event):void{
				var informacion:Object = JSON.parse(e.target.data);
				appInfo = informacion;
				dispatchEvent(new Event("appInfoCompleta"));
			});
			
			loaderInformacion.addEventListener(IOErrorEvent.IO_ERROR, function(error:IOErrorEvent){
				dispatchEvent(new Event("appInfoError"));
				return;
			});
		}
	}
}
