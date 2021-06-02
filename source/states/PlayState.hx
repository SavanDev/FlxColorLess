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
import objects.Artefact;
import objects.Spike;
import objects.Strawberry;

class PlayState extends FlxState
{
	static var LEVEL:Int = 1;
	static var POINTS:Int = 0;
	public static var BSIDE:Bool = false;

	var player:Player;
	var strawberry:Strawberry;
	var spikes:FlxTypedGroup<Spike>;
	var artefact:Artefact;
	var finishPlayer:FlxSprite;
	var walls:FlxTilemap;

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
	var bLevelText:Array<String> = [
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
			}
		}
	}

	override public function create()
	{
		super.create();
		bgColor = !BSIDE ? 0xff0163c6 : FlxColor.BLACK;

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

		var screen = new FlxSprite(0, 0, Paths.getImage("screen"));
		screen.alpha = .25;
		add(screen);

		fade = new FadeBoy();
		add(fade);

		var uiBorder = new FlxSprite(0, 132);
		uiBorder.makeGraphic(FlxG.width, FlxG.height - Std.int(uiBorder.y), FlxColor.BLACK);
		add(uiBorder);

		var uiText = new FlxText(5, 132 + 5, FlxG.width - 10, !BSIDE ? levelText[LEVEL] : bLevelText[LEVEL]);
		uiText.alignment = CENTER;
		add(uiText);

		if (BSIDE)
		{
			var spriteCursed = new FlxSprite().loadGraphic(Paths.getImage("cursed"));
			var glitchedEffect = new FlxGlitchEffect(2);
			var cursed = new FlxEffectSprite(spriteCursed, [glitchedEffect]);
			cursed.visible = false;
			add(cursed);

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

	function playerInteraction()
	{
		if (!BSIDE)
		{
			if (player.x < 0)
				player.x = 0;

			if (player.x > FlxG.width)
			{
				player.kill();
				fade.fadeOut();
				LEVEL++;
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
				LEVEL--;
			}

			if (player.x < 0 && LEVEL == 0)
				player.x = 0;
		}

		if (player.y > FlxG.height && !respawn)
		{
			respawn = true;
			FlxG.camera.shake(.01, .25);
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
			player.kill();
			fade.fadeOut();
		});
		FlxG.overlap(player, strawberry, (_player:Player, _strawberry:Strawberry) ->
		{
			_strawberry.kill();
			POINTS++;
		});
		FlxG.overlap(player, artefact, (_player:Player, _artefact:Artefact) ->
		{
			artefact.kill();
			player.kill();
			FlxG.camera.fade(FlxColor.WHITE, 2, () ->
			{
				BSIDE = true;
				FlxG.resetState();
			});
		});
		FlxG.overlap(player, finishPlayer, (obj1, obj2) -> FlxG.switchState(new EndingState()));

		if (player.alive)
			playerInteraction();
		else if (!fade.hasFadeOut)
			FlxG.resetState();

		if (FlxG.keys.justPressed.ESCAPE)
			System.exit(0);
	}
}
