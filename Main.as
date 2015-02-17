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
	
	//Greensock
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	public class Main extends MovieClip {
		
		private var api:String = "79cec077-7792-4ac8-90cc-a43d5cff69a6";
		private var lolApiRequest:LOLInfoApi = new LOLInfoApi(api);
		private var matchContainer:MovieClip = new MovieClip();
		private var userInfo:Object = {summonerName: "sannt1", realm:"las"};
		private var playersLoaded:int = 0;
		public static var Ssummoner:Object = new Object();
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
				if(userInfo.summonerName) populateUser();
				else onlyConfig.visible = true;
				_searchMatch.addEventListener(MouseEvent.CLICK, searchMatch);
				lolApiRequest.addEventListener("matchCompleta", generateMatchStage);
			});
        }
		
		private function stageOptions():void
		{
			//Obtener noticias
			var getAppInformation:infoSearch = new infoSearch(api);
			getAppInformation.getAppInfo();
			getAppInformation.addEventListener("appInfoCompleta", function(e:Event):void{
				appInfo = getAppInformation.appInfo;
				animateAlpha(alertBtn,1,0,1,alertBtn.x,alertBtn.x,true);
				alertBtn.addEventListener(MouseEvent.CLICK, createAlert);
			});
			//Seteos de Realm
			realmSearch.addEventListener("realmCambiado", function(e:Event){
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
			setPlaceHolder(summonerNameSearch, "Buscar invocador");
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
					animateAlpha(userContainer,1,0,1,userContainer.x,userContainer.x,true);
				});
			});
			getInfo.addEventListener("userInfoError", function(e:Event){
				trace("Error recuperando informacion del invocador");
				loadUser.visible = false;
				onlyConfig.visible = true;
				userContainer.visible = false;
			});
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
				var slot:playerSlot = new playerSlot(player,lolApiRequest.serverInfo.lastVersion,lolApiRequest.champArray);
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
				var slot:playerSlot = new playerSlot(player,lolApiRequest.serverInfo.lastVersion,lolApiRequest.champArray);
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
			barraMedio.y = 197;
			
			animateAlpha(barraMedio,2,0,1,-90,-30,true);

			matchContainer.addChild(barraMedio);
		}
		
		private function addToStage():void
		{
			matchContainer.y = 97;
			animateAlpha(matchContainer,1,0,1,0,53,true);
			
			addChild(matchContainer);
			
			realmSearch.visible = false;
			readyState();
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
		
		private function setPlaceHolder(objeto:TextField, placeHolder:String):void
		{
			objeto.addEventListener( FocusEvent.FOCUS_IN,  function(e:FocusEvent){
				e.target.text = "";
			});
			objeto.addEventListener( FocusEvent.FOCUS_OUT, function(e:FocusEvent){
				if(e.target.text == "")e.target.text = placeHolder;
			});
		}
		
		private function createAlert(e:MouseEvent):void
		{
			e.target.visible = false;
			var alerta:Alert = new Alert(appInfo);
			addChild(alerta);
			alerta.cerrar.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				TweenMax.to(alerta,0.5,{autoAlpha:0,onComplete:function(){removeChild(alerta)}});
			});
		}
		
		private function animateAlpha(mc,duration:int,alphaInit:int,alphaAmmount:int,initX:int,xPos:int,visibility:Boolean):void
		{
			mc.visible = visibility;
			mc.alpha = alphaInit;
			mc.x = initX;
			TweenMax.to(mc,duration,{autoAlpha:alphaAmmount, x:xPos});
		}
	}
}

/*
MOSTRAR ERRORES EN VENTANA
MOSTRAR INFORMACION EN VENTANA
ARMAR VENTANA DE CONFIGURACION
MASTERIES Y RUNAS
ESPECTADOR
PANTALLA DE INICIO
~ MATCH HISTORY Y SUMMONER SEARCH
*/