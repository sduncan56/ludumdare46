package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;


class PlayState extends FlxState
{
	var _player:Player;
	var _whale:Whale;
	var _aliens:FlxGroup = new FlxGroup();
	var _harpoons:FlxGroup = new FlxGroup();
	override public function create():Void
	{
		_player = new Player();
		add(_player);

		_whale = new Whale();
		add(_whale);

		var testAlien:Alien = new Alien(310, 0, _whale);
		//testAlien.fireHarpoon();
		testAlien.chooseTarget(_whale.x, _whale.x+_whale.width);
		_aliens.add(testAlien);
		add(_aliens);

		_harpoons.add(testAlien.harpoon);
		add(_harpoons);

		//FlxG.debugger.drawDebug = true;


		FlxG.camera.follow(testAlien, TOPDOWN, 1);

		super.create();
	}


	override public function update(elapsed:Float):Void
	{
		FlxG.worldBounds.set(_whale.x-300, _whale.y-300, _whale.width+300, _whale.height+300);
		FlxG.overlap(_whale, _harpoons, whaleShot);

		_harpoons.forEach(function(obj:FlxBasic){
			var harpoon:Harpoon = cast obj;

			FlxG.overlap(_player, harpoon.Chains, chainCollision);
		});

		super.update(elapsed);
	}

	public function whaleShot(whale:Whale, harpoon:Harpoon)
	{
		if (!harpoon.InWhale && FlxG.pixelPerfectOverlap(whale, harpoon))
		{
			harpoon.hitWhale();			

			FlxG.camera.shake(0.05, 0.05);
		}
	}

	public function chainCollision(player:Player, chain:ChainSegment)
	{
		if (!chain.Broken)
		{
			chain.breakChain(player.velocity);
		}
	}
}
