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
        if ( EnsureInteraction(PC, InteractionClassName) != None )
        {
                bInteractionAdded = true;
                SetTimer(0.0, false);
        }
}

// Both the local mutator and the owner-only replicator can become ready first.
static function Interaction EnsureInteraction(PlayerController PC, string ClassName)
{
        local int I;

        if ( PC == None || Viewport(PC.Player) == None || PC.Player.InteractionMaster == None )
                return None;

        for ( I = 0; I < PC.Player.LocalInteractions.Length; I++ )
                if ( string(PC.Player.LocalInteractions[I].Class) ~= ClassName )
                        return PC.Player.LocalInteractions[I];

        return PC.Player.InteractionMaster.AddInteraction(ClassName, PC.Player);
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
