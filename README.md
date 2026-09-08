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
