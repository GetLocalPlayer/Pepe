using Godot;
using System;
using System.Collections.Generic;
using System.Linq;


public partial class Inventory : Control
{   
    [Export] float _fadeScreenTime = 0.5f;
    ShaderMaterial _statusMaterial;
    ColorRect _fadeScreen;
    Control _backdrop;


    public override void _Ready()
    {
        var tree = GetTree();
        var currentScene = tree.CurrentScene;

        if (this != currentScene) base.Hide();

        VisibilityChanged += () =>
            tree.Paused = Visible;

        _statusMaterial = GetNode<ColorRect>("Backdrop/Rows/Character/Status/Portrait").Material as ShaderMaterial;
        _fadeScreen = GetNode<ColorRect>("FadeScreen");
        _backdrop = GetNode<Control>("Backdrop");
    }

    
    public override void _Input(InputEvent @event)
    {
        if (_fadeScreen.Visible) return;
        if (Input.IsActionJustPressed(InputActions.OpenInventory))
            Hide();
    }


    // Value as a factor of 1 (current health / max health)
    public void Show(float healthStatus)
    {
        _statusMaterial.SetShaderParameter("CurrentHealth", healthStatus);
        Show();
        _backdrop.Hide();
        _fadeScreen.Show();
        var tween = _fadeScreen.CreateTween();
        _fadeScreen.Color = _fadeScreen.Color with { A = 0f };
        tween.TweenProperty(_fadeScreen, "color", _fadeScreen.Color with { A = 1f }, _fadeScreenTime);
        tween.TweenCallback(Callable.From(_backdrop.Show));
        tween.TweenProperty(_fadeScreen, "color", _fadeScreen.Color with { A = 0f }, _fadeScreenTime);
        tween.TweenCallback(Callable.From(_fadeScreen.Hide));
    }


    public new void Hide()
    {
        _fadeScreen.Show();
        var tween = _fadeScreen.CreateTween();
        _fadeScreen.Color = _fadeScreen.Color with { A = 0f };
        tween.TweenProperty(_fadeScreen, "color", _fadeScreen.Color with { A = 1f }, _fadeScreenTime);
        tween.TweenCallback(Callable.From(_backdrop.Hide));
        tween.TweenProperty(_fadeScreen, "color", _fadeScreen.Color with { A = 0f }, _fadeScreenTime);
        tween.TweenCallback(Callable.From(base.Hide));
    }
}
