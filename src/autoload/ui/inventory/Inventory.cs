using Godot;
using System;
using System.Collections.Generic;
using System.Linq;


public partial class Inventory : Control
{   
    public override void _Ready()
    {
        var tree = GetTree();
        var currentScene = tree.CurrentScene;

        if (this != currentScene) Hide();

        VisibilityChanged += () =>
            tree.Paused = Visible;
    }
}
