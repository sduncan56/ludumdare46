package;

import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
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
	var _aliensNeeded:Int = 4;

	var _hud:FlxGroup = new FlxGroup();
	var _healthText:FlxText;
	var _endgameTimer:FlxTimer;

	override public function create():Void
	{
		_player = new Player();
		add(_player);

		_whale = new Whale();
		add(_whale);

		//var testAlien:Alien = new Alien(310, 0, _whale);
		//testAlien.fireHarpoon();
		//testAlien.chooseTarget(_whale.x, _whale.x+_whale.width);
		//_aliens.add(testAlien);
		add(_aliens);

//		_harpoons.add(testAlien.harpoon);
		add(_harpoons);

		//FlxG.debugger.drawDebug = true;

		_healthText = new FlxText(20, 20);
		_healthText.scrollFactor.set(0,0);
		 _hud.add(_healthText);
		add(_hud);

		_endgameTimer = new FlxTimer();
		_endgameTimer.start(250, gameWon);
		// _hud.forEach(function(obj:FlxBasic){
		// 	obj.scro
		// })



		FlxG.camera.follow(_player, TOPDOWN, 1);

		super.create();
	}


	override public function update(elapsed:Float):Void
	{

		FlxG.worldBounds.set(_whale.x-500, _whale.y-500, _whale.width+500, _whale.height+500);
		
		if (!FlxG.worldBounds.overlaps(_player.getHitbox()))
		{
			endGame();
		}
		
		FlxG.overlap(_whale, _harpoons, whaleShot);
		FlxG.overlap(_player, _whale, whaleStrike);

		_harpoons.forEach(function(obj:FlxBasic){
			var harpoon:Harpoon = cast obj;

			FlxG.overlap(_player, harpoon.Chains, chainCollision);
		});

		_aliens.forEachDead(function(obj){
			_aliens.remove(obj);
			_aliensNeeded++;
		});


		if (_aliensNeeded > 0)
		{
			addAlien();
		}

		_healthText.text = "Health: "+_whale.Health;

		if (_whale.Health <= 0)
		{
			endGame();
		}

		


		super.update(elapsed);
	}

	public function hyperspaceWhaleSpeed(timer:FlxTimer)
	{
		_whale.velocity.x += 100;

	}

	public function gameWon(timer:FlxTimer)
	{
		var timer = new FlxTimer();
		timer.start(2, hyperspaceWhaleSpeed, 10);

		var emitter = new FlxEmitter(_whale.x, _whale.y+50, 100);
		emitter.makeParticles(2,1, FlxColor.PURPLE, 200);
		add(emitter);

	}

	public function endGame()
	{
		FlxG.camera.fade(FlxColor.BLACK, 2, false, gameOver);



	}

	public function gameOver()
	{
		var restart = new PlayState();
		//destroy();
		FlxG.switchState(restart);
	}

	public function addAlien()
	{
		var alien = new Alien(
			FlxG.random.float(_whale.x, _whale.x+_whale.width), 
			FlxG.random.float(_whale.y-100, _whale.y - 500), _whale);
		alien.chooseTarget(_whale.x, _whale.x+_whale.width);
		_harpoons.add(alien.harpoon);	
		_aliens.add(alien);
		_aliensNeeded--;
	}

	public function whaleStrike(player:Player, whale:Whale) {
		if (FlxG.pixelPerfectOverlap(player, whale))
		{
			whale.hit(10);
			FlxG.camera.shake(0.07, 0.05);

			player.y -= 5;

		    player.velocity.x = -player.velocity.x/2;
		    player.velocity.y = -player.velocity.y/2;
		}
	}

	public function whaleShot(whale:Whale, harpoon:Harpoon)
	{
		if (!harpoon.InWhale && FlxG.pixelPerfectOverlap(whale, harpoon))
		{
			harpoon.hitWhale();
			whale.hit(1, harpoon.Point);

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
