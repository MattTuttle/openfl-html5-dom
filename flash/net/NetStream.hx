package flash.net;


//import haxe.remoting.Connection;
import flash.utils.UInt;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.NetStatusEvent;
import flash.media.VideoElement;
import flash.Lib;
import haxe.Timer;
import js.html.MediaElement;
import js.Browser;


class NetStream extends EventDispatcher {


	public static inline var BUFFER_UPDATED:String = "flash.net.NetStream.updated";
	public static inline var CODE_PLAY_STREAMNOTFOUND:String = "NetStream.Play.StreamNotFound";
	public static inline var CODE_BUFFER_EMPTY:String = "NetStream.Buffer.Empty";
	public static inline var CODE_BUFFER_FULL:String = "NetStream.Buffer.Full";
	public static inline var CODE_BUFFER_FLUSH:String = "NetStream.Buffer.Flush";
	public static inline var CODE_BUFFER_START:String = "NetStream.Play.Start";
	public static inline var CODE_BUFFER_STOP:String = "NetStream.Play.Stop";

	/*
	 * todo:
	var audioCodec(default,null) : UInt;
	var bufferLength(default,null) : Float;
	var bufferTime :s Float;
	var checkPolicyFile : Bool;
	var client : Dynamic;
	var currentFPS(default,null) : Float;
	var decodedFrames(default,null) : UInt;
	var liveDelay(default,null) : Float;
	var objectEncoding(default,null) : UInt;
	var videoCodec(default,null) : UInt;
	*/

	public var bytesLoaded(get, never) : Float;
	public var bytesTotal(get, never) : Float;
	public var time(get, never) : Float;
	public var soundTransform : flash.media.SoundTransform;
	public var bufferTime:Float;
	public var client:Dynamic;
	public var play:Dynamic;

	public var __videoElement(default, null):MediaElement;

	private static inline var fps:Int = 30;

	private var timer:Timer;

	private var __connection:NetConnection;


	public function new (connection:NetConnection):Void {

		super ();

		__videoElement = cast Browser.document.createElement ("video");
		__connection = connection;

		play = Reflect.makeVarArgs (__play);

	}


	private function __play (val:Array<Dynamic>):Void {

		var url = Std.string (val[0]);
		__videoElement.src = url;

	}

	private function get_bytesLoaded ():Float {

		return __videoElement.buffered.end(0);

	}

	private function get_bytesTotal ():Float {

		return __videoElement.duration;

	}

	private function get_time ():Float {

		return __videoElement.currentTime;

	}




	// Event Handlers




	public function __bufferEmpty (e) {

		__connection.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, false, { code : CODE_BUFFER_EMPTY } ));

	}


	public function __bufferStop (e) {

		__connection.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, false, { code : CODE_BUFFER_STOP } ));

	}


	public function __bufferStart(e) {

		__connection.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, false, { code : CODE_BUFFER_START } ));

	}


	public function __notFound(e) {

		__connection.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, false, { code : CODE_PLAY_STREAMNOTFOUND } ));

	}

	public function close() : Void {

		__videoElement.pause();
		__videoElement = null;
		__connection.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, false, { code : CODE_BUFFER_STOP } ));

	}

	public function pause() : Void {

		__videoElement.pause();

	}

	public function resume() : Void {

		__videoElement.play();

	}

	public function seek(offset : Float) : Void {

		__videoElement.currentTime = offset;

	}

	public function togglePause() : Void {

		if (__videoElement.paused) {

			play();

		} else {

			pause();

		}

	}


	/*
	todo:
	public function attachAudio(microphone : flash.media.Microphone);
	public function attachCamera(theCamera : flash.media.Camera, ?snapshotMilliseconds : Int);
	public function publish(?name : String, ?type : String) : Void;
	public function receiveVideoFPS(FPS : Float) : Void;
	public function send(handlerName : String, ?p1 : Dynamic, ?p2 : Dynamic, ?p3 : Dynamic, ?p4 : Dynamic, ?p5 : Dynamic ) : Void;

	#if flash10
	var maxPauseBufferTime : Float;
	var farID(default,null) : String;
	var farNonce(default,null) : String;
	var info(default,null) : NetStreamInfo;
	var nearNonce(default,null) : String;
	var peerStreams(default,null) : Array<Dynamic>;

	function onPeerConnect( subscriber : NetStream ) : Bool;
	function play2( param : NetStreamPlayOptions ) : Void;

	static var DIRECT_CONNECTIONS : String;
	#end
	*/


}