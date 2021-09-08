using Godot;
using System;

public class MainMenu : Node
{
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	public override void _Process(float delta)
	{
		if (Input.IsActionJustPressed("ui_accept")) {GetTree().ChangeScene("res://Main.tscn");}
		if (Input.IsActionJustPressed("ui_cancel")) {GetTree().Quit();}
	}
}
