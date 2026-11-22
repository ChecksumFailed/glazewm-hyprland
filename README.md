# glazewm-hyprland

A [GlazeWM](https://github.com/glzr-io/glazewm) + [Zebar](https://github.com/glzr-io/zebar)
setup for Windows 11 that mimics my Linux [Hyprland](https://hyprland.org) desktop,
ported from my Lua-configured Hyprland dotfiles.

I dual-boot and kept losing muscle memory on the Windows side, so this maps the
Hyprland keybinds, gaps, colors, and bar layout onto GlazeWM as closely as the
two allow.

## What you get

- **SUPER (Win key) as mod**, HJKL focus/move, `SUPER+Q` close, `SUPER+F`
  fullscreen, `SUPER+V` float toggle — identical muscle memory to Hyprland.
- **Workspaces 1–10 pinned per monitor** (like `persistent` workspaces), with
  `SUPER+1..0` focus / `SUPER+SHIFT+1..0` move+follow / `SUPER+ALT+1..0` move.
- **Scratchpad emulation** for Hyprland special workspaces: `magic` and
  `scratchpad` workspaces toggle via `ALT+Space` / `SUPER+ALT+`` ` using
  `toggle_workspace_on_refocus`.
- **Hyprland-ish visuals**: `gaps_in 4 / gaps_out 5`, rounded corners, slate
  active border (`#44464f`), subtle 95% dim on unfocused windows.
- **Waybar-style Zebar bar** (`zebar/hypr-bar/`): workspace pills + focused
  window title left, clock center, system stats right, in a dark palette with a
  cyan accent.
- **Flow Launcher** as the rofi/launcher stand-in on `SUPER+Space`.
- Region/fullscreen screenshots bound like grim+slurp (`SHIFT+Print`, `Print`).

## Requirements

- **Windows 11** (colored borders / rounded corners are Win11-only APIs).
- **Local admin rights** — GlazeWM's executable manifest requires elevation.
  On a corporate laptop without admin, this setup cannot run.
- [winget](https://learn.microsoft.com/windows/package-manager/winget/) for the
  app installs (or use `-SkipApps` and install manually).

## Install

```powershell
git clone https://github.com/ChecksumFailed/glazewm-hyprland.git
cd glazewm-hyprland
powershell -ExecutionPolicy Bypass -File install.ps1
```

Optional switches:

| Switch | Effect |
| --- | --- |
| `-SkipApps` | Only copy configs, no winget installs |
| `-NoWinKeys` | Disable Windows' built-in Win-key shortcuts so `SUPER+number` etc. reach GlazeWM (needs admin) |
| `-UnlockWinL` | Stop `Win+L` locking so `SUPER+L` (focus right) works. **Not for work machines** — `Ctrl+Alt+L` is bound to lock instead |

Existing configs are timestamped-backed-up before being overwritten.

## Repo layout

```
glazewm/
  config.yaml              # the WM config (keybinds, gaps, rules, workspaces)
  HYPRLAND-CHEATSHEET.md   # full Hyprland -> GlazeWM keybind mapping
  scripts/
    apply-win-key-fixes.ps1  # NoWinKeys tweak (elevated)
    unlock-win-l.ps1         # DisableLockWorkstation tweak (elevated)
zebar/
  settings.json            # points Zebar at the local hypr-bar pack
  hypr-bar/                # Waybar-style widget pack (HTML/CSS, zpack.json)
install.ps1
```

## Honest differences from Hyprland

- **No dwindle/master layout** — GlazeWM is BSP-style splits with a
  `toggle-tiling-direction` command. No consume/expel, no swapwithmaster.
- **No animations, blur, or real dimming** — GlazeWM doesn't do window
  animations; the "dim" is a 95% transparency on unfocused windows.
- **`magic`/`scratchpad` aren't true special workspaces** — they're regular
  workspaces with a refocus-toggle trick. Same rhythm, not an overlay.
- **Some Win-key combos are OS-reserved.** `SUPER+L` locks the session unless
  `-UnlockWinL` is applied; bare Win still opens the Start menu.

## Work-laptop caveats

- No local admin → no GlazeWM, full stop. FancyZones (PowerToys) is the best
  fallback that runs without admin.
- Group Policy can override the `NoWinKeys` registry tweak. If `SUPER+number`
  opens taskbar apps again, unpin everything from the taskbar as a workaround.
- Don't disable `Win+L` lock on managed machines.

## Credits

- [glzr-io/glazewm](https://github.com/glzr-io/glazewm) and
  [glzr-io/zebar](https://github.com/glzr-io/zebar) — the hard parts.
- The Zebar widget is a retheme of the official `glzr-io.starter` pack.
