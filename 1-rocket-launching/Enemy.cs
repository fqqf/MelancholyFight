using Godot;
using System;

public class Enemy : Area2D
{
	Vector2 Velocity;

	PackedScene explosionEffectScene;

    [Signal]
    public delegate void scoredUp(int score);

	[Export]
	int SPEED = (int)GD.RandRange(20, 60);

	[Export]
	int ARMOR = (int)GD.RandRange(2, 4);

	[Export]
	int RotationForce = (int)GD.RandRange(-30, 30);

	float ScaleAmount = (float)GD.RandRange(1.25, 2.4);

	public override void _Ready()
	{
		explosionEffectScene = (PackedScene)GD.Load("res://ExplosionEffect.tscn");
		this.Rotation = (int)GD.RandRange(-180, 180);
		this.Scale = new Vector2(ScaleAmount, ScaleAmount);
		this.Connect("area_entered", this, "OnAreaEntered");
		this.Connect("screen_exited", this, "OnScreenExited");

        Connect("tree_exited", this, "onExitTree");

		float r = (float)GD.RandRange(-0.2, 0.5);

		this.Modulate = new Color(Modulate.r - r, Modulate.g - r, Modulate.b - r, (float)GD.RandRange(0.2, 1.5));
        packedScene = this.GetTree().CurrentScene;
        Connect("scoredUp", packedScene, "onScoredUp");
	}

	void OnAreaEntered(Area2D area)
	{
		if (area is Bullet && ARMOR != 1)
		{Bullet h = (Bullet) area;
		h.createHitEffect();}
		if (area is Enemy) return;
		area.QueueFree();

		ARMOR -= 1;
		if (ARMOR == 0) 
        {
            int score_ = (int)(area.Scale.x*3);
            QueueFree();EmitSignal("scoredUp",score_);
			ExplosionEffect explosionEffect = explosionEffectScene.Instance<ExplosionEffect>();
			packedScene.AddChild(explosionEffect);
			explosionEffect.GlobalPosition = GlobalPosition;
		}
	}

	void OnScreenExited()
	{
		QueueFree();
	}

    Node packedScene;

	void onExitTree()
	{

	}

	//  // Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(float delta)
	{
		RotationDegrees += RotationForce * delta;
		Velocity.x = -SPEED;

		Position += Velocity * delta;

		Velocity.x = 0; Velocity.y = 0;
	}
}
