package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.effects.FlxFlicker;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.system.System;
import objects.Strawberry;

class PlayState extends FlxState
{
	static var LEVEL:Int = 1;
	static var POINTS:Int = 0;

	var player:Player;
	var strawberry:Strawberry;
	var walls:FlxTilemap;

	var finish:Bool = false;
	var respawn:Bool = false;

	var fade:FadeBoy;
	var initPos:FlxPoint;

	function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "Player":
				player.setPosition(entity.x, entity.y);
				initPos.set(entity.x, entity.y);
			case "Strawberry":
				strawberry.setPosition(entity.x, entity.y);
				FlxTween.num(entity.y, entity.y + 3, .5, {type: PINGPONG}, (v:Float) -> strawberry.y = v);
		}
	}

	override public function create()
	{
		super.create();

		Input.init();
		bgColor = 0xff0163c6;
		FlxG.timeScale = 1.03;

		var map = new FlxOgmo3Loader(Paths.getOgmoData(), 'assets/data/levels/level$LEVEL.json');
		initPos = new FlxPoint();

		var backWalls = map.loadTilemap(Paths.getImage("environment"), "Environment");
		add(backWalls);

		walls = map.loadTilemap(Paths.getImage("tileMap"), "Default");
		walls.setTileProperties(0, FlxObject.NONE);
		walls.setTileProperties(1, FlxObject.ANY);
		add(walls);

		strawberry = new Strawberry();
		add(strawberry);

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

		var uiText = new FlxText(5, 132 + 5, FlxG.width - 10, "Welcome to ColorLess!");
		uiText.alignment = CENTER;
		add(uiText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		Input.update();
		FlxG.collide(player, walls);
		FlxG.overlap(player, strawberry, (_player:Player, _strawberry:Strawberry) ->
		{
			_strawberry.kill();
			POINTS++;
		});

		if (player.x < 0)
			player.x = 0;

		if (player.x > FlxG.width && !finish)
		{
			player.x += 200;
			finish = true;
			LEVEL++;
			fade.animation.play("fadeOut");
		}

		if (player.y > FlxG.height && !finish && !respawn)
		{
			respawn = true;
			new FlxTimer().start(1, (_) ->
			{
				player.setPosition(initPos.x, initPos.y);
				FlxFlicker.flicker(player);
				new FlxTimer().start(1, (_) -> respawn = false);
			});
		}

		if (finish && fade.animation.finished)
			FlxG.resetState();

		if (FlxG.keys.justPressed.ESCAPE)
			System.exit(0);
	}
}
