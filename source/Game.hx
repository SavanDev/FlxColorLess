class Game
{
	public static inline var TILE_WIDTH:Int = 12;
	public static inline var TILE_HEIGHT:Int = 12;
	public static inline var MAP_WIDTH:Int = 16;
	public static inline var MAP_HEIGHT:Int = 11;
	public static inline var PIXEL_PERFECT:Bool = true;

	public static function getGameWidth():Int
	{
		return TILE_WIDTH * MAP_WIDTH;
	}

	public static function getGameHeight():Int
	{
		return TILE_HEIGHT * MAP_HEIGHT;
	}
}
