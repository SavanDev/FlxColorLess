import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxBitmapText;
import flixel.util.FlxTimer;

class SavanLogo extends FlxState
{
	var fade:FadeBoy;

	override public function create()
	{
		super.create();
		FlxG.camera.zoom = 2;

		var logo = new FlxSprite();
		logo.loadGraphic(Paths.getImage("SDPixel"));
		logo.screenCenter();
		logo.y -= 5;
		add(logo);

		var logoText = new FlxBitmapText(Fonts.PF_ARMA_FIVE_16);
		logoText.text = "SavanDev";
		logoText.screenCenter();
		logoText.y += 20;
		add(logoText);

		fade = new FadeBoy();
		add(fade);

		new FlxTimer().start(3, (_) -> fade.fadeOut());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!fade.hasFadeOut)
			FlxG.switchState(new states.CutsceneState());
	}
}
