package;

import flixel.ui.FlxButton;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.addons.display.FlxBackdrop;

class PlayState extends FlxState
{
	public static var LevelsData:LevelsData = new LevelsData();

	var _player:Player;
	var _whale:Whale;
	var _aliens:FlxGroup = new FlxGroup();
	var _harpoons:FlxGroup = new FlxGroup();
	var _aliensNeeded:Int = 4;

	var _hud:FlxGroup = new FlxGroup();
	var _healthText:FlxText;
	var _countdownText:FlxText;
	var _endgameTimer:FlxTimer;
	var _collisionCooldownTimer:FlxTimer = new FlxTimer();
	var _level:Int;
	var _levelClear:Bool = false;

	public function new(level:Int)
	{
		_level = level;
		super();
	}

	override public function create():Void
	{
		var backdrop:FlxBackdrop = new FlxBackdrop("assets/images/background.png");
		add(backdrop);

		FlxG.sound.playMusic("assets/music/music2.wav", 0.6, true);

		_player = new Player();
		add(_player);

		_whale = new Whale(LevelsData.Levels[_level].Health);
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

		_countdownText = new FlxText(20, 30);
		_countdownText.scrollFactor.set(0,0);
		_hud.add(_countdownText);

		add(_hud);

		_endgameTimer = new FlxTimer();
		_endgameTimer.start(LevelsData.Levels[_level].Time, gameWon);
		// _hud.forEach(function(obj:FlxBasic){
		// 	obj.scro
		// })
		_aliensNeeded = LevelsData.Levels[_level].NumberOfAliens;



		FlxG.camera.follow(_player, TOPDOWN, 1);

		super.create();
	}


	override public function update(elapsed:Float):Void
	{

		FlxG.worldBounds.set(_whale.x-1000, _whale.y-2000, _whale.x+_whale.width+2000, _whale.y+_whale.height+2000);
		
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
		_countdownText.text = "Time Left: "+Math.round(_endgameTimer.timeLeft);

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

	public function nextLevel()
	{
		FlxG.switchState(new PlayState(_level+1));
	}
	public function menu()
	{
		FlxG.switchState(new MenuState());
	}

	public function gameWon(timer:FlxTimer)
	{
		_levelClear = true;
		var timer = new FlxTimer();
		timer.start(1, hyperspaceWhaleSpeed, 1000);

		if (_level+1 > LevelsData.Levels.length-1)
		{
			var text:FlxText = new FlxText(150, 50, 400, "Thank You For Saving the Space Whales!", 50);
			text.scrollFactor.set(0,0);
			text.alignment = CENTER;
			add(text);
			var button:FlxButton = new FlxButton(300, 350, "Return to menu", menu);
			button.scale.set(3,3);
			button.scrollFactor.set(0,0);
			add(button);

		}else{

		    var button:FlxButton = new FlxButton(300, 300, "Next Level!", nextLevel);
			button.scale.set(3,3);
			button.scrollFactor.set(0,0);

		    add(button);
		}


		// var pos = _whale.x;
		// for (i in 0...Math.round(_whale.width/4))
		// {
		// 	var emitter = new FlxEmitter(pos+=Math.round(_whale.width/4), _whale.y+50, 100);
		// 	emitter.makeParticles(2,1, FlxColor.PURPLE, 100);
		// 	add(emitter);
		// 	emitter.start();
		// }


	}

	public function endGame()
	{
		if (_levelClear)
			return;
		FlxG.camera.fade(FlxColor.BLACK, 2, false, gameOver);
	}

	public function gameOver()
	{
		var restart = new PlayState(_level);
		//destroy();
		FlxG.switchState(restart);
	}

	public function addAlien()
	{
		var alien = new Alien(
			FlxG.random.float(_whale.x, _whale.x+_whale.width), 
			FlxG.random.float(_whale.y-100, _whale.y - 500), _whale,
			LevelsData.Levels[_level].RetractWaitTime);
		alien.chooseTarget(_whale.x, _whale.x+_whale.width, _whale.y);
		_harpoons.add(alien.harpoon);	
		_aliens.add(alien);
		_aliensNeeded--;
	}

	public function whaleStrike(player:Player, whale:Whale) {
		if (FlxG.pixelPerfectOverlap(player, whale))
		{
			whale.hit(10);
			FlxG.camera.shake(0.07, 0.05);

			player.hitWale();


		}else
		{
			//_collisionCooldownTimer.start(0.01);
		}
	}

	public function whaleShot(whale:Whale, harpoon:Harpoon)
	{

		if (!harpoon.InWhale && FlxG.pixelPerfectOverlap(whale, harpoon))
		{
			FlxG.sound.play("assets/sounds/hit.wav", 0.6);
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
