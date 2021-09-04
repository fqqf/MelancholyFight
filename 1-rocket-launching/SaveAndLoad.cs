using Godot;
using System;
//using System.Collections.Generic;

public class SaveAndLoad : Node
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";

    // Called when the node enters the scene tree for the first time.

    private static Godot.Collections.Dictionary standart_dict = new Godot.Collections.Dictionary
    {
        ["highscore"] = 0
    };

    public override void _Ready()
    {
        Godot.Collections.Dictionary<String, String> dict = new Godot.Collections.Dictionary<string, string>();
        dict.Add("key", "value");
        GD.Print(dict["key"]);
    }

    const String SAVE_DATA_PATH = "res://save_data.json";

    public static void saveData(Godot.Collections.Dictionary data)
    {
        var result = JSON.Print(data);
        Godot.File file = new File();
        file.Open(SAVE_DATA_PATH,Godot.File.ModeFlags.Write);
        file.StoreLine(result as String);
        file.Close();
    }
    
    public static Godot.Collections.Dictionary loadData()
    {
        File file = new File();
        if (!file.FileExists(SAVE_DATA_PATH)) return standart_dict;

        file.Open(SAVE_DATA_PATH,File.ModeFlags.Read);
        Godot.Collections.Dictionary dict_ = JSON.Parse(file.GetAsText()).Result as Godot.Collections.Dictionary;
        file.Close();
        return dict_;
    }

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    //  public override void _Process(float delta)
    //  {
    //      
    //  }
}
