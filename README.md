<div align="center">

# UI-Libs

**A curated collection of 15+ free Roblox UI libraries — with sources, previews, and ready-to-use loadstrings.**

[![Stars](https://img.shields.io/github/stars/Xyraniz/UI-Libs?style=for-the-badge&color=gold)](https://github.com/Xyraniz/UI-Libs/stargazers)[![Lua](https://img.shields.io/badge/Lua-000080?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)[![Roblox](https://img.shields.io/badge/Roblox-00A2FF?style=for-the-badge&logo=roblox&logoColor=white)](https://www.roblox.com/)[![Last Updated](https://img.shields.io/badge/last%20updated-August%202026-blue?style=for-the-badge)](https://github.com/Xyraniz/UI-Libs/commits/main)[![License](https://img.shields.io/badge/license-MIT%20%26%20Original%20Licenses-green?style=for-the-badge)](#license--attribution)

</div>

---

## About

**UI-Libs** is a centralized archive of popular **UI frameworks used across the Roblox community**, organized in one place for developers, scripters, and enthusiasts. Every library includes its full source code, a preview screenshot, and a working loadstring so you can drop it straight into your script and start building.

Whether you are prototyping a hub, learning how GUI libraries are structured in Luau, or looking for a lightweight UI layer for your project, this collection gives you direct access to well-known frameworks such as **BaconLib, Flux, Aztup, Blek, and many more** — no hunting through scattered repositories required.

### Why use this collection?

- **Everything in one place.** 15+ UI libraries from different original authors, archived and organized by name.

- **Full source included.** Every `Source.lua` is stored in this repository, so a library never disappears if the original repo goes down.

- **Ready-to-use loadstrings.** Each `Example.lua` shows how to load and use the library with a single `game:HttpGet` call.

- **Visual previews.** Screenshot of each library's default appearance so you can pick the look you want before loading anything.

---

## Libraries

| # | Library | Type | Source | Example | Preview |
| --- | --- | --- | --- | --- | --- |
| 1 | 0x37 | Loadstring + backup | [Source](Libraries/0x37/Source.lua) | [Example](Libraries/0x37/Example.lua) | Preview |
| 2 | Apple Library | Source | [Source](Libraries/Apple/Source.lua) | [Example](Libraries/Apple/Example.lua) | Preview |
| 3 | Avilon (Modified) | Source | [Source](Libraries/Avilon-Modified/Source.lua) | — | — |
| 4 | Aztup | Loadstring + source | [Source](Libraries/Aztup/Source.lua) | [Example](Libraries/Aztup/Example.lua) | Preview |
| 5 | BaconLib | Source | [Source](Libraries/Bacon/Source.lua) | [Example](Libraries/Bacon/Example.lua) | Preview |
| 6 | BlekLib | Loadstring + source | [Source](Libraries/Blek/Source.lua) | [Example](Libraries/Blek/Example.lua) | Preview |
| 7 | Criminality UI Lib | Loadstring + source | [Source](Libraries/Criminality%20Lib/Source.lua) | [Example](Libraries/Criminality%20Lib/Example.lua) | Preview |
| 8 | Daino | Loadstring | [Source](Libraries/Daino/Source.lua) | [Example](Libraries/Daino/Example.lua) | Preview |
| 9 | DarkraiX | Source | [Source](Libraries/DarkraiX/Source.lua) | [Example](Libraries/DarkraiX/Example.lua) | Preview |
| 10 | Dirt | Loadstring + source | [Source](Libraries/Dirt/Source.lua) | [Example](Libraries/Dirt/Example.lua) | Preview |
| 11 | Discord Lib | Loadstring | [Source](Libraries/Discord%20Lib/Source.lua) | [Example](Libraries/Discord%20Lib/Example.lua) | Preview |
| 12 | Essential Lib | Loadstring + source | [Source](Libraries/Essential/Source.lua) | [Example](Libraries/Essential/Example.lua) | Preview |
| 13 | Flux UI | Loadstring + source | [Source](Libraries/Flux/Source.lua) | [Example](Libraries/Flux/Example.lua) | Preview |
| 14 | FriseX | Loadstring + source | [Source](Libraries/FriseX/Source.lua) | [Example](Libraries/FriseX/Example.lua) | Preview |
| 15 | Fuzki | Loadstring + source | [Source](Libraries/Fuzki/Source.lua) | [Example](Libraries/Fuzki/Example.lua) | Preview |
| 16 | Gostmi | Source | [Source](Libraries/Gostmi/Source.lua) | [Example](Libraries/Gostmi/Example.lua) | Preview |
| 17 | Hook GUI | Source | [Source](Libraries/Hook/Source.lua) | [Example](Libraries/Hook/Example.lua) | Preview |
| 18 | NexusLib | Source | [Source](Libraries/NexusLib/Source.lua) | [Example](Libraries/NexusLib/Example.lua) | — |
| 19 | SynergyUI | Source | [Source](Libraries/SynergyUI/source.lua) | — | — |

> Preview images are available inside each library folder (e.g., `Libraries/Bacon/Screenshot_*.jpg`) and in each library's `README.md`.

---

## Quick Start

Loading a library takes a single line. Copy the loadstring from any `Example.lua`, or build your own from the included source:

```lua
-- Example: loading BaconLib (full source is also stored in Libraries/Bacon/Source.lua)
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/UI-Libs/main/Libraries/Bacon/Source.lua" ))()
local window = lib:CreateWindow("My Hub")
window:Button("Click me", function()
    print("It works!")
end)
```

Each library folder follows the same layout:

```
Libraries/<LibraryName>/
├── Source.lua      # Full library source code
├── Example.lua     # Minimal working example
├── README.md       # Preview screenshot
└── Screenshot_*    # Visual preview of the library
```

---

## Contributing

Contributions are welcome! If you want to help grow this collection:

1. **Add a library** — create a folder under `Libraries/` with its `Source.lua`, an `Example.lua`, and a preview screenshot.

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

This repository is a **preservation and archival collection**. The libraries included belong to their original authors (H3x0R, dawid-scripts, bloodball, and others, as credited in each `Source.lua` file) and remain under their respective original licenses. If you are an original author and would like your library removed or updated, please contact me.

**Maintained by** [xyraniz](https://github.com/Xyraniz) · **Contact:** Discord – `xyraniz.` · **Email:** [xyraniz@protonmail.com](mailto:xyraniz@protonmail.com)

<div align="center">

⭐ If this collection helped you, consider starring the repository!

</div>
