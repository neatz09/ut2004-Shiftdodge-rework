//====================================================================================
// Shift Dodge 2 - Interaction
// by Chatouille
//====================================================================================
class ShiftDodgeTwoInt extends Interaction;

var bool bHoldingShift;
var Actor.EDoubleClickDir lastDClick;

var string HeldDodgeKey;
var ShiftDodgeReplicator Replicator;

event Initialized()
{
	class'SingleTapDodgeKeyBinding'.static.EnsureControls(ViewportOwner.Actor);
}
/*close*/

function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
{
	local PlayerController PC;
	local string keyName;
	local string Binding;
	local Actor.EDoubleClickDir Dir;

	if ( ViewportOwner == None || ViewportOwner.Actor == None )
		return Super.KeyEvent(Key, Action, Delta);

	PC = ViewportOwner.Actor;
	keyName = GetFriendlyName(Key);
	if (Action != IST_Press && Action != IST_Release)
		return Super.KeyEvent(Key, Action, Delta);
	Binding = PC.ConsoleCommand("KEYBINDING" @ keyName);
	if (bHoldingShift && !(PC.ConsoleCommand("KEYBINDING" @ HeldDodgeKey) ~= "holdingshift"))
		bHoldingShift = false;

	if ( Binding ~= "holdingshift" )
	{
		bHoldingShift = (Action == IST_Press);
		HeldDodgeKey = keyName;
		lastDClick = PC.DoubleClickDir;
		return true;
	}
	else if ( bHoldingShift && PC.Pawn != None && PC.DoubleClickDir < DCLICK_Active && Action == IST_Press )
	{
		if ( Replicator == None )
			Replicator = FindReplicator(PC);
		if ( Binding ~= "moveforward" )
			Dir = DCLICK_Forward;
		else if ( Binding ~= "movebackward" )
			Dir = DCLICK_Back;
		else if ( Binding ~= "strafeleft" )
			Dir = DCLICK_Left;
		else if ( Binding ~= "straferight" )
			Dir = DCLICK_Right;
		else
			return Super.KeyEvent(Key, Action, Delta);

		if ( SendDodge(PC, Dir) )
			PC.DoubleClickDir = DCLICK_Active;
	}
	return Super.KeyEvent(Key, Action, Delta);
}
/*close*/

function bool SendDodge(PlayerController PC, Actor.EDoubleClickDir Dir)
{
	if ( Dir == DCLICK_Forward )
		PC.ConsoleCommand("mutate ShiftDodge Forward");
	else if ( Dir == DCLICK_Back )
		PC.ConsoleCommand("mutate ShiftDodge Back");
	else if ( Dir == DCLICK_Left )
		PC.ConsoleCommand("mutate ShiftDodge Left");
	else
		PC.ConsoleCommand("mutate ShiftDodge Right");
	return true;
}

function ShiftDodgeReplicator FindReplicator(PlayerController PC)
{
	local ShiftDodgeReplicator Candidate;

	foreach PC.AllActors(class'ShiftDodgeReplicator', Candidate)
	{
		if ( Candidate.Owner == PC )
			return Candidate;
	}
	return None;
}

event NotifyLevelChange()
{
	if ( Master != None )
		Master.RemoveInteraction(Self);
}
/*close*/

defaultproperties
{
	bActive=true
}
