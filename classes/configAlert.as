package classes {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class configAlert extends MovieClip {
		
		public var user:String;
		public var realm:String;
		
		public function configAlert() {
			Main.setPlaceHolder(_user, "NOMBRE DE INVOCADOR");
			Main.setPlaceHolder(_realm, "SERVER");
			
			accept.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				user = _user.text;
				realm = _realm.text;
				dispatchEvent(new Event("okPressed"));
			});
			
			cancel.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
				dispatchEvent(new Event("cancelPressed"));
			});
			
			prevB.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				bgChanger.changeBgPrev();
			});
			
			nextB.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				bgChanger.changeBgNext();
			});
		}
	}
	
}
