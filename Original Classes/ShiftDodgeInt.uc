//====================================================================================
// Shift Dodge - Interaction
// by Chatouille
//====================================================================================
class ShiftDodgeInt extends Interaction;

var bool bHoldingShift;
var Actor.EDoubleClickDir lastDClick;

var string keyForward;
var string keyBackward;
var string keyLeft;
var string keyRight;

var array<Actor.EDoubleClickDir> activeDir;

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

	if ( keyName ~= keyForward )
		updateDir(DCLICK_Forward, (Action == IST_Press));
	else if ( keyName ~= keyBackward )
		updateDir(DCLICK_Back, (Action == IST_Press));
	else if ( keyName ~= keyLeft )
		updateDir(DCLICK_Left, (Action == IST_Press));
	else if ( keyName ~= keyRight )
		updateDir(DCLICK_Right, (Action == IST_Press));
	else if ( keyName ~= "Shift" && Action == IST_Press && PC.Pawn != None )
	    {
		if ( activeDir.length > 0 && PC.DoubleClickDir < DCLICK_Active )
		{
			PC.Pawn.Dodge(activeDir[0]);
			PC.DoubleClickDir = DCLICK_Active;
		}
		return true;
	}
	return Super.KeyEvent(Key, Action, Delta);
}
/*close*/

function updateDir(Actor.EDoubleClickDir dir, bool press)
{
	local int i;

	if ( press && activeDir[0] != dir )
	{
		activeDir.Insert(0,1);
		activeDir[0] = dir;
	}
	else if ( !press )
	{
		for ( i=0; i<activeDir.length; i++ )
		{
			if ( activeDir[i] == dir )
			{
				activeDir.Remove(i,1);
				i--;
			}
		}
	}
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