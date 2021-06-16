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
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.system.System;
import misc.FadeBoy;
import misc.Input;
import misc.Paths;
import objects.Player;

class CutsceneState extends BaseState
{
	var playerCutscene:FlxSprite;

	var walls:FlxTilemap;

	var screenEffect:FlxSprite;

	var uiText:FlxText;
	var glitchTimer:FlxTimer;

	var startGame:Bool = false;
	var cutState:Int = 1;

	override public function create()
	{
		super.create();
		FlxG.camera.pixelPerfectRender = Game.PIXEL_PERFECT;

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
		add(playerCutscene);

		map.loadEntities((_entity:EntityData) ->
		{
			switch (_entity.name)
			{
				case "FinishEvent":
					playerCutscene.setPosition(_entity.x, _entity.y);
			}
		}, "Entities");

		screenEffect = new FlxSprite().makeGraphic(FlxG.width, 12 * 11, FlxColor.TRANSPARENT);
		var glitchEffect = new FlxGlitchEffect(4);
		var glitchSprite = new FlxEffectSprite(screenEffect, [glitchEffect]);
		glitchSprite.visible = false;
		add(glitchSprite);

		var screen = new FlxSprite(0, 0, Paths.getImage("screen"));
		screen.alpha = .25;
		add(screen);

		var uiBorder = new FlxSprite(0, Game.getGameHeight());
		uiBorder.makeGraphic(FlxG.width, FlxG.height - Std.int(uiBorder.y), FlxColor.BLACK);
		add(uiBorder);

		uiText = new FlxText(5, Game.getGameHeight() + 5, FlxG.width - 10, "Press ENTER to start!");
		uiText.alignment = CENTER;
		add(uiText);

		glitchTimer = new FlxTimer().start(4, (_) ->
		{
			new FlxTimer().start(.5, (_) ->
			{
				screenEffect.drawFrame(true);
				var screenPixels = screenEffect.framePixels;
				screenPixels.draw(FlxG.camera.canvas);
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
		Input.update();

		if ((Input.SELECT || Input.SELECT_ALT) && !startGame)
		{
			new FlxTimer().start(.2, (_) ->
			{
				if (uiText.alpha > 0)
					uiText.alpha -= .1;
				else
					_.cancel();
			}, 0);
			// FlxG.sound.play(Paths.getSound("Select"));
			glitchTimer.cancel();
			playerCutscene.animation.play("state1");
			startGame = true;
		}

		if (playerCutscene.alive && !playerCutscene.isOnScreen())
		{
			playerCutscene.kill();
			FlxG.switchState(new states.PlayState());
		}

		if (Input.BACK || Input.BACK_ALT)
			System.exit(0);
	}
}
