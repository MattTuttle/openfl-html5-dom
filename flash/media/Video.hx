package flash.media;


import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.VideoElement;
import flash.net.NetStream;
import flash.Lib;
import js.html.CanvasElement;
import js.html.MediaElement;


class Video extends DisplayObject {


	public var deblocking:Int;
	public var smoothing:Bool;

	private var netStream:NetStream;
	private var renderHandler:Event->Void;
	private var videoElement(default, null):MediaElement;
	private var windowHack:Bool;

	private var __graphics:Graphics;


	public function new (width:Int = 320, height:Int = 240):Void {

		super ();

		/*
		 * todo: netstream/camera
		 * 			check compat with flash events
		 */

		__graphics = new Graphics ();
		__graphics.drawRect (0, 0, width, height);

		this.width = width;
		this.height = height;

		this.smoothing = false;
		this.deblocking = 0;

		//this.addEventListener(Event.ADDED_TO_STAGE, added);

	}


	/*private function added(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
	}*/


	/*public function attachCamera(camera:flash.net.Camera):Void;
	{
		// (html5 <device/>
		throw "not implemented";
	}*/


	public function attachNetStream (ns:NetStream):Void {

		this.netStream = ns;
		var scope:Video = this;

		if (ns != null) {

			__surface = ns.__videoElement;

			ns.__videoElement.style.setProperty ("width", width + "px", "");
			ns.__videoElement.style.setProperty ("height", height + "px", "");
			ns.__videoElement.addEventListener ("error", ns.__notFound, false);
			ns.__videoElement.addEventListener ("waiting", ns.__bufferEmpty, false);
			ns.__videoElement.addEventListener ("ended", ns.__bufferStop, false);
			ns.__videoElement.addEventListener ("play", ns.__bufferStart, false);
			ns.__videoElement.play ();

		}

	}


	public function clear():Void {

		if (__graphics != null) {

			Lib.__removeSurface (__graphics.__surface);

		}

		__graphics = new Graphics ();
		__graphics.drawRect (0, 0, width, height);

	}


	override public function __getObjectUnderPoint (point:Point):InteractiveObject {

		var local = globalToLocal (point);

		if (local.x >= 0 && local.y >= 0 && local.x <= width && local.y <= height) {

			// NOTE: bad cast, should be InteractiveObject...
			return cast this;

		} else {

			return null;

		}

	}


	override public function __render (inMask:CanvasElement = null, clipRect:Rectangle = null):Void {

		if (_matrixInvalid || _matrixChainInvalid) {

			__validateMatrix ();

		}

		var gfx = __getGraphics ();
		if (gfx != null) {

			Lib.__setSurfaceTransform (gfx.__surface, getSurfaceTransform (gfx));

		}

	}


	override public function toString ():String {

		return "[Video name=" + this.name + " id=" + ___id + "]";

	}


}