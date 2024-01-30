using System;
using Godot;
using System.Collections.Generic;


[Tool]
public partial class Item : MarginContainer
{
    [Export] public string Description = null;

    uint _amount = 0;
    [Export] public uint Amount
    {
        get => _amount;
        set {
            _amount = value;
            if (IsNodeReady())
            {
                 GetNode<Label>("Texture/Amount").Text = $"x{value}";
                if (!Engine.IsEditorHint())
                    Visible = value > 0;
            }
        }
    }

    public Dictionary<string, Action<Item>> Actions = new(){};

    PackedScene _model;
    [Export] PackedScene Model
    {
        get => _model;
        set {
            if (IsNodeReady())
            {
                var modelOwner = GetNode<Node3D>("SubViewport/ModelOwner");
                foreach (var child in modelOwner.GetChildren())
                    child.QueueFree();
                if (value != null)
                    modelOwner.AddChild(value.Instantiate());
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
        var vp = GetNode<SubViewport>("SubViewport");
        var texRect = GetNode<TextureRect>("Texture");
        texRect.Texture = vp.GetTexture();

        if (!Engine.IsEditorHint())
            Visible = Amount > 0;

        var animPlayer = GetNode<AnimationPlayer>("SubViewport/AnimationPlayer");
        animPlayer.Play(animPlayer.Autoplay);


        var modelOwner = GetNode<Node3D>("SubViewport/ModelOwner");
        modelOwner.Scale = new Vector3(ModelScale, ModelScale, ModelScale);
        modelOwner.Position = ModelOffset;
        if (Model != null)
        {
            modelOwner.AddChild(Model.Instantiate());
        }
    }
}
