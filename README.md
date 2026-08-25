# VaultUI

**A curated collection of Roblox UI libraries with preserved source files, runnable examples, Mega showcase embeds and ready-to-use loadstrings.**

[![Stars](https://img.shields.io/github/stars/Xyraniz/VaultUI?style=for-the-badge&color=gold)](https://github.com/Xyraniz/VaultUI/stargazers)[![Lua](https://img.shields.io/badge/Lua-000080?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)[![Roblox](https://img.shields.io/badge/Roblox-00A2FF?style=for-the-badge&logo=roblox&logoColor=white)](https://www.roblox.com/)[![Last Updated](https://img.shields.io/badge/last%20updated-August%202026-blue?style=for-the-badge)](https://github.com/Xyraniz/VaultUI/commits/main)[![License](https://img.shields.io/badge/license-MIT%20%26%20Original%20Licenses-green?style=for-the-badge)](#license--attribution)

## About

**VaultUI** is a centralized archive of Roblox UI libraries organized for developers, scripters and enthusiasts. Each library includes a runnable `example.lua`; preserved `source.lua` files are included whenever the repository contains them. The web shelf loads the available showcases through responsive Mega iframes and shows `No Showcase` when a library does not have an embed configured.

The collection is useful when prototyping a hub, studying Luau interface architecture or comparing lightweight UI layers. Each folder keeps its usage example and any preserved library source together so the repository remains easy to browse and migrate.

## Included assets

| Asset | Purpose |
| --- | --- |
| `source.lua` | Preserved library source supplied by the collection, when available. |
| `example.lua` | A complete usage sample based on the library's public API. |
| `web/showcases.js` | The single, editable showcase table. Add a library id and Mega embed URL here. |

## Libraries

| # | Library | Type | Source | Example | Showcase |
| --- | --- | --- | --- | --- | --- |
| 1 | 0x37 | Source + example | [Source](Libraries/0x37/source.lua) | [Example](Libraries/0x37/example.lua) | No Showcase |
| 2 | Apple | Source + example | [Source](Libraries/Apple/source.lua) | [Example](Libraries/Apple/example.lua) | No Showcase |
| 3 | Armenta Lib | Source + example | [Source](Libraries/Armenta-Lib/source.lua) | [Example](Libraries/Armenta-Lib/example.lua) | [Mega embed](https://mega.nz/embed/MRkRBApL#KFE30TjcbNAfCv-aY8FJSjKAxzEM_eU_6zvRJSydwms) |
| 4 | Avilon Modified | Source + example | [Source](Libraries/Avilon-Modified/source.lua) | [Example](Libraries/Avilon-Modified/example.lua) | No Showcase |
| 5 | Aztup | Source + example | [Source](Libraries/Aztup/source.lua) | [Example](Libraries/Aztup/example.lua) | [Mega embed](https://mega.nz/embed/BQsiHbLZ#5HmpL81nfRptb5WdK7_neQLpwA4zpv8wfqMt37dMEws) |
| 6 | Bacon | Source + example | [Source](Libraries/Bacon/source.lua) | [Example](Libraries/Bacon/example.lua) | [Mega embed](https://mega.nz/embed/EZshGTAI#91w4D-Ur7h8xfGmL81Gs0IhfoOATmF7aDvzLyC0B18w) |
| 7 | Criminality Lib | Source + example | [Source](Libraries/Criminality-Lib/source.lua) | [Example](Libraries/Criminality-Lib/example.lua) | No Showcase |
| 8 | Daino | Source + example | [Source](Libraries/Daino/source.lua) | [Example](Libraries/Daino/example.lua) | No Showcase |
| 9 | DarkraiX | Source + example | [Source](Libraries/DarkraiX/source.lua) | [Example](Libraries/DarkraiX/example.lua) | No Showcase |
| 10 | Dirt | Source + example | [Source](Libraries/Dirt/source.lua) | [Example](Libraries/Dirt/example.lua) | No Showcase |
| 11 | Discord Lib | Source + example | [Source](Libraries/Discord-Lib/source.lua) | [Example](Libraries/Discord-Lib/example.lua) | [Mega embed](https://mega.nz/embed/dFtFBS4a#Rm0HKEYLSmSK7Udwy-UzKmTn4VKPekEsL8KAB0niaSo) |
| 12 | Flux | Source + example | [Source](Libraries/Flux/source.lua) | [Example](Libraries/Flux/example.lua) | No Showcase |
| 13 | FriseX | Source + example | [Source](Libraries/FriseX/source.lua) | [Example](Libraries/FriseX/example.lua) | No Showcase |
| 14 | Gostmi | Source + example | [Source](Libraries/Gostmi/source.lua) | [Example](Libraries/Gostmi/example.lua) | No Showcase |
| 15 | Hook | Example | — | [Example](Libraries/Hook/example.lua) | No Showcase |
| 16 | Kavo UI | Source + example | [Source](Libraries/Kavo-UI/source.lua) | [Example](Libraries/Kavo-UI/example.lua) | No Showcase |
| 17 | NexusLib | Source + example | [Source](Libraries/NexusLib/source.lua) | [Example](Libraries/NexusLib/example.lua) | No Showcase |
| 18 | SynergyUI | Source + example | [Source](Libraries/SynergyUI/source.lua) | [Example](Libraries/SynergyUI/example.lua) | [Mega embed](https://mega.nz/embed/9UdzlJbD#cbWE8v9-Q59CtYhD0zLPXjO7kCMSAROYCUA4SE2seH0) |
| 19 | WindUI Shiny | Source + example | [Source](Libraries/WindUI-Shiny/source.lua) | [Example](Libraries/WindUI-Shiny/example.lua) | No Showcase |

## Quick Start

A library can be loaded from its example file or directly from the preserved source. This is a minimal BaconLib usage example:

```lua
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Bacon/source.lua"  ))()
local window = lib:CreateWindow("My Hub")
window:Button("Click me", function()
    print("It works!")
end)
```

Each library folder keeps the source and runnable example together:

```
Libraries/<LibraryName>/
├── source.lua
└── example.lua
```

The web shelf discovers library folders and their `source.lua`/`example.lua` files automatically through the repository tree; adding a qualifying folder creates its section without editing `web/app.js`. Showcases remain configured centrally in [`web/showcases.js`](web/showcases.js). To add one, use the id generated from the folder name:

```
another_library_id: {
  embedUrl: 'https://mega.nz/embed/...'
}
```

The shelf automatically renders the Mega iframe responsively; entries without a row display `No Showcase`.

## Contributing

To add a library, create a folder under `Libraries/` with a `source.lua` and/or a complete `example.lua` that follows the library's actual public API. The web shelf detects the folder automatically. If a Mega showcase is available, add one row to `web/showcases.js` using the id generated from the folder name; otherwise the shelf will display `No Showcase`.

Report broken links or source issues through the [issue tracker](https://github.com/Xyraniz/VaultUI/issues). Contributions should preserve the original author's attribution and license terms.

## Notices

Some libraries may stop functioning if their original repositories change or public endpoints are removed. The collection preserves the files that were available at the time of import; verify the original author's terms before distributing a project that includes one of these libraries.

## License & Attribution

This repository is a preservation and archival collection. The included libraries belong to their original authors and remain under their respective original licenses. If you are an original author and would like a library removed or updated, please contact [xyraniz](https://github.com/Xyraniz) through GitHub.
