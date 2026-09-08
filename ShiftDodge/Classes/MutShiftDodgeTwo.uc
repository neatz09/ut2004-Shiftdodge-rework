//====================================================================================
// Shift Dodge 2 - Mutator
// by Chatouille
//====================================================================================
class MutShiftDodgeTwo extends Mutator;

var bool bHasInteraction;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.5, true);
}

simulated function Timer()
{
	local Controller C;
	local PlayerController PC;

	if ( Role == ROLE_Authority )
	{
		for ( C = Level.ControllerList; C != None; C = C.NextController )
		{
			PC = PlayerController(C);
			if ( PC != None && FindReplicator(PC) == None )
				SpawnReplicator(PC);
		}
	}
}

function ModifyPlayer(Pawn Other)
{
	local PlayerController PC;

	Super.ModifyPlayer(Other);
	PC = PlayerController(Other.Controller);
	if ( PC != None && FindReplicator(PC) == None )
		SpawnReplicator(PC);
}

function Mutate(string MutateString, PlayerController Sender)
{
	Super.Mutate(MutateString, Sender);
	if ( Sender == None || Sender.Pawn == None ||
		!(MutateString ~= "ShiftDodge Forward") &&
		!(MutateString ~= "ShiftDodge Back") &&
		!(MutateString ~= "ShiftDodge Left") &&
		!(MutateString ~= "ShiftDodge Right") )
		return;

	if ( MutateString ~= "ShiftDodge Forward" )
		Sender.Pawn.Dodge(DCLICK_Forward);
	else if ( MutateString ~= "ShiftDodge Back" )
		Sender.Pawn.Dodge(DCLICK_Back);
	else if ( MutateString ~= "ShiftDodge Left" )
		Sender.Pawn.Dodge(DCLICK_Left);
	else
		Sender.Pawn.Dodge(DCLICK_Right);
	Sender.DoubleClickDir = DCLICK_Active;
}

function ShiftDodgeReplicator SpawnReplicator(PlayerController PC)
{
	local ShiftDodgeReplicator Replicator;

	Replicator = Spawn(class'ShiftDodgeReplicator', PC);
	if ( Replicator != None )
		Replicator.InteractionClassName = string(class'ShiftDodgeTwoInt');
	return Replicator;
}

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

simulated function ShiftDodgeReplicator FindReplicator(PlayerController PC)
{
	local ShiftDodgeReplicator Replicator;

	foreach AllActors(class'ShiftDodgeReplicator', Replicator)
	{
		if ( Replicator.Owner == PC )
			return Replicator;
	}
	return None;
}
/*close*/

defaultproperties
{
	FriendlyName="Shift Dodge v2"
	Description="Shift Dodge 2 - hold shift and press movement key to dodge"
	bAlwaysRelevant=true
	RemoteRole=ROLE_SimulatedProxy
}
