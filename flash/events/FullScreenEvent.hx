package flash.events;


import flash.display.InteractiveObject;


class FullScreenEvent extends Event {


	public static var FULL_SCREEN = "fullScreen";
	public static var FULL_SCREEN_INTERACTIVE_ACCEPTED = "fullScreenInteractiveAccepted";

	public var fullScreen:Bool;
	public var interactive:Bool;


	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, inFullScreen:Bool = false, inInteractive:Bool = false) {

		super (type, bubbles, cancelable);

		fullScreen = inFullScreen;
		interactive = inInteractive;

	}


}