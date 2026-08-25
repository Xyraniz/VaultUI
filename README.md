# VaultUI

**A curated collection of 20 free Roblox UI libraries with source files, runnable examples, MP4 showcase videos and ready-to-use loadstrings.**

[![Stars](https://img.shields.io/github/stars/Xyraniz/VaultUI?style=for-the-badge&color=gold)](https://github.com/Xyraniz/VaultUI/stargazers)[![Lua](https://img.shields.io/badge/Lua-000080?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)[![Roblox](https://img.shields.io/badge/Roblox-00A2FF?style=for-the-badge&logo=roblox&logoColor=white)](https://www.roblox.com/)[![Last Updated](https://img.shields.io/badge/last%20updated-August%202026-blue?style=for-the-badge)](https://github.com/Xyraniz/VaultUI/commits/main)[![License](https://img.shields.io/badge/license-MIT%20%26%20Original%20Licenses-green?style=for-the-badge)](#license--attribution)

## About

**VaultUI** is a centralized archive of Roblox UI libraries organized for developers, scripters and enthusiasts. Each library includes a runnable `example.lua` and a `showcase.mp4` video asset that can be replaced by a real capture when the library is inspected in Roblox; preserved `source.lua` files are included whenever the repository contains them. The web shelf loads those videos directly and never embeds an HTML simulator.

The collection is useful when prototyping a hub, studying Luau interface architecture or comparing lightweight UI layers. Each folder keeps its usage example and any preserved library source together so the repository remains easy to browse and migrate.

## Included assets

| Asset | Purpose |
| --- | --- |
| `source.lua` | Preserved library source supplied by the collection, when available. |
| `example.lua` | A complete usage sample based on the library's public API. |
| `showcase.mp4` | An MP4 interface video used by the VaultUI shelf. Replace it with a real Roblox capture without changing the web code. |

## Libraries

| # | Library | Type | Source | Example | Showcase |
| --- | --- | --- | --- | --- | --- |
| 1 | 0x37 | Loadstring + backup | [Source](Libraries/0x37/source.lua) | [Example](Libraries/0x37/example.lua) | [Showcase](Libraries/0x37/showcase.mp4) |
| 2 | Apple Library | Source | [Source](Libraries/Apple/source.lua) | [Example](Libraries/Apple/example.lua) | [Showcase](Libraries/Apple/showcase.mp4) |
| 3 | Avilon (Modified) | Source | [Source](Libraries/Avilon-Modified/source.lua) | [Example](Libraries/Avilon-Modified/example.lua) | [Showcase](Libraries/Avilon-Modified/showcase.mp4) |
| 4 | Aztup | Loadstring + source | [Source](Libraries/Aztup/source.lua) | [Example](Libraries/Aztup/example.lua) | [Showcase](Libraries/Aztup/showcase.mp4) |
| 5 | BaconLib | Source | [Source](Libraries/Bacon/source.lua) | [Example](Libraries/Bacon/example.lua) | [Showcase](Libraries/Bacon/showcase.mp4) |
| 6 | BlekLib | Loadstring + source | [Source](Libraries/Blek/source.lua) | [Example](Libraries/Blek/example.lua) | [Showcase](Libraries/Blek/showcase.mp4) |
| 7 | Criminality UI Lib | Loadstring + source | [Source](Libraries/Criminality-Lib/source.lua) | [Example](Libraries/Criminality-Lib/example.lua) | [Showcase](Libraries/Criminality-Lib/showcase.mp4) |
| 8 | Daino | Loadstring | — | [Example](Libraries/Daino/example.lua) | [Showcase](Libraries/Daino/showcase.mp4) |
| 9 | DarkraiX | Source | [Source](Libraries/DarkraiX/source.lua) | [Example](Libraries/DarkraiX/example.lua) | [Showcase](Libraries/DarkraiX/showcase.mp4) |
| 10 | Dirt | Loadstring + source | [Source](Libraries/Dirt/source.lua) | [Example](Libraries/Dirt/example.lua) | [Showcase](Libraries/Dirt/showcase.mp4) |
| 11 | Discord Lib | Loadstring | [Source](Libraries/Discord-Lib/source.lua) | [Example](Libraries/Discord-Lib/example.lua) | [Showcase](Libraries/Discord-Lib/showcase.mp4) |
| 12 | Flux UI | Loadstring + source | [Source](Libraries/Flux/source.lua) | [Example](Libraries/Flux/example.lua) | [Showcase](Libraries/Flux/showcase.mp4) |
| 13 | FriseX | Loadstring + source | [Source](Libraries/FriseX/source.lua) | [Example](Libraries/FriseX/example.lua) | [Showcase](Libraries/FriseX/showcase.mp4) |
| 14 | Fuzki | Loadstring + source | [Source](Libraries/Fuzki/source.lua) | [Example](Libraries/Fuzki/example.lua) | [Showcase](Libraries/Fuzki/showcase.mp4) |
| 15 | Gostmi | Source | [Source](Libraries/Gostmi/source.lua) | [Example](Libraries/Gostmi/example.lua) | [Showcase](Libraries/Gostmi/showcase.mp4) |
| 16 | Hook GUI | Loadstring | — | [Example](Libraries/Hook/example.lua) | [Showcase](Libraries/Hook/showcase.mp4) |
| 17 | NexusLib | Source | [Source](Libraries/NexusLib/source.lua) | [Example](Libraries/NexusLib/example.lua) | [Showcase](Libraries/NexusLib/showcase.mp4) |
| 18 | SynergyUI | Source | [Source](Libraries/SynergyUI/source.lua) | [Example](Libraries/SynergyUI/example.lua) | [Showcase](Libraries/SynergyUI/showcase.mp4) |
| 19 | Armenta-Lib | Source | [Source](Libraries/Armenta-Lib/source.lua) | [Example](Libraries/Armenta-Lib/example.lua) | [Showcase](Libraries/Armenta-Lib/showcase.mp4) |
| 20 | WindUI-Shiny | Source | [Source](Libraries/WindUI-Shiny/source.lua) | [Example](Libraries/WindUI-Shiny/example.lua) | [Showcase](Libraries/WindUI-Shiny/showcase.mp4) |

## Quick Start

A library can be loaded from its example file or directly from the preserved source. This is a minimal BaconLib usage example:

```lua
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Bacon/source.lua" ))()
local window = lib:CreateWindow("My Hub")
window:Button("Click me", function()
    print("It works!")
end)
```

Each library folder follows the same layout:

```
Libraries/<LibraryName>/
├── source.lua
├── example.lua
└── showcase.mp4
```

## Contributing

To add a library, create a folder under `Libraries/` with its source, a complete `example.lua` that follows the library's actual public API and a `showcase.mp4` video capture. Keep the video path exactly at `Libraries/<LibraryName>/showcase.mp4` so the shelf and deployment workflow can discover it automatically.

Report broken links or source issues through the [issue tracker](https://github.com/Xyraniz/VaultUI/issues). Contributions should preserve the original author's attribution and license terms.

## Notices

Some libraries may stop functioning if their original repositories change or public endpoints are removed. The collection preserves the files that were available at the time of import; verify the original author's terms before distributing a project that includes one of these libraries.

## License & Attribution

This repository is a preservation and archival collection. The included libraries belong to their original authors and remain under their respective original licenses. If you are an original author and would like a library removed or updated, please contact [xyraniz](https://github.com/Xyraniz) through GitHub.
