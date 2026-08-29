package states;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxObject;
import backend.ui.PsychUIInputText;
import openfl.events.Event;
import haxe.Http;
import haxe.Json;
import states.TitleState;

class LoginState extends MusicBeatState
{
	public static var loggedInUsername:String = "";

	static final SERVER_URL:String = "https://psych-admin-server.onrender.com";

	var usernameInput:PsychUIInputText;
	var passwordInput:PsychUIInputText;
	var statusText:FlxText;
	var titleText:FlxText;
	var actionButton:FlxText;
	var switchModeText:FlxText;
	var skipText:FlxText;

	var isRegisterMode:Bool = false;
	var isBusy:Bool = false;

	var loginSave:flixel.util.FlxSave;

	override public function create():Void
	{
		FlxG.mouse.visible = true;

		loginSave = new flixel.util.FlxSave();
		loginSave.bind("psychLogin", CoolUtil.getSavePath());

		if (loginSave.data.username != null && loginSave.data.username != "")
		{
			loggedInUsername = loginSave.data.username;
			MusicBeatState.switchState(new TitleState());
			return;
		}

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		titleText = new FlxText(0, 60, FlxG.width, "GIRIS YAPIN");
		titleText.setFormat(null, 32, FlxColor.WHITE, CENTER);
		add(titleText);

		var userLabel:FlxText = new FlxText(FlxG.width / 2 - 200, 150, 400, "KULLANICI ADI");
		userLabel.setFormat(null, 16, FlxColor.WHITE, CENTER);
		add(userLabel);

		usernameInput = new PsychUIInputText(FlxG.width / 2 - 200, 180, 400, "", 16);
		add(usernameInput);

		var passLabel:FlxText = new FlxText(FlxG.width / 2 - 200, 230, 400, "SIFRE");
		passLabel.setFormat(null, 16, FlxColor.WHITE, CENTER);
		add(passLabel);

		passwordInput = new PsychUIInputText(FlxG.width / 2 - 200, 260, 400, "", 16);
		passwordInput.passwordMask = true;
		add(passwordInput);

		actionButton = new FlxText(FlxG.width / 2 - 200, 330, 400, "GIRIS YAP");
		actionButton.setFormat(null, 20, FlxColor.LIME, CENTER);
		actionButton.borderStyle = OUTLINE, FlxColor.BLACK, 2;
		add(actionButton);

		switchModeText = new FlxText(FlxG.width / 2 - 200, 390, 400, "Hesabin yok mu? Kayit ol");
		switchModeText.setFormat(null, 16, FlxColor.CYAN, CENTER);
		add(switchModeText);

		statusText = new FlxText(FlxG.width / 2 - 200, 430, 400, "");
		statusText.setFormat(null, 14, FlxColor.RED, CENTER);
		add(statusText);

		skipText = new FlxText(FlxG.width / 2 - 200, 470, 400, "Atla");
		skipText.setFormat(null, 14, FlxColor.GRAY, CENTER);
		add(skipText);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(actionButton) && !isBusy)
			{
				if (isRegisterMode) doRegister(); else doLogin();
			}
			else if (FlxG.mouse.overlaps(switchModeText) && !isBusy)
			{
				isRegisterMode = !isRegisterMode;
				actionButton.text = isRegisterMode ? "KAYIT OL" : "GIRIS YAP";
				switchModeText.text = isRegisterMode ? "Zaten hesabin var mi? Giris yap" : "Hesabin yok mu? Kayit ol";
				statusText.text = "";
			}
			else if (FlxG.mouse.overlaps(skipText) && !isBusy)
			{
				loggedInUsername = "Misafir";
				MusicBeatState.switchState(new TitleState());
			}
		}
	}

	function doLogin():Void
	{
		var username:String = usernameInput.text;
		var password:String = passwordInput.text;

		if (username == null || username.length == 0 || password == null || password.length == 0)
		{
			statusText.text = "Kullanici adi ve sifre gir!";
			return;
		}

		isBusy = true;
		statusText.color = FlxColor.WHITE;
		statusText.text = "Baglaniliyor...";

		var http:Http = new Http(SERVER_URL + "/login");
		http.setHeader("Content-Type", "application/json");
		http.setPostData(Json.stringify({username: username, password: password}));

		http.onData = function(data:String):Void
		{
			isBusy = false;
			try
			{
				var res:Dynamic = Json.parse(data);
				if (res.ok == true)
				{
					loggedInUsername = res.username;
					loginSave.data.username = res.username;
					loginSave.flush();
					MusicBeatState.switchState(new TitleState());
				}
				else
				{
					statusText.color = FlxColor.RED;
					statusText.text = "Giris basarisiz!";
				}
			}
			catch (e:Dynamic)
			{
				statusText.color = FlxColor.RED;
				statusText.text = "Sunucu hatasi!";
			}
		};

		http.onError = function(err:String):Void
		{
			isBusy = false;
			statusText.color = FlxColor.RED;
			statusText.text = "Kullanici adi veya sifre yanlis!";
		};

		http.request(true);
	}

	function doRegister():Void
	{
		var username:String = usernameInput.text;
		var password:String = passwordInput.text;

		if (username == null || username.length == 0 || password == null || password.length == 0)
		{
			statusText.text = "Kullanici adi ve sifre gir!";
			return;
		}

		if (username.indexOf(" ") != -1)
		{
			statusText.text = "Kullanici adinda bosluk olamaz!";
			return;
		}

		isBusy = true;
		statusText.color = FlxColor.WHITE;
		statusText.text = "Kayit olunuyor...";

		var http:Http = new Http(SERVER_URL + "/register");
		http.setHeader("Content-Type", "application/json");
		http.setPostData(Json.stringify({username: username, password: password}));

		http.onData = function(data:String):Void
		{
			isBusy = false;
			try
			{
				var res:Dynamic = Json.parse(data);
				if (res.ok == true)
				{
					loggedInUsername = username;
					loginSave.data.username = username;
					loginSave.flush();
					MusicBeatState.switchState(new TitleState());
				}
				else
				{
					statusText.color = FlxColor.RED;
					statusText.text = "Kayit basarisiz!";
				}
			}
			catch (e:Dynamic)
			{
				statusText.color = FlxColor.RED;
				statusText.text = "Sunucu hatasi!";
			}
		};

		http.onError = function(err:String):Void
		{
			isBusy = false;
			statusText.color = FlxColor.RED;
			statusText.text = "Bu kullanici adi zaten alinmis!";
		};

		http.request(true);
	}
}
