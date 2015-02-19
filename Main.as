package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.lolinfoapi.LOLInfoApi;
	import com.lolinfoapi.infoSearch;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import classes.playerSlot;
	import classes.midBar;
	import classes.realmDrop;
	import classes.Alert;
	import classes.configAlert;
	import classes.bgChanger;
	import classes.redirectBox;
	
	//Greensock
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	public class Main extends MovieClip {
		
		//Match related
		private var api:String = "79cec077-7792-4ac8-90cc-a43d5cff69a6";
		private var lolApiRequest:LOLInfoApi = new LOLInfoApi(api);
		private var playersLoaded:int = 0;
		private var Ssummoner:Object = new Object();
		//Containers
		private var matchContainer:MovieClip = new MovieClip();
		//User related
		private var userInfo:Object = {};
		//App related
		private var appInfo:Object = new Object();
		
		public function Main() {
			if(stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
			stageOptions();
			lolApiRequest.addEventListener("champsError", errorHandler);
			lolApiRequest.addEventListener("summonerError", errorHandler);
			lolApiRequest.addEventListener("matchError", errorHandler);
			lolApiRequest.addEventListener("versionError", errorHandler);
			
			lolApiRequest.addEventListener("champsCompleta", function(e:Event){
				readyState();
				userHandler();
				_searchMatch.addEventListener(MouseEvent.CLICK, searchMatch);
				lolApiRequest.addEventListener("matchCompleta", generateMatchStage);
			});
        }
		
		private function userHandler():void
		{
			setUserConfig();
			if(userInfo.summonerName) populateUser();
			else onlyConfig.visible = true;
		}
		
		private function setUserConfig():void
		{
			configPop.addEventListener("okPressed", function(e:Event):void{
				userInfo.summonerName = configPop.user;
				userInfo.realm = configPop.realm;
				configPop.visible = false;
				populateUser();
			});
			
			configPop.addEventListener("cancelPressed", function(e:Event):void{
				configPop.visible = false;
				if(userInfo.summonerName) populateUser();
				else onlyConfig.visible = true;
			});
			
			onlyConfig.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				onlyConfig.visible = false;
				configPop.visible = true;
			});
			
			userContainer.configIcon.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				userContainer.visible = false;
				configPop.visible = true;
			});
			
			userContainer.searchUser.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				cleanStage();
				loadingState();
				Ssummoner.summonerName = userInfo.name;
				Ssummoner.realm = userInfo.realm.toLowerCase();
				lolApiRequest.search(Ssummoner.summonerName,Ssummoner.realm);
			});
		}
		
		private function populateUser():void
		{
			onlyConfig.visible = false;
			loadUser.visible = true;
			
			var getInfo:infoSearch = new infoSearch(api);
			getInfo.searchSummoner(userInfo.summonerName, userInfo.realm);
			getInfo.addEventListener("userInfoCompleta", function(e:Event){
				userInfo = getInfo.userInfo;
				userContainer.sumName.text = userInfo.name;
				userContainer.levelText.text = userInfo.realm+" | Level "+userInfo.summonerLevel;
				userContainer.profileIcon.source = "http://ddragon.leagueoflegends.com/cdn/"+lolApiRequest.serverInfo.lastVersion+"/img/profileicon/"+userInfo.profileIconId+".png";
				userContainer.profileIcon.load();
				userContainer.profileIcon.addEventListener(Event.COMPLETE, function(eIcon:Event){
					eIcon.target.content.smoothing = true;
					loadUser.visible = false;
					animateAlpha(userContainer,1,0,1,userContainer.x,userContainer.x);
				});
			});
			getInfo.addEventListener("userInfoError", function(e:Event){
				trace("Error recuperando informacion del invocador");
				loadUser.visible = false;
				userContainer.visible = false;
				onlyConfig.visible = true;
			});
		}
		
		private function stageOptions():void
		{
			//Obtener noticias
			var getAppInformation:infoSearch = new infoSearch(api);
			getAppInformation.getAppInfo();
			getAppInformation.addEventListener("appInfoCompleta", function(e:Event):void{
				appInfo = getAppInformation.appInfo;
				animateAlpha(alertBtn,1,0,1,alertBtn.x,alertBtn.x,function(){
					alertBtn.addEventListener(MouseEvent.CLICK, createAlert);
				});
			});
			//Seteos de Realm
			realmSearch.addEventListener("searchRealmCambiado", function(e:Event){
				Ssummoner.realm = realmSearch.realm;
				realmText.text = Ssummoner.realm.toUpperCase();
			});
			
			openRealmSearch.addEventListener(MouseEvent.CLICK, function(e:MouseEvent){
				if(realmSearch.visible) realmSearch.visible = false;
				else realmSearch.visible = true;
				setChildIndex(realmSearch, numChildren - 1);
			});
			
			//BG
			bgImage.gotoAndStop("jinx");
			
			//Placeholder de summoner, condicional carga de usuario, seteo de loading state
			setPlaceHolder(summonerNameSearch, "BUSCAR INVOCADOR");
		}
		
		private function readyState():void
		{
			_searchMatch.visible = true;
			loadingAnim.visible = false;
		}
		
		private function loadingState():void
		{
			_searchMatch.visible = false;
			loadingAnim.visible = true;
		}
		
		public function searchMatch(e:MouseEvent):void
		{
			cleanStage();
			loadingState();
			Ssummoner.summonerName = summonerNameSearch.text;
			lolApiRequest.search(Ssummoner.summonerName,Ssummoner.realm);
		}
		
		private function generateMatchStage(e:Event)
		{
			lolApiRequest.getTrace();
			generateTeamA();
			generateTeamB();
			generateMatchInfo();
		}
		
		private function generateTeamA():void
		{
			var itirator:int = 0;
			for each(var player in lolApiRequest.teamA.players){
				var slot:playerSlot = new playerSlot(player,lolApiRequest.serverInfo.lastVersion,lolApiRequest.champArray,Ssummoner.realm,appInfo.badges);
				var poser:int = lolApiRequest.gameConstants.slotPos[lolApiRequest.teamA.players.length];
				itirator++;
				slot.x = poser+(itirator*140)-140;
				slot.alpha = 0;
				slot.rotationX = 60;
				TweenMax.to(slot, 3, {autoAlpha:1, x:poser+(itirator*140), rotationX:0, ease:Back.easeOut});
				matchContainer.addChild(slot);
				playersLoaded++;
			}
			if(playersLoaded === lolApiRequest.matchInfo.participants.length) addToStage();
		}
		
		private function generateTeamB():void
		{
			var itirator:int = 0;
			for each(var player in lolApiRequest.teamB.players){
				var slot:playerSlot = new playerSlot(player,lolApiRequest.serverInfo.lastVersion,lolApiRequest.champArray,Ssummoner.realm,appInfo.badges);
				var poser:int = lolApiRequest.gameConstants.slotPos[lolApiRequest.teamB.players.length];
				itirator++;
				slot.x = poser+(itirator*140)-140;
				slot.y = 275;
				slot.alpha = 0;
				slot.rotationX = 60;
				TweenMax.to(slot, 3, {autoAlpha:1, x:poser+(itirator*140), rotationX:0, ease:Back.easeOut});
				matchContainer.addChild(slot);
				playersLoaded++;
			}
			
			if(playersLoaded === lolApiRequest.matchInfo.participants.length){
				slot.addEventListener("splashCargado", function(e:Event):void{
					TweenMax.delayedCall(1,addToStage);
				});
			}
		}
		
		private function generateMatchInfo():void
		{
			var barraMedio:midBar = new midBar(lolApiRequest);
			barraMedio.y = 198;
			
			animateAlpha(barraMedio,2,0,1,-90,-30);

			matchContainer.addChild(barraMedio);
		}
		
		private function addToStage():void
		{
			matchContainer.y = 97;
			animateAlpha(matchContainer,1,0,1,0,53);
			
			addChild(matchContainer);
			setChildIndex(matchContainer,stage.numChildren+1);
			
			realmSearch.visible = false;
			readyState();
		}
		
		private function createAlert(e:MouseEvent):void
		{
			alertBtn.visible = false;
			var _alert:Alert = new Alert(appInfo.informacion);
			_alert.addEventListener("alertOculto", function(e:Event):void{
				removeChild(_alert);
			});
			addChild(_alert);
		}
		
		private function cleanStage():void
		{
			stage.focus = null;
			playersLoaded = 0;
			
			while (matchContainer.numChildren > 0) {
				matchContainer.removeChildAt(0);
			}
			
			matchContainer = new MovieClip();
		}
			
		public static function setPlaceHolder(objeto:TextField, placeHolder:String):void
		{
			objeto.addEventListener( FocusEvent.FOCUS_IN,  function(e:FocusEvent){
				e.target.text = "";
			});
			objeto.addEventListener( FocusEvent.FOCUS_OUT, function(e:FocusEvent){
				if(e.target.text == "")e.target.text = placeHolder;
			});
		}
		
		private function animateAlpha(mc,duration:int,alphaInit:int,alphaAmmount:int,initX:int,xPos:int,completeFunction:Function = null):void
		{
			mc.alpha = alphaInit;
			mc.x = initX;
			TweenMax.to(mc,duration,{autoAlpha:alphaAmmount, x:xPos, onComplete:completeFunction});
		}
		
		private function errorHandler(e:Event):void
		{
			switch(e.type){
				case "matchError":
					trace("No se encontró una partida activa para el invocador solicitado.");
				break;
				case "summonerError":
					trace("No se encontró al invocador solicitado en este server.");
				break;
				case "champsError":
					trace("No se pudo cargar la información estatica necesaria, verifique su conexion a internet y reincie la aplicación.");
				break;
				case "versionError":
					trace("No se pudo cargar la información estatica necesaria de ddragon, verifique su conexion a internet y reincie la aplicación.");
				break;
				case "tiersError":
					trace("No se pudo cargar la información de liga necesaria, pruebe nuevamente.");
				break;
				case "constError":
					trace("No se pudo cargar la información de constantes necesaria, reinicie la aplicacion.");
				break;
				case "appInfoError":
					trace("No se pudo cargar la información de la aplicacion.");
				break;
			}
			readyState();
		}
	}
}

/*
PANTALLA DE INICIO
BADGES
*/