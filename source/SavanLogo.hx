import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import misc.FadeBoy;
import misc.Paths;

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

		var logoText = new FlxText(0, 0, "SavanDev");
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
