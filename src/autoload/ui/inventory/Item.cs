using System;
using Godot;
using System.Collections.Generic;


[Tool]
public partial class Item : MarginContainer
{
    [Export] public string Description = null;

    public Dictionary<string, Action<Item>> Actions = new(){};

    PackedScene _model;
    [Export] PackedScene Model
    {
        get => _model;
        set {
            if (IsNodeReady())
            {
                if (_model != value)
                {   
                    var modelOwner = GetNode<Node3D>("SubViewport/ModelOwner");
                    foreach (var child in modelOwner.GetChildren())
                        child.QueueFree();
                    if (value != null)
                        modelOwner.AddChild(value.Instantiate());
                }
            }
            _model = value;
        }
    }

    float _modelScale = 1.0f;
    [Export] float ModelScale
    {
        get => _modelScale;
        set {
            _modelScale = value;
            if (IsNodeReady())
            {
                var modelOwner = GetNode<Node3D>("SubViewport/ModelOwner");
                modelOwner.Scale = new Vector3(value, value, value);
            }
        }
    }

    Vector3 _modelOffset = Vector3.Zero;
    [Export] Vector3 ModelOffset
    {
        get => _modelOffset;
        set {
            _modelOffset = value;
            if (IsNodeReady())
            {
                var modelOwner = GetNode<Node3D>("SubViewport/ModelOwner");
                modelOwner.Position = value;
            }
        }
    }


    public override void _Ready()
    {
        var modelOwner = GetNode<Node3D>("SubViewport/ModelOwner");
        modelOwner.Scale = new Vector3(ModelScale, ModelScale, ModelScale);
        modelOwner.Position = ModelOffset;
        if (Model != null)
        {
            modelOwner.AddChild(Model.Instantiate());
        }
        var animPlayer = GetNode<AnimationPlayer>("SubViewport/AnimationPlayer");
        animPlayer.Play(animPlayer.Autoplay);
    }
}
