using Godot;
using System;


public partial class Pepe : CharacterBody3D
{
    [Export] public float Gravity = 10;
    [Export] public float TurnSpeed = 60;
    /* Max time*/
    [Export] public float MaxStamina = 20;
    [Export] public float StaminaRestorationRate = 5;

    float _stamina;
    [Export] public float Stamina
    {
        get => _stamina;
        set => _stamina = value > MaxStamina ? MaxStamina : (value < 0f ? 0 : value);
    }

    public bool Exhausted { get => Stamina <= 0; }

    Area3D _interactableDetector;
    UI _ui;

    public override void _Ready()
    {
        Stamina = MaxStamina;
        _interactableDetector = GetNode<Area3D>("InteractableDetector");
        _ui = GetTree().Root.GetNode<UI>("UI");
    }


    async public override void _Input(InputEvent @event)
    {
        if (Input.IsActionJustPressed(InputActions.Action))
        {
            foreach (var a in _interactableDetector.GetOverlappingAreas())
            {
                _ui.RunInteration(a.GetParent<Interactable>());
                GetViewport().SetInputAsHandled();
                await ToSignal(_ui, UI.Signals.InteractionFinished);
            }
        }
    }
}
