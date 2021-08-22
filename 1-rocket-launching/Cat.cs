using Godot;
using System;

public class Cat : Area2D
{
    PackedScene bulletScene;

    Vector2 Velocity;

    [Export]
    int SPEED = 30;

    public override void _Ready()
    {
        bulletScene = (PackedScene)GD.Load("res://Bullet.tscn");
        Connect("area_entered", this, "OnAreaEntered");
    }

    void OnAreaEntered(Area2D area)
    {
        if (area is Bullet) return;

        QueueFree();
        area.QueueFree();
    }

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        if (Input.IsActionPressed("ui_up")) Velocity.y = -SPEED;
        if (Input.IsActionPressed("ui_down")) Velocity.y = SPEED;
        Position += Velocity * delta;

        Velocity.x = 0; Velocity.y = 0;
    }

    public override void _Input(InputEvent @event)
    {
        if (@event is InputEventMouseButton mouseEvent)
        {

            if (mouseEvent.ButtonIndex == (int)ButtonList.Left && mouseEvent.Pressed)
            {
                FireBullet();
            }
        }
    }

    public void FireBullet()
    {
        Area2D bullet = (Area2D)bulletScene.Instance();
        GetTree().CurrentScene.AddChild(bullet);
        bullet.GlobalPosition = GlobalPosition;

    }
}
