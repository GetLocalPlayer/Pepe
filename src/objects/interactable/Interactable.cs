using Godot;
using System;

public partial class Interactable : Node3D
{
    [Export] string[] _lines;
    public string[] Lines { get => _lines; }
    Area3D _collider;

    UI _ui;


    public override void _Ready()
    {
        _collider = GetNode<Area3D>("Detectable");
        _ui = GetTree().Root.GetNode<UI>("UI");
    }
}
