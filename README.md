This is a rework of the shiftdodge mutator(v1 and v2) that adds replication for online play. currently "works" but not fully tested.
Original source by Chatouille

The dodge key can be changed while connected to a server running either mutator:

1. Open **Settings > Input > Configure Controls**.
2. Find **Single Tap Dodge > OneTapDodge**.
3. Assign the key in either native key column. The change takes effect immediately.

The controls entry is registered at runtime, following Q2CTF's downloaded-client
controls interaction. Clients only need the server-downloaded `ShiftDodge.u`;
`ShiftDodge.int` is optional. Installing the `.int` locally also makes the entry
available outside a match. Runtime registration avoids duplicating that entry.

Both versions use the same binding (`holdingshift`): v1 presses the dodge key while
moving; v2 holds the dodge key and then presses a movement key. Shift is initialized
once if it is unbound or still assigned to the stock `Walking` command. Existing
dodge bindings and custom Shift commands are preserved. Changing or clearing the
binding through Controls is saved in the client's `User.ini` and respected on
reconnect. There is no hardcoded Shift fallback after a binding is cleared.

Server setup: compile the `ShiftDodge/Classes` sources using your normal UCC build
workflow and install the resulting `ShiftDodge.u` in the server's `System` folder.
Run **one** of `ShiftDodge.MutShiftDodge` or `ShiftDodge.MutShiftDodgeTwo`. Both
automatically add the package to the server package map. Update a redirect copy if
your server uses one. Rebuilding an existing package changes its GUID; clients with
an older manually installed `System/ShiftDodge.u` must remove or update that copy.
