package classes{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	
	public class realmDrop extends MovieClip {
		
		private var realm:String;
		
		public function realmDrop() {
			this.visible = false;
			
			br.addEventListener(MouseEvent.CLICK, setRealm);
			eune.addEventListener(MouseEvent.CLICK, setRealm);
			euw.addEventListener(MouseEvent.CLICK, setRealm);
			kr.addEventListener(MouseEvent.CLICK, setRealm);
			lan.addEventListener(MouseEvent.CLICK, setRealm);
			las.addEventListener(MouseEvent.CLICK, setRealm);
			na.addEventListener(MouseEvent.CLICK, setRealm);
			oce.addEventListener(MouseEvent.CLICK, setRealm);
			ru.addEventListener(MouseEvent.CLICK, setRealm);
			tr.addEventListener(MouseEvent.CLICK, setRealm);
		}
				
		private function setRealm(e:MouseEvent):void
		{
			Main.Ssummoner.realm = e.target.name;
			realm = e.target.name;
			this.visible = false;
			dispatchEvent(new Event("realmCambiado"));
		}
	}
}
