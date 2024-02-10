using Godot;
using System;


public partial class Pepe : CharacterBody3D
{
    [Export] public float MaxHealth = 100.0f;
    float _health;
    [Export] public float Health 
    {
        get => _health;
        set {
            _health = value < 0f ? 0f : (value > MaxHealth ? MaxHealth : value);
        }
    }
    [Export] public float Gravity = 10f;
    [Export] public float TurnSpeed = 60f;
    /* Max time*/
    [Export] public float MaxStamina = 20f;
    [Export] public float StaminaRestorationRate = 5f;

    float _stamina;
    [Export] public float Stamina
    {
        get => _stamina;
        set => _stamina = value > MaxStamina ? MaxStamina : (value < 0f ? 0 : value);
    }

    public bool Exhausted { get => Stamina <= 0; }

    Area3D _interactableDetector;
    Interaction _interaction;
    Control _inventory;

    public override void _Ready()
    {
        Stamina = MaxStamina;
        _interactableDetector = GetNode<Area3D>("InteractableDetector");
        _interaction = GetTree().Root.GetNode<Interaction>("Interaction");
        _inventory = GetTree().Root.GetNode<Control>("Inventory");
    }


    async public override void _Input(InputEvent @event)
    {
        if (Input.IsActionJustPressed(InputActions.Action))
        {
            if (_interactableDetector.HasOverlappingAreas())
                GetViewport().SetInputAsHandled();
                
            foreach (var a in _interactableDetector.GetOverlappingAreas())
            {
                _interaction.Run(a.GetParent<Interactable>().Lines);
                await ToSignal(_interaction, Interaction.Signals.InteractionFinished);
            }
        }
        if (Input.IsActionJustPressed(InputActions.OpenInventory))
        {
            GetViewport().SetInputAsHandled();
        }

    }


    public void RestoreHealth(float value)
    {
        Health += value;
    }
}
