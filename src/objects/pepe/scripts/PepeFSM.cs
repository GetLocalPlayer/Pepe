using Godot;
using System;

public partial class PepeFSM : FiniteStateMachine
{
    static class States
    {
        public static State Idle = new Idle();
        public static State Dancing;
        public static State Walking;
        public static State Running;
        public static State Ready;
    }

    protected override State GetInitialState() => States.Idle;
}
