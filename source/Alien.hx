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
    public var harpoon(default, null):Harpoon;
    public function new(x:Int, y:Int, target:FlxSprite)
    {
        super(x, y, "assets/images/alien.png");

        _target = target;

        harpoon = new Harpoon(x, y, 0);
    }

    public function chooseTarget(x:Float, farX:Float)
    {
        var goal:Float = FlxG.random.float(x, farX);
        tween = FlxTween.tween(this, {x:goal, y:-100}, 2, 
            {type: FlxTweenType.PERSIST, ease: FlxEase.quadInOut,
            onComplete: arrived});

    }

    public function arrived(tween:FlxTween)
    {
        if (FlxG.random.bool(70))
        {
            fireHarpoon();
        }else{
            chooseTarget(_target.x, _target.x+_target.width);
        }

    }

    private function resetWeapon(timer:FlxTimer)
    {
        harpoon.withdraw();
    }

    public function fireHarpoon()
    {
        harpoon.fired(x+width/2-5, y+20, 100);

        _resetTimer.start(5, resetWeapon);

        //var harpoon = new Harpoon(x+width/2, y+20, 100);
        //FlxG.state.add(harpoon);
    }
}