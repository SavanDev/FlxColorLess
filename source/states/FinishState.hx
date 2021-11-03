package states;

import flixel.FlxCamera;
import flixel.FlxG;
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
		"Thanks for playing!\nSee you next time ;)"
	];
	var actualText:Int = 0;

	override public function create()
	{
		super.create();
		var gameCamera = new FlxCamera(Game.GAME_X, 0, Game.getGameWidth(), Game.getGameHeight());
		FlxG.cameras.reset(gameCamera);

		var uiCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		uiCamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(uiCamera, false);

		var finishText = new FlxText(0, 0, 150, texts[actualText]);
		finishText.alignment = CENTER;
		finishText.cameras = [uiCamera];
		finishText.screenCenter();
		add(finishText);

		var fade = new FadeBoy(false);
		add(fade);

		new FlxTimer().start(3, (_) -> fade.fadeOut(FlxColor.BLACK));

		fade.setCallbackIn(() ->
		{
			if (actualText < texts.length - 1)
				new FlxTimer().start(3, (_) -> fade.fadeOut(FlxColor.BLACK));
			else
				new FlxTimer().start(3, (_) -> System.exit(0));
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
