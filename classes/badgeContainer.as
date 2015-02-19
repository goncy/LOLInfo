package classes {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class badgeContainer extends MovieClip {
		
		private var textoBadge:String = "";
		
		public function badgeContainer() {
			
			gBtn.addEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):void{
				_container.texto.text = textoBadge;
				_container.visible = true;
			});
			
			gBtn.addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):void{
				_container.visible = false;
			});
		}
		
		public function setTexto(texto):void
		{
			textoBadge = texto;
		}
	}
	
}
