using Godot;
using System;



public abstract partial class State
{
	public event EventHandler<Node> StateFinished;
	
	public abstract void Enter(Node context);
	public abstract void Update(Node context, double delta);
	public abstract void Exit(Node context);

	protected void EmitStateFinished(Node context)
	{
		StateFinished?.Invoke(this, context);
	}
}
