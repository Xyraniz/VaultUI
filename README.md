# VaultUI

A curated archive of Roblox UI libraries with preserved source files and runnable examples.

[![Stars](https://img.shields.io/github/stars/Xyraniz/VaultUI?style=for-the-badge&color=gold)](https://github.com/Xyraniz/VaultUI/stargazers)[![Lua](https://img.shields.io/badge/Lua-000080?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)[![Roblox](https://img.shields.io/badge/Roblox-00A2FF?style=for-the-badge&logo=roblox&logoColor=white)](https://www.roblox.com/)

## Explore the collection

The complete collection, examples, and available showcases are available through the web catalog:

[**Open VaultUI**](https://xyraniz.github.io/VaultUI/)

VaultUI is intended for developers, scripters, and enthusiasts who want to explore, compare, or prototype with Roblox UI libraries. When available, each entry includes the original source and a runnable usage example.

## Quick start

Libraries can be loaded directly from their preserved source files. Replace the library name and API calls with the library you want to use:

```lua
local lib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Xyraniz/VaultUI/main/Libraries/Bacon/source.lua"
 ))()

local window = lib:CreateWindow("My Hub")

window:Button("Click me", function()
    print("It works!")
end)
```

For the most accurate usage details, refer to the example provided with the selected library.

VindUI-Reborn is included as a reusable library with acrylic-style windows, searchable tabs, sub-tabs, notifications, modals, cards, sliders, dropdowns, textboxes, color pickers, keybinds, and configuration helpers. Its preserved source returns the `NullUI` library table through the `CreateWindow` entry point, and the example exercises the main component handles and callbacks. The catalog uses the supplied [VindUI-Reborn showcase image](https://i.postimg.cc/5tWZJV3V/image.png).

Euphoria is included as a reusable library with responsive scaling, draggable windows, tabs, modules, sliders, textboxes, checkboxes, dropdowns, dividers, and queued notifications. The example covers both direct tab controls and nested module controls. Its catalog entry uses the supplied [Euphoria showcase image](https://i.postimg.cc/rsG95B49/image.png).

MacLib is included as a reusable macOS-inspired library with windows, tab groups, sections, notifications, global settings, buttons, toggles, sliders, inputs, keybinds, dropdowns, color pickers, paragraphs, and configuration helpers. Its catalog entry includes a runnable example and the supplied [MacLib showcase image](https://i.ibb.co/5g36K8K9/483312443-2d96552b-baee-4c49-927d-ebe0e1f7f908.png).

Ragebot is included as a reusable dark control interface converted from the attached standalone script. The preserved controls remain intact while the library now exposes `Ragebot.new`, `Ragebot.CreateWindow`, `SetVisible`, `ToggleVisibility`, `GetVisible`, and `Destroy`. Its catalog entry includes a local visual showcase because the original attachment did not include a separate image.

## Contributing

Contributions are welcome. When adding or updating a library, include an accurate example whenever possible, preserve the original author's attribution, and respect the library's license terms.

If you find a broken link, an outdated source, or another issue, please [open an issue](https://github.com/Xyraniz/VaultUI/issues).

## Attribution and notice

VaultUI is a preservation and reference project. The included libraries belong to their respective authors, and VaultUI does not claim ownership of third-party code. Availability and functionality may change if an original project or public endpoint is removed.

Before using or distributing a library, review its original source, license, and usage terms. Authors who want a library updated or removed can contact [Xyraniz](https://github.com/Xyraniz) through GitHub.

## Links

- [Web catalog](https://xyraniz.github.io/VaultUI/)

- [Repository](https://github.com/Xyraniz/VaultUI)

- [Issue tracker](https://github.com/Xyraniz/VaultUI/issues)
