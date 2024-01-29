using Godot;
using System;

public partial class Collectable : Interactable
{
    [Export] int _amount = 1;
    [Export] bool _deleteIfEmpty = false;
    [Export] string[] _linesOnEmpty;

    public Vector3 LookAtPoint
    {
        get => GetNode<Marker3D>("LookAtPoint").GlobalPosition;
    }


    public override void _Ready()
    {
        base._Ready();
    }
}
