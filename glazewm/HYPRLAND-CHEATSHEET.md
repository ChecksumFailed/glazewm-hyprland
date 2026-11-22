# Hyprland -> GlazeWM cheat sheet

Ported from `dotfiles/hyprland-base/.config/hypr/` (custom/keybinds.lua +
hyprland/keybinds.lua). Mod = **SUPER** (`lwin`). Reload config: `SUPER+SHIFT+R`.

## Core (matches Linux exactly)

| Action | Bind | GlazeWM command |
| --- | --- | --- |
| Focus L/D/U/R | `SUPER+H/J/K/L`, `SUPER+Left/Right` | `focus --direction` |
| Move window L/D/U/R | `SUPER+SHIFT+H/J/K/L`, `SUPER+SHIFT+arrows` | `move --direction` |
| Close window | `SUPER+Q` | `close` |
| Fullscreen | `SUPER+F`, `SUPER+SHIFT+F`, `ALT+F` | `toggle-fullscreen` |
| Maximize | `SUPER+ALT+D` | `toggle-maximized` |
| Float toggle | `SUPER+V`, `SUPER+ALT+Space` | `toggle-floating` |
| Toggle split dir | `SUPER+;`, `CTRL+SHIFT+\` | `toggle-tiling-direction` |
| Resize nudge | `SUPER+'` / `SUPER+SHIFT+'` | `resize --width ±2%` |
| Resize mode (HJKL) | `SUPER+R`, exit `ESC`/`Enter` | binding mode `resize` |
| Focus workspace 1-10 | `SUPER+1..0` | `focus --workspace N` |
| Move + follow | `SUPER+SHIFT+1..0` | `move --workspace N` + `focus` |
| Move, stay | `SUPER+ALT+1..0` | `move --workspace N` |
| Next/prev workspace | `SUPER+I`/`SUPER+U`, `SUPER+Down`/`Up`, `SUPER+PageDown/Up`, `CTRL+SUPER+Right/Left` | `focus --next/prev-active-workspace` |
| Hop monitors | `CTRL+SUPER+ALT+Left/Right` | `focus --direction` (crosses edges) |
| Toggle special:magic | `ALT+Space` | `focus --workspace magic` |
| Send to magic | `ALT+SHIFT+Space` | `move --workspace magic` |
| Toggle scratchpad | `SUPER+ALT+`` ` | `focus --workspace scratchpad` |
| Send to scratchpad | `SUPER+ALT+S` | `move --workspace scratchpad` |
| Terminal | `SUPER+Return`, `SUPER+T`, `SUPER+A`, `CTRL+ALT+T` | `shell-exec wt` |
| Brave | `SUPER+B` | `shell-exec brave` |
| File manager | `SUPER+E` | `shell-exec explorer` |
| Launcher | `SUPER+Space` | Flow Launcher |
| Task manager | `SUPER+SHIFT+G`, `CTRL+SHIFT+Esc` | `shell-exec taskmgr` |
| Volume mixer | `CTRL+SUPER+V` | `shell-exec sndvol` |
| Region snip | `SHIFT+Print`, `SUPER+SHIFT+S` | `ms-screenclip:` (grim+slurp feel) |
| Fullscreen snip | `Print`, `CTRL+SUPER+S` | `SnippingTool /clip` |
| Lock | `CTRL+ALT+L` | `LockWorkStation` |
| Sleep | `CTRL+ALT+SHIFT+L` | `SetSuspendState` |
| Shutdown | `CTRL+SHIFT+ALT+SUPER+Delete` | `shutdown /s /t 0` |
| Exit WM | `SUPER+CTRL+E` | `wm-exit` |
| Pause all binds (VM mode) | `SUPER+ALT+F1` | `wm-toggle-pause` |
| Restart bar | `SUPER+SHIFT+Q` | restarts Zebar (was Noctalia restart) |
| Wallpaper settings | `CTRL+SUPER+T`, `ALT+W` | `ms-settings:personalization-background` |
| Theme settings | `CTRL+SUPER+SHIFT+D` | `ms-settings:colors` |

## Left to Windows itself (no GlazeWM bind on purpose)

| Action | Use |
| --- | --- |
| Notifications | `WIN+N` |
| Clipboard history | `WIN+V` |
| Emoji picker | `WIN+.` |
| Screen zoom | `WIN+Plus` / `WIN+Minus` (Magnifier) |
| Alt-tab switcher | `ALT+Tab`, `WIN+Tab` |
| Screen record | `WIN+ALT+R` (Game Bar) |
| Show desktop | `WIN+D` |

## Not ported (no GlazeWM equivalent)

- `SUPER+Grave` swapwithmaster, `SUPER+[/]` consume/expel, `CTRL+\` pseudo,
  `CTRL+SUPER+\` resize-to-640x480 — GlazeWM's BSP tree has no master layout.
- Animations, blur, shadows, dim curves.
- Media/volume on `ALT+V/C/X/B/Z`, `ALT+[/]`, `ALT+/`, `ALT+\` — your keyboard's
  hardware media keys are handled by Windows natively.
- `SUPER+C` editor, `SUPER+Y` yazi, `SUPER+X` cmus, `SUPER+M` Telegram,
  `CTRL+SUPER+SHIFT+ALT+W` office — apps aren't installed on the Windows side;
  stubs are commented in `config.yaml`.

## Known caveats

- **`SUPER+L`** (focus right) is swallowed by Windows (locks the session) until
  you run `scripts\unlock-win-l.ps1`.
- **Flow Launcher's default hotkey is `ALT+Space`** (your magic-workspace bind).
  Change it to e.g. `CTRL+ALT+Space` in Flow Launcher settings -> Hotkey.
- Scratchpad = normal workspaces `magic`/`scratchpad` + `toggle_workspace_on_refocus`.
  Refocusing the workspace you're on jumps back, i.e. toggles.
