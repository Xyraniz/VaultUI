<div align="center">

# UI-Libs

**A curated collection of 20+ free Roblox UI libraries — with sources, interactive previews, and ready-to-use loadstrings.**

[![Stars](https://img.shields.io/github/stars/Xyraniz/UI-Libs?style=for-the-badge&color=gold)](https://github.com/Xyraniz/UI-Libs/stargazers)[![Lua](https://img.shields.io/badge/Lua-000080?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)[![Roblox](https://img.shields.io/badge/Roblox-00A2FF?style=for-the-badge&logo=roblox&logoColor=white)](https://www.roblox.com/)[![Last Updated](https://img.shields.io/badge/last%20updated-August%202026-blue?style=for-the-badge)](https://github.com/Xyraniz/UI-Libs/commits/main)[![License](https://img.shields.io/badge/license-MIT%20%26%20Original%20Licenses-green?style=for-the-badge)](#license--attribution)

</div>

---

## About

**UI-Libs** is a centralized archive of popular **UI frameworks used across the Roblox community**, organized in one place for developers, scripters, and enthusiasts. Every library includes its full source code and a working loadstring; selected libraries also include an interactive HTML preview so you can explore the interface before loading anything.

Whether you are prototyping a hub, learning how GUI libraries are structured in Luau, or looking for a lightweight UI layer for your project, this collection gives you direct access to well-known frameworks such as **BaconLib, Flux, Aztup, Blek, and many more** — no hunting through scattered repositories required.

### Why use this collection?

- **Everything in one place.** 15+ UI libraries from different original authors, archived and organized by name.

- **Full source included.** Every `source.lua` is stored in this repository, so a library never disappears if the original repo goes down.

- **Ready-to-use loadstrings.** Each `example.lua` shows how to load and use the library with a single `game:HttpGet` call.

- **Interactive previews.** HTML showcases for SynergyUI, BaconLib, and Armenta-Lib make their controls clickable and easy to inspect on desktop or mobile.

---

## Libraries

| # | Library | Type | Source | Example | Preview |
| --- | --- | --- | --- | --- | --- |
| 1 | 0x37 | Loadstring + backup | [Source](Libraries/0x37/source.lua) | [Example](Libraries/0x37/example.lua) | Preview |
| 2 | Apple Library | Source | [Source](Libraries/Apple/source.lua) | [Example](Libraries/Apple/example.lua) | Preview |
| 3 | Avilon (Modified) | Source | [Source](Libraries/Avilon-Modified/source.lua) | — | — |
| 4 | Aztup | Loadstring + source | [Source](Libraries/Aztup/source.lua) | [Example](Libraries/Aztup/example.lua) | Preview |
| 5 | BaconLib | Source | [Source](Libraries/Bacon/source.lua) | [Example](Libraries/Bacon/example.lua) | Preview |
| 6 | BlekLib | Loadstring + source | [Source](Libraries/Blek/source.lua) | [Example](Libraries/Blek/example.lua) | Preview |
| 7 | Criminality UI Lib | Loadstring + source | [Source](Libraries/Criminality%20Lib/source.lua) | [Example](Libraries/Criminality%20Lib/example.lua) | Preview |
| 8 | Daino | Loadstring | [Source](Libraries/Daino/source.lua) | [Example](Libraries/Daino/example.lua) | Preview |
| 9 | DarkraiX | Source | [Source](Libraries/DarkraiX/source.lua) | [Example](Libraries/DarkraiX/example.lua) | Preview |
| 10 | Dirt | Loadstring + source | [Source](Libraries/Dirt/source.lua) | [Example](Libraries/Dirt/example.lua) | Preview |
| 11 | Discord Lib | Loadstring | [Source](Libraries/Discord%20Lib/source.lua) | [Example](Libraries/Discord%20Lib/example.lua) | Preview |
| 12 | Essential Lib | Loadstring + source | [Source](Libraries/Essential/source.lua) | [Example](Libraries/Essential/example.lua) | Preview |
| 13 | Flux UI | Loadstring + source | [Source](Libraries/Flux/source.lua) | [Example](Libraries/Flux/example.lua) | Preview |
| 14 | FriseX | Loadstring + source | [Source](Libraries/FriseX/source.lua) | [Example](Libraries/FriseX/example.lua) | Preview |
| 15 | Fuzki | Loadstring + source | [Source](Libraries/Fuzki/source.lua) | [Example](Libraries/Fuzki/example.lua) | Preview |
| 16 | Gostmi | Source | [Source](Libraries/Gostmi/source.lua) | [Example](Libraries/Gostmi/example.lua) | Preview |
| 17 | Hook GUI | Source | [Source](Libraries/Hook/source.lua) | [Example](Libraries/Hook/example.lua) | Preview |
| 18 | NexusLib | Source | [Source](Libraries/NexusLib/source.lua) | [Example](Libraries/NexusLib/example.lua) | — |
| 19 | SynergyUI | Source | [Source](Libraries/SynergyUI/source.lua) | — | [Preview](Libraries/SynergyUI/preview.html) |
| 20 | Armenta-Lib | Source | [Source](Libraries/Armenta-Lib/source.lua) | — | [Preview](Libraries/Armenta-Lib/preview.html) |

> Interactive HTML previews are currently available for [SynergyUI](Libraries/SynergyUI/preview.html), [BaconLib](Libraries/Bacon/preview.html), and [Armenta-Lib](Libraries/Armenta-Lib/preview.html). More libraries will be migrated incrementally.

---

## Quick Start

Loading a library takes a single line. Copy the loadstring from any `example.lua`, or build your own from the included source:

```lua
-- Example: loading BaconLib (full source is also stored in Libraries/Bacon/source.lua)
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/UI-Libs/main/Libraries/Bacon/source.lua" ))()
local window = lib:CreateWindow("My Hub")
window:Button("Click me", function()
    print("It works!")
end)
```

Each library folder follows the same layout:

```
Libraries/<LibraryName>/
├── source.lua      # Full library source code
├── example.lua     # Minimal working example
├── README.md       # Library notes and links
└── preview.html    # Interactive HTML preview, when available
```

---

## Contributing

Contributions are welcome! If you want to help grow this collection:

1. **Add a library** — create a folder under `Libraries/` with its `source.lua`, an `example.lua`, and an interactive `preview.html` when the UI can be represented in the browser.

1. **Report broken links** — open an [issue](https://github.com/Xyraniz/UI-Libs/issues) if a loadstring or source no longer works.

1. **Suggest improvements** — feedback on structure, documentation, or new libraries to include is always appreciated.

---

## Notices

Please note that certain libraries may stop functioning without notice due to:

- Source changes made by their original developers

- The removal or deprecation of public repositories

If you encounter broken links, missing libraries, or functionality issues, feel free to reach out on **Discord: ****`xyraniz.`** or open an [issue](https://github.com/Xyraniz/UI-Libs/issues) in this repository.

---

## License & Attribution

This repository is a **preservation and archival collection**. The libraries included belong to their original authors (H3x0R, dawid-scripts, bloodball, and others, as credited in each `source.lua` file) and remain under their respective original licenses. If you are an original author and would like your library removed or updated, please contact me.

**Maintained by** [xyraniz](https://github.com/Xyraniz) · **Contact:** Discord – `xyraniz` · **Email:** [xyraniz@protonmail.com](mailto:xyraniz@protonmail.com)

<div align="center">

⭐ If this collection helped you, consider starring the repository!

</div>
