using Godot;
using System;
using System.Linq;


[Tool]
public partial class ItemList : Container
{
    int _currentIndex;
    [Export] public int CurrentIndex
    {
        get => _currentIndex;
        set {
            if (IsNodeReady())
            {
                if (value >= 0 && value != _currentIndex)
                {
                    var visibleItems = _container.GetChildren()
                        .Where(child => child is Control c && c.Visible)
                        .Cast<Control>()
                        .ToArray();
                    if (value < visibleItems.Length)
                    {
                        var time = Math.Abs(_currentIndex - value) * _tweenTime;
                        var itemPos = visibleItems[value].Position;
                        var newPos = _container.Position - _container.GetTransform() * itemPos;
                        var tween = _container.CreateTween();
                        tween.TweenProperty(_container, "position", newPos, time);
                        _currentIndex = value;
                    }
                }
                if (value < 0)
                    _currentIndex = 0;
            }
            else
                _currentIndex = value;
        }
    }

    public Control Current
    {
        get {
            var visibleItems = _container.GetChildren()
                .Where(child => child is Control c && c.Visible)
                .Cast<Control>()
                .ToArray();
            return visibleItems[CurrentIndex];
        }
    }


    [Export] float _tweenTime = 0.5f;
    VFlowContainer _container;


    public override void _Ready()
    {
        _container = GetNode<VFlowContainer>("VFlowContainer");
        CallDeferred("ReadyDeferred");

        foreach (var child in _container.GetChildren())
        {
            if (child is Control control)
            {
                control.VisibilityChanged += () =>
                {
                    var visibleItems = _container.GetChildren()
                        .Where(child => child is Control c && c.Visible)
                        .Cast<Control>()
                        .ToArray();
                    var index = Array.IndexOf(visibleItems, control);
                    if (index < CurrentIndex)
                        CurrentIndex += control.Visible ? 1 : -1;

                    if (index == CurrentIndex && !control.Visible && control == visibleItems.Last())
                        CurrentIndex--;
                };
            }
        }
    }

    
    void ReadyDeferred()
    {
        var visibleItems = _container.GetChildren()
            .Where(child => child is Control c && c.Visible)
            .Cast<Control>()
            .ToArray();
        if (visibleItems.Any())
        {
            var index = CurrentIndex < visibleItems.Length ? CurrentIndex : visibleItems.Length - 1;
            _container.Position = index >= 0 ? _container.Position - _container.GetTransform() * visibleItems[index].Position: Vector2.Zero;
        }
    }
}
