using Godot;
using System;

public abstract partial class FiniteStateMachine : Node
{
	protected State currentState;

    public override void _PhysicsProcess(double delta)
    {
        currentState?.Update(GetContext(), delta);
    }

	protected virtual Node GetContext() => GetParent();

	protected abstract State GetInitialState();
	
    public virtual void SetState(State newState)
	{
		currentState?.Exit(GetContext());
		currentState = newState;
		newState?.Enter(GetContext());
	}

	public override void _Ready()
	{
		SetState(GetInitialState());
	}

    public override void _Input(InputEvent @event)
    {
        currentState?.HandleInput(GetContext(), @event);
    }
}
