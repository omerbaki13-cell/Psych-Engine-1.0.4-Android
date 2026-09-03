/*
 * Firebase Cloud Messaging (FCM) bridge for Android.
 *
 * Triggers an FCM registration-token fetch. The token is printed to logcat by
 * org.haxe.lime.FCMMessagingService (tag: "FCM").
 *
 * NOTE: The Android 13+ POST_NOTIFICATIONS runtime permission is requested in
 * StorageUtil.requestPermissions() together with the other Android permissions,
 * so the notification permission dialog appears only once at startup.
 */
package mobile.backend;

#if android
import lime.system.JNI;

class FCMManager #if (lime >= "8.0.0") implements JNISafety #end
{
	/**
	 * Asks Firebase for the current registration token (logged to logcat).
	 */
	public static inline function init():Void
	{
		requestToken();
	}

	/**
	 * Asks Firebase for the registration token and prints it to logcat.
	 */
	public static inline function requestToken():Void
		requestToken_jni();

	@:noCompletion private static var requestToken_jni:Dynamic = JNI.createStaticMethod('org/haxe/lime/FCMMessagingService', 'requestToken', '()V');
}
#end
