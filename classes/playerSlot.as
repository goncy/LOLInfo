package  classes{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.greensock.TweenMax;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.hybrid.ui.ToolTip;
	import flash.text.TextFormat;
	import flash.display.DisplayObject;
	
	public class playerSlot extends MovieClip {
		
		private var redirecter;
		
		public function playerSlot(player:Object,version:String,champArray:Object,realm:String,badges:Object) {
			setTooltip();
			redirecter = new redirectBox(champArray[player.championId],player,realm);
			division.gotoAndStop(player.tier);
			tierLogo.gotoAndStop(player.tier);
			spell1.gotoAndStop(String(player.spell1));
			spell2.gotoAndStop(String(player.spell2));
			if(badges[player.summonerId]){
				badge.visible = true;
				badge.setTexto(badges[player.summonerId].razon.toUpperCase());
				badge.gotoAndStop(badges[player.summonerId].badgeName);
			}
			summonerName.text = player.summonerName;
			div.text = player.division;
			playerGs.text = player.gScore+" GS";
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
			});
			
			goLk.addEventListener(MouseEvent.CLICK,function(lk:MouseEvent):void{
				redirecter.cerrar.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
					parent.parent.removeChild(redirecter);
				});
				parent.parent.addChild(redirecter);
			});
		}
		
		private function setTooltip():void
		{

		}
	}
}