# Downloaded client controls validation

## Implementation references

The runtime menu registration follows `Q2ControlsInteraction.RegisterControls` in
the local Q2CTF v12 test sources. The GitHub Q2CTF prototype only contains the
`.int`-based `Q2CTFKeyBinding` declaration, so that declaration alone does not solve
the server-download case.

The UT2004 script source confirms the relevant APIs:

- `XRelics.XRelicsCPOptions.OpenBinder` opens `GUI2K4.ControlBinder`, confirming
  that XRelics uses the same native controls menu used by this change.
- `GUI2K4.ControlBinder.LoadCustomBindings` discovers custom controls through local
  `.int` files. Server downloads do not supply this registration file.
- `GUI2K4.KeyBindMenu.CreateAliasMapping`, `FindAliasIndex`, and `BindKeyToAlias`
  support adding and populating the entry in the existing native menu.
- `GUI2K4.KeyBindMenu.SetKeyBind` uses the controller's native input binding API.
- `Engine.Interactions.GetFriendlyName` returns the canonical input key name.
- `Engine.InteractionMaster.AddInteraction` appends local interactions without
  checking for an existing instance; the mod now checks before adding one.
- `Engine.Mutator.PreBeginPlay` adds the package to the download map when
  `bAddToServerPackages=True`.

## Checks performed on November 24, 2026

- Sweeney `uccheck.py`: seven active package classes checked; no findings.
- Sweeney `upredict.py`: `ok`, no errors, no unmodelled constructs.
- A fresh UCC compile parsed and compiled all seven classes, imported their
  defaults, and exported both mutator cache records: **0 errors, 0 warnings**.
  Compiler: Win64 UCC 3374, compiled July 18, 2026, 20:29:44.
- An isolated dedicated server loaded `DM-Rankin` with
  `ShiftDodge.MutShiftDodge` and reached game initialization.
- A separate client was staged without `ShiftDodge.u` or `ShiftDodge.int`.
  Windows refused to launch its game executable with **Illegal System DLL
  Relocation**, so no successful package download, GUI interaction, persistence,
  or online dodge behavior was observed. These remain acceptance checks below.

No production installation or server was modified by these checks.

## Live acceptance checks

Use a dedicated test server and a separate client, initially with no dodge package,
`.int`, cached package, or existing dodge initialization marker. Run each mutator
separately.

1. Join and allow the server to download the package. While connected, open
   Settings > Input > Configure Controls. Confirm exactly one Single Tap Dodge
   section and one OneTapDodge action, initially bound to Shift on a stock profile.
2. Change the primary key to an unused key. Close the menu and verify v1/v2 uses
   that key immediately. Confirm the old key no longer dodges. Repeat with the
   secondary key column and verify both assigned keys work.
3. Close and reopen Controls, then use Reset and reopen it again. Confirm runtime
   registration restores one entry without duplicates. Check normal movement.
4. Reconnect, travel to another map, and restart the client. Confirm the chosen
   binding persists and that a single dodge press is handled once.
5. Clear both dodge keys. Confirm Shift does not become an implicit fallback,
   including after reconnecting and restarting the client.
6. On fresh profiles, test an existing custom dodge binding and an unrelated
   custom Shift binding. Confirm neither is replaced by default initialization.
7. Repeat with `ShiftDodge.int` installed locally. Confirm the runtime interaction
   does not add duplicate controls. Also check a listen-server host.

To repeat first-run initialization on a disposable test profile, remove only the
`[ShiftDodge.SingleTapDodgeKeyBinding]` section of that test client's `User.ini`.
Keep ordinary user settings intact.
