/*
 * Firebase Cloud Messaging (FCM) bridge for Android.
 *
 * Requests the Android 13+ notification permission and triggers an FCM
 * registration-token fetch. The actual token is printed to logcat by
 * org.haxe.lime.FCMMessagingService (tag: "FCM").
 */
package mobile.backend;

#if android
import lime.system.JNI;

class FCMManager #if (lime >= "8.0.0") implements JNISafety #end
{
	/**
	 * Requests the POST_NOTIFICATIONS runtime permission on Android 13+,
	 * then asks Firebase for the current registration token (logged to logcat).
	 */
	public static inline function init():Void
	{
		requestNotificationPermission();
		requestToken();
	}

	/**
	 * Android 13 (API 33) and above require the POST_NOTIFICATIONS permission
	 * to be granted at runtime before notifications can be displayed.
	 */
	public static inline function requestNotificationPermission():Void
	{
		if (AndroidVersion.SDK_INT >= AndroidVersionCode.TIRAMISU)
			AndroidPermissions.requestPermissions(['POST_NOTIFICATIONS']);
	}

	/**
	 * Asks Firebase for the registration token and prints it to logcat.
	 */
	public static inline function requestToken():Void
		requestToken_jni();

	@:noCompletion private static var requestToken_jni:Dynamic = JNI.createStaticMethod('org/haxe/lime/FCMMessagingService', 'requestToken', '()V');
}
#end
