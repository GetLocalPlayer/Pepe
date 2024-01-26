using Godot;


namespace PepeStates
{
    public class Exhausted : Idle
    {
        float _restoredStamina;


        public Exhausted()
        {
            _animState = "Exhausted";
        }


        public override void Enter(Node context)
        {
            base.Enter(context);
            _restoredStamina = 0;
        }

        public override void Update(Node context, double delta)
        {
            base.Update(context, delta);
            var pepe = context as Pepe;
            _restoredStamina += pepe.Stamina;
            pepe.Stamina = _restoredStamina >= pepe.MaxStamina ? _restoredStamina : 0;
        }
    }
}