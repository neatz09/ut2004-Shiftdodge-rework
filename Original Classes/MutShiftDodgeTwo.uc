//====================================================================================
// Shift Dodge 2 - Mutator
// by Chatouille
//====================================================================================
class MutShiftDodgeTwo extends Mutator;

var bool bHasInteraction;

simulated function Tick(float DeltaTime)
{
	local PlayerController PC;

	if ( bHasInteraction )
		return;

	PC = Level.GetLocalPlayerController();
	if ( PC != None )
	{
		PC.Player.InteractionMaster.AddInteraction(string(class'ShiftDodgeTwoInt'), PC.Player);
		bHasInteraction = true;
		Disable('Tick');
	}
}
/*close*/

defaultproperties
{
	FriendlyName="Shift Dodge v2"
	Description="Shift Dodge 2 - hold shift and press movement key to dodge"
	bAlwaysRelevant=true
	RemoteRole=ROLE_SimulatedProxy
}
