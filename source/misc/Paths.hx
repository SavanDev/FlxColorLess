package misc;

class Paths
{
	static inline var OGMO_DATA:String = "mapsData";

	static public function getImage(file:String, secret:Bool = false)
	{
		if (secret)
			return 'secret/images/$file.png';
		else
			return 'assets/images/$file.png';
	}

	static public function getSound(file:String)
	{
		return 'assets/sounds/$file.wav';
	}

	static public function getMusic(file:String, secret:Bool = false)
	{
		if (secret)
			return 'secret/music/$file.ogg';
		else
			return 'assets/music/$file.ogg';
	}

	static public function getOgmoData()
	{
		return 'assets/data/$OGMO_DATA.ogmo';
	}
}
