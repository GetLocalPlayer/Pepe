using Godot;


namespace PepeStates
{
    public class Exhausted : Idle
    {
        float _restoredStamina;


        public override void Enter(Node context)
        {
            _animState = "Exhausted";
            base.Enter(context);
            _restoredStamina = 0;
        }

        public override void Update(Node context, double delta)
        {
            base.Update(context, delta);
            _restoredStamina += (float)delta;
            var pepe = context as Pepe;
            pepe.Stamina = _restoredStamina >= pepe.MaxStamina ? _restoredStamina : 0;
        }
    }
}