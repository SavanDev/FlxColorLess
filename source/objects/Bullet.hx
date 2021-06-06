package objects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import misc.Paths;

class Bullet extends FlxSprite
{
	var player:Player;

	public function new(_player:Player)
	{
		super(-10, -10);
		makeGraphic(4, 4, FlxColor.WHITE);
		player = _player;
	}

	public function shoot()
	{
		if (!this.isOnScreen())
		{
			FlxG.sound.play(Paths.getSound("Shoot"));
			setPosition(player.x, player.y + (player.height / 2));
			velocity.x = player.facing == FlxObject.RIGHT ? 150 : -150;
		}
	}
}
