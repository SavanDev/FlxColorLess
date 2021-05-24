package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var player:Player;
	var walls:FlxTilemap;

	function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "Player":
				player.setPosition(entity.x, entity.y);
		}
	}

	override public function create()
	{
		super.create();
		Input.init();
		bgColor = 0xFF5080FF;

		var map = new FlxOgmo3Loader(Paths.getOgmoData(), "assets/data/levels/level1.json");

		var backWalls = map.loadTilemap(Paths.getImage("backTile"), "Environment");
		add(backWalls);

		walls = map.loadTilemap(Paths.getImage("tileMap"), "Default");
		walls.setTileProperties(0, FlxObject.NONE);
		walls.setTileProperties(1, FlxObject.ANY);
		add(walls);

		player = new Player();
		add(player);

		map.loadEntities(placeEntities, "Entities");

		var uiBorder = new FlxSprite(0, MapData.MAP_HEIGHT * MapData.TILE_HEIGHT);
		uiBorder.makeGraphic(FlxG.width, FlxG.height - Std.int(uiBorder.y), FlxColor.BLACK);
		add(uiBorder);

		var gameName = new FlxText(5, MapData.MAP_HEIGHT * MapData.TILE_HEIGHT + 5, 0, "ColorLess!");
		add(gameName);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		Input.update();
		FlxG.collide(player, walls);
	}
}
