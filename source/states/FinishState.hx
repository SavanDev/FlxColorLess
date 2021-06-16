package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.system.System;
import misc.FadeBoy;
import misc.Input;

class FinishState extends BaseState
{
	var texts:Array<String> = [
		"Game made by SavanDev",
		"Created in HaxeFlixel",
		"Music made by\nJoshua McLean",
		"This game was made for\n#MejorandoAndo of May\n\nin 1 week and a half",
		"Thanks for playing!\n\nPress ESCAPE to exit the game"
	];
	var actualText:Int = 0;

	override public function create()
	{
		super.create();
		FlxG.camera.pixelPerfectRender = Game.PIXEL_PERFECT;

		var finishText = new FlxText(0, 0, 150, texts[actualText]);
		finishText.alignment = CENTER;
		finishText.screenCenter();
		add(finishText);

		var fade = new FadeBoy(false);
		add(fade);

		new FlxTimer().start(3, (_) -> fade.fadeOut(FlxColor.BLACK));

		fade.setCallbackIn(() ->
		{
			if (actualText < texts.length - 1)
				new FlxTimer().start(3, (_) -> fade.fadeOut(FlxColor.BLACK));
		});
		fade.setCallbackOut(() ->
		{
			actualText++;
			finishText.text = texts[actualText];
			finishText.screenCenter();
			fade.fadeIn();
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		Input.update();

		if (Input.BACK || Input.BACK_ALT)
			System.exit(0);
	}
}
