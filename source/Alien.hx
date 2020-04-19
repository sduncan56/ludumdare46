package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.FlxSprite;


class Alien extends FlxSprite
{
    var tween:FlxTween;
    var _target:FlxSprite;
    var _resetTimer:FlxTimer = new FlxTimer();
    var _resetting:Bool = false;
    var _weaponResetTime:Int = 5;
    public var harpoon(default, null):Harpoon;
    public function new(x:Float, y:Float, target:FlxSprite, weaponResetTime:Int)
    {
        super(x, y, "assets/images/alien.png");

        _target = target;
        _weaponResetTime = weaponResetTime;

        harpoon = new Harpoon(x, y, 0, this);
    }

    public function leaveGame()
    {
        _resetTimer.cancel();
        _resetting = false;
        tween =FlxTween.tween(this, {x:_target.x+_target.width/2, y: -4000},
            6, {type: FlxTweenType.ONESHOT, ease:FlxEase.quadInOut,onComplete: leftGame});
    }

    public function leftGame(tween:FlxTween)
    {
        kill();
    }

    public function chooseTarget(x:Float, farX:Float, y:Float)
    {
        var goal:Float = FlxG.random.float(x, farX-60);
        var goalY:Float = FlxG.random.float(y-20, y-300);
        tween = FlxTween.tween(this, {x:goal, y:goalY}, 2, 
            {type: FlxTweenType.PERSIST, ease: FlxEase.quadInOut,
            onComplete: arrived});

    }

    public function arrived(tween:FlxTween)
    {
        if (FlxG.random.bool(70))
        {
            fireHarpoon();
        }else{
            chooseTarget(_target.x, _target.x+_target.width, _target.y);
        }

    }

    private function resetWeapon(timer:FlxTimer)
    {

        if (harpoon.InWhale)
        {
        harpoon.withdraw();
        _resetting = true;
        }
        else
        {
            _resetTimer.start(_weaponResetTime, resetWeapon);

        }
    }

    public function fireHarpoon()
    {
        harpoon.fired(x+width/2-5, y+20, 100);

        _resetTimer.start(_weaponResetTime, resetWeapon);

        //var harpoon = new Harpoon(x+width/2, y+20, 100);
        //FlxG.state.add(harpoon);
    }
    
    override public function update(elapsed:Float)
    {
        if (_resetting && !harpoon.visible)
        {
            _resetting = false;
            chooseTarget(_target.x, _target.x+_target.width, _target.y);
        }
    }
}