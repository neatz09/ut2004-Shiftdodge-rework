// Server downloads include the package, but not its .int controls registration.
class ShiftDodgeControlsInteraction extends Interaction;

var float CheckDelay;
var float BindingsDelay;
var bool bBindingsReady;

event Tick(float DeltaTime)
{
    local GUIController GUI;
    local ControlBinder Binder;

    if (ViewportOwner == None)
        return;
    // Q2CTF also waits for the viewport's input profile to finish loading.
    if (!bBindingsReady)
    {
        BindingsDelay += DeltaTime;
        if (BindingsDelay >= 2.0)
            bBindingsReady = class'SingleTapDodgeKeyBinding'.static.InitializeBindings(ViewportOwner.Actor);
    }

    CheckDelay -= DeltaTime;
    if (CheckDelay > 0)
        return;
    CheckDelay = 0.25;

    GUI = GUIController(ViewportOwner.GUIController);
    if (GUI == None)
        return;
    Binder = ControlBinder(GUI.FindMenuByClass(class'ControlBinder'));
    if (Binder != None)
        RegisterControls(Binder);
}

function RegisterControls(ControlBinder Binder)
{
    local int I, K, Index;
    local bool HasSection, Changed;
    local string Binding, KeyName, LocalizedKeyName;

    if (Binder == None || Binder.li_Binds == None)
        return;

    for (I = 0; I < Binder.Bindings.Length; I++)
        if (Binder.Bindings[I].bIsSectionLabel
            && Binder.Bindings[I].KeyLabel ~= class'SingleTapDodgeKeyBinding'.default.KeyData[0].KeyLabel)
            HasSection = True;

    // Checking aliases also avoids duplicates when the client has the .int installed.
    for (I = 1; I < class'SingleTapDodgeKeyBinding'.default.KeyData.Length; I++)
        if (Binder.FindAliasIndex(class'SingleTapDodgeKeyBinding'.default.KeyData[I].Alias) < 0)
        {
            if (!HasSection)
            {
                Binder.CreateAliasMapping("", class'SingleTapDodgeKeyBinding'.default.KeyData[0].KeyLabel, True);
                HasSection = True;
            }
            Binder.CreateAliasMapping(class'SingleTapDodgeKeyBinding'.default.KeyData[I].Alias,
                class'SingleTapDodgeKeyBinding'.default.KeyData[I].KeyLabel, False);
            Changed = True;
        }

    if (!Changed)
        return;

    // Populate both native key columns without rebuilding/resetting the open menu.
    for (K = 1; K < 255; K++)
        if (Binder.Controller.KeyNameFromIndex(byte(K), KeyName, LocalizedKeyName)
            && Binder.Controller.GetCurrentBind(KeyName, Binding))
        {
            Index = Binder.FindAliasIndex(Binding);
            if (Index >= 0)
                Binder.BindKeyToAlias(Index, K);
        }
}

event NotifyLevelChange()
{
    if (Master != None)
        Master.RemoveInteraction(Self);
}

defaultproperties
{
    bActive=False
    bVisible=False
    bRequiresTick=True
}
