//====================================================================================
// Shift Dodge 2 - Interaction
// by Chatouille
//====================================================================================
class ShiftDodgeTwoInt extends Interaction;

var bool bHoldingShift;
var Actor.EDoubleClickDir lastDClick;

var string keyForward;
var string keyBackward;
var string keyLeft;
var string keyRight;
var ShiftDodgeReplicator Replicator;

event Initialized()
{
	keyForward = Class'GameInfo'.static.GetKeyBindName("moveforward", ViewportOwner.Actor);
	keyBackward = Class'GameInfo'.static.GetKeyBindName("movebackward", ViewportOwner.Actor);
	keyLeft = Class'GameInfo'.static.GetKeyBindName("strafeleft", ViewportOwner.Actor);
	keyRight = Class'GameInfo'.static.GetKeyBindName("straferight", ViewportOwner.Actor);
}
/*close*/

function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
{
	local PlayerController PC;
	local string keyName;
	local Actor.EDoubleClickDir Dir;

	if ( ViewportOwner == None || ViewportOwner.Actor == None )
		return Super.KeyEvent(Key, Action, Delta);

	PC = ViewportOwner.Actor;
	keyName = GetFriendlyName(Key);

	if ( keyName ~= "Shift" )
	{
		bHoldingShift = (Action == IST_Press);
		lastDClick = PC.DoubleClickDir;
		return true;
	}
	else if ( bHoldingShift && PC.Pawn != None && PC.DoubleClickDir < DCLICK_Active && Action == IST_Press )
	{
		if ( Replicator == None )
			Replicator = FindReplicator(PC);
		if ( keyName ~= keyForward )
			Dir = DCLICK_Forward;
		else if ( keyName ~= keyBackward )
			Dir = DCLICK_Back;
		else if ( keyName ~= keyLeft )
			Dir = DCLICK_Left;
		else if ( keyName ~= keyRight )
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