package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxUIInputText;

class AdminSubState extends FlxSubState
{
	var bg:FlxSprite;
	var titleText:FlxText;
	var inputMessage:FlxUIInputText;

	override function create()
	{
		super.create();

		// Arka planı yarı saydam siyah yapalım
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.8;
		add(bg);

		// Başlık
		titleText = new FlxText(0, 40, FlxG.width, "ADMIN PANEL", 32);
		titleText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		add(titleText);

		// 1. Duyuru Yazı Kutusu (Mobilde klavye açılmasını sağlar)
		inputMessage = new FlxUIInputText(FlxG.width / 2 - 150, 150, 300, "Duyuru yaz...", 20);
		add(inputMessage);

		// 2. Duyuruyu Gönder Butonu
		var btnAnnounce = new FlxButton(FlxG.width / 2 - 100, 210, "Duyuru Gonder", function() {
			var duyuruMetni = inputMessage.text;
			
			if (PlayState.instance != null) {
				PlayState.instance.showGlobalAnnouncement(duyuruMetni);
			}
			
			close();
		});
		btnAnnounce.scale.set(1.5, 1.5);
		add(btnAnnounce);

		// 3. Şarkıyı Bitir Butonu
		var btnWin = new FlxButton(FlxG.width / 2 - 100, 290, "Sarkiyi Bitir (Win)", function() {
			if (PlayState.instance != null) {
				PlayState.instance.finishSong();
				close();
			}
		});
		btnWin.scale.set(1.5, 1.5);
		add(btnWin);

		// 4. Paneli Kapat Butonu
		var btnClose = new FlxButton(FlxG.width / 2 - 100, 370, "Kapat", function() {
			close();
		});
		btnClose.scale.set(1.5, 1.5);
		add(btnClose);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Android'in geri tuşuna basıldığında paneli kapat
		if (FlxG.android.justReleased.BACK || FlxG.keys.justPressed.ESCAPE)
		{
			close();
		}
	}
}

