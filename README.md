## Quick Start

```lua
-- Load the library
local SevereUI = require(script) -- or load from file

-- Create a window
local Window = SevereUI:CreateWindow("My UI", 650, 550)

-- Create tabs
local MainTab = Window:AddTab("Main")
local SettingsTab = Window:AddTab("Settings")

-- Add columns to tabs
local LeftColumn = MainTab:AddColumn()
local RightColumn = MainTab:AddColumn()

-- Create sections
local ESP = LeftColumn:AddSection("ESP")
local Aimbot = RightColumn:AddSection("Aimbot")

-- Add elements
ESP:AddToggle("Player ESP", false, function(value)
    print("ESP:", value)
end):AddColorPicker(Color3.fromRGB(255, 0, 0), function(color)
    print("ESP Color:", color)
end)

ESP:AddSlider("ESP Distance", 0, 1000, 500, " studs", function(value)
    print("Distance:", value)
end)

ESP:AddDropdown("ESP Style", {"Box", "Skeleton", "Name"}, "Box", function(selected)
    print("Style:", selected)
end)

ESP:AddMultiDropdown("ESP Features", {"Health", "Distance", "Weapon", "Team"}, {"Health"}, function(selected)
    print("Features:", table.concat(selected, ", "))
end)

-- Setup render loop
local RunService = game:GetService("RunService")
RunService.Render:Connect(function()
    Window:UpdateInput()
    Window:Render()
end)
```

## Available Elements

### Toggle
```lua
section:AddToggle("Name", defaultValue, callback)
    :AddColorPicker(defaultColor, callback) -- Optional color picker
```

### Slider
```lua
section:AddSlider("Name", min, max, defaultValue, suffix, callback)
```

### Dropdown
```lua
section:AddDropdown("Name", options, defaultOption, callback)
```

### Multi-Select Dropdown
```lua
section:AddMultiDropdown("Name", options, defaultOptions, callback)
```

### Label
```lua
section:AddLabel("Text")
```

## Theming

### Preset Themes
```lua
SevereUI:SetTheme("Default")    -- Default dark theme
SevereUI:SetTheme("Purple")     -- Purple accent
SevereUI:SetTheme("Green")      -- Green accent
SevereUI:SetTheme("Red")        -- Red accent
SevereUI:SetTheme("Orange")     -- Orange accent
```

### Custom Theme
```lua
SevereUI.Settings.Theme.Accent = Color3.fromRGB(100, 200, 255)
SevereUI.Settings.Theme.AccentDark = Color3.fromRGB(70, 140, 178)
```

### UI Scaling
```lua
SevereUI.Settings.UIScale = 1.2  -- 120% scale
SevereUI.Settings.FontSize = 14  -- Font size
```

## 📝 API Reference

### SevereUI:CreateWindow(title, width, height)
Creates a new draggable window.

### window:AddTab(name)
Adds a new tab to the window.

### tab:AddColumn()
Adds a column to the tab for multi-column layouts.

### column:AddSection(name)
Adds a section to the column.

### section:AddToggle(name, default, callback)
Adds a toggle switch. Returns toggle object for chaining.

### toggle:AddColorPicker(defaultColor, callback)
Adds an inline color picker to the toggle.

### section:AddSlider(name, min, max, default, suffix, callback)
Adds a slider with customizable suffix.

### section:AddDropdown(name, options, default, callback)
Adds a single-select dropdown.

### section:AddMultiDropdown(name, options, defaults, callback)
Adds a multi-select dropdown.

### section:AddLabel(text)
Adds a text label.

### window:Close()
Closes the window.
