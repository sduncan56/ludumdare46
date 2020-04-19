package;

import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxState;

class MenuState extends FlxState
{
    var _titleText:FlxText;
    var _playButton:FlxButton;
    var _instructionsButton:FlxButton;
    var _backBtn:FlxButton;
    var _inst:FlxText;
    override public function create():Void
    {
		var backdrop:FlxBackdrop = new FlxBackdrop("assets/images/background.png");
        add(backdrop);
        
        _titleText = new FlxText(50, 10, FlxG.width-100, "Save the Space Whales!");
        _titleText.size = 70;
        _titleText.wordWrap = true;
        _titleText.alignment = CENTER;
        add(_titleText);

        _playButton = new FlxButton(FlxG.width/2-50, _titleText.y+_titleText.height+20, "Play", play);
        _playButton.scale.set(3,3);
        add(_playButton);

        _instructionsButton = new FlxButton(_playButton.x, _playButton.y+_playButton.height+50, "Instructions", instructions);
        _instructionsButton.scale.set(3,3);
        add(_instructionsButton);
    }

    public function play()
    {
        FlxG.switchState(new PlayState(0));
    }

    public function instructions()
    {
        _titleText.visible = false;
        _playButton.visible = false;
        _instructionsButton.visible = false;

        _inst = new FlxText(100, 100, 400, "The space whale is under attack by alien poachers! Keep it alive by breaking the chains of their harpoons with your ship. UP/W and DOWN/D change your heading, while RIGHT/D fires the engines.");
        _inst.size = 16;
        _inst.alignment = CENTER;
        add(_inst);

        _backBtn = new FlxButton(FlxG.width/2-50, 300, "Back", back);
        _backBtn.scale.set(3,3);
        add(_backBtn);
    }

    public function back()
    {
        _inst.visible = false;
        _backBtn.visible = false;
        
        _titleText.visible = true;
        _playButton.visible = true;
        _instructionsButton.visible = true;

    }
}