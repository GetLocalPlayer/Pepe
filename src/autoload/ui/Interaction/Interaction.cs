using Godot;
using System;
using System.Collections.Generic;
using System.Linq;


public partial class Interaction : Control
{
    [Signal] public delegate void InteractionFinishedEventHandler();


    public static class Signals
    {
        public const string InteractionFinished = "InteractionFinished";
    }


    readonly List<string> _lines = new();
    RichTextLabel _label;


    public override void _Ready()
    {
        var tree = GetTree();
        var currentScene = tree.CurrentScene;
        if (this != currentScene) Hide();
        VisibilityChanged += () =>
            GetTree().Paused = Visible;
        _label = GetNode<RichTextLabel>("Text");
    }

    
    public override void _Input(InputEvent @event)
    {
        if (Visible && Input.IsActionJustPressed(InputActions.Action))
        {
            if (_lines.Any())
            {
                _label.Text = _lines[0];
                _lines.RemoveAt(0);
            }
            else
            {
                Hide();
                EmitSignal(Signals.InteractionFinished);
            }
        }
    }


    public void Run(string[] lines)
    {
        _lines.AddRange(lines);

        if (!_lines.Any())
            throw new Exception("'Interaciton.Run' - lines array cannot be empty!");

        _label.Text = _lines[0];
        _lines.RemoveAt(0);
        Show();
    }
}
