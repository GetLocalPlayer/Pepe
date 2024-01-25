using Godot;
using System;
using PepeStates;

public partial class PepeFSM : FiniteStateMachine
{
    static class States
    {
        public static State Idle = new Idle();
        public static State Walking = new Walking();
        public static State WalkingBackwards = new WalkingBackwards();
        public static State Running = new Running();
        public static State Exhausted = new Exhausted();   
    }


    const string _walkAction = "Walk";
    const string _walkBackwardsAction = "WalkBackwards";
    const string _runModifierAction = "RunModifier";


    protected override State GetInitialState() => States.Idle;


    public override void SetState(State newState)
    {
        if (newState != currentState) base.SetState(newState);
    }


    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);

        var pepe = GetContext() as Pepe;
        var body = GetContext() as CharacterBody3D;

        body.ApplyFloorSnap();
        
        if (body.IsOnFloor())
        {
            if (Input.IsActionPressed(_walkAction))
            {
                if (Input.IsActionPressed(_walkBackwardsAction))
                    SetState(States.WalkingBackwards);
                else if (Input.IsActionPressed(_runModifierAction) && !pepe.Exhausted)
                    SetState(States.Running);
                else
                    SetState(States.Walking);
            }
            else
            {
                SetState(pepe.Exhausted ? States.Exhausted : States.Idle);
            }
        }
    }
}
