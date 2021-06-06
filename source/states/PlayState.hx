package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.system.System;
import misc.FadeBoy;
import misc.Input;
import misc.Paths;
import objects.Artefact;
import objects.Bullet;
import objects.Player;
import objects.Spike;
import objects.Strawberry;

class PlayState extends FlxState
{
	static var LEVEL:Int = 1;
	public static var POINTS:Int = 0;
	public static var BSIDE:Bool = false;

	var player:Player;
	var strawberry:Strawberry;
	var spikes:FlxTypedGroup<Spike>;
	var artefact:Artefact;
	var finishPlayer:FlxSprite;
	var walls:FlxTilemap;
	var fakeWalls:FlxTilemap;
	var gun:FlxSprite;
	var bullet:Bullet;

	var finish:Bool = false;
	var respawn:Bool = false;
	var levelText:Array<String> = [
		"Welcome! :)",
		"Strawberries!",
		"Jumps!",
		"Danger!",
		"The Cave!",
		"Let's go!",
		"..."
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

	var fade:FadeBoy;
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
					strawberry = new Strawberry(entity.x, entity.y);
					FlxTween.num(entity.y, entity.y + 3, .5, {type: PINGPONG}, (v:Float) -> strawberry.y = v);
					add(strawberry);
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
					finishPlayer = new FlxSprite(entity.x, entity.y).loadGraphic(Paths.getImage("Bplayer"), true, 12, 24);
					finishPlayer.animation.frameIndex = 11;
					add(finishPlayer);
				case "Gun":
					if (POINTS >= 6)
					{
						gun = new FlxSprite(entity.x, entity.y, Paths.getImage("BGun"));
						FlxTween.num(entity.y, entity.y + 3, .5, {type: PINGPONG}, (v:Float) -> gun.y = v);
						add(gun);
					}
			}
		}
	}

	override public function create()
	{
		super.create();
		bgColor = !BSIDE ? 0xff0163c6 : FlxColor.BLACK;

		var glitchedEffect = new FlxGlitchEffect(2);

		var map = new FlxOgmo3Loader(Paths.getOgmoData(), 'assets/data/levels/level$LEVEL.json');
		initPos = new FlxPoint();

		if (!BSIDE)
		{
			var backWalls = map.loadTilemap(Paths.getImage("environment"), "Environment");
			add(backWalls);
		}

		walls = map.loadTilemap(Paths.getImage(!BSIDE ? "tileMap" : "BtileMap"), "Default");
		walls.setTileProperties(0, FlxObject.NONE);
		walls.setTileProperties(1, FlxObject.ANY);
		add(walls);

		if (!BSIDE)
		{
			spikes = new FlxTypedGroup<Spike>();
			add(spikes);
		}

		player = new Player();
		add(player);

		map.loadEntities(placeEntities, "Entities");

		fakeWalls = map.loadTilemap(Paths.getImage(!BSIDE ? "tileMap" : "BtileMap"), "FakeFloor");
		add(fakeWalls);

		var screen = new FlxSprite(0, 0, Paths.getImage("screen"));
		screen.alpha = .25;
		add(screen);

		fade = new FadeBoy();
		add(fade);

		var uiBorder = new FlxSprite(0, Game.getGameHeight());
		uiBorder.makeGraphic(FlxG.width, FlxG.height - Std.int(uiBorder.y), FlxColor.BLACK);
		add(uiBorder);

		var uiText = new FlxText(5, Game.getGameHeight() + 5, FlxG.width - 10, !BSIDE ? levelText[LEVEL] : bSideText[LEVEL]);
		uiText.alignment = RIGHT;
		add(uiText);

		var uiStrawberry = new FlxSprite(5, Game.getGameHeight() + 5, Paths.getImage("strawberry"));
		if (!BSIDE)
			add(uiStrawberry);
		else
		{
			var uiStrawGlitched = new FlxEffectSprite(uiStrawberry, [glitchedEffect]);
			uiStrawGlitched.setPosition(5, Game.getGameHeight() + 5);
			add(uiStrawGlitched);
		}

		uiStrawCount = new FlxText(17, Game.getGameHeight() + 5, 0, "x 0");
		add(uiStrawCount);

		if (BSIDE)
		{
			var spriteCursed = new FlxSprite().loadGraphic(Paths.getImage("cursed"));
			var cursed = new FlxEffectSprite(spriteCursed, [glitchedEffect]);
			cursed.visible = false;
			add(cursed);

			if (finishPlayer == null)
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
			else
			{
				cursed.visible = true;
				new FlxTimer().start(.1, (_) -> cursed.alpha = Math.max(0, .5 - (player.x / FlxG.width)), 0);
			}
		}

		if ((LEVEL == 6 && !BSIDE) || LEVEL == 0)
			FlxG.sound.music.stop();

		bullet = new Bullet(player);
		add(bullet);
	}

	function playerInteraction()
	{
		if (!BSIDE)
		{
			if (player.x < 0)
				player.x = 0;

			if (player.x > FlxG.width)
			{
				if (player.y > 0)
				{
					player.kill();
					fade.fadeOut();
				}
				else
					player.x = FlxG.width;
			}
		}
		else
		{
			if (player.x > (FlxG.width - player.width))
				player.x = FlxG.width - player.width;

			if (player.x < -player.width)
			{
				player.kill();
				fade.fadeOut();
			}

			if (player.x < 0 && LEVEL == 0)
				player.x = 0;
		}

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
		FlxG.overlap(player, strawberry, (_player:Player, _strawberry:Strawberry) ->
		{
			FlxG.sound.play(Paths.getSound("Pickup"));
			_strawberry.kill();
			POINTS++;
		});
		if (gun != null)
			FlxG.overlap(player, gun, (d1, _gun:FlxSprite) ->
			{
				if (_gun.alive)
				{
					FlxG.sound.play(Paths.getSound("Select"));
					Player.HAS_GUN = true;
					gun.kill();
				}
			});
		if (artefact != null)
			FlxG.overlap(player, artefact, (_player:Player, _artefact:Artefact) ->
			{
				FlxG.sound.play(Paths.getSound("Artefact"));
				artefact.kill();
				player.kill();
				FlxG.camera.fade(FlxColor.WHITE, 2, () ->
				{
					BSIDE = true;
					FlxG.sound.playMusic(Paths.getMusic("night-chip-Bside"));
					FlxG.resetState();
				});
			});
		if (finishPlayer != null)
			FlxG.overlap(player, finishPlayer, (d1, d2) -> FlxG.switchState(new EndingState()));

		FlxG.overlap(bullet, finishPlayer, (d1, d2) -> FlxG.switchState(new EndingState(1)));

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
		else if (!fade.hasFadeOut)
		{
			if (BSIDE)
				LEVEL--;
			else
				LEVEL++;
			FlxG.resetState();
		}

		if (FlxG.keys.justPressed.ESCAPE)
			System.exit(0);

		if (FlxG.keys.justPressed.F)
			FlxG.fullscreen = !FlxG.fullscreen;

		if (Player.HAS_GUN && FlxG.keys.justPressed.CONTROL)
			bullet.shoot();

		#if FLX_DEBUG
		if (FlxG.keys.justPressed.L)
		{
			if (BSIDE)
				LEVEL--;
			else
				LEVEL++;
			FlxG.resetState();
		}
		#end
	}
}
