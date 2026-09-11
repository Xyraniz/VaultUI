# VaultUI

**+20 Roblox UI libraries archived in one place, source files, working examples, and previews for each one.**

[![Stars](https://img.shields.io/github/stars/Xyraniz/VaultUI?style=for-the-badge&color=gold)](https://github.com/Xyraniz/VaultUI/stargazers)
[![Lua](https://img.shields.io/badge/Lua-000080?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)
[![Roblox](https://img.shields.io/badge/Roblox-00A2FF?style=for-the-badge&logo=roblox&logoColor=white)](https://www.roblox.com/)
[![Last Updated](https://img.shields.io/badge/last%20updated-August%202026-blue?style=for-the-badge)](https://github.com/Xyraniz/VaultUI/commits/main)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen?style=for-the-badge)](#contributing)

## What this is

Roblox UI libraries get shared through Discord servers, Pastebin links, and forum threads that go dead after a few months. VaultUI keeps +20 of them in one repository, each with its original `source.lua` when it could be preserved, a runnable `example.lua` built against that library's real API, and showcase in the web, for a quick visual reference before you commit to one

It's meant for scripters comparing UI layers before starting a hub, and for anyone who wants a loadstring that still works next year instead of a link that 404s

## Web catalog

— https://xyraniz.github.io/VaultUI/

## Folder layout

Every library lives under `Libraries/<Name>/` with the same two files:

```
Libraries/<LibraryName>/
├── source.lua      # preserved original source, when available
├── example.lua     # working usage sample for that library's API
```

Not every library ships with `source.lua` — some (Daino, Hook GUI) are loadstring-only rather than missing by accident.

## Quick start

Load a library straight from its preserved source with `loadstring`. This is BaconLib:

```lua
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Bacon/source.lua"))()
local window = lib:CreateWindow("My Hub")

window:Button("Click me", function()
    print("It works!")
end)
```

Swap `Bacon` for any folder name under `Libraries/` and check that library's `example.lua` — constructor names and method signatures differ between them, so BaconLib's API won't necessarily match another library's.

## Contributing

To add a library, open a PR with a new folder under `Libraries/<Name>/` containing:

1. `source.lua`, if the original file is redistributable.
2. An `example.lua` that actually exercises the library's public methods — not a placeholder.
3. A `showcase.png` at that exact path, so the web shelf and its deploy workflow pick it up without extra configuration.

check the library before adding it, broken links, dead loadstrings or outdated sources go in [Issues](https://github.com/Xyraniz/VaultUI/issues).

## A note on staleness

If you authored one of these libraries and want it removed, credited differently, or updated, open an issue or contact [Xyraniz](https://github.com/Xyraniz) directly.
