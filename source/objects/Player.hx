package objects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import misc.Input;
import misc.Paths;
import states.PlayState;

class Player extends FlxSprite
{
	public static inline var SPEED:Float = 75;
	public static var HAS_GUN:Bool = false;
	static inline var GRAVITY:Float = 300;
	static inline var JUMP_POWER:Float = 100;

	var jumping:Bool = false;
	var jumpTimer:Float = 0;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(Paths.getImage(!PlayState.BSIDE ? "player" : "Bplayer"), true, 12, 24);
		acceleration.y = 300;

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("default", [0, 1], 3, true);
		animation.add("default-gun", [8, 9], 3, true);
		animation.add("walk", [5, 6, 5, 7], 5, true);
		animation.add("walk-gun", [2, 3, 2, 4], 5, true);
		animation.add("jump", [12]);
		animation.play("default");

		if (PlayState.BSIDE)
			facing = FlxObject.LEFT;
	}

	function movement(elapsed:Float)
	{
		var jump:Bool = Input.JUMP || Input.JUMP_ALT,
			left:Bool = Input.LEFT || Input.LEFT_ALT,
			right:Bool = Input.RIGHT || Input.RIGHT_ALT;

		if (left && !right)
		{
			velocity.x = -SPEED;
			facing = FlxObject.LEFT;
		}

		if (right && !left)
		{
			velocity.x = SPEED;
			facing = FlxObject.RIGHT;
		}

		if (!left && !right)
			velocity.x = 0;

		// sistema de salto (gracias HaxeFlixel Snippets!)
		if (jumping && !jump)
			jumping = false;

		if (jump && jumpTimer == -1 && isTouching(FlxObject.DOWN))
			FlxG.sound.play(Paths.getSound("Jump"));

		// reinicia el tiempo de salto al tocar el suelo
		if (isTouching(FlxObject.DOWN) && !jumping)
			jumpTimer = 0;

		if (jumpTimer >= 0 && jump)
		{
			jumping = true;
			jumpTimer += elapsed;
		}
		else
			jumpTimer = -1;

		// mantener precionado para saltar más alto
		if (jumpTimer > 0 && jumpTimer < .25)
			velocity.y = -JUMP_POWER;
	}

	function playerAnimation()
	{
		if (!isTouching(FlxObject.DOWN))
			animation.play("jump");
		else
		{
			if (velocity.x != 0)
				animation.play(HAS_GUN ? "walk-gun" : "walk");
			else
				animation.play(HAS_GUN ? "default-gun" : "default");
		}
	}

	override function kill()
	{
		alive = false;
		animation.stop();
		animation.frameIndex = 10;
		velocity.x = 0;
	}

	override function update(elapsed:Float)
	{
		if (alive)
		{
			movement(elapsed);
			playerAnimation();
		}

		super.update(elapsed);
	}
}
