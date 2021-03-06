package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.tile.FlxTilemapExt;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.system.System;
import misc.Input;
import misc.Paths;
import misc.ScanLines;
import objects.Artefact;
import objects.Bullet;
import objects.Heart;
import objects.Player;
import objects.Spike;
import openfl.Lib;

class PlayState extends BaseState
{
	static var LEVEL:Int = 1;
	public static var POINTS:Int = 0;
	public static var BSIDE:Bool = false;

	var player:Player;
	var heart:Heart;
	var spikes:FlxTypedGroup<Spike>;
	var artefact:Artefact;
	var finishPlayer:FlxSprite;
	var walls:FlxTilemapExt;
	var fakeWalls:FlxTilemapExt;
	var gun:FlxSprite;
	var bullet:Bullet;
	var hasGun:Void->Void;
	var messages:Message;

	var finish:Bool = false;
	var respawn:Bool = false;
	var levelText:Array<String> = [
		"Welcome! :)",
		"Hi!",
		"Jumps!",
		"Danger!",
		"The Cave!",
		"Let's go!",
		"...",
		"What?"
	];
	var bSideText:Array<String> = [
		"It's your fault",
		"Give up",
		"You can't do it",
		"Hopeless",
		"Colorless",
		"Why you are here?",
		"...?"
	];

	var trueEndingText:Array<String> = [
		"You can do it!",
		"Keep going!",
		"We are with you!",
		"Don't listen to him!",
		"Beat him!"
	];

	var initPos:FlxPoint;
	var uiStrawCount:FlxText;

	function placeEntities(entity:EntityData)
	{
		if (!BSIDE)
		{
			switch (entity.name)
			{
				case "Player":
					player.setPosition(entity.x, entity.y);
					initPos.set(entity.x, entity.y);
				case "Strawberry":
					heart = new Heart(entity.x, entity.y);
					FlxTween.num(entity.y, entity.y + 3, .5, {type: PINGPONG}, (v:Float) -> heart.y = v);
					add(heart);
				case "Spike":
					spikes.add(new Spike(entity.x + 1, entity.y - 6));
				case "Artefact":
					artefact = new Artefact(entity.x, entity.y);
					add(artefact);
			}
		}
		else
		{
			switch (entity.name)
			{
				case "BPlayer":
					player.setPosition(entity.x, entity.y);
					initPos.set(entity.x, entity.y);
				case "FinishEvent":
					finishPlayer = new FlxSprite(entity.x, entity.y).loadGraphic(Paths.getImage("Bplayer", true), true, 12, 24);
					finishPlayer.animation.frameIndex = 11;
					add(finishPlayer);
				case "Gun":
					if (POINTS >= 6)
					{
						gun = new FlxSprite(entity.x, entity.y, Paths.getImage("BGun", true));
						FlxTween.num(entity.y, entity.y + 3, .5, {type: PINGPONG}, (v:Float) -> gun.y = v);
						add(gun);
					}
			}
		}
	}

	override public function create()
	{
		super.create();

		if (LEVEL < 0 || LEVEL > 7)
			LEVEL = 7;

		FlxG.camera.pixelPerfectRender = Game.PIXEL_PERFECT;
		bgColor = !BSIDE ? 0xff0163c6 : FlxColor.BLACK;

		persistentDraw = persistentUpdate = true;

		var glitchedEffect = new FlxGlitchEffect(2);
		var uiCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		uiCamera.bgColor = FlxColor.TRANSPARENT;
		uiCamera.pixelPerfectRender = Game.PIXEL_PERFECT;

		var map = new FlxOgmo3Loader(Paths.getOgmoData(), 'assets/data/levels/level$LEVEL.json');
		initPos = new FlxPoint();

		if (!BSIDE)
		{
			var backWalls = map.loadTilemap(Paths.getImage("environment"), "Environment");
			add(backWalls);
		}

		walls = map.loadTilemapExt(Paths.getImage(!BSIDE ? "tileMap" : "BtileMap", BSIDE ? true : false), "Default");
		walls.setTileProperties(0, FlxObject.NONE);
		walls.setTileProperties(1, FlxObject.ANY);
		add(walls);

		var tutoLayer = map.loadTilemap(Paths.getImage("tuto", true), "TutoLayer");
		FlxTween.num(tutoLayer.y, tutoLayer.y + 3, 1, {type: PINGPONG}, (v:Float) -> tutoLayer.y = v);
		if (!BSIDE)
			add(tutoLayer);

		if (!BSIDE)
		{
			spikes = new FlxTypedGroup<Spike>();
			add(spikes);
		}

		player = new Player();
		add(player);

		map.loadEntities(placeEntities, "Entities");

		fakeWalls = map.loadTilemapExt(Paths.getImage(!BSIDE ? "tileMap" : "BtileMap", BSIDE ? true : false), "FakeFloor");
		add(fakeWalls);

		messages = new Message();
		add(messages);

		var screen = new ScanLines();
		add(screen);

		var uiBorder = new FlxSprite(0, Game.getGameHeight());
		uiBorder.makeGraphic(FlxG.width, FlxG.height - Std.int(uiBorder.y), FlxColor.BLACK);
		add(uiBorder);

		var uiStrawberry = new Heart(5, Game.getGameHeight() + 5);
		if (!BSIDE)
			add(uiStrawberry);
		else
		{
			var uiStrawGlitched = new FlxEffectSprite(uiStrawberry, [glitchedEffect]);
			uiStrawGlitched.setPosition(5, Game.getGameHeight() + 5);
			uiStrawGlitched.cameras = [uiCamera];
			add(uiStrawGlitched);
		}

		uiStrawCount = new FlxText(17, Game.getGameHeight() + 5, 0, "x 0");
		add(uiStrawCount);

		var uiText = new FlxText(5, Game.getGameHeight() + 5, FlxG.width - 10, !BSIDE ? levelText[LEVEL] : bSideText[LEVEL]);
		uiText.alignment = RIGHT;
		add(uiText);

		if (BSIDE)
		{
			var spriteCursed = new FlxSprite().loadGraphic(Paths.getImage("cursed", true));
			var cursed = new FlxEffectSprite(spriteCursed, [glitchedEffect]);
			cursed.visible = false;
			add(cursed);

			if (finishPlayer == null)
			{
				if (POINTS < 6)
				{
					new FlxTimer().start(5, (_) ->
					{
						new FlxTimer().start(.5, (_) ->
						{
							uiText.visible = !uiText.visible;
							cursed.visible = !cursed.visible;
						}, 2);
					}, 0);
				}
			}
			else
			{
				cursed.visible = true;
				new FlxTimer().start(.1, (_) -> cursed.alpha = Math.max(0, .5 - (player.x / FlxG.width)), 0);
			}
		}

		bullet = new Bullet(player);
		add(bullet);

		// Music
		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
			if (!BSIDE)
				FlxG.sound.playMusic(Paths.getMusic("night-chip"));
			else
				FlxG.sound.playMusic(Paths.getMusic("night-chip-Bside", true));

		// Eventos espec??ficos
		if ((LEVEL == 6 && !BSIDE) || LEVEL == 0)
			FlxG.sound.music.stop();

		if (LEVEL == 6 && BSIDE && POINTS >= 6)
			Lib.application.window.title = "COLORLESS - It's time";

		if (BSIDE && POINTS >= 6)
		{
			// No se me ocurre otra forma :|
			if (LEVEL == 0)
			{
				messages.showText("Do it!");
				messages.callback = () -> messages.showText("Do it!");
			}
			else
			{
				messages.showArrayText(trueEndingText);
				messages.callback = () -> messages.showArrayText(trueEndingText);
			}
		}

		if (LEVEL == 0)
			Lib.application.window.title = "COLORLESS - Shoot it!";

		// Player tiene un arma!
		hasGun = () ->
		{
			Player.HAS_GUN = true;
			add(tutoLayer);
		};

		// HUD
		FlxG.cameras.add(uiCamera, false);
		uiBorder.cameras = [uiCamera];
		uiCamera.cameras = [uiCamera];
		uiStrawberry.cameras = [uiCamera];
		uiText.cameras = [uiCamera];
		uiStrawCount.cameras = [uiCamera];
		screen.cameras = [uiCamera];

		// Hacker time?
		if (LEVEL == 7)
		{
			FlxG.sound.music.stop();
			var spriteCursed = new FlxSprite().loadGraphic(Paths.getImage("cursedever"));
			new FlxTimer().start(10, (_) ->
			{
				player.kill();
				add(spriteCursed);
				uiText.text = "DIRTY HACKER";
				uiText.color = FlxColor.RED;
				new FlxTimer().start(2, (_) -> System.exit(0));
			});
		}
	}

	function playerInteraction()
	{
		// Pasar de nivel por derecha e izquierda
		if ((player.x > FlxG.width) || (player.x < -player.width))
		{
			player.kill();
			player.visible = false;
			BaseState.fadeColor = FlxColor.BLACK;
			if (BSIDE)
				LEVEL--;
			else
				LEVEL++;
			FlxG.resetState();
		}

		// Pared m??gica por izquierda
		if (player.x < 0 && (LEVEL == 0 || !BSIDE))
			player.x = 0;

		// Pared m??gica por derecha
		if ((BSIDE || player.y <= 0) && player.x > (FlxG.width - player.width))
			player.x = FlxG.width - player.width;

		// Te ca??ste bro
		if (player.y > FlxG.height && !respawn)
		{
			respawn = true;
			FlxG.camera.shake(.01, .25);
			FlxG.sound.play(Paths.getSound("Hurt"));
			new FlxTimer().start(1, (_) ->
			{
				player.setPosition(initPos.x, initPos.y);
				FlxFlicker.flicker(player);
				new FlxTimer().start(1, (_) -> respawn = false);
			});
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		Input.update();
		FlxG.collide(player, walls);
		FlxG.overlap(player, spikes, (_player:Player, _spikes:Spike) ->
		{
			if (player.alive)
			{
				player.kill();
				FlxFlicker.flicker(player);
				FlxG.sound.play(Paths.getSound("Hurt"));
				new FlxTimer().start(1, (_) ->
				{
					player.setPosition(initPos.x, initPos.y);
					player.revive();
					new FlxTimer().start(1, (_) -> respawn = false);
				});
			}
		});
		FlxG.overlap(player, heart, (_player:Player, _strawberry:Heart) ->
		{
			if (_strawberry.alive)
			{
				FlxG.sound.play(Paths.getSound("Pickup"));
				_strawberry.kill();
				POINTS++;

				if (POINTS == 6)
					messages.showText("It's time");
			}
		});
		if (gun != null)
			FlxG.overlap(player, gun, (d1, _gun:FlxSprite) ->
			{
				if (_gun.alive)
				{
					FlxG.sound.play(Paths.getSound("Select"));
					hasGun();
					gun.kill();
				}
			});
		if (artefact != null)
			FlxG.overlap(player, artefact, (_player:Player, _artefact:Artefact) ->
			{
				FlxG.sound.play(Paths.getSound("Artefact"));
				artefact.kill();
				player.kill();
				FlxG.camera.shake(.05, 3);
				var fadeTemp = new FlxSprite(0, 0).makeGraphic(Game.TILE_WIDTH * Game.MAP_WIDTH, Game.TILE_HEIGHT * Game.MAP_HEIGHT, FlxColor.WHITE);
				fadeTemp.alpha = 0;
				add(fadeTemp);
				new FlxTimer().start(.5, (_timer:FlxTimer) ->
				{
					if (fadeTemp.alpha < 1)
						fadeTemp.alpha += .2;
					else
					{
						_timer.cancel();
						BSIDE = true;
						BaseState.fadeColor = FlxColor.WHITE;
						BaseState.skipNextTransOut = true;
						FlxG.resetState();
					}
				}, 0);
			});
		if (finishPlayer != null)
			FlxG.overlap(player, finishPlayer, (d1, d2) ->
			{
				Lib.application.window.title = "COLORLESS - The End?";
				BaseState.skipNextTransOut = BaseState.skipNextTransIn = true;
				FlxG.switchState(new EndingState());
			});

		FlxG.overlap(bullet, finishPlayer, (d1, d2) ->
		{
			Lib.application.window.title = "COLORLESS - The End";
			BaseState.skipNextTransOut = BaseState.skipNextTransIn = true;
			FlxG.switchState(new EndingState(1));
		});

		var playerX = player.x + (player.width / 2);
		var playerY = player.y + (player.height / 2);

		var fakeWallCheck = fakeWalls.getTile(Math.floor(playerX / 12), Math.floor(playerY / 12)) != 0 || player.y < 0;

		if (fakeWallCheck && fakeWalls.alpha > 0)
			fakeWalls.alpha -= .1;
		if (!fakeWallCheck && fakeWalls.alpha < 1)
			fakeWalls.alpha += .1;

		uiStrawCount.text = 'x $POINTS';

		if (player.alive)
			playerInteraction();

		if ((Input.BACK || Input.BACK_ALT) && LEVEL != 7)
			System.exit(0);

		if (Player.HAS_GUN && (Input.SHOOT || Input.SHOOT_ALT))
			bullet.shoot();

		#if debug
		if (FlxG.keys.justPressed.L)
		{
			if (BSIDE)
				LEVEL--;
			else
				LEVEL++;
			FlxG.resetState();
		}
		if (FlxG.keys.justPressed.K)
			POINTS++;
		#end
	}
}
