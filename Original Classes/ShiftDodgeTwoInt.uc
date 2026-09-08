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
		if ( keyName ~= keyForward )
			PC.Pawn.Dodge(DCLICK_Forward);
		else if ( keyName ~= keyBackward )
			PC.Pawn.Dodge(DCLICK_Back);
		else if ( keyName ~= keyLeft )
			PC.Pawn.Dodge(DCLICK_Left);
		else if ( keyName ~= keyRight )
			PC.Pawn.Dodge(DCLICK_Right);
		else
			return Super.KeyEvent(Key, Action, Delta);

		PC.DoubleClickDir = DCLICK_Active;
	}
	return Super.KeyEvent(Key, Action, Delta);
}
/*close*/

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