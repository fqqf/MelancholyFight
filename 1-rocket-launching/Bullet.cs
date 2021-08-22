using Godot;
using System;

public class Bullet : Area2D
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";

    // Called when the node enters the scene tree for the first time.

    Vector2 Velocity;

    [Export]
    int SPEED = 130;

    [Export]
    int RotationForce;


    public override void _Ready()
    {
        //this.Rotation = (int) GD.RandRange(-180,180);

        float number = (float)GD.RandRange(0.1, 0.23);
        Sprite bulletSprite = this.GetNode<Sprite>("Sprite");
        bulletSprite.GlobalScale = new Vector2(number, number);
        RotationForce = (int)GD.RandRange(-130, 130);
        if (RotationForce > 0) RotationForce += 40; else RotationForce -= 40;
        this.Connect("screen_exited", this, "OnScreenExited");
        color = this.Modulate;
    }

    Color color;

    void OnScreenExited()
    {
        QueueFree();
    }

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        RotationDegrees += RotationForce * delta;
        Velocity.x = +SPEED;

        Position += Velocity * delta;

        Velocity.x = 0; Velocity.y = 0;
        color.a -=0.005f; // In _Process method
        this.Modulate = color;
    }
}
