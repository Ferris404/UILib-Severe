local SevereUI = {}

-- Settings
SevereUI.Settings = {
    UIScale = 1.0,
    FontSize = 12,
    AnimationSpeed = 0.3,
    ToggleKey = 0x10, -- Right Shift keycode
    Theme = {
        Background = Color3.fromRGB(15, 15, 17),
        Header = Color3.fromRGB(20, 20, 23),
        Section = Color3.fromRGB(25, 25, 28),
        Element = Color3.fromRGB(30, 30, 33),
        Border = Color3.fromRGB(45, 45, 50),
        Accent = Color3.fromRGB(90, 200, 250),
        AccentDark = Color3.fromRGB(60, 150, 200),
        Text = Color3.fromRGB(220, 220, 225),
        TextDim = Color3.fromRGB(150, 150, 155),
        Success = Color3.fromRGB(100, 200, 100)
    }
}

-- Preset themes
SevereUI.Themes = {
    Default = {
        Background = Color3.fromRGB(15, 15, 17),
        Header = Color3.fromRGB(20, 20, 23),
        Section = Color3.fromRGB(25, 25, 28),
        Element = Color3.fromRGB(30, 30, 33),
        Border = Color3.fromRGB(45, 45, 50),
        Accent = Color3.fromRGB(90, 200, 250),
        AccentDark = Color3.fromRGB(60, 150, 200),
        Text = Color3.fromRGB(220, 220, 225),
        TextDim = Color3.fromRGB(150, 150, 155),
        Success = Color3.fromRGB(100, 200, 100)
    },
    Purple = {
        Background = Color3.fromRGB(18, 15, 25),
        Header = Color3.fromRGB(23, 20, 30),
        Section = Color3.fromRGB(28, 25, 35),
        Element = Color3.fromRGB(33, 30, 40),
        Border = Color3.fromRGB(50, 45, 60),
        Accent = Color3.fromRGB(138, 43, 226),
        AccentDark = Color3.fromRGB(100, 30, 180),
        Text = Color3.fromRGB(220, 220, 225),
        TextDim = Color3.fromRGB(150, 150, 155),
        Success = Color3.fromRGB(100, 200, 100)
    },
    Green = {
        Background = Color3.fromRGB(15, 20, 15),
        Header = Color3.fromRGB(20, 25, 20),
        Section = Color3.fromRGB(25, 30, 25),
        Element = Color3.fromRGB(30, 35, 30),
        Border = Color3.fromRGB(45, 55, 45),
        Accent = Color3.fromRGB(50, 205, 50),
        AccentDark = Color3.fromRGB(34, 139, 34),
        Text = Color3.fromRGB(220, 225, 220),
        TextDim = Color3.fromRGB(150, 155, 150),
        Success = Color3.fromRGB(100, 200, 100)
    },
    Red = {
        Background = Color3.fromRGB(20, 15, 15),
        Header = Color3.fromRGB(25, 20, 20),
        Section = Color3.fromRGB(30, 25, 25),
        Element = Color3.fromRGB(35, 30, 30),
        Border = Color3.fromRGB(55, 45, 45),
        Accent = Color3.fromRGB(255, 69, 69),
        AccentDark = Color3.fromRGB(200, 50, 50),
        Text = Color3.fromRGB(225, 220, 220),
        TextDim = Color3.fromRGB(155, 150, 150),
        Success = Color3.fromRGB(100, 200, 100)
    },
    Orange = {
        Background = Color3.fromRGB(20, 17, 15),
        Header = Color3.fromRGB(25, 22, 20),
        Section = Color3.fromRGB(30, 27, 25),
        Element = Color3.fromRGB(35, 32, 30),
        Border = Color3.fromRGB(55, 50, 45),
        Accent = Color3.fromRGB(255, 140, 0),
        AccentDark = Color3.fromRGB(200, 100, 0),
        Text = Color3.fromRGB(225, 222, 220),
        TextDim = Color3.fromRGB(155, 152, 150),
        Success = Color3.fromRGB(100, 200, 100)
    }
}

-- Apply theme function
function SevereUI:SetTheme(themeName)
    if self.Themes[themeName] then
        for key, value in pairs(self.Themes[themeName]) do
            self.Settings.Theme[key] = value
        end
    end
end

-- Helper function
local function IsPointInRect(px, py, rx, ry, rw, rh)
    return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
end

-- Helper to get current theme
local function GetTheme()
    return SevereUI.Settings.Theme
end

-- Helper to scale values
local function Scale(value)
    return math.floor(value * SevereUI.Settings.UIScale)
end

-- Helper to get font size
local function GetFontSize()
    return math.floor(SevereUI.Settings.FontSize * SevereUI.Settings.UIScale)
end

-- Create main window
function SevereUI:CreateWindow(title, width, height)
    local window = {
        Title = title or "Linoria UI",
        X = 300,
        Y = 150,
        BaseWidth = width or 650,
        BaseHeight = height or 550,
        Width = width or 650,
        Height = height or 550,
        Visible = true,
        Dragging = false,
        DragOffsetX = 0,
        DragOffsetY = 0,
        Tabs = {},
        CurrentTab = nil,
        LastMouseState = false,
        ScrollOffsets = {},
        SettingsTab = nil,
        LastKeyState = {}
    }
    
    -- Update dimensions based on scale
    function window:UpdateScale()
        self.Width = Scale(self.BaseWidth)
        self.Height = Scale(self.BaseHeight)
    end
    
    -- Create built-in settings tab
    function window:CreateSettingsTab()
        local settingsTab = {
            Name = "Settings",
            Columns = {},
            Window = self,
            IsSettingsTab = true
        }
        
        -- Add settings column
        local column = {
            Elements = {},
            Tab = settingsTab
        }
        
        -- Helper to add elements to settings
        function column:AddSection(name)
            local section = {
                Type = "Section",
                Name = name,
                Elements = {}
            }
            
            function section:AddToggle(text, default, callback)
                local element = {
                    Type = "Toggle",
                    Text = text,
                    Value = default or false,
                    Callback = callback or function() end,
                    ColorPicker = nil
                }
                
                function element:SetValue(value)
                    self.Value = value
                    pcall(self.Callback, value)
                end
                
                function element:AddColorPicker(defaultColor, callback)
                    self.ColorPicker = {
                        Color = defaultColor or Color3.fromRGB(255, 255, 255),
                        Callback = callback or function() end,
                        Open = false,
                        Hue = 0,
                        Saturation = 1,
                        Value = 1,
                        DraggingPicker = false,
                        DraggingHue = false
                    }
                    
                    -- Convert RGB to HSV
                    local r, g, b = defaultColor.R, defaultColor.G, defaultColor.B
                    local max = math.max(r, g, b)
                    local min = math.min(r, g, b)
                    local delta = max - min
                    
                    self.ColorPicker.Value = max
                    self.ColorPicker.Saturation = max == 0 and 0 or (delta / max)
                    
                    if delta == 0 then
                        self.ColorPicker.Hue = 0
                    elseif max == r then
                        self.ColorPicker.Hue = ((g - b) / delta) % 6
                    elseif max == g then
                        self.ColorPicker.Hue = ((b - r) / delta) + 2
                    else
                        self.ColorPicker.Hue = ((r - g) / delta) + 4
                    end
                    self.ColorPicker.Hue = self.ColorPicker.Hue / 6
                    
                    function self.ColorPicker:UpdateFromHSV()
                        local h, s, v = self.Hue * 6, self.Saturation, self.Value
                        local c = v * s
                        local x = c * (1 - math.abs((h % 2) - 1))
                        local m = v - c
                        
                        local r, g, b
                        if h < 1 then r, g, b = c, x, 0
                        elseif h < 2 then r, g, b = x, c, 0
                        elseif h < 3 then r, g, b = 0, c, x
                        elseif h < 4 then r, g, b = 0, x, c
                        elseif h < 5 then r, g, b = x, 0, c
                        else r, g, b = c, 0, x
                        end
                        
                        self.Color = Color3.new(r + m, g + m, b + m)
                        pcall(self.Callback, self.Color)
                    end
                    
                    return self
                end
                
                table.insert(section.Elements, element)
                return element
            end
            
            function section:AddSlider(text, min, max, default, suffix, callback)
                local element = {
                    Type = "Slider",
                    Text = text,
                    Min = min or 0,
                    Max = max or 100,
                    Value = default or 50,
                    Suffix = suffix or "",
                    Callback = callback or function() end,
                    Dragging = false
                }
                
                function element:SetValue(value)
                    self.Value = math.clamp(value, self.Min, self.Max)
                    pcall(self.Callback, self.Value)
                end
                
                table.insert(section.Elements, element)
                return element
            end
            
            function section:AddDropdown(text, options, default, callback)
                local element = {
                    Type = "Dropdown",
                    Text = text,
                    Options = options or {"Option 1", "Option 2"},
                    Selected = default or (options and options[1]) or "None",
                    Callback = callback or function() end,
                    Open = false,
                    Multi = false
                }
                
                function element:SetValue(value)
                    if table.find(self.Options, value) then
                        self.Selected = value
                        pcall(self.Callback, value)
                    end
                end
                
                table.insert(section.Elements, element)
                return element
            end
            
            function section:AddLabel(text)
                table.insert(section.Elements, {
                    Type = "Label",
                    Text = text
                })
            end
            
            table.insert(column.Elements, section)
            return section
        end
        
        table.insert(settingsTab.Columns, column)
        
        -- Add UI settings
        local uiSection = column:AddSection("UI Settings")
        
        uiSection:AddSlider("UI Scale", 0.5, 2.0, SevereUI.Settings.UIScale, "x", function(value)
            SevereUI.Settings.UIScale = value
        end)
        
        uiSection:AddSlider("Font Size", 8, 20, SevereUI.Settings.FontSize, "px", function(value)
            SevereUI.Settings.FontSize = value
        end)
        
        -- Add theme selector
        local themeSection = column:AddSection("Theme")
        
        themeSection:AddDropdown("Select Theme", {"Default", "Purple", "Green", "Red", "Orange"}, "Default", function(value)
            SevereUI:SetTheme(value)
        end)
        
        -- Add keybind info
        local keybindSection = column:AddSection("Keybinds")
        keybindSection:AddLabel("Toggle UI: Right Shift")
        
        return settingsTab
    end
    
    function window:AddTab(name)
        local tab = {
            Name = name,
            Columns = {},
            Window = self
        }
        
        function tab:AddColumn()
            local column = {
                Elements = {},
                Tab = self
            }
            
            function column:AddSection(name)
                local section = {
                    Type = "Section",
                    Name = name,
                    Elements = {}
                }
                
                function section:AddToggle(text, default, callback)
                    local element = {
                        Type = "Toggle",
                        Text = text,
                        Value = default or false,
                        Callback = callback or function() end,
                        ColorPicker = nil
                    }
                    
                    function element:SetValue(value)
                        self.Value = value
                        pcall(self.Callback, value)
                    end
                    
                    function element:AddColorPicker(defaultColor, callback)
                        self.ColorPicker = {
                            Color = defaultColor or Color3.fromRGB(255, 255, 255),
                            Callback = callback or function() end,
                            Open = false,
                            Hue = 0,
                            Saturation = 1,
                            Value = 1,
                            DraggingPicker = false,
                            DraggingHue = false
                        }
                        
                        -- Convert RGB to HSV
                        local r, g, b = defaultColor.R, defaultColor.G, defaultColor.B
                        local max = math.max(r, g, b)
                        local min = math.min(r, g, b)
                        local delta = max - min
                        
                        self.ColorPicker.Value = max
                        self.ColorPicker.Saturation = max == 0 and 0 or (delta / max)
                        
                        if delta == 0 then
                            self.ColorPicker.Hue = 0
                        elseif max == r then
                            self.ColorPicker.Hue = ((g - b) / delta) % 6
                        elseif max == g then
                            self.ColorPicker.Hue = ((b - r) / delta) + 2
                        else
                            self.ColorPicker.Hue = ((r - g) / delta) + 4
                        end
                        self.ColorPicker.Hue = self.ColorPicker.Hue / 6
                        
                        function self.ColorPicker:UpdateFromHSV()
                            local h, s, v = self.Hue * 6, self.Saturation, self.Value
                            local c = v * s
                            local x = c * (1 - math.abs((h % 2) - 1))
                            local m = v - c
                            
                            local r, g, b
                            if h < 1 then r, g, b = c, x, 0
                            elseif h < 2 then r, g, b = x, c, 0
                            elseif h < 3 then r, g, b = 0, c, x
                            elseif h < 4 then r, g, b = 0, x, c
                            elseif h < 5 then r, g, b = x, 0, c
                            else r, g, b = c, 0, x
                            end
                            
                            self.Color = Color3.new(r + m, g + m, b + m)
                            pcall(self.Callback, self.Color)
                        end
                        
                        return self
                    end
                    
                    table.insert(section.Elements, element)
                    return element
                end
                
                function section:AddSlider(text, min, max, default, suffix, callback)
                    local element = {
                        Type = "Slider",
                        Text = text,
                        Min = min or 0,
                        Max = max or 100,
                        Value = default or 50,
                        Suffix = suffix or "",
                        Callback = callback or function() end,
                        Dragging = false
                    }
                    
                    function element:SetValue(value)
                        self.Value = math.clamp(value, self.Min, self.Max)
                        pcall(self.Callback, self.Value)
                    end
                    
                    table.insert(section.Elements, element)
                    return element
                end
                
                function section:AddDropdown(text, options, default, callback)
                    local element = {
                        Type = "Dropdown",
                        Text = text,
                        Options = options or {"Option 1", "Option 2"},
                        Selected = default or (options and options[1]) or "None",
                        Callback = callback or function() end,
                        Open = false,
                        Multi = false
                    }
                    
                    function element:SetValue(value)
                        if table.find(self.Options, value) then
                            self.Selected = value
                            pcall(self.Callback, value)
                        end
                    end
                    
                    table.insert(section.Elements, element)
                    return element
                end
                
                function section:AddMultiDropdown(text, options, defaults, callback)
                    local element = {
                        Type = "Dropdown",
                        Text = text,
                        Options = options or {"Option 1", "Option 2"},
                        Selected = defaults or {},
                        Callback = callback or function() end,
                        Open = false,
                        Multi = true
                    }
                    
                    function element:SetValue(values)
                        self.Selected = values or {}
                        pcall(self.Callback, self.Selected)
                    end
                    
                    function element:IsSelected(option)
                        return table.find(self.Selected, option) ~= nil
                    end
                    
                    function element:Toggle(option)
                        if self:IsSelected(option) then
                            -- Remove
                            local index = table.find(self.Selected, option)
                            if index then
                                table.remove(self.Selected, index)
                            end
                        else
                            -- Add
                            table.insert(self.Selected, option)
                        end
                        pcall(self.Callback, self.Selected)
                    end
                    
                    table.insert(section.Elements, element)
                    return element
                end
                
                function section:AddLabel(text)
                    table.insert(section.Elements, {
                        Type = "Label",
                        Text = text
                    })
                end
                
                table.insert(column.Elements, section)
                return section
            end
            
            table.insert(tab.Columns, column)
            return column
        end
        
        table.insert(self.Tabs, tab)
        if #self.Tabs == 1 then
            self.CurrentTab = tab
            self.ScrollOffsets[tab] = 0
        end
        
        return tab
    end
    
    -- Initialize settings tab
    window.SettingsTab = window:CreateSettingsTab()
    table.insert(window.Tabs, window.SettingsTab)
    window.ScrollOffsets[window.SettingsTab] = 0
    
    -- Setup keybind handler
    function window:HandleKeybinds()
        local isKeyPressed = iskeydown(SevereUI.Settings.ToggleKey)
        local wasKeyPressed = self.LastKeyState[SevereUI.Settings.ToggleKey] or false
        
        if isKeyPressed and not wasKeyPressed then
            self.Visible = not self.Visible
        end
        
        self.LastKeyState[SevereUI.Settings.ToggleKey] = isKeyPressed
    end
    
    function window:Toggle()
        self.Visible = not self.Visible
    end
    
    function window:Render()
        if not self.Visible then return end
        
        -- Update scale
        self:UpdateScale()
        
        local Theme = GetTheme()
        local fontSize = GetFontSize()
        
        -- Main background
        DrawingImmediate.FilledRectangle(
            Vector2.new(self.X, self.Y),
            Vector2.new(self.Width, self.Height),
            Theme.Background,
            1,
            Scale(4)
        )
        
        -- Border
        DrawingImmediate.Rectangle(
            Vector2.new(self.X, self.Y),
            Vector2.new(self.Width, self.Height),
            Theme.Border,
            1,
            Scale(4),
            1
        )
        
        -- Title bar
        local titleBarHeight = Scale(30)
        DrawingImmediate.FilledRectangle(
            Vector2.new(self.X, self.Y),
            Vector2.new(self.Width, titleBarHeight),
            Theme.Header,
            1,
            Scale(4)
        )
        
        -- Title text
        DrawingImmediate.OutlinedText(
            Vector2.new(self.X + Scale(10), self.Y + Scale(8)),
            fontSize + 1,
            Theme.Text,
            1,
            self.Title,
            false,
            "Tamzen"
        )
        
        -- Tab bar (horizontal)
        local tabBarY = self.Y + Scale(35)
        local tabBarHeight = Scale(28)
        local tabX = self.X + Scale(10)
        local tabWidth = Scale(120)
        
        for i, tab in ipairs(self.Tabs) do
            local isActive = tab == self.CurrentTab
            local tabBG = isActive and Theme.Section or Theme.Background
            
            -- Tab button
            DrawingImmediate.FilledRectangle(
                Vector2.new(tabX, tabBarY),
                Vector2.new(tabWidth - Scale(5), tabBarHeight),
                tabBG,
                1,
                Scale(4)
            )
            
            -- Active tab indicator (bottom line)
            if isActive then
                DrawingImmediate.FilledRectangle(
                    Vector2.new(tabX, tabBarY + tabBarHeight - Scale(2)),
                    Vector2.new(tabWidth - Scale(5), Scale(2)),
                    Theme.Accent,
                    1,
                    0
                )
            end
            
            -- Tab text
            DrawingImmediate.OutlinedText(
                Vector2.new(tabX + (tabWidth - Scale(5)) / 2, tabBarY + Scale(8)),
                fontSize,
                isActive and Theme.Text or Theme.TextDim,
                1,
                tab.Name,
                true,
                "Tamzen"
            )
            
            tabX = tabX + tabWidth
        end
        
        -- Content area
        if not self.CurrentTab then return end
        
        local contentY = tabBarY + tabBarHeight + Scale(10)
        local contentHeight = self.Height - (contentY - self.Y) - Scale(10)
        local scrollOffset = self.ScrollOffsets[self.CurrentTab] or 0
        
        -- Calculate column width
        local numColumns = #self.CurrentTab.Columns
        if numColumns == 0 then return end
        
        local columnSpacing = Scale(10)
        local totalSpacing = columnSpacing * (numColumns + 1)
        local columnWidth = (self.Width - totalSpacing) / numColumns
        
        -- Render columns
        local columnX = self.X + columnSpacing
        
        for colIndex, column in ipairs(self.CurrentTab.Columns) do
            local currentY = contentY - scrollOffset
            
            -- Render sections in this column
            for _, section in ipairs(column.Elements) do
                if section.Type == "Section" then
                    -- Section background
                    local sectionHeight = self:CalculateSectionHeight(section)
                    
                    DrawingImmediate.FilledRectangle(
                        Vector2.new(columnX, currentY),
                        Vector2.new(columnWidth, sectionHeight),
                        Theme.Section,
                        1,
                        Scale(4)
                    )
                    
                    -- Section border
                    DrawingImmediate.Rectangle(
                        Vector2.new(columnX, currentY),
                        Vector2.new(columnWidth, sectionHeight),
                        Theme.Border,
                        0.5,
                        Scale(4),
                        1
                    )
                    
                    -- Section title
                    DrawingImmediate.OutlinedText(
                        Vector2.new(columnX + Scale(10), currentY + Scale(8)),
                        fontSize,
                        Theme.Text,
                        1,
                        section.Name,
                        false,
                        "Tamzen"
                    )
                    
                    -- Section divider
                    DrawingImmediate.FilledRectangle(
                        Vector2.new(columnX + Scale(5), currentY + Scale(26)),
                        Vector2.new(columnWidth - Scale(10), 1),
                        Theme.Border,
                        1,
                        0
                    )
                    
                    -- Render elements
                    local elementY = currentY + Scale(35)
                    
                    for _, element in ipairs(section.Elements) do
                        if element.Type == "Toggle" then
                            -- Toggle label
                            DrawingImmediate.OutlinedText(
                                Vector2.new(columnX + Scale(10), elementY + Scale(3)),
                                fontSize - 1,
                                Theme.Text,
                                1,
                                element.Text,
                                false,
                                "Tamzen"
                            )
                            
                            -- Checkbox
                            local checkX = columnX + columnWidth - Scale(60)
                            local checkSize = Scale(14)
                            
                            DrawingImmediate.FilledRectangle(
                                Vector2.new(checkX, elementY),
                                Vector2.new(checkSize, checkSize),
                                element.Value and Theme.Accent or Theme.Element,
                                1,
                                Scale(2)
                            )
                            
                            DrawingImmediate.Rectangle(
                                Vector2.new(checkX, elementY),
                                Vector2.new(checkSize, checkSize),
                                Theme.Border,
                                1,
                                Scale(2),
                                1
                            )
                            
                            -- Color picker box (if exists)
                            if element.ColorPicker then
                                local colorBoxX = columnX + columnWidth - Scale(40)
                                DrawingImmediate.FilledRectangle(
                                    Vector2.new(colorBoxX, elementY),
                                    Vector2.new(checkSize, checkSize),
                                    element.ColorPicker.Color,
                                    1,
                                    Scale(2)
                                )
                                
                                DrawingImmediate.Rectangle(
                                    Vector2.new(colorBoxX, elementY),
                                    Vector2.new(checkSize, checkSize),
                                    Theme.Border,
                                    1,
                                    Scale(2),
                                    1
                                )
                                
                                -- Store position for popup
                                if element.ColorPicker.Open then
                                    element.ColorPicker._x = colorBoxX
                                    element.ColorPicker._y = elementY
                                end
                            end
                            
                            elementY = elementY + Scale(22)
                            
                        elseif element.Type == "Slider" then
                            -- Slider label and value
                            DrawingImmediate.OutlinedText(
                                Vector2.new(columnX + Scale(10), elementY),
                                fontSize - 1,
                                Theme.Text,
                                1,
                                element.Text,
                                false,
                                "Tamzen"
                            )
                            
                            local valueText = tostring(math.floor(element.Value)) .. element.Suffix
                            -- Estimate text width and position from right edge
                            local estimatedTextWidth = #valueText * (fontSize - 1) * 0.6
                            DrawingImmediate.OutlinedText(
                                Vector2.new(columnX + columnWidth - estimatedTextWidth - Scale(10), elementY),
                                fontSize - 1,
                                Theme.Accent,
                                1,
                                valueText,
                                false,
                                "Tamzen"
                            )
                            
                            -- Slider bar
                            local sliderY = elementY + Scale(18)
                            local sliderWidth = columnWidth - Scale(20)
                            local sliderX = columnX + Scale(10)
                            
                            -- Background
                            local sliderBarHeight = Scale(4)
                            DrawingImmediate.FilledRectangle(
                                Vector2.new(sliderX, sliderY),
                                Vector2.new(sliderWidth, sliderBarHeight),
                                Theme.Element,
                                1,
                                Scale(2)
                            )
                            
                            -- Fill
                            local percent = (element.Value - element.Min) / (element.Max - element.Min)
                            DrawingImmediate.FilledRectangle(
                                Vector2.new(sliderX, sliderY),
                                Vector2.new(sliderWidth * percent, sliderBarHeight),
                                Theme.Accent,
                                1,
                                Scale(2)
                            )
                            
                            -- Handle
                            DrawingImmediate.FilledCircle(
                                Vector2.new(sliderX + sliderWidth * percent, sliderY + sliderBarHeight / 2),
                                Scale(6),
                                Theme.AccentDark,
                                1,
                                16
                            )
                            
                            elementY = elementY + Scale(35)
                            
                        elseif element.Type == "Dropdown" then
                            -- Dropdown label
                            DrawingImmediate.OutlinedText(
                                Vector2.new(columnX + Scale(10), elementY),
                                fontSize - 1,
                                Theme.TextDim,
                                1,
                                element.Text,
                                false,
                                "Tamzen"
                            )
                            
                            -- Dropdown button
                            local dropY = elementY + Scale(18)
                            local dropWidth = columnWidth - Scale(20)
                            local dropHeight = Scale(24)
                            DrawingImmediate.FilledRectangle(
                                Vector2.new(columnX + Scale(10), dropY),
                                Vector2.new(dropWidth, dropHeight),
                                Theme.Element,
                                1,
                                Scale(3)
                            )
                            
                            DrawingImmediate.Rectangle(
                                Vector2.new(columnX + Scale(10), dropY),
                                Vector2.new(dropWidth, dropHeight),
                                Theme.Border,
                                1,
                                Scale(3),
                                1
                            )
                            
                            -- Selected text
                            local displayText = element.Selected
                            if element.Multi then
                                if #element.Selected == 0 then
                                    displayText = "None"
                                else
                                    -- Join selected items with commas and truncate if too long
                                    displayText = table.concat(element.Selected, ", ")
                                    local maxChars = math.floor((dropWidth - Scale(30)) / (fontSize - 1) * 1.5)
                                    if #displayText > maxChars then
                                        displayText = string.sub(displayText, 1, maxChars - 3) .. "..."
                                    end
                                end
                            end
                            
                            DrawingImmediate.OutlinedText(
                                Vector2.new(columnX + Scale(15), dropY + Scale(6)),
                                fontSize - 1,
                                Theme.Text,
                                1,
                                displayText,
                                false,
                                "Tamzen"
                            )
                            
                            -- Arrow
                            DrawingImmediate.OutlinedText(
                                Vector2.new(columnX + Scale(10) + dropWidth - Scale(15), dropY + Scale(6)),
                                fontSize - 2,
                                Theme.TextDim,
                                1,
                                element.Open and "^" or "v",
                                false,
                                "Tamzen"
                            )
                            
                            elementY = elementY + Scale(50)
                            
                        elseif element.Type == "Label" then
                            DrawingImmediate.OutlinedText(
                                Vector2.new(columnX + Scale(10), elementY),
                                fontSize - 2,
                                Theme.TextDim,
                                1,
                                element.Text,
                                false,
                                "Tamzen"
                            )
                            elementY = elementY + Scale(18)
                        end
                    end
                    
                    currentY = currentY + sectionHeight + Scale(10)
                end
            end
            
            columnX = columnX + columnWidth + columnSpacing
        end
        
        -- Render dropdowns and color pickers on top
        columnX = self.X + columnSpacing
        for colIndex, column in ipairs(self.CurrentTab.Columns) do
            local currentY = contentY - scrollOffset
            
            for _, section in ipairs(column.Elements) do
                if section.Type == "Section" then
                    local elementY = currentY + Scale(35)
                    
                    for _, element in ipairs(section.Elements) do
                        if element.Type == "Toggle" then
                            -- Render color picker popup
                            if element.ColorPicker and element.ColorPicker.Open then
                                local colorBoxX = columnX + columnWidth - Scale(40)
                                local pickerX = colorBoxX + Scale(20)
                                local pickerY = elementY
                                local pickerWidth = Scale(180)
                                local pickerHeight = Scale(160)
                                local gradientSize = Scale(140)
                                
                                -- Picker background
                                DrawingImmediate.FilledRectangle(
                                    Vector2.new(pickerX, pickerY),
                                    Vector2.new(pickerWidth, pickerHeight),
                                    Theme.Section,
                                    1,
                                    Scale(4)
                                )
                                
                                -- Border
                                DrawingImmediate.Rectangle(
                                    Vector2.new(pickerX, pickerY),
                                    Vector2.new(pickerWidth, pickerHeight),
                                    Theme.Border,
                                    1,
                                    Scale(4),
                                    2
                                )
                                
                                -- Render 2D gradient picker
                                local cp = element.ColorPicker
                                local gridSize = Scale(10)
                                for gx = 0, gradientSize - gridSize, gridSize do
                                    for gy = 0, gradientSize - gridSize, gridSize do
                                        local s = gx / gradientSize
                                        local v = 1 - (gy / gradientSize)
                                        
                                        -- Convert HSV to RGB for gradient
                                        local h = cp.Hue * 6
                                        local c = v * s
                                        local x = c * (1 - math.abs((h % 2) - 1))
                                        local m = v - c
                                        
                                        local r, g, b
                                        if h < 1 then r, g, b = c, x, 0
                                        elseif h < 2 then r, g, b = x, c, 0
                                        elseif h < 3 then r, g, b = 0, c, x
                                        elseif h < 4 then r, g, b = 0, x, c
                                        elseif h < 5 then r, g, b = x, 0, c
                                        else r, g, b = c, 0, x
                                        end
                                        
                                        DrawingImmediate.FilledRectangle(
                                            Vector2.new(pickerX + Scale(10) + gx, pickerY + Scale(10) + gy),
                                            Vector2.new(gridSize, gridSize),
                                            Color3.new(r + m, g + m, b + m),
                                            1,
                                            0
                                        )
                                    end
                                end
                                
                                -- Picker cursor
                                local cursorX = pickerX + Scale(10) + (cp.Saturation * gradientSize)
                                local cursorY = pickerY + Scale(10) + ((1 - cp.Value) * gradientSize)
                                DrawingImmediate.Circle(
                                    Vector2.new(cursorX, cursorY),
                                    Scale(5),
                                    Color3.fromRGB(255, 255, 255),
                                    1,
                                    16,
                                    2
                                )
                                DrawingImmediate.Circle(
                                    Vector2.new(cursorX, cursorY),
                                    Scale(4),
                                    Color3.fromRGB(0, 0, 0),
                                    1,
                                    16,
                                    1
                                )
                                
                                -- Hue slider
                                local hueX = pickerX + gradientSize + Scale(20)
                                local hueSliceSize = Scale(5)
                                for i = 0, gradientSize - hueSliceSize, hueSliceSize do
                                    local hue = i / gradientSize
                                    local h = hue * 6
                                    local c = 1
                                    local x = c * (1 - math.abs((h % 2) - 1))
                                    
                                    local r, g, b
                                    if h < 1 then r, g, b = c, x, 0
                                    elseif h < 2 then r, g, b = x, c, 0
                                    elseif h < 3 then r, g, b = 0, c, x
                                    elseif h < 4 then r, g, b = 0, x, c
                                    elseif h < 5 then r, g, b = x, 0, c
                                    else r, g, b = c, 0, x
                                    end
                                    
                                    DrawingImmediate.FilledRectangle(
                                        Vector2.new(hueX, pickerY + Scale(10) + i),
                                        Vector2.new(Scale(15), hueSliceSize),
                                        Color3.new(r, g, b),
                                        1,
                                        0
                                    )
                                end
                                
                                -- Hue slider cursor
                                local hueY = pickerY + Scale(10) + (cp.Hue * gradientSize)
                                DrawingImmediate.FilledRectangle(
                                    Vector2.new(hueX - Scale(2), hueY - Scale(2)),
                                    Vector2.new(Scale(19), Scale(4)),
                                    Color3.fromRGB(255, 255, 255),
                                    1,
                                    0
                                )
                            end
                            
                            elementY = elementY + Scale(22)
                            
                        elseif element.Type == "Slider" then
                            elementY = elementY + Scale(35)
                            
                        elseif element.Type == "Dropdown" then
                            -- Render dropdown menu
                            if element.Open then
                                local dropY = elementY + Scale(18)
                                local dropWidth = columnWidth - Scale(20)
                                local dropHeight = Scale(24)
                                local optionHeight = Scale(22)
                                local menuHeight = #element.Options * optionHeight
                                local menuStartY = dropY + dropHeight + Scale(2)
                                
                                -- Dropdown menu background
                                DrawingImmediate.FilledRectangle(
                                    Vector2.new(columnX + Scale(10), menuStartY),
                                    Vector2.new(dropWidth, menuHeight),
                                    Theme.Element,
                                    1,
                                    Scale(3)
                                )
                                
                                -- Border
                                DrawingImmediate.Rectangle(
                                    Vector2.new(columnX + Scale(10), menuStartY),
                                    Vector2.new(dropWidth, menuHeight),
                                    Theme.Border,
                                    1,
                                    Scale(3),
                                    1
                                )
                                
                                -- Options
                                local optionY = menuStartY
                                local mousePos = getmouseposition()
                                for _, option in ipairs(element.Options) do
                                    -- Hover effect
                                    if IsPointInRect(mousePos.X, mousePos.Y, columnX + Scale(10), optionY, dropWidth, optionHeight) then
                                        DrawingImmediate.FilledRectangle(
                                            Vector2.new(columnX + Scale(10), optionY),
                                            Vector2.new(dropWidth, optionHeight),
                                            Theme.Accent,
                                            0.3,
                                            0
                                        )
                                    end
                                    
                                    if element.Multi then
                                        -- Multi-select: Show checkbox
                                        local checkSize = Scale(12)
                                        local checkX = columnX + Scale(15)
                                        local checkY = optionY + Scale(5)
                                        local isSelected = element:IsSelected(option)
                                        
                                        DrawingImmediate.FilledRectangle(
                                            Vector2.new(checkX, checkY),
                                            Vector2.new(checkSize, checkSize),
                                            isSelected and Theme.Accent or Theme.Element,
                                            1,
                                            Scale(2)
                                        )
                                        
                                        DrawingImmediate.Rectangle(
                                            Vector2.new(checkX, checkY),
                                            Vector2.new(checkSize, checkSize),
                                            Theme.Border,
                                            1,
                                            Scale(2),
                                            1
                                        )
                                        
                                        -- Option text (indented)
                                        DrawingImmediate.OutlinedText(
                                            Vector2.new(checkX + checkSize + Scale(8), optionY + Scale(5)),
                                            fontSize - 1,
                                            Theme.Text,
                                            1,
                                            option,
                                            false,
                                            "Tamzen"
                                        )
                                    else
                                        -- Single-select: Regular text
                                        local isSelected = option == element.Selected
                                        DrawingImmediate.OutlinedText(
                                            Vector2.new(columnX + Scale(15), optionY + Scale(5)),
                                            fontSize - 1,
                                            isSelected and Theme.Accent or Theme.Text,
                                            1,
                                            option,
                                            false,
                                            "Tamzen"
                                        )
                                    end
                                    
                                    optionY = optionY + optionHeight
                                end
                            end
                            
                            elementY = elementY + Scale(50)
                            
                        elseif element.Type == "Label" then
                            elementY = elementY + Scale(18)
                        end
                    end
                    
                    local sectionHeight = self:CalculateSectionHeight(section)
                    currentY = currentY + sectionHeight + Scale(10)
                end
            end
            
            columnX = columnX + columnWidth + columnSpacing
        end
        
        -- Render scrollbar
        local contentStartY = tabBarY + tabBarHeight + Scale(10)
        local visibleHeight = self.Height - (contentStartY - self.Y) - Scale(10)
        local totalContentHeight = 0
        
        -- Calculate total content height
        for _, column in ipairs(self.CurrentTab.Columns) do
            local columnHeight = 0
            for _, section in ipairs(column.Elements) do
                if section.Type == "Section" then
                    columnHeight = columnHeight + self:CalculateSectionHeight(section) + Scale(10)
                end
            end
            totalContentHeight = math.max(totalContentHeight, columnHeight)
        end
        
        if totalContentHeight > visibleHeight then
            local scrollbarWidth = Scale(8)
            local scrollbarX = self.X + self.Width - scrollbarWidth - Scale(5)
            local scrollbarY = contentStartY
            local scrollbarHeight = visibleHeight
            local maxScroll = totalContentHeight - visibleHeight
            local currentScroll = self.ScrollOffsets[self.CurrentTab] or 0
            
            -- Scrollbar background
            DrawingImmediate.FilledRectangle(
                Vector2.new(scrollbarX, scrollbarY),
                Vector2.new(scrollbarWidth, scrollbarHeight),
                Color3.fromRGB(40, 40, 40),
                1,
                Scale(4)
            )
            
            -- Scrollbar thumb
            local thumbHeight = math.max(Scale(20), (visibleHeight / totalContentHeight) * scrollbarHeight)
            local thumbY = scrollbarY + (currentScroll / maxScroll) * (scrollbarHeight - thumbHeight)
            
            DrawingImmediate.FilledRectangle(
                Vector2.new(scrollbarX, thumbY),
                Vector2.new(scrollbarWidth, thumbHeight),
                Color3.fromRGB(80, 80, 80),
                1,
                Scale(4)
            )
            
            -- Scrollbar border
            DrawingImmediate.Rectangle(
                Vector2.new(scrollbarX, scrollbarY),
                Vector2.new(scrollbarWidth, scrollbarHeight),
                Color3.fromRGB(60, 60, 60),
                1,
                Scale(4),
                Scale(1)
            )
        end
    end
    
    function window:CalculateSectionHeight(section)
        local height = Scale(35) -- Header
        
        for _, element in ipairs(section.Elements) do
            if element.Type == "Toggle" then
                height = height + Scale(22)
            elseif element.Type == "Slider" then
                height = height + Scale(35)
            elseif element.Type == "Dropdown" then
                height = height + Scale(50)
            elseif element.Type == "Label" then
                height = height + Scale(18)
            end
        end
        
        return height + Scale(10) -- Bottom padding
    end
    
    function window:UpdateInput()
        -- Handle keybinds even when UI is hidden
        self:HandleKeybinds()
        
        if not self.Visible then return end
        
        local mousePos = getmouseposition()
        local mx, my = mousePos.X, mousePos.Y
        
        local mousePressed = isleftpressed()
        local mouseClicked = mousePressed and not self.LastMouseState
        local mouseReleased = not mousePressed and self.LastMouseState
        
        -- Handle dragging
        if mouseReleased then
            self.Dragging = false
            self.DraggingSlider = nil
            self.DraggingColorPicker = nil
            self.DraggingScrollbar = false
            -- Reset all dragging states
            for _, tab in ipairs(self.Tabs) do
                for _, column in ipairs(tab.Columns) do
                    for _, section in ipairs(column.Elements) do
                        if section.Type == "Section" then
                            for _, element in ipairs(section.Elements) do
                                if element.Type == "Slider" then
                                    element.Dragging = false
                                elseif element.Type == "Toggle" and element.ColorPicker then
                                    element.ColorPicker.DraggingPicker = false
                                    element.ColorPicker.DraggingHue = false
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if mousePressed and self.Dragging then
            self.X = mx - self.DragOffsetX
            self.Y = my - self.DragOffsetY
            self.LastMouseState = mousePressed
            return
        end
        
        -- Don't process clicks on UI elements if we're dragging the window
        if self.Dragging then
            self.LastMouseState = mousePressed
            return
        end
        
        -- Handle active slider dragging
        if self.DraggingSlider and mousePressed then
            local element = self.DraggingSlider
            local sliderWidth = element._sliderWidth
            local sliderX = element._sliderX
            
            local percent = math.clamp((mx - sliderX) / sliderWidth, 0, 1)
            element.Value = element.Min + (element.Max - element.Min) * percent
            pcall(element.Callback, element.Value)
            self.LastMouseState = mousePressed
            return
        end
        
        -- Handle active color picker dragging
        if self.DraggingColorPicker and mousePressed then
            local cp = self.DraggingColorPicker
            
            if cp.DraggingPicker then
                local pickerX = cp._pickerX
                local pickerY = cp._pickerY
                local gradientSize = cp._gradientSize
                
                local relX = math.clamp((mx - (pickerX + Scale(10))) / gradientSize, 0, 1)
                local relY = math.clamp((my - (pickerY + Scale(10))) / gradientSize, 0, 1)
                cp.Saturation = relX
                cp.Value = 1 - relY
                cp:UpdateFromHSV()
                self.LastMouseState = mousePressed
                return
            end
            
            if cp.DraggingHue then
                local pickerY = cp._pickerY
                local gradientSize = cp._gradientSize
                
                local relY = math.clamp((my - (pickerY + Scale(10))) / gradientSize, 0, 1)
                cp.Hue = relY
                cp:UpdateFromHSV()
                self.LastMouseState = mousePressed
                return
            end
        end
        
        -- Handle scrollbar dragging
        if self.DraggingScrollbar and mousePressed then
            if not self.CurrentTab then 
                self.LastMouseState = mousePressed
                return 
            end
            
            local contentStartY = self.Y + Scale(35) + Scale(28) + Scale(10) -- tabBarY + tabBarHeight + Scale(10)
            local visibleHeight = self.Height - (contentStartY - self.Y) - Scale(10)
            local totalContentHeight = 0
            
            -- Calculate total content height
            for _, column in ipairs(self.CurrentTab.Columns) do
                local columnHeight = 0
                for _, section in ipairs(column.Elements) do
                    if section.Type == "Section" then
                        columnHeight = columnHeight + self:CalculateSectionHeight(section) + Scale(10)
                    end
                end
                totalContentHeight = math.max(totalContentHeight, columnHeight)
            end
            
            if totalContentHeight > visibleHeight then
                local scrollbarWidth = Scale(8)
                local scrollbarX = self.X + self.Width - scrollbarWidth - Scale(5)
                local scrollbarY = contentStartY
                local scrollbarHeight = visibleHeight
                local maxScroll = totalContentHeight - visibleHeight
                
                -- Calculate new scroll position based on mouse Y
                local thumbHeight = math.max(Scale(20), (visibleHeight / totalContentHeight) * scrollbarHeight)
                local relY = math.clamp((my - scrollbarY) / (scrollbarHeight - thumbHeight), 0, 1)
                local newScroll = relY * maxScroll
                
                self.ScrollOffsets[self.CurrentTab] = newScroll
            end
            
            self.LastMouseState = mousePressed
            return
        end
        
        if mouseClicked then
            -- Check tab clicks
            local tabBarY = self.Y + Scale(35)
            local tabX = self.X + Scale(10)
            local tabWidth = Scale(120)
            
            for i, tab in ipairs(self.Tabs) do
                if IsPointInRect(mx, my, tabX, tabBarY, tabWidth - Scale(5), Scale(28)) then
                    self.CurrentTab = tab
                    if not self.ScrollOffsets[tab] then
                        self.ScrollOffsets[tab] = 0
                    end
                    self.LastMouseState = mousePressed
                    return
                end
                tabX = tabX + tabWidth
            end
            
            -- Check title bar for dragging
            if IsPointInRect(mx, my, self.X, self.Y, self.Width, Scale(30)) then
                self.Dragging = true
                self.DragOffsetX = mx - self.X
                self.DragOffsetY = my - self.Y
                self.LastMouseState = mousePressed
                return
            end
            
            -- Check scrollbar click
            if self.CurrentTab then
                local contentStartY = self.Y + Scale(35) + Scale(28) + Scale(10)
                local visibleHeight = self.Height - (contentStartY - self.Y) - Scale(10)
                local totalContentHeight = 0
                
                -- Calculate total content height
                for _, column in ipairs(self.CurrentTab.Columns) do
                    local columnHeight = 0
                    for _, section in ipairs(column.Elements) do
                        if section.Type == "Section" then
                            columnHeight = columnHeight + self:CalculateSectionHeight(section) + Scale(10)
                        end
                    end
                    totalContentHeight = math.max(totalContentHeight, columnHeight)
                end
                
                if totalContentHeight > visibleHeight then
                    local scrollbarWidth = Scale(8)
                    local scrollbarX = self.X + self.Width - scrollbarWidth - Scale(5)
                    local scrollbarY = contentStartY
                    local scrollbarHeight = visibleHeight
                    
                    -- Check if clicked on scrollbar
                    if IsPointInRect(mx, my, scrollbarX, scrollbarY, scrollbarWidth, scrollbarHeight) then
                        self.DraggingScrollbar = true
                        self.LastMouseState = mousePressed
                        return
                    end
                end
            end
        end
        
        -- Process element interactions
        if not self.CurrentTab then
            self.LastMouseState = mousePressed
            return
        end
        
        local tabBarY = self.Y + Scale(35)
        local tabBarHeight = Scale(28)
        local contentY = tabBarY + tabBarHeight + Scale(10)
        local scrollOffset = self.ScrollOffsets[self.CurrentTab] or 0
        
        local numColumns = #self.CurrentTab.Columns
        if numColumns == 0 then
            self.LastMouseState = mousePressed
            return
        end
        
        local columnSpacing = Scale(10)
        local totalSpacing = columnSpacing * (numColumns + 1)
        local columnWidth = (self.Width - totalSpacing) / numColumns
        local columnX = self.X + columnSpacing
        
        for colIndex, column in ipairs(self.CurrentTab.Columns) do
            local currentY = contentY - scrollOffset
            
            for _, section in ipairs(column.Elements) do
                if section.Type == "Section" then
                    local elementY = currentY + Scale(35)
                    
                    for _, element in ipairs(section.Elements) do
                        if element.Type == "Toggle" then
                            local checkX = columnX + columnWidth - Scale(60)
                            local checkSize = Scale(14)
                            
                            -- Check toggle click
                            if mouseClicked and IsPointInRect(mx, my, checkX, elementY, checkSize, checkSize) then
                                element.Value = not element.Value
                                pcall(element.Callback, element.Value)
                                self.LastMouseState = mousePressed
                                return
                            end
                            
                            -- Check color picker click
                            if element.ColorPicker then
                                local colorBoxX = columnX + columnWidth - Scale(40)
                                if mouseClicked and IsPointInRect(mx, my, colorBoxX, elementY, checkSize, checkSize) then
                                    element.ColorPicker.Open = not element.ColorPicker.Open
                                    self.LastMouseState = mousePressed
                                    return
                                end
                                
                                -- Handle color picker interactions
                                if element.ColorPicker.Open then
                                    local pickerX = colorBoxX + Scale(20)
                                    local pickerY = elementY
                                    local pickerWidth = Scale(180)
                                    local pickerHeight = Scale(160)
                                    local gradientSize = Scale(140)
                                    
                                    -- Store picker data for dragging
                                    element.ColorPicker._pickerX = pickerX
                                    element.ColorPicker._pickerY = pickerY
                                    element.ColorPicker._gradientSize = gradientSize
                                    
                                    -- 2D gradient area
                                    if mouseClicked and IsPointInRect(mx, my, pickerX + Scale(10), pickerY + Scale(10), gradientSize, gradientSize) then
                                        if not self.DraggingColorPicker then
                                            element.ColorPicker.DraggingPicker = true
                                            self.DraggingColorPicker = element.ColorPicker
                                            
                                            -- Update immediately
                                            local relX = math.clamp((mx - (pickerX + Scale(10))) / gradientSize, 0, 1)
                                            local relY = math.clamp((my - (pickerY + Scale(10))) / gradientSize, 0, 1)
                                            element.ColorPicker.Saturation = relX
                                            element.ColorPicker.Value = 1 - relY
                                            element.ColorPicker:UpdateFromHSV()
                                        end
                                    end
                                    
                                    -- Hue slider
                                    local hueX = pickerX + gradientSize + Scale(20)
                                    if mouseClicked and IsPointInRect(mx, my, hueX, pickerY + Scale(10), Scale(15), gradientSize) then
                                        if not self.DraggingColorPicker then
                                            element.ColorPicker.DraggingHue = true
                                            self.DraggingColorPicker = element.ColorPicker
                                            
                                            -- Update immediately
                                            local relY = math.clamp((my - (pickerY + Scale(10))) / gradientSize, 0, 1)
                                            element.ColorPicker.Hue = relY
                                            element.ColorPicker:UpdateFromHSV()
                                        end
                                    end
                                end
                            end
                            
                            elementY = elementY + Scale(22)
                            
                        elseif element.Type == "Slider" then
                            local sliderY = elementY + Scale(18)
                            local sliderWidth = columnWidth - Scale(20)
                            local sliderX = columnX + Scale(10)
                            
                            -- Check slider interaction
                            if mouseClicked and IsPointInRect(mx, my, sliderX, sliderY - Scale(5), sliderWidth, Scale(14)) then
                                if not self.DraggingSlider then
                                    element.Dragging = true
                                    element._sliderWidth = sliderWidth
                                    element._sliderX = sliderX
                                    self.DraggingSlider = element
                                    
                                    -- Update value immediately
                                    local percent = math.clamp((mx - sliderX) / sliderWidth, 0, 1)
                                    element.Value = element.Min + (element.Max - element.Min) * percent
                                    pcall(element.Callback, element.Value)
                                end
                            end
                            
                            elementY = elementY + Scale(35)
                            
                        elseif element.Type == "Dropdown" then
                            local dropY = elementY + Scale(18)
                            local dropWidth = columnWidth - Scale(20)
                            local dropHeight = Scale(24)
                            local optionHeight = Scale(22)
                            
                            -- Check dropdown click
                            if mouseClicked and IsPointInRect(mx, my, columnX + Scale(10), dropY, dropWidth, dropHeight) then
                                element.Open = not element.Open
                                self.LastMouseState = mousePressed
                                return
                            end
                            
                            -- Check option clicks
                            if element.Open then
                                local optionY = dropY + dropHeight + Scale(2)
                                for _, option in ipairs(element.Options) do
                                    if mouseClicked and IsPointInRect(mx, my, columnX + Scale(10), optionY, dropWidth, optionHeight) then
                                        if element.Multi then
                                            -- Multi-select: Toggle option
                                            element:Toggle(option)
                                            -- Keep dropdown open for multi-select
                                        else
                                            -- Single-select: Select and close
                                            element.Selected = option
                                            element.Open = false
                                            pcall(element.Callback, option)
                                        end
                                        self.LastMouseState = mousePressed
                                        return
                                    end
                                    optionY = optionY + optionHeight
                                end
                            end
                            
                            elementY = elementY + Scale(50)
                            
                        elseif element.Type == "Label" then
                            elementY = elementY + Scale(18)
                        end
                    end
                    
                    local sectionHeight = self:CalculateSectionHeight(section)
                    currentY = currentY + sectionHeight + Scale(10)
                end
            end
            
            columnX = columnX + columnWidth + columnSpacing
        end
        
        self.LastMouseState = mousePressed
    end
    
    function window:Close()
        self.Visible = false
    end
    
    return window
end

return SevereUI


