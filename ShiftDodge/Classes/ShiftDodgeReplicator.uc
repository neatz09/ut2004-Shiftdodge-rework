class ShiftDodgeReplicator extends Actor;

var string InteractionClassName;
var bool bInteractionAdded;

replication
{
        reliable if ( Role == ROLE_Authority )
                InteractionClassName;
        reliable if ( Role < ROLE_Authority )
                ServerDodge;
}

simulated event PostNetBeginPlay()
{
        Super.PostNetBeginPlay();
        SetTimer(0.5, true);
}

simulated function Timer()
{
        local PlayerController PC;

        if ( bInteractionAdded || InteractionClassName == "" )
                return;

        PC = PlayerController(Owner);
        if ( PC != None && PC.Player != None && PC.Player.InteractionMaster != None )
        {
                PC.Player.InteractionMaster.AddInteraction(InteractionClassName, PC.Player);
                bInteractionAdded = true;
                SetTimer(0.0, false);
        }
}

function ServerDodge(Actor.EDoubleClickDir Dir)
{
        if ( Dir < DCLICK_Forward || Dir > DCLICK_Right )
                return;

        if ( PlayerController(Owner) != None &&
                PlayerController(Owner).Pawn != None )
        {
                PlayerController(Owner).Pawn.Dodge(Dir);
                PlayerController(Owner).DoubleClickDir = DCLICK_Active;
        }
}

defaultproperties
{
        RemoteRole=ROLE_AutonomousProxy
        bOnlyRelevantToOwner=true
        bAlwaysRelevant=false
}