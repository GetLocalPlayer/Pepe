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

    public override void _Ready()
    {
        Stamina = MaxStamina;
    }
}
