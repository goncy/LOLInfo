﻿package classes {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.greensock.TweenMax;
	
	
	public class bannedChamp extends MovieClip {
		
		
		public function bannedChamp(champ:String,version:String) {
			champPhoto.source = "http://ddragon.leagueoflegends.com/cdn/"+version+"/img/champion/"+champ+".png";
			champPhoto.addEventListener(Event.COMPLETE, function(e:Event){
				e.target.content.smoothing = true;
				e.target.alpha = 0;
				TweenMax.to(e.target,1,{autoAlpha:1});
			});
		}
	}
	
}
