package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.system.System;
import misc.Input;
import misc.Paths;
import misc.ScanLines;
import objects.Player;

class MenuState extends BaseState
{
	var playerCutscene:FlxSprite;

	var walls:FlxTilemap;

	var screenEffect:FlxSprite;

	var uiText:FlxText;
	var uiName:FlxText;
	var glitchTimer:FlxTimer;

	var startGame:Bool = false;
	var cutState:Int = 1;

	override public function create()
	{
		super.create();

		var gameCamera = new FlxCamera(Game.GAME_X, 0, Game.getGameWidth(), Game.getGameHeight());
		gameCamera.pixelPerfectRender = Game.PIXEL_PERFECT;
		gameCamera.bgColor = 0xff0163c6;
		FlxG.cameras.reset(gameCamera);

		var hudCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		hudCamera.pixelPerfectRender = Game.PIXEL_PERFECT;
		hudCamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(hudCamera, false);

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

		uiName = new FlxText(0, 30, "COLORLESS", 16);
		// uiName.cameras = [hudCamera];
		uiName.screenCenter(X);
		uiName.x -= gameCamera.x;
		add(uiName);

		var screen = new ScanLines();
		screen.cameras = [hudCamera];
		add(screen);

		var startTitle:String;
		#if mobile
		startTitle = "Touch to start!";
		#else
		startTitle = "Press ENTER to start!";
		#end

		uiText = new FlxText(5, Game.getGameHeight() + 5, FlxG.width - 10, startTitle);
		uiText.cameras = [hudCamera];
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

		persistentDraw = persistentUpdate = true;

		if (Input.SELECT || Input.SELECT_ALT)
		{
			if (!startGame)
			{
				new FlxTimer().start(.2, (_) ->
				{
					if (uiText.alpha > 0)
					{
						uiText.alpha -= .1;
						uiName.alpha = uiText.alpha;
					}
					else
						_.cancel();
				}, 0);
				// FlxG.sound.play(Paths.getSound("Select"));
				glitchTimer.cancel();
				playerCutscene.animation.play("state1");
				startGame = true;
			}
			else
				FlxG.switchState(new states.PlayState());
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
