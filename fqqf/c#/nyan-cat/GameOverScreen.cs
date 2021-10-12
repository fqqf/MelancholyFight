using Godot;
using System;

public class GameOverScreen : Node
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        scoreLabel = (Label) FindNode("Label2",true,false);

        setHighScoreLabel();
    }

    Label scoreLabel;

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        if (Input.IsActionJustPressed("ui_cancel")) GetTree().ChangeScene("res://MainMenu.tscn");
    }

    public void setHighScoreLabel()
    {
        Godot.Collections.Dictionary dat = SaveAndLoad.loadData(); 
        scoreLabel.Text = $"maximum score is {dat["highscore"]}";
    }
}
