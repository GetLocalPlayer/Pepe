using Godot;
using System;
using System.Collections.Generic;
using System.Linq;


public partial class UI : Control
{
    [Signal] public delegate void InteractionFinishedEventHandler();

    
    public static class Signals
    {
        public const string InteractionFinished = "InteractionFinished";
    }
    
    Control _modal;
    RichTextLabel _interactionText;


    public override void _Ready()
    {
        _modal = GetNode<Control>("Modal");
        _modal.Hide();
        _modal.VisibilityChanged += () =>
        {
            if (_modal.Visible)
            {
                _modal.FocusMode = FocusModeEnum.All;
                _modal.GrabFocus();
            }
            else
            {
                _modal.FocusMode = FocusModeEnum.None;
                _modal.ReleaseFocus();
            }
        };
        _interactionText = GetNode<RichTextLabel>("InteractionText");
        if (GetTree().CurrentScene != this)  _interactionText.Hide();
        VisibilityChanged += () =>
            GetTree().Paused = Visible;

        if (GetTree().CurrentScene != this) Hide();
    }


    public void RunInteration(Interactable i)
    {
        if (i.Lines == null)
            throw new Exception("'RunInteraction' - lines array cannot be null!");
        if (i.Lines.IsEmpty())
            throw new Exception("'RunInteraction' - lines array cannot be empty!");

        var list = new List<string>(i.Lines);
        _interactionText.Text = "[center]" + list[0];
        _interactionText.Show();
        list.RemoveAt(0);
        Show();

        void guiInputEvent(InputEvent e)
        {
            if (Input.IsActionJustPressed(InputActions.Action))
            {
                if (list.Any())
                {
                    _interactionText.Text = "[center]" + list[0];
                    list.RemoveAt(0);
                }
                else
                {
                    _interactionText.Hide();
                    _modal.GuiInput -= guiInputEvent;
                    Hide();
                    _modal.Hide();
                    EmitSignal(Signals.InteractionFinished);
                    _modal.SetProcessInput(false);
                }
            }
        }
        _modal.GuiInput += guiInputEvent;
        _modal.Show();
    }
}
