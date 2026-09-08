//====================================================================================
// Shift Dodge - Mutator
// by Chatouille
//====================================================================================
class MutShiftDodge extends Mutator;

var bool bHasInteraction;

simulated function Tick(float DeltaTime)
{
	local PlayerController PC;

	if ( bHasInteraction )
		return;

	PC = Level.GetLocalPlayerController();
	if ( PC != None )
	{
		PC.Player.InteractionMaster.AddInteraction(string(class'ShiftDodgeInt'), PC.Player);
		bHasInteraction = true;
		Disable('Tick');
	}
}
/*close*/

defaultproperties
{
	FriendlyName="Shift Dodge v1"
	Description="Shift Dodge 1 - press shift while holding movement key to dodge"
	bAlwaysRelevant=true
	RemoteRole=ROLE_SimulatedProxy
}
