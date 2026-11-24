class SingleTapDodgeKeyBinding extends GUIUserKeyBinding
    config(User);

var config bool bBindingInitialized;

static function EnsureControls(PlayerController PC)
{
    local int I;

    if (PC == None || Viewport(PC.Player) == None || PC.Player.InteractionMaster == None)
        return;

    // The .int is optional: downloaded clients register the controls at runtime.
    for (I = 0; I < PC.Player.LocalInteractions.Length; I++)
        if (ShiftDodgeControlsInteraction(PC.Player.LocalInteractions[I]) != None)
            break;
    if (I == PC.Player.LocalInteractions.Length)
        PC.Player.InteractionMaster.AddInteraction(string(class'ShiftDodgeControlsInteraction'), PC.Player);
}

static function bool InitializeBindings(PlayerController PC)
{
    local string Existing;

    if (PC == None || Viewport(PC.Player) == None)
        return False;

    if (default.bBindingInitialized)
        return True;

    if (PC.ConsoleCommand("BINDINGTOKEY holdingshift") == "")
    {
        Existing = PC.ConsoleCommand("KEYBINDING Shift");
        // Shift was already consumed by older versions; Walking is its stock bind.
        if (Existing == "" || Existing ~= "Walking")
        {
            PC.ConsoleCommand("SET Input Shift holdingshift");
            if (!(PC.ConsoleCommand("KEYBINDING Shift") ~= "holdingshift"))
                return False;
        }
        else
            PC.ClientMessage("Shift Dodge: choose OneTapDodge in Settings > Input > Configure Controls.");
    }

    // Do this once so clearing the binding in Controls stays cleared on reconnect.
    default.bBindingInitialized = True;
    StaticSaveConfig();
    return True;
}

defaultproperties
{
    KeyData(0)=(KeyLabel="Single Tap Dodge",bIsSection=True)
    KeyData(1)=(Alias="holdingshift",KeyLabel="OneTapDodge")
}
