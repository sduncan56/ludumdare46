package;

import haxe.Log;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxG;

class Harpoon extends FlxSprite
{
    private var _lastChainPos:Float;
    private static final _ChainLength:Int = 16;

    private var _chains:FlxGroup = new FlxGroup();
    private var _stopped:Bool = true;
    private var _withdrawing:Bool = false;
    private var _alien:Alien;
    public var InWhale(default, null):Bool;

    public var Chains(get, null):FlxGroup;

    function get_Chains() return _chains;

    public function new(x:Float, y:Float, speed:Int, alien:Alien) {
        super(x, y, "assets/images/harpoon.png");
        visible = false;

        _alien = alien;

        FlxG.state.insert(0,_chains);
    }

    public function fired(_x:Float, _y:Float, speed:Int)
    {
        _stopped = false;
        visible = true;

        x = _x;
        y = _y;

        _lastChainPos = y;

        velocity.y = speed;


    }

    public function withdraw()
    {
        _chains.forEach(function(obj){
           var chainSeg:ChainSegment = cast obj;
           chainSeg.velocity.y = -50;
        });


        _withdrawing = true;
    }

    public function chainDestroyed()
    {
        _withdrawing = false;
        _stopped = true;

        _chains.forEach(function(obj){
            obj.kill();
        });
        kill();



        _alien.leaveGame();
    }

    override public function update(elapsed:Float) {
        if (!_stopped && y - _lastChainPos > _ChainLength)
        {
            var chain:ChainSegment;
            if (_chains.length > 0)
            {
                var last:ChainSegment = cast _chains.members[_chains.length-1];
                chain = new ChainSegment(last.x, last.y-last.height, last.velocity, last);
                //last.AboveChain = chain;              
            } else
            {
                chain = new ChainSegment(x+6, y-5, velocity, null, this);
            }
            _lastChainPos = y;
            _chains.add(chain);
        }



        if (_withdrawing)
        {
            var last:ChainSegment = cast _chains.members[_chains.length-1];

            if (last != null &&last.y+last.height < _lastChainPos)
            {
                _chains.remove(last,true);
                _lastChainPos = last.y+last.height;

                last.kill();
            }
            if (last == null)
            {
                _withdrawing = false;
                InWhale = false;
                visible = false;
                velocity.y = 0;
            }

        }

        super.update(elapsed);
    }

    public function hitWhale()
    {
        _stopped = true;
        velocity.set(0,0);
        InWhale = true;
    }
}