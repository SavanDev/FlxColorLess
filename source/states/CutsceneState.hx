package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.geom.Matrix;

class CutsceneState extends FlxState
{
	var playerCutscene:FlxSprite;
	var walls:FlxTilemap;

	var fade:FadeBoy;
	var screenEffect:FlxSprite;

	var uiText:FlxText;
	var glitchTimer:FlxTimer;

	var startGame:Bool = false;
	var cutState:Int = 1;

	override public function create()
	{
		super.create();
		Input.init();
		bgColor = 0xff0163c6;
		FlxG.timeScale = 1.03;

		var map = new FlxOgmo3Loader(Paths.getOgmoData(), 'assets/data/levels/level0.json');

		var backWalls = map.loadTilemap(Paths.getImage("environment"), "Environment");
		add(backWalls);

		walls = map.loadTilemap(Paths.getImage("tileMap"), "Default");
		walls.setTileProperties(0, FlxObject.NONE);
		walls.setTileProperties(1, FlxObject.ANY);
		add(walls);

		playerCutscene = new FlxSprite();
		playerCutscene.loadGraphic(Paths.getImage("anim_001"), true, 12, 24);
		playerCutscene.animation.add("state1", [0, 1, 2], .5, false);
		playerCutscene.animation.add("state2", [4, 5], 1, false);
		playerCutscene.animation.add("state3", [6, 7], 3, false);
		playerCutscene.animation.add("state4", [9, 10, 9, 11], 5);
		playerCutscene.animation.finishCallback = cutsceneCallback;
		playerCutscene.screenCenter(X);
		playerCutscene.y = 12 * 8;
		add(playerCutscene);

		var screen = new FlxSprite(0, 0, Paths.getImage("screen"));
		screen.alpha = .25;
		add(screen);

		fade = new FadeBoy();
		add(fade);

		var uiBorder = new FlxSprite(0, 132);
		uiBorder.makeGraphic(FlxG.width, FlxG.height - Std.int(uiBorder.y), FlxColor.BLACK);
		add(uiBorder);

		uiText = new FlxText(5, 132 + 5, FlxG.width - 10, "Welcome to ColorLess!");
		uiText.alignment = CENTER;
		add(uiText);

		screenEffect = new FlxSprite().makeGraphic(FlxG.width, 12 * 11, FlxColor.TRANSPARENT);
		var glitchEffect = new FlxGlitchEffect(4);
		var glitchSprite = new FlxEffectSprite(screenEffect, [glitchEffect]);
		glitchSprite.setColorTransform(1, 0, 0, 1);
		glitchSprite.visible = false;
		add(glitchSprite);

		glitchTimer = new FlxTimer().start(5, (_) ->
		{
			new FlxTimer().start(.5, (_) ->
			{
				screenEffect.drawFrame();
				var screenPixels = screenEffect.framePixels;
				screenPixels.draw(FlxG.camera.canvas, new Matrix(1, 0, 0, 1, 0, 0));
				glitchSprite.visible = !glitchSprite.visible;
			}, 2);
		}, 0);
	}

	function cutsceneCallback(name:String)
	{
		switch (cutState)
		{
			case 1 | 2:
				new FlxTimer().start(1, (_) ->
				{
					cutState++;
					playerCutscene.animation.play('state$cutState');
				});
			case 3:
				new FlxTimer().start(1, (_) ->
				{
					cutState++;
					playerCutscene.animation.play('state$cutState');
					playerCutscene.velocity.x = Player.SPEED;
				});
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && !startGame)
		{
			FlxTween.num(1, 0, (v:Float) -> uiText.alpha = v);
			glitchTimer.cancel();
			playerCutscene.animation.play("state1");
			startGame = true;
		}

		if (playerCutscene.alive && !playerCutscene.isOnScreen())
		{
			fade.fadeOut();
			playerCutscene.kill();
		}

		if (!playerCutscene.alive && !fade.hasFadeOut)
			FlxG.switchState(new states.PlayState());
	}
}
