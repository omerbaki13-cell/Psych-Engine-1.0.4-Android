package org.haxe.lime;

import android.util.Log;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

/**
 * Firebase Cloud Messaging (FCM) service.
 *
 * Handles incoming push notifications and prints the FCM registration token
 * to logcat whenever it is created or refreshed.
 */
public class FCMMessagingService extends FirebaseMessagingService
{
	private static final String TAG = "FCM";

	/**
	 * Called whenever a new (or refreshed) FCM registration token is available.
	 * The token is printed to logcat so it can be read with:
	 *     adb logcat -s FCM
	 */
	@Override
	public void onNewToken(String token)
	{
		super.onNewToken(token);
		Log.d(TAG, "FCM registration token: " + token);
	}

	/**
	 * Called when a data message is received while the app is in the foreground.
	 */
	@Override
	public void onMessageReceived(RemoteMessage message)
	{
		super.onMessageReceived(message);

		Log.d(TAG, "FCM message received from: " + message.getFrom());

		if (message.getNotification() != null)
		{
			Log.d(TAG, "FCM notification title: " + message.getNotification().getTitle());
			Log.d(TAG, "FCM notification body: " + message.getNotification().getBody());
		}

		if (message.getData().size() > 0)
		{
			Log.d(TAG, "FCM data payload: " + message.getData());
		}
	}

	/**
	 * Explicitly requests the current FCM registration token and logs it.
	 * Can be called from Haxe via JNI (see mobile.backend.FCMManager).
	 */
	public static void requestToken()
	{
		FirebaseMessaging.getInstance().getToken()
			.addOnCompleteListener(task ->
			{
				if (!task.isSuccessful())
				{
					Log.w(TAG, "Fetching FCM registration token failed", task.getException());
					return;
				}

				String token = task.getResult();
				Log.d(TAG, "FCM registration token: " + token);
			});
	}
}
