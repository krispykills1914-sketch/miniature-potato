-- Tapology UI library. Load this alone for the window, pages, and controls.

if getgenv().Library then 
    getgenv().Library:Unload()
end

local Library do
    local CloneRef = cloneref or function(Object)
        return Object
    end

    local function GetService(Name)
        local Service
        for _ = 1, 4 do
            Service = game:GetService(Name)
            if typeof(Service) == "Instance" then
                break
            end
            task.wait()
        end
        if typeof(Service) ~= "Instance" then
            return nil
        end
        local Ok, Wrapped = pcall(CloneRef, Service)
        if Ok and typeof(Wrapped) == "Instance" then
            return Wrapped
        end
        return Service
    end

    local UserInputService = GetService("UserInputService")
    local Players = GetService("Players")
    local Workspace = GetService("Workspace")
    local HttpService = GetService("HttpService")
    local TweenService = GetService("TweenService")
    local RunService = GetService("RunService")

    pcall(function()
        if type(getconnections) ~= "function" or type(debug) ~= "table" or type(debug.getconstants) ~= "function" then
            return
        end
        local Mark = { Watermark = true, FreecamDebug = true, NotifHolder = true, IsShown = true }
        for _, Signal in { RunService.RenderStepped, RunService.Heartbeat, RunService.Stepped } do
            for _, Connection in getconnections(Signal) do
                local Func = Connection.Function
                if type(Func) == "function" and (debug.info(Func, "s") or "") == "" then
                    local Ok, Constants = pcall(debug.getconstants, Func)
                    if Ok and type(Constants) == "table" then
                        for _, Value in Constants do
                            if Mark[Value] then
                                pcall(function()
                                    Connection:Disconnect()
                                end)
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
    local GuiService = GetService("GuiService")
    local MarketplaceService = GetService("MarketplaceService")
    local CoreGui = GetService("CoreGui")
    local Lighting = GetService("Lighting")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = CloneRef(Players.LocalPlayer)

    local function GuiHost()
        local Existing = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if Existing then
            return Existing
        end
        local Ok, Gui = pcall(function()
            return LocalPlayer:WaitForChild("PlayerGui", 5)
        end)
        return Ok and Gui or CoreGui
    end

    local function RealPlayer()
        return Players.LocalPlayer
    end

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new

    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local InstanceNew = Instance.new

    local MathClamp = math.clamp
    local MathFloor = math.floor

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub

    local GameFolder = (getgenv and getgenv().TapologyGame) or "rivals"

    Library = {
        Flags = { },
        
        Theme = {
            ["Background"] = FromRGB(44, 44, 44),
            ["Inline"] = FromRGB(47, 47, 47),
            ["Page Background"] = FromRGB(49, 49, 49),
            ["Border"] = FromRGB(5, 5, 5),
            ["Outline"] = FromRGB(56, 56, 56),
            ["Accent"] = FromRGB(96, 126, 255),
            ["Element"] = FromRGB(44, 44, 44),
            ["Hovered Element"] = FromRGB(55, 55, 55),
            ["Text"] = FromRGB(225, 225, 225),
            ["Inactive Text"] = FromRGB(115, 115, 115),
            ["Text Border"] = FromRGB(0, 0, 0)
        },

        ThemePresets = {
            ["Tapology"] = {
                ["Background"] = "#2C2C2C", ["Inline"] = "#2F2F2F", ["Page Background"] = "#313131",
                ["Border"] = "#050505", ["Outline"] = "#383838", ["Accent"] = "#607EFF",
                ["Element"] = "#2C2C2C", ["Hovered Element"] = "#373737", ["Text"] = "#E1E1E1",
                ["Inactive Text"] = "#737373", ["Text Border"] = "#000000"
            },
            ["Graphite"] = {
                ["Background"] = "#1E1E1E", ["Inline"] = "#131313", ["Page Background"] = "#212121",
                ["Border"] = "#050505", ["Outline"] = "#383838", ["Accent"] = "#607EFF",
                ["Element"] = "#2C2C2C", ["Hovered Element"] = "#373737", ["Text"] = "#E1E1E1",
                ["Inactive Text"] = "#737373", ["Text Border"] = "#000000"
            },
            ["Midnight"] = {
                ["Background"] = "#0C0C11", ["Inline"] = "#101016", ["Page Background"] = "#14141C",
                ["Border"] = "#020204", ["Outline"] = "#282938", ["Accent"] = "#607EFF",
                ["Element"] = "#1B1B25", ["Hovered Element"] = "#252634", ["Text"] = "#E4E6F0",
                ["Inactive Text"] = "#686C86", ["Text Border"] = "#000000"
            },
            ["Bone"] = {
                ["Background"] = "#3A3936", ["Inline"] = "#34332F", ["Page Background"] = "#403F3B",
                ["Border"] = "#080807", ["Outline"] = "#4C4A45", ["Accent"] = "#D8B46A",
                ["Element"] = "#47463F", ["Hovered Element"] = "#53524A", ["Text"] = "#ECE8DF",
                ["Inactive Text"] = "#8A867C", ["Text Border"] = "#000000"
            }
        },

        FrameBand = 3,
        AccentBars = { },
        AccentRefreshers = { },
        CopiedColor = nil,

        MenuKeybind = Enum.KeyCode.RightControl,

        Tween = {
            Time = 0.15,
            Style = Enum.EasingStyle.Quad,
            Direction = Enum.EasingDirection.Out
        },

        Folders = {
            Root = "tapology",
            Directory = "tapology/" .. GameFolder,
            Configs = "tapology/" .. GameFolder .. "/configs",
            Themes = "tapology/" .. GameFolder .. "/themes",
            Assets = "tapology/" .. GameFolder .. "/assets"
        },

        ConfigIgnore = { },

        ConfigExtension = ".tapconfig",
        ThemeExtension = ".taptheme",
        AutoloadFile = "tapology/" .. GameFolder .. "/autoload.txt",
        DefaultThemeFile = "tapology/" .. GameFolder .. "/defaulttheme.txt",

        Images = {
            ["Saturation"] = {"Saturation.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true" },
            ["Value"] = { "Value.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true" },
            ["Hue"] = { "Hue.png", "https://github.com/sametexe001/images/blob/main/hue.png?raw=true" },
            ["Scrollbar"] =  { "Scrollbar.png", "https://github.com/sametexe001/images/blob/main/scrollbar.png?raw=true" },
            ["Checkers"] = { "Checkers.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true" },
            ["Resize"] = { "Resize.png", "https://github.com/sametexe001/images/blob/main/resize.png?raw=true" },
        },

        Pages = { },
        Sections = { },
        Connections = { },
        Threads = { },
        ThemeMap = { },
        ThemeItems = { },

        SetFlags = { },
        FlagDefaults = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        Font = nil,
        KeyList = nil,

        CurrentColorpicker = nil
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    for _, FolderPath in { Library.Folders.Root, Library.Folders.Directory } do
        if not isfolder(FolderPath) then
            makefolder(FolderPath)
        end
    end

    for Key, FolderPath in Library.Folders do
        if Key ~= "Directory" and Key ~= "Root" and not isfolder(FolderPath) then
            makefolder(FolderPath)
        end
    end

    -- Images / fonts / sounds are fetched lazily into Assets when first used.

    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.Border = function(self)
            if not self.Instance then 
                return
            end

            local Item = self.Instance
            local UIStroke = Instances:Create("UIStroke", {
                Parent = Item,
                Color = Library.Theme.Border,
                Thickness = 1,
                LineJoinMode = Enum.LineJoinMode.Miter
            })

            UIStroke:AddToTheme({Color = "Border"})

            return UIStroke
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance
            Gui.Active = true

            local Dragging = false 
            local DragStart
            local StartPosition 

            local function Inside(Position)
                local Abs = Gui.AbsolutePosition
                local Size = Gui.AbsoluteSize
                return Position.X >= Abs.X and Position.X <= Abs.X + Size.X
                    and Position.Y >= Abs.Y and Position.Y <= Abs.Y + Size.Y
            end

            local function Blocked(Position)
                local Screen = Gui:FindFirstAncestorOfClass("ScreenGui")
                local Host = Screen and Screen.Parent
                if not Host or not Host.GetGuiObjectsAtPosition then
                    return true
                end
                local Ok, Objects = pcall(Host.GetGuiObjectsAtPosition, Host, Position.X, Position.Y)
                if not Ok or type(Objects) ~= "table" then
                    return true
                end
                for _, Object in Objects do
                    if Object:IsDescendantOf(Gui) and (Object:IsA("GuiButton") or Object:IsA("TextBox")) then
                        return true
                    end
                end
                return false
            end

            local function Set(Input)
                if not DragStart or not StartPosition then
                    return
                end
                local DragDelta = Input.Position - DragStart
                Gui.Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)
            end

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position
                end
            end)

            self:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end
                if not Gui.Visible or not Inside(Input.Position) or Blocked(Input.Position) then
                    return
                end
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    Set(Input)
                end
            end)

            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local Start = UDim2New()
            local Delta = UDim2New()
            local ResizeMax = Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

            local ResizeButton = Instances:Create("TextButton", {
				Parent = Gui,
				AnchorPoint = Vector2New(1, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 8, 0, 8),
				Position = UDim2New(1, 0, 1, 0),
                Name = "\0",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
                Visible = true,
                Text = ""
			})

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)
                end
            end)

            ResizeButton:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Resizing = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement and Resizing then
					ResizeMax = Maximum or Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

					Delta = Start + UDim2New(0, Input.Position.X, 0, Input.Position.Y)
					Delta = UDim2New(0, math.clamp(Delta.X.Offset, Minimum.X, ResizeMax.X), 0, math.clamp(Delta.Y.Offset, Minimum.Y, ResizeMax.Y))

					Tween:Create(Gui, TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Delta}, true)
                end
            end)

            return Resizing
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    local function SnapSpaceAdvance(Bytes)
        local Ok, Result = pcall(function()
            local function U16(Offset)
                return (string.unpack(">I2", Bytes, Offset + 1))
            end

            local function U32(Offset)
                return (string.unpack(">I4", Bytes, Offset + 1))
            end

            local Tables = { }
            for Index = 0, U16(4) - 1 do
                local Record = 12 + 16 * Index
                Tables[string.sub(Bytes, Record + 1, Record + 4)] = U32(Record + 8)
            end

            local Grid = U16(Tables.head + 18) / 16
            local Metrics = U16(Tables.hhea + 34)
            local Cmap = Tables.cmap
            local Glyph

            for Index = 0, U16(Cmap + 2) - 1 do
                local Sub = Cmap + U32(Cmap + 4 + 8 * Index + 4)
                if U16(Sub) == 4 then
                    local Segments = U16(Sub + 6) / 2
                    for Segment = 0, Segments - 1 do
                        if U16(Sub + 14 + Segment * 2) >= 32 then
                            local Start = U16(Sub + 16 + Segments * 2 + Segment * 2)
                            local Delta = U16(Sub + 16 + Segments * 4 + Segment * 2)
                            local RangeAt = Sub + 16 + Segments * 6 + Segment * 2
                            local Range = U16(RangeAt)
                            if Start <= 32 then
                                if Range == 0 then
                                    Glyph = (32 + Delta) % 65536
                                else
                                    local Raw = U16(RangeAt + Range + (32 - Start) * 2)
                                    Glyph = Raw ~= 0 and (Raw + Delta) % 65536 or nil
                                end
                            end
                            break
                        end
                    end
                    break
                end
            end

            if not Glyph or Glyph >= Metrics then
                return Bytes
            end

            local At = Tables.hmtx + Glyph * 4
            local Advance = U16(At)
            local Snapped = math.max(MathFloor(Advance / Grid + 0.5), 1) * Grid
            if Snapped == Advance or Snapped % 1 ~= 0 then
                return Bytes
            end

            return string.sub(Bytes, 1, At) .. string.pack(">I2", Snapped) .. string.sub(Bytes, At + 3)
        end)

        return Ok and Result or Bytes
    end

    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if Data.SnapSpace then
                Name = Name .. "-Snapped"
            end

            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end

            if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
                local Bytes = game:HttpGet(Data.Url)
                if Data.SnapSpace then
                    Bytes = SnapSpaceAdvance(Bytes)
                end
                writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", Bytes)
            end

            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
                } }
            }

            writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        function CustomFont:Get(Name)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end
        end

        Library.Font = CustomFont:New("Windows-XP-Tahoma", 200, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/windows-xp-tahoma.ttf",
            SnapSpace = true
        })
    end

    local FontBase = "https://raw.githubusercontent.com/Cyerc/LuaFiles/main/Fonts/"

    local SametBase = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/"

    Library.FontList = {
        { "Tahoma", "windows-xp-tahoma.ttf", true },
        { "Tahoma Bold", SametBase .. "tahomabd.ttf" },
        { "Tahoma 8px", SametBase .. "fs-tahoma-8px.ttf" },
        { "Tahoma 8px Bold", SametBase .. "TAHOMA-8PT-BOLD-WINDOWS-XP.TTF" },
        { "Smallest Pixel", SametBase .. "smallest_pixel-7.ttf" },
        { "Pixel Operator", SametBase .. "PixelOperator.ttf" },
        { "Pixel Arial", SametBase .. "PIXEARG_.TTF" },
        { "NDS12", SametBase .. "NDS12.ttf" },
        { "Reactor7", SametBase .. "Reactor7.ttf" },
        { "Basis33", SametBase .. "basis33.ttf" },
        { "SGK075", SametBase .. "SGK075.ttf" },
        { "Minecraft Standard", SametBase .. "MinecraftStandard.ttf" },
        { "Roboto Mono", SametBase .. "RobotoMono-Regular.ttf" },
        { "Lato Bold", SametBase .. "Lato-Bold.ttf" },
        { "Figtree", SametBase .. "Figtree-SemiBold.ttf" },
        { "Outfit", SametBase .. "Outfit-Medium.ttf" },
        { "Lexend", SametBase .. "Lexend-Medium.ttf" },
        { "Prompt", SametBase .. "Prompt-Medium.ttf" },
        { "Hanken Grotesk", SametBase .. "HankenGrotesk-SemiBold.ttf" },
        { "Comfortaa", SametBase .. "Comfortaa-Regular.ttf" },
        { "Bubblegum", SametBase .. "Bubblegum-Sans.ttf" },
        { "Verdana", "verdana.ttf" },
        { "Verdana Bold", "verdana-bold.ttf" },
        { "Inter", "Inter.ttf" },
        { "Inter Medium", "InterMedium.ttf" },
        { "Inter Semibold", "InterSemibold.ttf" },
        { "Inter Bold", "InterBold.ttf" },
        { "Poppins", "Poppins-Medium.ttf" },
        { "Monaco", "Monaco.ttf" },
        { "Lucida Console", "lucida-console.ttf" },
        { "Cozette", "cozette-vector.ttf" },
        { "Minecraftia", "minecraftia-regular.ttf" },
        { "Open Sans Px", "open-sans-px.ttf" },
        { "Proggy Clean", "proggy-clean.ttf" },
        { "Proggy Square", "proggy-square.ttf" },
        { "Proggy Tiny", "proggy-tiny.ttf" },
        { "Teachers Pet", "teachers-pet.ttf" }
    }

    Library.FontNames = { }
    for _, Entry in Library.FontList do
        TableInsert(Library.FontNames, Entry[1])
    end

    local LoadedFonts = { }

    local LoadingFonts = { }

    Library.GetFont = function(self, Name)
        if LoadedFonts[Name] then
            return LoadedFonts[Name]
        end

        if LoadingFonts[Name] then
            return Library.Font
        end

        for _, Entry in Library.FontList do
            if Entry[1] == Name then
                LoadingFonts[Name] = true

                task.spawn(function()
                    local FileName = "Font-" .. StringGSub(Name, "%s", "")
                    local Ok, Result = pcall(function()
                        return CustomFont:New(FileName, 400, "Regular", { Url = string.sub(Entry[2], 1, 4) == "http" and Entry[2] or FontBase .. Entry[2], SnapSpace = Entry[3] })
                    end)

                    LoadedFonts[Name] = (Ok and Result) or Library.Font
                end)

                return Library.Font
            end
        end

        return Library.Font
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = GuiHost(),
        Name = "\0",
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        ZIndex = 20000,
        BorderColor3 = FromRGB(0, 0, 0),
        AnchorPoint = Vector2New(0, 0),
        BackgroundTransparency = 1,
        Position = UDim2New(0, 14, 0, 14),
        Name = "\0",
        Size = UDim2New(0, 460, 1, -28),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    }) 
    
    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDimNew(0, 5)
    })

    Library.NotifAnchor = nil
    Library.ActiveNotifications = { }
    Library.MaxNotifications = 15

    local function PlaceNotifs()
        local Holder = Library and Library.NotifHolder and Library.NotifHolder.Instance
        if not (Holder and Holder.Parent) then
            return
        end
        local Target = UDim2New(0, 14, 0, 14 + GuiService:GetGuiInset().Y)
        if Holder.Position ~= Target then
            Holder.Position = Target
        end
    end

    PlaceNotifs()
    task.defer(function()
        local Camera = Workspace.CurrentCamera
        if Camera and Library and type(Library.Connect) == "function" then
            Library:Connect(Camera:GetPropertyChangedSignal("ViewportSize"), PlaceNotifs)
        end
    end)

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]
        if not ImageData then 
            return
        end

        local Path = self.Folders.Assets .. "/" .. ImageData[1]
        if not isfile(Path) then
            local Ok, Body = pcall(game.HttpGet, game, ImageData[2])
            if not (Ok and type(Body) == "string" and #Body > 16) then
                return
            end
            if makefolder and not isfolder(self.Folders.Assets) then
                pcall(makefolder, self.Folders.Assets)
            end
            local Wrote = pcall(writefile, Path, Body)
            if not Wrote then
                return
            end
        end

        local Ok, Asset = pcall(getcustomasset, Path)
        return Ok and Asset or nil
    end

    Library.ScrollbarAsset = function(self)
        return self:GetImage("Scrollbar")
    end

    Library.ApplyScrollbar = function(self, Frame, Thickness)
        local Image = self:ScrollbarAsset()
        if Image then
            Frame.TopImage = Image
            Frame.MidImage = Image
            Frame.BottomImage = Image
        end
        Frame.ScrollBarThickness = Thickness or 1
        Frame.ScrollingDirection = Enum.ScrollingDirection.Y
        Frame.ElasticBehavior = Enum.ElasticBehavior.Never
        Frame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        pcall(function()
            Frame.ScrollBarInset = Enum.ScrollBarInset.ScrollBar
        end)
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.GetTransparencyPropertyFromItem = function(self, Item)
        if Item:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Item:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Item:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Library.FadeItem = function(self, Item, Property, Visibility, Speed)
        local OldTransparency = Item[Property]
        Item[Property] = Visibility and 1 or OldTransparency

        local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
            [Property] = Visibility and OldTransparency or 1
        }, true)

        Library:Connect(NewTween.Tween.Completed, function()
            if not Visibility then 
                task.wait()
                Item[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    local CursorStep = "\0TapologyCursor"
    local ArrowIcon = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png"
    local SavedCursor

    Library.SetCursorUnlocked = function(self, Bool)
        if Bool and not SavedCursor then
            SavedCursor = {
                Behavior = UserInputService.MouseBehavior,
                Icon = UserInputService.MouseIcon,
                Enabled = UserInputService.MouseIconEnabled
            }

            RunService:BindToRenderStep(CursorStep, Enum.RenderPriority.Last.Value + 1, function()
                if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                end
                if not UserInputService.MouseIconEnabled then
                    UserInputService.MouseIconEnabled = true
                end
                if UserInputService.MouseIcon ~= ArrowIcon then
                    UserInputService.MouseIcon = ArrowIcon
                end
            end)
        elseif not Bool and SavedCursor then
            pcall(RunService.UnbindFromRenderStep, RunService, CursorStep)
            -- Restore icon only — never force LockCenter back when the menu closes.
            UserInputService.MouseIcon = SavedCursor.Icon
            UserInputService.MouseIconEnabled = SavedCursor.Enabled
            if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
            SavedCursor = nil
        end
    end

    Library.Unload = function(self)
        self:SetCursorUnlocked(false)

        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.WorldEsp then
            pcall(function()
                self.WorldEsp:Destroy()
            end)
        end

        if self.WorldMods then
            pcall(function()
                self.WorldMods:Destroy()
            end)
        end

        if self.CharacterMods then
            pcall(function()
                self.CharacterMods:Destroy()
            end)
        end

        if self.Cosmetics then
            pcall(function()
                self.Cosmetics:Destroy()
            end)
        end

        if self.Spoofer then
            pcall(function()
                self.Spoofer:Destroy()
            end)
        end

        if self.Rage then
            pcall(function()
                self.Rage:Destroy()
            end)
        end

        if self.Legit then
            pcall(function()
                self.Legit:Destroy()
            end)
        end

        for _, Key in { "Sounds", "Hud", "HitLogs", "MiscFeatures" } do
            if self[Key] then
                pcall(function()
                    self[Key]:Destroy()
                end)
            end
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Library = nil 
        getgenv().Library = nil
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)

        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            Library:Notification("Error caught in function, report this to the devs:\n"..Result, 5, FromRGB(255, 0, 0))
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("Connection_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        NewConnection.Connection = Event:Connect(function(...)
            if setthreadidentity then
                setthreadidentity(8)
            end
            return Callback(...)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("Flag Number %s %s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

    local function SerializeFlag(Value)
        if type(Value) == "table" and Value.Key then
            return { Key = tostring(Value.Key), Mode = Value.Mode }
        elseif type(Value) == "table" and (Value.Color or Value.HexValue) then
            local Hex = Value.HexValue
            if not Hex and typeof(Value.Color) == "Color3" then
                Hex = Value.Color:ToHex()
            elseif not Hex and type(Value.Color) == "string" then
                Hex = string.gsub(Value.Color, "^#", "")
            end
            return { Color = "#" .. (Hex or "FFFFFF"), Alpha = Value.Alpha or 0 }
        elseif type(Value) == "table" then
            local Copy = { }
            for Key, Item in Value do
                if type(Item) ~= "function" and type(Item) ~= "userdata" then
                    Copy[Key] = Item
                end
            end
            return Copy
        end

        return Value
    end

    local function SameFlag(A, B)
        if type(A) ~= type(B) then
            return false
        end

        if type(A) ~= "table" then
            return A == B
        end

        for Key, Value in A do
            if not SameFlag(Value, B[Key]) then
                return false
            end
        end

        for Key in B do
            if A[Key] == nil then
                return false
            end
        end

        return true
    end

    local function ConfigSkipped(Index)
        return type(Index) ~= "string" or string.sub(Index, 1, 5) == "Theme" or Library.ConfigIgnore[Index]
    end

    Library.RememberDefault = function(self, Flag)
        if ConfigSkipped(Flag) or not self.SetFlags[Flag] then
            return
        end

        self.FlagDefaults[Flag] = SerializeFlag(self.Flags[Flag])
    end

    local function ApplyFlag(Index, Value)
        local SetFunction = Library.SetFlags[Index]
        if not SetFunction or ConfigSkipped(Index) then
            return
        end

        local Current = SerializeFlag(Library.Flags[Index])
        local Target = SerializeFlag(Value)
        if SameFlag(Current, Target) then
            return
        end

        if type(Value) == "table" and Value.Key then
            SetFunction(Value)
        elseif type(Value) == "table" and Value.Color then
            SetFunction(Value.Color, Value.Alpha)
        else
            SetFunction(Value)
        end
    end

    Library.GetConfig = function(self)
        local Config = { }

        local Success, Result = Library:SafeCall(function()
            for Index in Library.SetFlags do
                if ConfigSkipped(Index) then
                    continue
                end

                local Value = SerializeFlag(Library.Flags[Index])
                if SameFlag(Value, Library.FlagDefaults[Index]) then
                    continue
                end

                Config[Index] = Value
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local function ApplyMissing()
            for Index, Default in Library.FlagDefaults do
                if Decoded[Index] == nil then
                    pcall(ApplyFlag, Index, Default)
                end
            end
        end

        local Success, Result = Library:SafeCall(function()
            ApplyMissing()

            for Index, Value in Decoded do
                pcall(ApplyFlag, Index, Value)
            end

            -- Saved callbacks can turn other options on. Put those back on their defaults.
            for _ = 1, 4 do
                local Changed = false
                for Index, Default in Library.FlagDefaults do
                    if Decoded[Index] == nil and not SameFlag(SerializeFlag(Library.Flags[Index]), SerializeFlag(Default)) then
                        pcall(ApplyFlag, Index, Default)
                        Changed = true
                    end
                end
                if not Changed then
                    break
                end
            end
        end)

        return Success
    end

    Library.ResetToDefaults = function(self)
        local Success = self:LoadConfig("{}")
        if Success then
            self:Notification("Reset to default", 3)
        else
            self:Notification("Reset failed", 3)
        end
        return Success
    end

    local function CleanName(Name)
        Name = tostring(Name or "")
        Name = StringGSub(Name, "[^%w%s%-_%.]", "")
        Name = StringGSub(Name, "^%s+", "")
        Name = StringGSub(Name, "%s+$", "")
        return Name
    end

    Library.ListFiles = function(self, Folder, Extension)
        local Names = { }

        if type(isfolder) ~= "function" or not isfolder(Folder) then
            return Names
        end

        if type(listfiles) ~= "function" then
            return Names
        end

        local Ok, Files = pcall(listfiles, Folder)
        if not Ok or type(Files) ~= "table" then
            return Names
        end

        for _, Path in Files do
            local FileName = string.match(tostring(Path), "([^/\\]+)$") or tostring(Path)
            if string.sub(FileName, -#Extension) == Extension then
                TableInsert(Names, string.sub(FileName, 1, -#Extension - 1))
            end
        end

        table.sort(Names, function(A, B)
            return string.lower(A) < string.lower(B)
        end)

        return Names
    end

    Library.ConfigPath = function(self, Name)
        return self.Folders.Configs .. "/" .. CleanName(Name) .. self.ConfigExtension
    end

    Library.ThemePath = function(self, Name)
        return self.Folders.Themes .. "/" .. CleanName(Name) .. self.ThemeExtension
    end

    Library.ConfigExists = function(self, Name)
        return CleanName(Name) ~= "" and isfile(self:ConfigPath(Name))
    end

    Library.SaveConfig = function(self, Name)
        if CleanName(Name) == "" then
            Library:Notification("Enter a config name first", 3)
            return false
        end

        writefile(self:ConfigPath(Name), self:GetConfig())
        Library:Notification("Saved config " .. CleanName(Name), 3)
        return true
    end

    Library.LoadConfigFile = function(self, Name)
        if not self:ConfigExists(Name) then
            Library:Notification("Config " .. tostring(Name) .. " not found", 3)
            return false
        end

        local Ok = self:LoadConfig(readfile(self:ConfigPath(Name)))
        if Ok ~= false then
            Library:Notification("Loaded config " .. CleanName(Name), 3)
        end
        return Ok
    end

    Library.DeleteConfig = function(self, Name)
        if self:ConfigExists(Name) then
            delfile(self:ConfigPath(Name))
            Library:Notification("Deleted config " .. CleanName(Name), 3)

            if self:GetAutoload() == CleanName(Name) then
                self:SetAutoload(nil)
            end
            return true
        end
        return false
    end

    Library.RefreshConfigsList = function(self, Element)
        Element:Refresh(self:ListFiles(self.Folders.Configs, self.ConfigExtension))
    end

    Library.GetAutoload = function(self)
        if isfile(self.AutoloadFile) then
            local Name = CleanName(readfile(self.AutoloadFile))
            if Name ~= "" then
                return Name
            end
        end
    end

    Library.SetAutoload = function(self, Name)
        if Name and CleanName(Name) ~= "" then
            writefile(self.AutoloadFile, CleanName(Name))
        elseif isfile(self.AutoloadFile) then
            delfile(self.AutoloadFile)
        end
    end

    Library.RunAutoload = function(self)
        local Name = self:GetAutoload()
        if Name and self:ConfigExists(Name) then
            self:LoadConfigFile(Name)
            return Name
        end
    end

    Library.GetDefaultTheme = function(self)
        if isfile(self.DefaultThemeFile) then
            local Name = CleanName(readfile(self.DefaultThemeFile))
            if Name ~= "" then
                return Name
            end
        end
    end

    Library.SetDefaultTheme = function(self, Name)
        if Name and CleanName(Name) ~= "" then
            writefile(self.DefaultThemeFile, CleanName(Name))
        elseif isfile(self.DefaultThemeFile) then
            delfile(self.DefaultThemeFile)
        end
    end

    Library.ApplyDefaultTheme = function(self)
        local Name = self:GetDefaultTheme()
        if not Name then
            return
        end
        if self.ThemePresets[Name] then
            self:ApplyTheme(self.ThemePresets[Name])
            return Name
        end
        local Path = self:ThemePath(Name)
        if isfile(Path) then
            local Ok, Data = pcall(HttpService.JSONDecode, HttpService, readfile(Path))
            if Ok and type(Data) == "table" then
                self:ApplyTheme(Data)
                return Name
            end
        end
    end

    Library.GetTheme = function(self)
        local Data = { }
        for Name, Color in self.Theme do
            Data[Name] = Color:ToHex()
        end
        return HttpService:JSONEncode(Data)
    end

    Library.ApplyTheme = function(self, Data)
        for Name, Value in Data do
            local Color = typeof(Value) == "Color3" and Value or (type(Value) == "string" and FromHex(Value))
            if Color and self.Theme[Name] ~= nil then
                self:ChangeTheme(Name, Color)

                local SetFlag = self.SetFlags["Theme" .. Name]
                if SetFlag then
                    SetFlag(Color)
                end
            end
        end
    end

    Library.SaveTheme = function(self, Name)
        if CleanName(Name) == "" then
            Library:Notification("Enter a theme name first", 3)
            return false
        end

        writefile(self:ThemePath(Name), self:GetTheme())
        Library:Notification("Saved theme " .. CleanName(Name), 3)
        return true
    end

    Library.LoadThemeFile = function(self, Name)
        local Path = self:ThemePath(Name)
        if CleanName(Name) == "" or not isfile(Path) then
            Library:Notification("Theme " .. tostring(Name) .. " not found", 3)
            return false
        end

        local Ok, Data = pcall(HttpService.JSONDecode, HttpService, readfile(Path))
        if not Ok or type(Data) ~= "table" then
            Library:Notification("Theme " .. CleanName(Name) .. " is corrupted", 3)
            return false
        end

        self:ApplyTheme(Data)
        Library:Notification("Loaded theme " .. CleanName(Name), 3)
        return true
    end

    Library.DeleteTheme = function(self, Name)
        local Path = self:ThemePath(Name)
        if CleanName(Name) ~= "" and isfile(Path) then
            delfile(Path)
            if self:GetDefaultTheme() == CleanName(Name) then
                self:SetDefaultTheme(nil)
            end
            Library:Notification("Deleted theme " .. CleanName(Name), 3)
            return true
        end
        return false
    end

    Library.RefreshThemesList = function(self, Element)
        Element:Refresh(self:ListFiles(self.Folders.Themes, self.ThemeExtension))
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        for Property, Value in Properties do
            if type(Value) == "string" and self.Theme[Value] then
                Item[Property] = self.Theme[Value]
            end
        end
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        local function Apply()
            if self.Theme[Theme] ~= Color then
                return
            end

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                end
            end
        end
    end

        Apply()

        task.delay(self.Tween.Time + 0.05, Apply)

        if Theme == "Accent" or Theme == "Text" or Theme == "Inactive Text" then
            if Theme == "Accent" then
                self:RefreshAccentBars()
            end

            for _, Refresh in self.AccentRefreshers do
                Refresh()
            end
        end
    end

    local function Shade(Color, Brightness)
        local H, S, V = Color:ToHSV()
        return FromHSV(H, S, MathClamp(V * Brightness, 0, 1))
    end

    local function AccentSequence(Base, Brightness)
        local Color = Shade(Base, Brightness)
        return RGBSequence{
            RGBSequenceKeypoint(0, Color),
            RGBSequenceKeypoint(1, Color)
        }
    end

    Library.RefreshAccentBars = function(self)
        for _, Bar in self.AccentBars do
            if Bar.Bright.Parent then
                local Base = Bar.Color or self.Theme.Accent
                Bar.BrightGradient.Color = AccentSequence(Base, 1)
                Bar.DimGradient.Color = AccentSequence(Base, 0.45)
            end
        end
    end

    Library.CreateAccentBar = function(self, Parent, FixedColor)
        local Holder = InstanceNew("Frame")
        Holder.Name = "\0"
        Holder.BackgroundTransparency = 1
        Holder.BorderSizePixel = 0
        Holder.Size = UDim2New(1, 0, 0, 2)
        Holder.ZIndex = 2
        Holder.Parent = Parent

        local Bright = InstanceNew("Frame")
        Bright.Name = "\0"
        Bright.BorderSizePixel = 0
        Bright.BackgroundColor3 = FromRGB(255, 255, 255)
        Bright.Size = UDim2New(1, 0, 0, 1)
        Bright.ZIndex = 2
        Bright.Parent = Holder

        local Dim = InstanceNew("Frame")
        Dim.Name = "\0"
        Dim.BorderSizePixel = 0
        Dim.BackgroundColor3 = FromRGB(255, 255, 255)
        Dim.Position = UDim2New(0, 0, 0, 1)
        Dim.Size = UDim2New(1, 0, 0, 1)
        Dim.ZIndex = 2
        Dim.Parent = Holder

        local BrightGradient = InstanceNew("UIGradient")
        BrightGradient.Parent = Bright

        local DimGradient = InstanceNew("UIGradient")
        DimGradient.Parent = Dim

        local Bar = {
            Holder = Holder,
            Bright = Bright,
            BrightGradient = BrightGradient,
            DimGradient = DimGradient,
            Color = FixedColor
        }

        BrightGradient.Color = AccentSequence(FixedColor or self.Theme.Accent, 1)
        DimGradient.Color = AccentSequence(FixedColor or self.Theme.Accent, 0.45)

        if not FixedColor then
            TableInsert(self.AccentBars, Bar)
        end

        return Bar
    end

    Library.CreateGroupGlow = function(self, Parent, TopPadding)
        local Glow = Instances:Create("Frame", {
            Parent = Parent,
                Name = "\0",
            Position = UDim2New(0, -1, 0, -(TopPadding + 1)),
            Size = UDim2New(1, 2, 0, 1),
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            ZIndex = 2,
            BackgroundColor3 = self.Theme.Accent
        })  Glow:AddToTheme({BackgroundColor3 = "Accent"})

        Instances:Create("UIGradient", {
            Parent = Glow.Instance,
            Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.5, 0.85), NumSequenceKeypoint(1, 1)}
        })

        return Glow
    end

    local function SoftFalloff(Strength)
        return NumSequence{
            NumSequenceKeypoint(0, Strength),
            NumSequenceKeypoint(0.2, Strength + (1 - Strength) * 0.36),
            NumSequenceKeypoint(0.45, Strength + (1 - Strength) * 0.68),
            NumSequenceKeypoint(0.7, Strength + (1 - Strength) * 0.88),
            NumSequenceKeypoint(1, 1)
        }
    end

    local function SoftShadow(Parent, Position, Size, Rotation, Strength, ZIndex)
        local Frame = InstanceNew("Frame")
        Frame.Name = "\0"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = FromRGB(0, 0, 0)
        Frame.Position = Position
        Frame.Size = Size
        Frame.ZIndex = ZIndex or 0
        Frame.Parent = Parent

        local Gradient = InstanceNew("UIGradient")
        Gradient.Rotation = Rotation
        Gradient.Transparency = SoftFalloff(Strength)
        Gradient.Parent = Frame

        return Frame
    end

    local function EdgeLine(Parent, Position, Size, Transparency, ZIndex)
        local Frame = InstanceNew("Frame")
        Frame.Name = "\0"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = FromRGB(255, 255, 255)
        Frame.BackgroundTransparency = Transparency
        Frame.Position = Position
        Frame.Size = Size
        Frame.ZIndex = ZIndex or 1
        Frame.Parent = Parent
        return Frame
    end

    Library.AddInsetShadow = function(self, Parent, Pad, Depth)
        local L, T, R, B = Pad[1], Pad[2], Pad[3], Pad[4]
        Depth = math.max(2, MathFloor((Depth or 12) * 0.5))

        SoftShadow(Parent, UDim2New(0, -L, 0, -T), UDim2New(1, L + R, 0, Depth), 90, 0.55)
        SoftShadow(Parent, UDim2New(0, -L, 0, -T), UDim2New(0, MathFloor(Depth * 0.75), 1, T + B), 0, 0.7)

        EdgeLine(Parent, UDim2New(0, -L - 1, 1, B + 1), UDim2New(1, L + R + 3, 0, 1), 0.93)
        EdgeLine(Parent, UDim2New(1, R + 1, 0, -T - 1), UDim2New(0, 1, 1, T + B + 2), 0.93)
    end

    Library.AddTopHighlight = function(self, Parent, TopPadding, BottomPadding)
        BottomPadding = BottomPadding or 6

        local Highlight = EdgeLine(Parent, UDim2New(0, 0, 0, -TopPadding), UDim2New(1, 0, 0, 1), 0.92, 2)

        SoftShadow(Parent, UDim2New(0, 1, 1, BottomPadding + 1), UDim2New(1, 2, 0, 3), 90, 0.5)
        SoftShadow(Parent, UDim2New(1, 1, 0, -TopPadding + 1), UDim2New(0, 2, 1, TopPadding + BottomPadding + 1), 0, 0.65)

        return Highlight
    end

    Library.CreateOverlayFrame = function(self, Props)
        local Band = self.FrameBand

        local Outer = Instances:Create("Frame", {
            Parent = Props.Parent or self.Holder.Instance,
            Name = "\0",
            AnchorPoint = Props.AnchorPoint or Vector2New(0, 0),
            Position = Props.Position or UDim2New(0, 0, 0, 0),
            Size = Props.Size or UDim2New(0, 100, 0, 40),
            AutomaticSize = Props.AutomaticSize or Enum.AutomaticSize.None,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            ClipsDescendants = false,
            BackgroundColor3 = self.Theme.Outline
        })  Outer:AddToTheme({BackgroundColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
            Parent = Outer.Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
            Thickness = 1,
                Name = "\0",
            Color = self.Theme.Border
        }):AddToTheme({Color = "Border"})
            
        if Props.AutomaticSize and Props.AutomaticSize ~= Enum.AutomaticSize.None then
            Instances:Create("UIPadding", {
                Parent = Outer.Instance,
                PaddingTop = UDimNew(0, Band),
                PaddingBottom = UDimNew(0, Band),
                PaddingLeft = UDimNew(0, Band),
                PaddingRight = UDimNew(0, Band)
            })
        end

        local Inner = Instances:Create("Frame", {
            Parent = Outer.Instance,
            Name = "\0",
            Position = Props.AutomaticSize and Props.AutomaticSize ~= Enum.AutomaticSize.None and UDim2New(0, 0, 0, 0) or UDim2New(0, Band, 0, Band),
            Size = Props.AutomaticSize and Props.AutomaticSize ~= Enum.AutomaticSize.None and UDim2New(0, 0, 0, 0) or UDim2New(1, -Band * 2, 1, -Band * 2),
            AutomaticSize = Props.AutomaticSize or Enum.AutomaticSize.None,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            ClipsDescendants = Props.ClipInner or false,
            BackgroundColor3 = self.Theme.Background
        })  Inner:AddToTheme({BackgroundColor3 = "Background"})

        Instances:Create("UIStroke", {
            Parent = Inner.Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Thickness = 1,
            Name = "\0",
            Color = self.Theme.Border
        }):AddToTheme({Color = "Border"})

        local Bar
        if Props.AccentBar ~= false then
            Bar = self:CreateAccentBar(Inner.Instance, Props.AccentColor)
        end

        return Outer, Inner, Bar
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    local function ColorToHex(Color)
        return StringFormat("#%02X%02X%02X", MathFloor(Color.R * 255 + 0.5), MathFloor(Color.G * 255 + 0.5), MathFloor(Color.B * 255 + 0.5))
    end

    Library.Watermark = function(self, Name)
        local Watermark = {
            Brand = "Tapology",
            Parts = { "Brand", "Time", "Game" },
            Custom = Name
        }

        local PlaceName = ""
        pcall(function()
            PlaceName = MarketplaceService:GetProductInfo(game.PlaceId).Name
        end)

        local Items = { } do
            Items["Watermark"], Items["Inner"], Items["Bar"] = Library:CreateOverlayFrame({
                AnchorPoint = Vector2New(0.5, 0),
                Position = UDim2New(0.5, 0, 0, 12 - GuiService:GetGuiInset().Y),
                Size = UDim2New(0, 120, 0, 22 + Library.FrameBand * 2)
            })

            Items["Watermark"]:MakeDraggable()
            Library:AddShadow(Items["Watermark"].Instance, "Watermark")
            Library.CurrentWatermark = Watermark
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Inner"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                RichText = true,
                Name = "\0",
                Position = UDim2New(0, 8, 0, 5),
                Size = UDim2New(1, -16, 0, 14),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Library:Connect(Items["Title"].Instance:GetPropertyChangedSignal("TextBounds"), function()
                Items["Watermark"].Instance.Size = UDim2New(0, MathFloor(Items["Title"].Instance.TextBounds.X) + 16 + Library.FrameBand * 2, 0, 22 + Library.FrameBand * 2)
            end)
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
        end

        local function Accent(Text)
            return StringFormat('<font color="%s">%s</font>', ColorToHex(Library.Theme.Accent), Text)
        end

        local function BuildText()
            local Chunks = { }

            for _, Part in Watermark.Parts do
                local Key = string.lower(tostring(Part))

                if Key == "brand" then
                    TableInsert(Chunks, Watermark.Brand .. Accent(".pro"))
                elseif Key == "time" then
                    local Hour = tonumber(os.date("%I"))
                    TableInsert(Chunks, StringFormat("%d:%s ", Hour, os.date("%M")) .. Accent(string.lower(os.date("%p"))))
                elseif Key == "date" then
                    TableInsert(Chunks, os.date("%b %d %Y"))
                elseif Key == "username" then
                    TableInsert(Chunks, LocalPlayer and LocalPlayer.Name or "player")
                elseif Key == "game" then
                    TableInsert(Chunks, PlaceName ~= "" and PlaceName or tostring(game.PlaceId))
                elseif Key == "fps" then
                    TableInsert(Chunks, StringFormat("%d ", MathFloor(Workspace:GetRealPhysicsFPS())) .. Accent("fps"))
                elseif Key == "ping" then
                    local Ping = 0
                    pcall(function()
                        Ping = MathFloor(LocalPlayer:GetNetworkPing() * 1000)
                    end)
                    TableInsert(Chunks, StringFormat("%d", Ping) .. Accent("ms"))
                elseif Key == "custom" and Watermark.Custom then
                    TableInsert(Chunks, tostring(Watermark.Custom))
                end
            end

            local Divider = StringFormat('  <font color="%s">/</font>  ', ColorToHex(Library.Theme["Inactive Text"]))
            return TableConcat(Chunks, Divider)
        end

        local function Refresh()
            local Text = BuildText()
            if Items["Title"].Instance.Text ~= Text then
                Items["Title"].Instance.Text = Text
            end
        end

        function Watermark:SetParts(Parts)
            Watermark.Parts = Parts or Watermark.Parts
            Refresh()
        end

        function Watermark:SetBrand(Brand)
            Watermark.Brand = Brand or "Tapology"
            Refresh()
        end

        local WatermarkOn = false

        function Watermark:SetVisibility(Bool)
            WatermarkOn = Bool and true or false
            Items["Watermark"].Instance.Visible = WatermarkOn
        end

        Refresh()

        local LastUpdate = 0
        Library:Connect(RunService.RenderStepped, function()
            if not WatermarkOn or os.clock() - LastUpdate <= 0.25 then
                return
            end
            LastUpdate = os.clock()
            Refresh()
        end)
        
        return Watermark
    end

    Library.Confirm = function(self, Text, OnYes)
        if self.ActiveConfirm then
            self.ActiveConfirm:Destroy()
        end

        local Outer, Inner = self:CreateOverlayFrame({
            AnchorPoint = Vector2New(0.5, 0.5),
            Position = UDim2New(0.5, 0, 0.5, 0),
            Size = UDim2New(0, 280, 0, 82)
        })
        Outer.Instance.ZIndex = 20010
        Inner.Instance.ZIndex = 20010
        self.ActiveConfirm = Outer.Instance

        local function Close()
            if self.ActiveConfirm == Outer.Instance then
                self.ActiveConfirm = nil
            end
            Outer.Instance:Destroy()
        end

        local Title = Instances:Create("TextLabel", {
            Parent = Inner.Instance,
                Name = "\0",
            FontFace = self.Font,
            Text = Text,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 20011,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 10, 0, 8),
            Size = UDim2New(1, -20, 0, 32)
        })
        Title:AddToTheme({TextColor3 = "Text"})
        Instances:Create("UIStroke", {
            Parent = Title.Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
            LineJoinMode = Enum.LineJoinMode.Round,
            Thickness = 1,
            Name = "\0",
            Color = self.Theme["Text Border"]
        }):AddToTheme({Color = "Text Border"})

        for Index, Choice in { "yes", "no" } do
            local Button = Instances:Create("TextButton", {
                Parent = Inner.Instance,
                Name = "\0",
                FontFace = self.Font,
                Text = Choice,
                TextSize = 12,
                AutoButtonColor = false,
                ZIndex = 20011,
                BorderSizePixel = 0,
                Position = UDim2New((Index - 1) * 0.5, Index == 1 and 10 or 5, 1, -28),
                Size = UDim2New(0.5, -15, 0, 20),
                BackgroundColor3 = self.Theme.Element
            })
            Button:AddToTheme({BackgroundColor3 = "Element", TextColor3 = Index == 1 and "Accent" or "Text"})
            Instances:Create("UIStroke", {
                Parent = Button.Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = self.Theme.Outline
            }):AddToTheme({Color = "Outline"}) 
            Instances:Create("UIStroke", {
                Parent = Button.Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                LineJoinMode = Enum.LineJoinMode.Round,
                Thickness = 1,
                Name = "\0",
                Color = self.Theme["Text Border"]
            }):AddToTheme({Color = "Text Border"})
            Button:Connect("MouseButton1Click", function()
                Close()
                if Index == 1 and OnYes then
                    self:SafeCall(OnYes)
                end
            end)
        end
    end

    Library.Notification = function(self, Text, Duration, Color, Icon)
        Duration = Duration or 3

        local Band = Library.FrameBand
        local Height = 24 + Band * 2
        local Active = Library.ActiveNotifications
        local Max = Library.MaxNotifications or 15

        while #Active >= Max do
            local Oldest = TableRemove(Active, 1)
            if Oldest and Oldest.Slot then
                pcall(function()
                    Oldest.Slot:Clean()
                end)
            end
        end

        local Items = { } do
            Items["Slot"] = Instances:Create("CanvasGroup", {
                Parent = Library.NotifHolder.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                GroupTransparency = 1,
                Size = UDim2New(0, 120, 0, Height + 2),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Clip"] = Instances:Create("Frame", {
                Parent = Items["Slot"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Size = UDim2New(1, 0, 1, 0)
            })

            Items["Notification"], Items["Inner"], Items["Bar"] = Library:CreateOverlayFrame({
                Parent = Items["Clip"].Instance,
                Position = UDim2New(0, 1, 0, 1),
                Size = UDim2New(1, -2, 0, Height),
                AccentColor = Color
            }) 
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Inner"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Text,
                Name = "\0",
                Position = UDim2New(0, 8, 0, 5),
                Size = UDim2New(1, -16, 0, 14),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

        end

        for _, Item in Items["Slot"].Instance:GetDescendants() do
            if Item:IsA("GuiObject") then
                Item.ZIndex = 20000
            end
        end
        Items["Slot"].Instance.ZIndex = 20000
        Library:AddShadow(Items["Slot"].Instance, "Notifications", 6, 1, 19999)

        local Entry = { Slot = Items["Slot"] }
        TableInsert(Active, Entry)

        local FadeIn = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local FadeOut = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        Library:Thread(function()
            for _ = 1, 10 do
                if Items["Title"].Instance.TextBounds.X > 0 then
                    break
                end
                task.wait()
            end

            local Width = MathFloor(Items["Title"].Instance.TextBounds.X) + 16 + Band * 2 + 2
            Items["Slot"].Instance.Size = UDim2New(0, Width, 0, Height + 2)
            Items["Slot"]:Tween(FadeIn, { GroupTransparency = 0 })

            task.wait(Duration)

            Items["Slot"]:Tween(FadeOut, { GroupTransparency = 1 })
            task.wait(0.3)

            local Index = TableFind(Active, Entry)
            if Index then
                TableRemove(Active, Index)
            end
            Items["Slot"]:Clean()
        end)
    end

    Library.KeybindList = function(self)
        local Band = Library.FrameBand

        local KeybindList = {
            Entries = { },
            Width = 170,
            Row = 16,
            Gap = 1,
            Spacing = 4
        }
        self.KeyList = KeybindList

        local Items = { } do
            Items["KeybindList"], Items["Inner"], Items["Bar"] = Library:CreateOverlayFrame({
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 15, 0.5, 0),
                Size = UDim2New(0, KeybindList.Width, 0, 22 + Band * 2)
            })

            Items["KeybindList"]:MakeDraggable()
            Library:AddShadow(Items["KeybindList"].Instance, "Keybinds")
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Inner"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "keybinds",
                Name = "\0",
                Position = UDim2New(0, 0, 0, 5),
                Size = UDim2New(1, 0, 0, 14),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["List"], Items["ListInner"] = Library:CreateOverlayFrame({
                Parent = Items["KeybindList"].Instance,
                Position = UDim2New(0, 0, 1, KeybindList.Spacing),
                Size = UDim2New(1, 0, 0, 0),
                AccentBar = false,
                ClipInner = true
            })
            Items["List"].Instance.Visible = false
            Library:AddShadow(Items["List"].Instance, "Keybinds")

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["ListInner"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 6, 0, 4),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -12, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, KeybindList.Gap),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 
        end

        local SizeTween

        function KeybindList:RefreshSize()
            local Count = 0
            for _, Entry in KeybindList.Entries do
                if Entry.Visible then
                    Count += 1
                end
            end

            local List = Items["List"]

            if SizeTween then
                SizeTween.Tween:Cancel()
            end

            if Count > 0 then
                local Height = 8 + Count * KeybindList.Row + (Count - 1) * KeybindList.Gap + Band * 2
                List.Instance.Visible = true
                SizeTween = List:Tween(nil, {Size = UDim2New(1, 0, 0, Height)})
            else
                SizeTween = List:Tween(nil, {Size = UDim2New(1, 0, 0, 0)})
                local ThisTween = SizeTween
                ThisTween.Tween.Completed:Connect(function(State)
                    if State == Enum.PlaybackState.Completed then
                        List.Instance.Visible = false
                    end
                end)
            end
        end

        function KeybindList:Add(Mode, Name, Key)
            local Row = Instances:Create("Frame", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, KeybindList.Row),
                BorderSizePixel = 0,
                Visible = false,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            local NameLabel = Instances:Create("TextLabel", {
                Parent = Row.Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                Name = "\0",
                Size = UDim2New(1, -40, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  NameLabel:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = NameLabel.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
        
            local KeyLabel = Instances:Create("TextLabel", {
                Parent = Row.Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Inactive Text"],
                BorderColor3 = FromRGB(0, 0, 0),
                Text = tostring(Key),
                Name = "\0",
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, 0, 0, 0),
                Size = UDim2New(0, 40, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  KeyLabel:AddToTheme({TextColor3 = "Inactive Text"})

            Instances:Create("UIStroke", {
                Parent = KeyLabel.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            local NewKey = {
                Row = Row,
                Visible = false
            }

            function NewKey:Set(_, BindName, BindKey)
                NameLabel.Instance.Text = BindName
                local KeyText = StringGSub(tostring(BindKey), "Enum.KeyCode.", "")
                KeyText = StringGSub(KeyText, "Enum.UserInputType.", "")
                KeyLabel.Instance.Text = KeyText
            end

            function NewKey:SetStatus(Status)
                local Visible = Status == "Active"
                if Visible == NewKey.Visible then
                    return
                end

                NewKey.Visible = Visible
                Row.Instance.Visible = Visible
                KeybindList:RefreshSize()
            end

            NewKey:Set(Mode, Name, Key)
            TableInsert(KeybindList.Entries, NewKey)
            return NewKey
        end

        function KeybindList:SetVisibility(Bool)
            Items["KeybindList"].Instance.Visible = Bool
        end

        return KeybindList
    end

    local function ParseColorText(Text)
        if type(Text) ~= "string" then
            return
        end

        local Clean = StringGSub(Text, "%s", "")

        local Hex = string.match(Clean, "^#?(%x%x%x%x%x%x)$")
        if Hex then
            return FromHex(Hex)
        end

        local R, G, B = string.match(Clean, "(%d+),(%d+),(%d+)")
        if R then
            return FromRGB(MathClamp(tonumber(R), 0, 255), MathClamp(tonumber(G), 0, 255), MathClamp(tonumber(B), 0, 255))
        end

        Hex = string.match(Clean, "#?(%x%x%x%x%x%x)")
        if Hex then
            return FromHex(Hex)
        end
    end

    local function ReadClipboard()
        local Reader = getclipboard or fromclipboard or (Clipboard and Clipboard.get)
        if not Reader then
            return
        end

        local Ok, Result = pcall(Reader)
        if Ok and type(Result) == "string" then
            return Result
        end
    end

    local function WriteClipboard(Text)
        local Writer = setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if Writer then
            pcall(Writer, Text)
        end
    end

    local function ColorToRGBText(Color)
        return StringFormat("%d, %d, %d", MathFloor(Color.R * 255 + 0.5), MathFloor(Color.G * 255 + 0.5), MathFloor(Color.B * 255 + 0.5))
    end

    local function IsShown(Gui)
        local Ok, Result = pcall(function()
            local Current = Gui
            while Current and Current:IsA("GuiObject") do
                if not Current.Visible then
                    return false
                end
                Current = Current.Parent
            end
            return Current ~= nil and Gui:IsDescendantOf(Library.Holder.Instance)
        end)
        return Ok and Result or false
    end

    Library.Shadows = { }
    Library.ShadowSettings = {
        Enabled = false,
        Targets = { UI = true, Watermark = true, Keybinds = true, Notifications = true }
    }

    Library.AddShadow = function(self, Target, Kind, Rings, Inset, ZIndex)
        Rings = math.max(2, MathFloor((Rings or 6) * 0.5))

        Inset = Inset or 0

        local Container = InstanceNew("Frame")
        Container.Name = "\0"
        Container.BackgroundTransparency = 1
        Container.BorderSizePixel = 0
        Container.ZIndex = ZIndex or 0
        Container.Position = UDim2New(0, Inset, 0, Inset)
        Container.Size = UDim2New(1, -Inset * 2, 1, -Inset * 2)
        Container.Visible = false
        Container.Parent = Target

        for Ring = 1, Rings do
            local Frame = InstanceNew("Frame")
            Frame.Name = "\0"
            Frame.BackgroundTransparency = 1
            Frame.BorderSizePixel = 0
            Frame.ZIndex = ZIndex or 0
            Frame.Position = UDim2New(0, -Ring, 0, -Ring)
            Frame.Size = UDim2New(1, Ring * 2, 1, Ring * 2)
            Frame.Parent = Container

            local Corner = InstanceNew("UICorner")
            Corner.CornerRadius = UDimNew(0, Ring)
            Corner.Parent = Frame

            local Stroke = InstanceNew("UIStroke")
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Stroke.LineJoinMode = Enum.LineJoinMode.Round
            Stroke.Thickness = 1
            Stroke.Color = FromRGB(0, 0, 0)
            Stroke.Transparency = 0.55 + (Ring / Rings) ^ 0.75 * 0.45
            Stroke.Parent = Frame
        end

        local Shadow = { Kind = Kind, Container = Container }
        TableInsert(self.Shadows, Shadow)
        self:RefreshShadows()

        Container.Destroying:Connect(function()
            local Index = TableFind(Library.Shadows, Shadow)
            if Index then
                TableRemove(Library.Shadows, Index)
            end
        end)

        return Container
    end

    Library.RefreshShadows = function(self)
        local Settings = self.ShadowSettings
        for _, Shadow in self.Shadows do
            local Show = (Settings.Enabled and Settings.Targets[Shadow.Kind]) and true or false
            if Shadow.Container.Visible ~= Show then
                Shadow.Container.Visible = Show
            end
        end
    end

    Library.SetShadowEnabled = function(self, Bool)
        self.ShadowSettings.Enabled = Bool and true or false
        self:RefreshShadows()
    end

    Library.SetShadowTargets = function(self, Targets)
        local Set = { }
        for Key, Value in Targets or { } do
            if type(Key) == "number" then
                Set[Value] = true
            elseif Value then
                Set[Key] = true
            end
        end
        self.ShadowSettings.Targets = Set
        self:RefreshShadows()
    end

    local function FollowAnchor(Popup, Anchor, Place, OnHidden)
        local Connection

        local function Step()
            if not Library then
                if Connection then
                    Connection:Disconnect()
                end
                return
            end

            if not IsShown(Anchor) then
                OnHidden()
                return
            end

            local Position = Place(Anchor)
            if Popup.Position ~= Position then
                Popup.Position = Position
            end
        end

        Step()
        Connection = RunService.RenderStepped:Connect(Step)
        return Connection
    end

    local function SetZ(Root, Z)
        if Root:IsA("GuiObject") then
            Root.ZIndex = Z
        end
        for _, Child in Root:GetDescendants() do
            if Child:IsA("GuiObject") then
                Child.ZIndex = Z
            end
        end
    end

    local function MakeSmallButton(Parent, Text, Props)
        local Button = Instances:Create("TextButton", {
            Parent = Parent,
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            BorderColor3 = FromRGB(0, 0, 0),
            Text = Text,
            AutoButtonColor = false,
            Name = "\0",
            AnchorPoint = Props.AnchorPoint or Vector2New(0, 0),
            Position = Props.Position or UDim2New(0, 0, 0, 0),
            Size = Props.Size or UDim2New(1, 0, 0, 16),
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = Library.Theme.Element
        })  Button:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text"})

        Instances:Create("UIStroke", {
            Parent = Button.Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Thickness = 1,
            Name = "\0",
            Color = Library.Theme.Border
        }):AddToTheme({Color = "Border"})

        Button:OnHover(function()
            Button:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
            Button:ChangeItemTheme({BackgroundColor3 = "Hovered Element", TextColor3 = "Text"})
        end)

        Button:OnHoverLeave(function()
            Button:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            Button:ChangeItemTheme({BackgroundColor3 = "Element", TextColor3 = "Text"})
        end)

        return Button
    end

    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Hue = 0,
            Saturation = 0,
            Value = 0,

            Alpha = 0,

            HexValue = "",
            
            IsOpen = false,
            ContextOpen = false,

            Color = FromRGB(0, 0, 0),

            Class = "Colorpicker"
        }

        Library.Flags[Data.Flag] = { }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0.5),
                Name = "\0",
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 20, 0, 10),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 

            Colorpicker.CalculateCount = function(self, Index, YScale, YOffset)
                local MaxButtonsAdded = 5

                local Column = Index % MaxButtonsAdded
            
                local ButtonSize = Items["ColorpickerButton"].Instance.AbsoluteSize
                local Spacing = 4
            
                local XPosition = (ButtonSize.X + Spacing) * Column - Spacing - 21
            
                Items["ColorpickerButton"].Instance.Position = UDim2New(1, -XPosition, YScale or 0.5, YOffset or 0)
            end

            Colorpicker:CalculateCount(Data.Count)
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = Library.Theme.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["ColorpickerButton"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(150, 150, 150))}
            })

            Items["ColorpickerWindow"], Items["PickerInner"] = Library:CreateOverlayFrame({
                Size = UDim2New(0, 188, 0, 168),
                AccentBar = false
            })
            Items["ColorpickerWindow"].Instance.Visible = false
            Items["ColorpickerWindow"].Instance.Active = true
            Items["PickerInner"].Instance.Active = true

            Instances:Create("UIPadding", {
                Parent = Items["PickerInner"].Instance,
                PaddingTop = UDimNew(0, 5),
                PaddingBottom = UDimNew(0, 5),
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 5)
            })
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["PickerInner"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Data.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 12),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["PickerInner"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 16),
                Size = UDim2New(1, -18, 1, -50),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 
            
            Items["Saturation"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Saturation"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Value"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Value"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = Library.Theme.Border
            }):AddToTheme({Color = "Border"})
            
            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 2, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(0, 0, 0)
            })
            
            Items["Hue"] = Instances:Create("ImageButton", {
                Parent = Items["PickerInner"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Image = Library:GetImage("Hue"),
                Name = "\0",
                Position = UDim2New(1, 0, 0, 16),
                Size = UDim2New(0, 12, 1, -50),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(0, 0, 0)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = Library.Theme.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["PickerInner"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, -21),
                Size = UDim2New(1, 0, 0, 9),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Alpha"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = Library.Theme.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Checkers"),
                TileSize = UDim2New(0, 6, 0, 6),
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            }) 
            
            Instances:Create("UIGradient", {
                Parent = Items["Alpha"].Instance,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(0, 0, 0))}
            }) 
            
            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 1, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(0, 0, 0)
            })

            Items["ValueBox"] = Instances:Create("TextBox", {
                Parent = Items["PickerInner"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                PlaceholderColor3 = Library.Theme["Inactive Text"],
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                PlaceholderText = "#hex or r, g, b",
                ClearTextOnFocus = false,
                Name = "\0",
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, -44, 0, 16),
                BorderSizePixel = 0,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = false,
                ClipsDescendants = true,
                BackgroundColor3 = Library.Theme.Element
            })  Items["ValueBox"]:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text", PlaceholderColor3 = "Inactive Text"})

            Instances:Create("UIStroke", {
                Parent = Items["ValueBox"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = Library.Theme.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UIPadding", {
                Parent = Items["ValueBox"].Instance,
                PaddingLeft = UDimNew(0, 4)
            })

            Items["PasteButton"] = MakeSmallButton(Items["PickerInner"].Instance, "paste", {
                AnchorPoint = Vector2New(1, 1),
                Position = UDim2New(1, 0, 1, 0),
                Size = UDim2New(0, 40, 0, 16)
            })

            SetZ(Items["ColorpickerWindow"].Instance, 10001)

            Items["Context"], Items["ContextInner"] = Library:CreateOverlayFrame({
                Size = UDim2New(0, 112, 0, 74),
                AccentBar = false
            })
            Items["Context"].Instance.Visible = false
            Items["Context"].Instance.Active = true

            Instances:Create("UIPadding", {
                Parent = Items["ContextInner"].Instance,
                PaddingTop = UDimNew(0, 4),
                PaddingBottom = UDimNew(0, 4),
                PaddingRight = UDimNew(0, 4),
                PaddingLeft = UDimNew(0, 4)
            })

            Items["ContextSwatch"] = Instances:Create("Frame", {
                Parent = Items["ContextInner"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 3),
                Size = UDim2New(0, 10, 0, 10),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIStroke", {
                Parent = Items["ContextSwatch"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = Library.Theme.Border
            }):AddToTheme({Color = "Border"})

            Items["ContextValue"] = Instances:Create("TextLabel", {
                Parent = Items["ContextInner"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Name = "\0",
                Position = UDim2New(0, 15, 0, 0),
                Size = UDim2New(1, -15, 0, 16),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["ContextValue"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["ContextValue"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["ContextCopy"] = MakeSmallButton(Items["ContextInner"].Instance, "copy", {
                Position = UDim2New(0, 0, 0, 20),
                Size = UDim2New(1, 0, 0, 16)
            })

            Items["ContextPaste"] = MakeSmallButton(Items["ContextInner"].Instance, "paste", {
                Position = UDim2New(0, 0, 0, 40),
                Size = UDim2New(1, 0, 0, 16)
            })

            SetZ(Items["Context"].Instance, 10010)
        end

        local SlidingPalette = false
        local SlidingHue = false
        local SlidingAlpha = false

        local function SetContextOpen(Bool)
            Colorpicker.ContextOpen = Bool
            if Bool then
                local MousePos = UserInputService:GetMouseLocation()
                local Inset = GuiService:GetGuiInset()
                Items["Context"].Instance.Position = UDim2New(0, MousePos.X - Inset.X + 2, 0, MousePos.Y - Inset.Y + 2)
            end
            Items["Context"].Instance.Visible = Bool
        end

        local Follow

        function Colorpicker:SetOpen(Bool)
            Colorpicker.IsOpen = Bool

            if Follow then
                Follow:Disconnect()
                Follow = nil
            end

            if Bool then
                if Library.CurrentColorpicker and Library.CurrentColorpicker ~= Colorpicker then
                    Library.CurrentColorpicker:SetOpen(false)
                end
                Library.CurrentColorpicker = Colorpicker
                SetContextOpen(false)

                Follow = FollowAnchor(Items["ColorpickerWindow"].Instance, Items["ColorpickerButton"].Instance, function(Anchor)
                    return UDim2New(0, Anchor.AbsolutePosition.X, 0, Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + 6)
                end, function()
                    Colorpicker:SetOpen(false)
                end)
            elseif Library.CurrentColorpicker == Colorpicker then
                Library.CurrentColorpicker = nil
            end

            Items["ColorpickerWindow"].Instance.Visible = Bool and Colorpicker.IsOpen
        end

        function Colorpicker:Get()
            return Colorpicker.Value
        end

        function Colorpicker:SetVisibility(Bool)
           Data.Parent.Instance.Visible = Bool 
        end

        local function RefreshReadout()
            local Hex = ColorToHex(Colorpicker.Color)
            local RGBText = ColorToRGBText(Colorpicker.Color)

            if not Items["ValueBox"].Instance:IsFocused() then
                Items["ValueBox"].Instance.Text = Hex .. "  " .. RGBText
            end

            Items["ContextValue"].Instance.Text = Hex
            Items["ContextSwatch"].Instance.BackgroundColor3 = Colorpicker.Color
        end

        function Colorpicker:Set(Color, Alpha)
            if type(Color) == "table" then 
                Alpha = Color[4]
                Color = FromRGB(Color[1], Color[2], Color[3])
            elseif type(Color) == "string" then 
                Color = FromHex(Color)
            end

            self.Hue, self.Saturation, self.Value = Color:ToHSV()
            self.Alpha = Alpha or 0

            local Info = TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            Items["PaletteDragger"]:Tween(Info, {Position = UDim2New(MathClamp(1 - self.Saturation, 0, 0.989), 0, MathClamp(1 - self.Value, 0, 0.989), 0)})
            Items["HueDragger"]:Tween(Info, {Position = UDim2New(0, 0, MathClamp(self.Hue, 0, 0.994), 0)})
            Items["AlphaDragger"]:Tween(Info, {Position = UDim2New(MathClamp(self.Alpha, 0, 0.994), 0, 0, 0)})

            self:Update()
        end

        function Colorpicker:Update(IsFromAlpha)
            self.Color = FromHSV(self.Hue, self.Saturation, self.Value)
            self.HexValue = self.Color:ToHex()

            Library.Flags[Data.Flag] = {
                Color = self.Color,
                HexValue =  self.HexValue,
                Alpha = self.Alpha
            }

            local Info = TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            Items["ColorpickerButton"]:Tween(Info, {BackgroundColor3 = self.Color})
            Items["Palette"]:Tween(Info, {BackgroundColor3 = FromHSV(self.Hue, 1, 1)})

            if not IsFromAlpha then 
                Items["Alpha"]:Tween(Info, {BackgroundColor3 = self.Color})
            end

            RefreshReadout()

            if Data.Callback then 
                Library:SafeCall(Data.Callback, self.Color, self.Alpha)
            end
        end

        local function ApplyText(Text)
            local Parsed = ParseColorText(Text)
            if Parsed then
                Colorpicker:Set(Parsed, Colorpicker.Alpha)
                return true
            end
            return false
        end

        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then 
                return
            end

            local Palette = Items["Palette"].Instance
            local SlideX = MathClamp((Input.Position.X - Palette.AbsolutePosition.X) / Palette.AbsoluteSize.X, 0, 1)
            local SlideY = MathClamp((Input.Position.Y - Palette.AbsolutePosition.Y) / Palette.AbsoluteSize.Y, 0, 1)

            self.Saturation = 1 - SlideX
            self.Value = 1 - SlideY

            Items["PaletteDragger"].Instance.Position = UDim2New(MathClamp(SlideX, 0, 0.989), 0, MathClamp(SlideY, 0, 0.989), 0)
            self:Update()            
        end

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then 
                return
            end

            local Hue = Items["Hue"].Instance
            local ValueY = MathClamp((Input.Position.Y - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y, 0, 1)

            self.Hue = ValueY

            Items["HueDragger"].Instance.Position = UDim2New(0, 0, MathClamp(ValueY, 0, 0.994), 0)
            self:Update()
        end

        function Colorpicker:SlideAlpha(Input)
            if not Input or not SlidingAlpha then 
                return
            end

            local Alpha = Items["Alpha"].Instance
            local ValueX = MathClamp((Input.Position.X - Alpha.AbsolutePosition.X) / Alpha.AbsoluteSize.X, 0, 1)
            
            self.Alpha = ValueX

            Items["AlphaDragger"].Instance.Position = UDim2New(MathClamp(ValueX, 0, 0.994), 0, 0, 0)
            self:Update(true)
        end

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Items["ColorpickerButton"]:Connect("MouseButton2Click", function()
            SetContextOpen(not Colorpicker.ContextOpen)
        end)

        Items["ValueBox"]:Connect("Focused", function()
            Items["ValueBox"].Instance.Text = ColorToHex(Colorpicker.Color)
        end)

        Items["ValueBox"]:Connect("FocusLost", function()
            if not ApplyText(Items["ValueBox"].Instance.Text) then
                RefreshReadout()
            end
            Items["ValueBox"].Instance.Text = ColorToHex(Colorpicker.Color) .. "  " .. ColorToRGBText(Colorpicker.Color)
        end)

        Items["PasteButton"]:Connect("MouseButton1Click", function()
            local Text = ReadClipboard()
            if Text and ApplyText(Text) then
                return
            end

            if Library.CopiedColor then
                Colorpicker:Set(Library.CopiedColor.Color, Library.CopiedColor.Alpha)
            end
        end)

        Items["ContextCopy"]:Connect("MouseButton1Click", function()
            Library.CopiedColor = { Color = Colorpicker.Color, Alpha = Colorpicker.Alpha }
            WriteClipboard(ColorToHex(Colorpicker.Color))
            SetContextOpen(false)
        end)

        Items["ContextPaste"]:Connect("MouseButton1Click", function()
            if Library.CopiedColor then
                Colorpicker:Set(Library.CopiedColor.Color, Library.CopiedColor.Alpha)
            else
                ApplyText(ReadClipboard())
            end
            SetContextOpen(false)
        end)

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = true
                Colorpicker:SlidePalette(Input)
            end
        end)

        Items["Palette"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = false
            end
        end)

        Items["Hue"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = true
                Colorpicker:SlideHue(Input)
            end
        end)

        Items["Hue"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = false
            end
        end)

        Items["Alpha"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = true
                Colorpicker:SlideAlpha(Input)
            end
        end)

        Items["Alpha"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = false
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                if SlidingPalette then
                    Colorpicker:SlidePalette(Input)
                end

                if SlidingHue then
                    Colorpicker:SlideHue(Input)
                end

                if SlidingAlpha then
                    Colorpicker:SlideAlpha(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = false
                SlidingHue = false
                SlidingAlpha = false
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            local IsLeft = Input.UserInputType == Enum.UserInputType.MouseButton1
            local IsRight = Input.UserInputType == Enum.UserInputType.MouseButton2

            if not IsLeft and not IsRight then
                    return
                end

            local OverButton = Library:IsMouseOverFrame(Items["ColorpickerButton"])

            if Colorpicker.ContextOpen and not Library:IsMouseOverFrame(Items["Context"]) and not OverButton then
                SetContextOpen(false)
            end

            if IsLeft and Colorpicker.IsOpen and not OverButton and not Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                Colorpicker:SetOpen(false)
            end
        end)

        if Data.Default then 
            Colorpicker:Set(Data.Default, Data.Alpha)
        end

        Library.SetFlags[Data.Flag] = function(Color, Alpha)
            Colorpicker:Set(Color, Alpha)
        end

        Library:RememberDefault(Data.Flag)
        return Colorpicker
    end

    Library.CreateSettings = function(self, Window, Data)
        Data = Data or { }

        local SettingsTab = Window:Page({ Name = Data.Name or "Settings", Columns = 2, Subtabs = false })

        local ConfigsBox = SettingsTab:Section({ Name = "Configs", Side = 1 })
        local ThemesBox = SettingsTab:Section({ Name = "Themes", Side = 1 })
        local ThemeBox = SettingsTab:Section({ Name = "Theme", Side = 2 })
        local MenuBox, ExtraBox = SettingsTab:MultiSection({ Name = "Menu", Sections = { "general", "extra" }, Side = 2 })

        Library.ConfigIgnore["Configs List"] = true
        Library.ConfigIgnore["Config Name"] = true

        local function Tone(Text, Key)
            return string.format('<font color="#%s">%s</font>', Library.Theme[Key]:ToHex(), Text)
        end

        local SelectedConfig
        local ConfigName = ""

        local Status = ConfigsBox:Label({ Name = "", Alignment = "Left" })

        local function RefreshStatus()
            Status:SetText(string.format("%s  /  auto %s", Tone(SelectedConfig or "none", "Text"), Tone(Library:GetAutoload() or "none", "Inactive Text")))
        end

        TableInsert(Library.AccentRefreshers, RefreshStatus)

        local ConfigNameBox

        local ConfigsList = ConfigsBox:Listbox({
            Items = {},
            Size = 84,
            Flag = "Configs List",
            Callback = function(Value)
                SelectedConfig = Value
                if Value and ConfigNameBox then
                    ConfigNameBox:Set(Value)
                end
                RefreshStatus()
            end,
        })

        ConfigNameBox = ConfigsBox:Textbox({
            Name = "Name",
            Placeholder = "config name",
            Flag = "Config Name",
            Callback = function(Value)
                ConfigName = Value
            end,
        })

        local function Refresh()
            Library:RefreshConfigsList(ConfigsList)
            RefreshStatus()
        end

        local function TargetName()
            if ConfigName ~= "" then
                return ConfigName
            end
            return SelectedConfig
        end

        ConfigsBox:ButtonRow({
            {
                Name = "save",
                Callback = function()
                    if Library:SaveConfig(TargetName()) then
                        Refresh()
                    end
                end,
            },
            {
                Name = "load",
                Callback = function()
                    Library:LoadConfigFile(SelectedConfig or TargetName())
                end,
            },
        })

        ConfigsBox:ButtonRow({
            {
                Name = "delete",
                Callback = function()
                    if SelectedConfig and Library:DeleteConfig(SelectedConfig) then
                        SelectedConfig = nil
                        Refresh()
                    end
                end,
            },
            {
                Name = "autoload",
                Callback = function()
                    local Name = SelectedConfig or TargetName()
                    if not Name or not Library:ConfigExists(Name) then
                        Library:Notification("Select a saved config first", 3)
                        return
                    end

                    if Library:GetAutoload() == Name then
                        Library:SetAutoload(nil)
                        Library:Notification("Autoload cleared", 3)
                    else
                        Library:SetAutoload(Name)
                        Library:Notification("Autoload set to " .. Name, 3)
                    end
                    RefreshStatus()
                end,
            },
            {
                Name = "refresh",
                Callback = Refresh,
            },
        })

        ConfigsBox:Button({
            Name = "reset to default",
            Callback = function()
                Library:ResetToDefaults()
            end,
        })

        local SelectedTheme
        local ThemeName = ""

        local PresetNames = {}
        for Name in Library.ThemePresets do
            table.insert(PresetNames, Name)
        end
        table.sort(PresetNames)

        ThemesBox:Dropdown({
            Name = "Preset",
            Flag = "Theme Preset",
            Default = "Tapology",
            Items = PresetNames,
            Callback = function(Value)
                if Value and Library.ThemePresets[Value] then
                    Library:ApplyTheme(Library.ThemePresets[Value])
                    RefreshStatus()
                end
            end,
        })

        local ThemeNameBox

        local ThemesList = ThemesBox:Listbox({
            Items = {},
            Size = 56,
            Flag = "Themes List",
            Callback = function(Value)
                SelectedTheme = Value
                if Value and ThemeNameBox then
                    ThemeNameBox:Set(Value)
                end
            end,
        })

        ThemeNameBox = ThemesBox:Textbox({
            Name = "Name",
            Placeholder = "theme name",
            Flag = "Theme Name",
            Callback = function(Value)
                ThemeName = Value
            end,
        })

        ThemesBox:ButtonRow({
            {
                Name = "save",
                Callback = function()
                    if Library:SaveTheme(ThemeName ~= "" and ThemeName or SelectedTheme) then
                        Library:RefreshThemesList(ThemesList)
                    end
                end,
            },
            {
                Name = "load",
                Callback = function()
                    Library:LoadThemeFile(SelectedTheme or ThemeName)
                    RefreshStatus()
                end,
            },
            {
                Name = "delete",
                Callback = function()
                    if SelectedTheme and Library:DeleteTheme(SelectedTheme) then
                        SelectedTheme = nil
                        Library:RefreshThemesList(ThemesList)
                    end
                end,
            },
            {
                Name = "default",
                Callback = function()
                    local Name = SelectedTheme
                    if type(Name) ~= "string" or Name == "" then
                        Name = ThemeName
                    end
                    if type(Name) ~= "string" or Name == "" then
                        Name = Library.Flags["Theme Preset"]
                    end
                    if type(Name) ~= "string" or CleanName(Name) == "" then
                        Library:Notification("Pick a theme first", 3)
                        return
                    end
                    if Library:GetDefaultTheme() == CleanName(Name) then
                        Library:SetDefaultTheme(nil)
                        Library:Notification("Default theme cleared", 3)
                    elseif Library.ThemePresets[Name] or isfile(Library:ThemePath(Name)) then
                        Library:SetDefaultTheme(Name)
                        if Library.ThemePresets[Name] then
                            Library:ApplyTheme(Library.ThemePresets[Name])
                        else
                            Library:LoadThemeFile(Name)
                        end
                        Library:Notification("Default theme set to " .. CleanName(Name), 3)
                    else
                        Library:Notification("Theme " .. CleanName(Name) .. " not found", 3)
                    end
                end,
            },
        })

        for Index, Value in Library.Theme do
            ThemeBox:Label({ Name = Index, Alignment = "Left" }):Colorpicker({
                Name = Index,
                Default = Value,
                Flag = "Theme" .. Index,
                Callback = function(Color)
                    Library.Theme[Index] = Color
                    Library:ChangeTheme(Index, Color)
                end,
            })
        end

        MenuBox:Label({ Name = "Menu Keybind", Alignment = "Left" }):Keybind({
            Name = "Menu Keybind",
            Flag = "Menu Keybind",
            Default = Enum.KeyCode.RightControl,
            Mode = "Toggle",
            Callback = function()
                Library.MenuKeybind = Library.Flags["Menu Keybind"].Key
            end,
        })

        MenuBox:Toggle({
            Name = "Watermark",
            Flag = "Watermark",
            Default = false,
            Callback = function(Value)
                if Library.CurrentWatermark then Library.CurrentWatermark:SetVisibility(Value) end
            end,
        }):Children():Dropdown({
            Name = "Watermark Parts",
            Flag = "Watermark Parts",
            Default = { "Brand", "Time", "Game" },
            Multi = true,
            Items = { "Brand", "Time", "Date", "Username", "Game", "FPS", "Ping" },
            Callback = function(Value)
                if Library.CurrentWatermark then Library.CurrentWatermark:SetParts(Value) end
            end,
        })

        MenuBox:Toggle({
            Name = "Keybind List",
            Flag = "Keybind List",
            Default = false,
            Callback = function(Value)
                if Library.KeyList then Library.KeyList:SetVisibility(Value) end
            end,
        })

        MenuBox:ButtonRow({
            {
                Name = "notify",
                Callback = function()
                    Library:Notification("Tapology.pro notification", 4)
                end,
            },
            {
                Name = "unload",
                Callback = function()
                    Library:Unload()
                end,
            },
        })

        local ShadowTargets = { "UI", "Watermark", "Keybinds", "Notifications" }

        local ShadowOptions = ExtraBox:Toggle({
            Name = "Shadows",
            Flag = "Shadow Enabled",
            Default = false,
            Callback = function(Value)
                Library:SetShadowEnabled(Value)
            end,
        }):Children()

        ShadowOptions:Dropdown({
            Name = "Apply to",
            Flag = "Shadow Targets",
            Multi = true,
            Default = { "UI", "Watermark", "Keybinds", "Notifications" },
            Items = ShadowTargets,
            Callback = function(Value)
                Library:SetShadowTargets(Value)
            end,
        })

        Refresh()
        Library:RefreshThemesList(ThemesList)

        local Autoloaded = Library:RunAutoload()
        if Autoloaded then
            SelectedConfig = Autoloaded
        end
        Library:ApplyDefaultTheme()
        RefreshStatus()

        return SettingsTab
    end

    Library.Window = function(self, Data)
        Data = Data or { }

        local Window = {
            Name = Data.Name or Data.name or "Window",
            Size = Data.Size or Data.size or UDim2New(0, 480, 0, 505),

            FadeSpeed = Data.FadeSpeed or Data.fadespeed or 0,

            Pages = { },
            SubPages = { },
            Elements = { },

            IsOpen = true
        }

        local Items = { } do 
            Items["MainFrame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                AnchorPoint = Vector2New(0, 0),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(8, 8, 8),
                Size = Window.Size,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Outline
            })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Outline", BorderColor3 = "Border"})

            Items["MainFrame"].Instance.Position = UDim2New(0, Workspace.CurrentCamera.ViewportSize.X / 4, 0, Workspace.CurrentCamera.ViewportSize.Y / 4)
            Items["MainFrame"].Instance.ClipsDescendants = false

            Items["MainFrame"]:MakeDraggable()
            Items["MainFrame"]:MakeResizeable(Vector2New(Window.Size.X.Offset, Window.Size.Y.Offset), Vector2New(9999, 9999))
            
            Instances:Create("UIStroke", {
                Parent = Items["MainFrame"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Thickness = 1,
                Name = "\0",
                Color = FromRGB(8, 8, 8)
            }):AddToTheme({Color = "Border"})

            Library:AddShadow(Items["MainFrame"].Instance, "UI", 10)
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["MainFrame"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(210, 210, 210),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Window.Name,
                Name = "\0",
                Visible = false,
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 6, 0, 1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Items["Inline"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                Position = UDim2New(0, Library.FrameBand, 0, Library.FrameBand),
                BorderColor3 = FromRGB(8, 8, 8),
                Size = UDim2New(1, -Library.FrameBand * 2, 1, -Library.FrameBand * 2),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Background
            })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["Inline"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Thickness = 1,
                Color = Library.Theme.Border,
                Name = "\0"
            }):AddToTheme({Color = "Border"})
            
            Items["TabBar"] = Instances:Create("Frame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                Position = UDim2New(0, 6, 0, 6),
                BorderColor3 = FromRGB(8, 8, 8),
                Size = UDim2New(1, -12, 0, 22),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Inline
            })  Items["TabBar"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["TabBar"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Thickness = 1,
                Color = Library.Theme.Border,
                Name = "\0"
            }):AddToTheme({Color = "Border"})

            Instances:Create("UIPadding", {
                Parent = Items["TabBar"].Instance,
                PaddingLeft = UDimNew(0, 12),
                PaddingRight = UDimNew(0, 12),
                PaddingTop = UDimNew(0, 2),
                PaddingBottom = UDimNew(0, 2)
            })

            Library:AddInsetShadow(Items["TabBar"].Instance, {12, 2, 12, 2})

            Items["TabChip"] = Instances:Create("Frame", {
                Parent = Items["TabBar"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, -2),
                Size = UDim2New(0, 0, 1, 4),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 0,
                BackgroundTransparency = 0.94,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIGradient", {
                Parent = Items["TabChip"].Instance,
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Items["Pages"] = Instances:Create("Frame", {
                Parent = Items["TabBar"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Pages"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.None,
                Padding = UDimNew(0, 14),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            })

            Items["ContentContainer"] = Instances:Create("Frame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                Position = UDim2New(0, 6, 0, 34),
                BorderColor3 = FromRGB(8, 8, 8),
                Size = UDim2New(1, -12, 1, -40),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Inline
            })  Items["ContentContainer"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})
        
            Instances:Create("UIStroke", {
                Parent = Items["ContentContainer"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Thickness = 1,
                Color = Library.Theme.Border,
                Name = "\0"
            }):AddToTheme({Color = "Border"})

            Instances:Create("UIPadding", {
                Parent = Items["ContentContainer"].Instance,
                PaddingTop = UDimNew(0, 6),
                PaddingBottom = UDimNew(0, 6),
                PaddingLeft = UDimNew(0, 6),
                PaddingRight = UDimNew(0, 6)
            })

            Library:AddInsetShadow(Items["ContentContainer"].Instance, {6, 6, 6, 6})

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["ContentContainer"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(8, 8, 8),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                BackgroundColor3 = FromRGB(18, 18, 18)
            })
        end

        function Window:SetOpen(Bool)
            Window.IsOpen = Bool
            Items["MainFrame"].Instance.Visible = Bool
            Library:SetCursorUnlocked(Bool)
        end

        function Window:MoveTabIndicator(Button)
            local Bar = Items["TabBar"].Instance
            local Chip = Items["TabChip"]
            local First = Chip.Instance.Size.X.Offset == 0

            Library:Thread(function()
                for _ = 1, 30 do
                    if Button.AbsoluteSize.X > 0 then
                        break
                    end
                    task.wait()
                end

                local X = Button.AbsolutePosition.X - Bar.AbsolutePosition.X - 12

                local ChipGoal = {
                    Position = UDim2New(0, X - 10, 0, -2),
                    Size = UDim2New(0, Button.AbsoluteSize.X + 20, 1, 4)
                }

                if First then
                    Chip.Instance.Position = ChipGoal.Position
                    Chip.Instance.Size = ChipGoal.Size
                else
                    Chip:Tween(nil, ChipGoal)
                end
            end)
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        Window.Elements = Items
        Library:SetCursorUnlocked(Window.IsOpen)

        return setmetatable(Window, Library)
    end

    Library.Page = function(self, Data)
        Data = Data or { }

        local Page = {
            Window = self,

            Name = Data.Name or Data.name or "Page",
            Columns = Data.Columns or Data.columns or 2,

            HasSubtabs = Data.Subtabs or Data.subtabs or false,

            Active = false,
            ColumnsData = { },
            Elements = { }
        }

        local Items = { } do 
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = Page.Window.Elements["Pages"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(28, 28, 28)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Inactive"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(210, 210, 210),
                TextTransparency = 0.47999998927116394,
                Text = Page.Name,
                Name = "\0",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 1, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Hide"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Visible = false,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Size = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                BackgroundColor3 = FromRGB(18, 18, 18)
            })            

            Items["Page"] = Instances:Create("Frame", {
                Parent = Page.Window.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255),
                Visible = false
            })
            
            if not Page.HasSubtabs then 
                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })
                
                for Index = 1, Page.Columns do
                    local NewColumn = Instances:Create("ScrollingFrame", {
                        Parent = Items["Page"].Instance,
                        ScrollBarImageColor3 = FromRGB(96, 126, 255),
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 100, 0, 100),
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    })  NewColumn:AddToTheme({ScrollBarImageColor3 = "Accent"})
                    Library:ApplyScrollbar(NewColumn.Instance, 1)
                    
                    Instances:Create("UIPadding", {
                        Parent = NewColumn.Instance,
                        PaddingTop = UDimNew(0, 6),
                        PaddingBottom = UDimNew(0, 6),
                        PaddingRight = UDimNew(0, 6),
                        PaddingLeft = UDimNew(0, 6)
                    })
                    
                    Instances:Create("UIListLayout", {
                        Parent = NewColumn.Instance,
                        Padding = UDimNew(0, 16),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }) 

                    Page.ColumnsData[Index] = NewColumn
                end
            else
                Items["Columns"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 7, 0, 45),
                    BorderColor3 = FromRGB(10, 10, 10),
                    Size = UDim2New(1, -14, 1, -52),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(15, 15, 20)
                })  Items["Columns"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Items["SubTabs"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 7, 0, 7),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -14, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                }) 

                Instances:Create("UIListLayout", {
                    Parent = Items["SubTabs"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 
            end
        end

        local Debounce = false

        function Page:Turn(Bool)
            Page.Active = Bool
            Items["Page"].Instance.Visible = Bool

            if Bool then 
                Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                Items["Text"]:Tween(nil, {TextTransparency = 0})
                Page.Window:MoveTabIndicator(Items["Inactive"].Instance)
            else
                Items["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                Items["Text"]:Tween(nil, {TextTransparency = 0})
            end

            if Items["Hide"] then
                Items["Hide"].Instance.Visible = false
                end
            end

        Items["Inactive"]:OnHover(function()
            if not Page.Active then
                Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
            end
        end)

        Items["Inactive"]:OnHoverLeave(function()
            if not Page.Active then
                Items["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
            end
        end)

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in Page.Window.Pages do
                Value:Turn(Value == Page)
            end
        end)

        if #Page.Window.Pages == 0 then 
            Page:Turn(true)
        end

        Page.Elements = Items

        TableInsert(Page.Window.Pages, Page)
        return setmetatable(Page, Library.Pages)
    end

    Library.Pages.SubPage = function(self, Data)
        Data = Data or { }

        local SubPage = {
            Window = self.Window,
            Page = self,

            Icon = Data.Icon or Data.icon or "9080568477801",
            Columns = Data.Columns or Data.columns or 2,

            Active = false,
            ColumnsData = { },
            Elements = { }
        }

        local Items = { } do
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = SubPage.Page.Elements["SubTabs"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, -2),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(30, 30, 35)
            })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})

            Items["Hide"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Visible = false,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 2),
                Size = UDim2New(1, 0, 0, 2),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Background"})

            Items["MiscPixel1"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                Size = UDim2New(0, 1, 0, 1),
                Name = "\0",
                Position = UDim2New(0, -1, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            }) 

            Items["MiscPixel2"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                Name = "\0",
                Position = UDim2New(1, 1, 0, 1),
                Size = UDim2New(0, 1, 0, 1),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            }) 

            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["Inactive"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                ImageTransparency = 0.35,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://"..SubPage.Icon,
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                Size = UDim2New(0, 30, 0, 30),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Icon"]:AddToTheme({ImageColor3 = "Text"})

            Instances:Create("UIGradient", {
                Parent = Items["Inactive"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(138, 138, 138))}
            }) 

            Items["Subtab"] = Instances:Create("Frame", {
                Parent = SubPage.Page.Elements["Columns"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIPadding", {
                Parent = Items["Subtab"].Instance,
                PaddingTop = UDimNew(0, 6),
                PaddingRight = UDimNew(0, 6),
                PaddingLeft = UDimNew(0, 6)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["Subtab"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalFlex = Enum.UIFlexAlignment.Fill
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Subtab"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            for Index = 1, SubPage.Columns do
                local NewColumn = Instances:Create("ScrollingFrame", {
                    Parent = Items["Subtab"].Instance,
                    ScrollBarImageColor3 = FromRGB(96, 126, 255),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 100, 0, 100),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0)
                })  NewColumn:AddToTheme({ScrollBarImageColor3 = "Accent"})
                Library:ApplyScrollbar(NewColumn.Instance, 1)

                Instances:Create("UIPadding", {
                    Parent = NewColumn.Instance,
                    PaddingTop = UDimNew(0, 6),
                    PaddingBottom = UDimNew(0, 6),
                    PaddingRight = UDimNew(0, 6),
                    PaddingLeft = UDimNew(0, 6)
                }) 

                Instances:Create("UIListLayout", {
                    Parent = NewColumn.Instance,
                    Padding = UDimNew(0, 16),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 

                SubPage.ColumnsData[Index] = NewColumn
            end
        end

        local Debounce = false

        function SubPage:Turn(Bool)
            if Debounce then 
                return 
            end

            SubPage.Active = Bool

            Debounce = true 

            if Bool then 
                Items["Subtab"].Instance.Visible = true

                Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, ImageTransparency = 0})
                Items["Hide"].Instance.Visible = true

                Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})

                Items["Inactive"].Instance.Size = UDim2New(1, 0, 1, 1)
            else
                Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Text, ImageTransparency = 0.35})
                Items["Hide"].Instance.Visible = false

                Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})
                Items["Inactive"].Instance.Size = UDim2New(1, 0, 1, -2)
            end

            local Descendants = Items["Subtab"].Instance:GetDescendants()
            TableInsert(Descendants, Items["Subtab"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, SubPage.Window.FadeSpeed or 0.5)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, SubPage.Window.FadeSpeed or 0.5)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["Subtab"].Instance.Visible = Bool
            end)
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in SubPage.Window.SubPages do
                Value:Turn(Value == SubPage)
            end
        end)

        if #SubPage.Window.SubPages == 0 then 
            SubPage:Turn(true)
        end

        SubPage.Elements = Items

        TableInsert(SubPage.Window.SubPages, SubPage)
        return setmetatable(SubPage, Library.Pages)
    end

    Library.Pages.Section = function(self, Data)
        Data = Data or { }

        local Section = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or 1,

            Elements = { }
        }

        local Items = { } do 
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 25),
                BorderColor3 = FromRGB(34, 34, 34),
                BorderSizePixel = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(22, 22, 22)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(8, 8, 8),
                Name = "\0",
                Thickness = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 6),
                PaddingTop = UDimNew(0, 8)
            })

            Library:AddTopHighlight(Items["Section"].Instance, 8)
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(210, 210, 210),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                ZIndex = 5,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 16),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 8, 0, -8),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(22, 22, 22)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 6, 0, 3),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -12, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        Section.Elements = Items
        Section.Frame = Items["Section"].Instance

        return setmetatable(Section, Library.Sections)
    end

    Library.Pages.MultiSection = function(self, Data)
        Data = Data or { }

        local MultiSection = {
            Window = self.Window,
            Page = self,
            
            Name = Data.Name or Data.name,
            Sections = Data.Sections or Data.sections or { "Section 1", "Section 2", "Section 3" }, 
            Callback = Data.Callback or Data.callback, 
            Side = Data.Side or Data.side or 1,
            Size = Data.Size or Data.size,
            Scrollable = Data.Scrollable == true or Data.scrollable == true,

            SectionContents = { },

            Elements = { }
        }

        local HeaderOffset = (MultiSection.Name and 4 or 0) + 25
        local Scrollable = MultiSection.Scrollable or type(MultiSection.Size) == "number"
        local FixedHeight = type(MultiSection.Size) == "number" and MultiSection.Size or (Scrollable and 220 or nil)

        local Items = { } do
            Items["MultiSection"] = Instances:Create("Frame", {
                Parent = MultiSection.Page.ColumnsData[MultiSection.Side].Instance,
                Name = "\0",
                Size = FixedHeight and UDim2New(1, 0, 0, FixedHeight) or UDim2New(1, 0, 0, 0),
                BorderColor3 = FromRGB(27, 27, 32),
                BorderSizePixel = 1,
                AutomaticSize = FixedHeight and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
                ClipsDescendants = false,
                BackgroundColor3 = Library.Theme["Page Background"]
            })  Items["MultiSection"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["MultiSection"].Instance,
                Color = FromRGB(10, 10, 10),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["MultiSection"].Instance,
                PaddingBottom = UDimNew(0, 6),
                PaddingTop = UDimNew(0, 8)
            }) 
            
            Library:AddTopHighlight(Items["MultiSection"].Instance, 8)

            if MultiSection.Name then
                Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["MultiSection"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                    Text = MultiSection.Name,
                    Name = "\0",
                    ZIndex = 5,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 0, 16),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 8, 0, -8),
                BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Title"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0"
                }):AddToTheme({Color = "Text Border"})
            end

            Items["Tabs"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                Position = UDim2New(0, 6, 0, MultiSection.Name and 4 or 0),
                Size = UDim2New(1, -12, 0, 18),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = Library.Theme.Inline
            })  Items["Tabs"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UIStroke", {
                Parent = Items["Tabs"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = Library.Theme.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UIPadding", {
                Parent = Items["Tabs"].Instance,
                PaddingLeft = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 8)
            })

            Library:AddInsetShadow(Items["Tabs"].Instance, {8, 0, 8, 0}, 6)

            Items["TabList"] = Instances:Create("Frame", {
                Parent = Items["Tabs"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["TabList"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDimNew(0, 12),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            if Scrollable then
                Items["Content"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["MultiSection"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 6, 0, HeaderOffset),
                    Size = UDim2New(1, -12, 1, -(HeaderOffset + 2)),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = FromRGB(96, 126, 255),
                    Active = true,
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Content"]:AddToTheme({ScrollBarImageColor3 = "Accent"})
                Library:ApplyScrollbar(Items["Content"].Instance, 1)

                Instances:Create("UIPadding", {
                    Parent = Items["Content"].Instance,
                    PaddingTop = UDimNew(0, 3),
                    PaddingLeft = UDimNew(0, 2),
                    PaddingRight = UDimNew(0, 2),
                    PaddingBottom = UDimNew(0, 4)
                })
            else
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                    Position = UDim2New(0, 6, 0, HeaderOffset),
                    Size = UDim2New(1, -12, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            end
        end

        MultiSection.Elements = Items

        for Index, Value in MultiSection.Sections do 
            local NewSection = {
                Window = MultiSection.Window,
                Page = MultiSection.Page,
                MultiSection = MultiSection,

                Name = Value,

                Elements = { },

                Active = false,
            }

            local SubItems = { } do 
                SubItems["Inactive"] = Instances:Create("TextButton", {
                    Parent = Items["TabList"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 1, 0),
                    LayoutOrder = Index,
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                SubItems["Text"] = Instances:Create("TextLabel", {
                    Parent = SubItems["Inactive"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Inactive Text"],
                    TextTransparency = 0,
                    Text = NewSection.Name,
                    Name = "\0",
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2New(0, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  SubItems["Text"]:AddToTheme({TextColor3 = "Inactive Text"})

                Instances:Create("UIStroke", {
                    Parent = SubItems["Text"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0"
                }):AddToTheme({Color = "Text Border"})

                SubItems["Content"] = Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                }) 
                
                Instances:Create("UIListLayout", {
                    Parent = SubItems["Content"].Instance,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 
            end

            function NewSection:Turn(Bool)
                NewSection.Active = Bool
                SubItems["Content"].Instance.Visible = Bool
                SubItems["Text"]:ChangeItemTheme({TextColor3 = Bool and "Text" or "Inactive Text"})
                SubItems["Text"]:Tween(nil, {TextTransparency = 0})
            end

            SubItems["Inactive"]:OnHover(function()
                if not NewSection.Active then
                    SubItems["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                end
            end)

            SubItems["Inactive"]:OnHoverLeave(function()
                if not NewSection.Active then
                    SubItems["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                end
            end)

            SubItems["Inactive"]:Connect("MouseButton1Down", function()
                for _, Other in MultiSection.SectionContents do
                    Other:Turn(Other == NewSection)
                end

                if MultiSection.Callback then
                    Library:SafeCall(MultiSection.Callback, NewSection.Name)
            end
            end)

            NewSection.Elements = SubItems
            NewSection.Frame = Items["MultiSection"].Instance

            MultiSection.SectionContents[#MultiSection.SectionContents + 1] = setmetatable(NewSection, Library.Sections)
        end

        for Index, Section in MultiSection.SectionContents do
            Section:Turn(Index == 1)
        end

        return TableUnpack(MultiSection.SectionContents)
    end

    Library.Pages.ScrollableSection = function(self, Data)
        Data = Data or { }

        local Section = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or 1,
            Size = Data.Size or Data.size or 175,

            Elements = { }
        }

        local Items = { } do 
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, Section.Size),
                BorderColor3 = FromRGB(27, 27, 32),
                BorderSizePixel = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Outline"})

            Items["Fade"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 20),
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 2),
                BorderSizePixel = 0,
                ZIndex = 15,
                BackgroundColor3 = FromRGB(27, 27, 32)
            })  Items["Fade"]:AddToTheme({BackgroundColor3 = "Page Background"})

            Instances:Create("UIGradient", {
                Parent = Items["Fade"].Instance,
                Rotation = -90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.718, 0.768750011920929), NumSequenceKeypoint(1, 1)}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(10, 10, 10),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 6),
                PaddingTop = UDimNew(0, 8)
            })

            Library:AddTopHighlight(Items["Section"].Instance, 8)
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(210, 210, 210),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                ZIndex = 5,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 16),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 8, 0, -8),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(22, 22, 22)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Content"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(96, 126, 255),
                Active = true,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 21),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, -20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Content"]:AddToTheme({ScrollBarImageColor3 = "Accent"})
            Library:ApplyScrollbar(Items["Content"].Instance, 1)

            Instances:Create("UIPadding", {
                Parent = Items["Content"].Instance,
                PaddingTop = UDimNew(0, 0),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 11),
                PaddingLeft = UDimNew(0, 8)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        Section.Elements = Items

        return setmetatable(Section, Library.Sections)
    end

    Library.Sections.Divider = function(self)
        local Divider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
        }

        local Items = { } do
            Items["Divider"] = Instances:Create("Frame", {
                Parent = Divider.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 10),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["RealDivider"] = Instances:Create("Frame", {
                Parent = Items["Divider"].Instance,
                AnchorPoint = Vector2New(0, 0.5),
                Name = "\0",
                Position = UDim2New(0, 0, 0.5, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 3),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["RealDivider"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["RealDivider"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})
        end
        
        function Divider:SetVisibility(Bool)
            Items["Divider"].Instance.Visible = Bool
        end

        return Divider
    end

    local ShortKeyNames = {
        MouseButton1 = "mb1", MouseButton2 = "mb2", MouseButton3 = "mb3",
        LeftShift = "lshift", RightShift = "rshift",
        LeftControl = "lctrl", RightControl = "rctrl",
        LeftAlt = "lalt", RightAlt = "ralt",
        Return = "enter", CapsLock = "caps"
    }

    local function KeyName(Key)
        if not Key then
            return "none"
        end

        local Text = StringGSub(tostring(Key), "Enum.KeyCode.", "")
        Text = StringGSub(Text, "Enum.UserInputType.", "")
        return string.lower(ShortKeyNames[Text] or Text)
    end

    local function ParseKey(Value)
        if typeof(Value) == "EnumItem" then
            return Value
        end

        if type(Value) ~= "string" then
            return nil
        end

        local KeyCodeName = string.match(Value, "KeyCode%.(.+)$")
        local InputName = string.match(Value, "UserInputType%.(.+)$")

        local Ok, Result = pcall(function()
            if KeyCodeName then
                return Enum.KeyCode[KeyCodeName]
            elseif InputName then
                return Enum.UserInputType[InputName]
            end
        end)

        return Ok and Result or nil
    end

    local function InputMatches(Input, Key)
        return Key ~= nil and (Input.KeyCode == Key or Input.UserInputType == Key)
    end

    local function OpenPopup(Popup)
        if Library.CurrentPopup and Library.CurrentPopup ~= Popup then
            Library.CurrentPopup:Close()
        end
        Library.CurrentPopup = Popup
    end

    local function ClosedPopup(Popup)
        if Library.CurrentPopup == Popup then
            Library.CurrentPopup = nil
        end
    end

    local function PopupLabel(Parent, Text, Position, Size, Alignment, Theme)
        local Label = Instances:Create("TextLabel", {
            Parent = Parent,
            FontFace = Library.Font,
            TextColor3 = Library.Theme[Theme or "Text"],
            BorderColor3 = FromRGB(0, 0, 0),
            Text = Text,
            Name = "\0",
            Position = Position,
            Size = Size,
            BackgroundTransparency = 1,
            TextXAlignment = Alignment or Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Label:AddToTheme({TextColor3 = Theme or "Text"})

        Instances:Create("UIStroke", {
            Parent = Label.Instance,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0"
        }):AddToTheme({Color = "Text Border"})

        return Label
    end

    local function PopupField(Parent, Position, Size, IsTextBox)
        local Field = Instances:Create(IsTextBox and "TextBox" or "TextButton", {
            Parent = Parent,
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "",
            Name = "\0",
            AnchorPoint = Vector2New(1, 0),
            Position = Position,
            Size = Size,
            BorderSizePixel = 0,
            TextSize = 12,
            ClipsDescendants = true,
            BackgroundColor3 = Library.Theme.Element
        })  Field:AddToTheme({BackgroundColor3 = "Element", TextColor3 = "Text"})

        if IsTextBox then
            Field.Instance.ClearTextOnFocus = false
            Field.Instance.TextWrapped = false
        else
            Field.Instance.AutoButtonColor = false
        end

        Instances:Create("UIStroke", {
            Parent = Field.Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Thickness = 1,
            Name = "\0",
            Color = Library.Theme.Border
        }):AddToTheme({Color = "Border"})

        Instances:Create("UIGradient", {
            Parent = Field.Instance,
            Rotation = 90,
            Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(170, 170, 170))}
        })

        return Field
    end

    local function AttachBind(Options)
        local Width = 156
        local Modes = { "Toggle", "Hold", "Always" }
        local BaseHeight = Options.ShowModes and 66 or 46
        local Button = Options.Button

        local Bind = {
            Key = nil,
            Mode = Options.DefaultMode or "Always",
            Picking = false,
            IsOpen = false,
            ModesOpen = false
        }

        local Items = { }
        local KeyListEntry
        local Follow

        local function DisplayName()
            return type(Options.Name) == "function" and Options.Name() or tostring(Options.Name)
        end

        local function Title()
            return string.lower(DisplayName()) .. " / " .. KeyName(Bind.Key)
        end

        local function SaveFlag()
            Library.Flags[Options.Flag] = { Key = Bind.Key and tostring(Bind.Key) or "None", Mode = Bind.Mode }
        end

        local function RefreshLabel()
            if not Options.Label then
                return
            end

            local Text = DisplayName()
            if Bind.Key then
                Text = StringFormat('%s / <font color="#%s">%s</font>', Text, Library.Theme.Accent:ToHex(), KeyName(Bind.Key))
            end

            Options.Label.Instance.RichText = true
            Options.Label.Instance.Text = Text
        end

        local function RefreshEntry()
            if not Options.KeyList or not Library.KeyList then
                return
            end

            if Bind.Key and not KeyListEntry then
                KeyListEntry = Library.KeyList:Add(Bind.Mode, DisplayName(), KeyName(Bind.Key))
            end

            if KeyListEntry then
                KeyListEntry:Set(Bind.Mode, DisplayName(), KeyName(Bind.Key))
                KeyListEntry:SetStatus((Bind.Key and (not Options.IsActive or Options.IsActive())) and "Active" or "Inactive")
            end
        end

        local function RefreshTexts()
            RefreshLabel()

            if not Items["Popup"] then
                return
            end

            Items["Title"].Instance.Text = Title()
            Items["KeyField"].Instance.Text = Bind.Picking and "..." or KeyName(Bind.Key)

            if Options.ShowModes then
                Items["ModeField"].Instance.Text = string.lower(Bind.Mode)

                for Mode, Option in Items["ModeOptions"] do
                    local Active = Mode == Bind.Mode
                    Option:ChangeItemTheme({TextColor3 = Active and "Accent" or "Text"})
                    Option:Tween(nil, {TextColor3 = Active and Library.Theme.Accent or Library.Theme.Text, TextTransparency = Active and 0 or 0.4})
                end
            end
        end

        local function SetModesOpen(Bool)
            if not Options.ShowModes then
                return
            end

            Bind.ModesOpen = Bool
            Items["ModeList"].Instance.Visible = Bool

            local InnerHeight = BaseHeight + (Bool and (#Modes * 15 + 6) or 0)
            Items["Popup"].Instance.Size = UDim2New(0, Width, 0, InnerHeight + Library.FrameBand * 2)
        end

        function Bind:SetKey(Key)
            Bind.Key = Key
            Bind.Picking = false
            SaveFlag()
            RefreshTexts()
            RefreshEntry()

            if Options.OnKey then
                Options.OnKey(Key)
            end
        end

        function Bind:SetMode(Mode)
            if not TableFind(Modes, Mode) then
                return
            end

            Bind.Mode = Mode
            SaveFlag()

            if Mode == "Always" and Options.OnAlways then
                Options.OnAlways()
            end

            RefreshTexts()
            RefreshEntry()
        end

        Bind.Refresh = function()
            RefreshTexts()
            RefreshEntry()
        end

        local function Build()
            Items["Popup"], Items["Inner"] = Library:CreateOverlayFrame({
                AnchorPoint = Vector2New(1, 0),
                Size = UDim2New(0, Width, 0, BaseHeight + Library.FrameBand * 2)
            })
            Items["Popup"].Instance.Visible = false
            Items["Popup"].Instance.Active = true

            Items["Title"] = PopupLabel(Items["Inner"].Instance, Title(), UDim2New(0, 8, 0, 5), UDim2New(1, -16, 0, 14))

            PopupLabel(Items["Inner"].Instance, "key", UDim2New(0, 8, 0, 24), UDim2New(0, 40, 0, 16), nil, "Inactive Text")
            Items["KeyField"] = PopupField(Items["Inner"].Instance, UDim2New(1, -8, 0, 24), UDim2New(0, 72, 0, 16))

            Items["KeyField"]:Connect("MouseButton1Click", function()
                Bind.Picking = true
                RefreshTexts()
            end)

            if Options.ShowModes then
                PopupLabel(Items["Inner"].Instance, "mode", UDim2New(0, 8, 0, 44), UDim2New(0, 40, 0, 16), nil, "Inactive Text")
                Items["ModeField"] = PopupField(Items["Inner"].Instance, UDim2New(1, -8, 0, 44), UDim2New(0, 72, 0, 16))
                PopupLabel(Items["ModeField"].Instance, "+", UDim2New(0, 0, 0, 0), UDim2New(1, -4, 1, 0), Enum.TextXAlignment.Right)

                Items["ModeList"] = Instances:Create("Frame", {
                    Parent = Items["Inner"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -8, 0, 64),
                    Size = UDim2New(0, 72, 0, #Modes * 15),
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Visible = false,
                    BackgroundColor3 = Library.Theme.Inline
                })  Items["ModeList"]:AddToTheme({BackgroundColor3 = "Inline"})

                Instances:Create("UIStroke", {
                    Parent = Items["ModeList"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0",
                    Color = Library.Theme.Border
                }):AddToTheme({Color = "Border"})

                Items["ModeOptions"] = { }

                for Index, Mode in Modes do
                    local Option = Instances:Create("TextButton", {
                        Parent = Items["ModeList"].Instance,
                        FontFace = Library.Font,
                        TextColor3 = Library.Theme.Text,
                        TextTransparency = 0.4,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = string.lower(Mode),
                        AutoButtonColor = false,
                        Name = "\0",
                        Position = UDim2New(0, 6, 0, (Index - 1) * 15),
                        Size = UDim2New(1, -6, 0, 15),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  Option:AddToTheme({TextColor3 = "Text"})

                    Instances:Create("UIStroke", {
                        Parent = Option.Instance,
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        Name = "\0"
                    }):AddToTheme({Color = "Text Border"})

                    Option:Connect("MouseButton1Click", function()
                        Bind:SetMode(Mode)
                        SetModesOpen(false)
                    end)

                    Items["ModeOptions"][Mode] = Option
                end

                Items["ModeField"]:Connect("MouseButton1Click", function()
                    SetModesOpen(not Bind.ModesOpen)
                end)
            end

            SetZ(Items["Popup"].Instance, 10030)
            RefreshTexts()
        end

        function Bind:Close()
            Bind.IsOpen = false
            Bind.Picking = false

            if Follow then
                Follow:Disconnect()
                Follow = nil
            end

            if Items["Popup"] then
                SetModesOpen(false)
                Items["Popup"].Instance.Visible = false
                RefreshTexts()
            end

            ClosedPopup(Bind)
        end

        function Bind:Open()
            if not Items["Popup"] then
                Build()
            end

            OpenPopup(Bind)
            Bind.IsOpen = true
            RefreshTexts()

            Follow = FollowAnchor(Items["Popup"].Instance, Button, function(Anchor)
                return UDim2New(0, Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X, 0, Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + 4)
            end, function()
                Bind:Close()
            end)

            Items["Popup"].Instance.Visible = Bind.IsOpen
        end

        Library:Connect(Button.MouseButton2Click, function()
            if Bind.IsOpen then
                Bind:Close()
            else
                Bind:Open()
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Bind.Picking then
                if Input.UserInputType == Enum.UserInputType.Keyboard then
                    if Input.KeyCode == Enum.KeyCode.Escape or Input.KeyCode == Enum.KeyCode.Backspace then
                        Bind:SetKey(nil)
                    else
                        Bind:SetKey(Input.KeyCode)
                    end
                    return
                elseif Input.UserInputType == Enum.UserInputType.MouseButton2 or Input.UserInputType == Enum.UserInputType.MouseButton3 then
                    Bind:SetKey(Input.UserInputType)
                    return
                end
            end

            local IsClick = Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseButton2
            if IsClick and Bind.IsOpen and not Library:IsMouseOverFrame(Items["Popup"]) and not Library:IsMouseOverFrame({ Instance = Button }) then
                Bind:Close()
            end

            if not Options.OnTrigger or UserInputService:GetFocusedTextBox() or not InputMatches(Input, Bind.Key) then
                return
            end

            if Bind.Mode == "Toggle" or Bind.Mode == "Hold" then
                Options.OnTrigger(true, Bind.Mode)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Options.OnTrigger and Bind.Mode == "Hold" and InputMatches(Input, Bind.Key) then
                Options.OnTrigger(false, Bind.Mode)
            end
        end)

        Library.SetFlags[Options.Flag] = function(Value)
            if type(Value) ~= "table" then
                return
            end

            Bind:SetKey(ParseKey(Value.Key))
            Bind:SetMode(Value.Mode or "Always")
        end

        TableInsert(Library.AccentRefreshers, RefreshLabel)

        if Options.DefaultKey then
            Bind:SetKey(ParseKey(Options.DefaultKey) or Options.DefaultKey)
        else
            SaveFlag()
            RefreshLabel()
        end

        Library:RememberDefault(Options.Flag)
        return Bind
    end

    local function AttachToggleBind(Toggle, ToggleButton, TextLabel)
        local function SetValue(Value)
            if Toggle.Value ~= Value then
                Toggle:Set(Value)
            end
        end

        local Bind = AttachBind({
            Name = function()
                return Toggle.Name
            end,
            Flag = Toggle.Flag .. " Bind",
            Button = ToggleButton,
            Label = TextLabel,
            ShowModes = true,
            KeyList = true,
            IsActive = function()
                return Toggle.Value
            end,
            OnTrigger = function(Down, Mode)
                if Mode == "Toggle" then
                    Toggle:Set()
                else
                    SetValue(Down)
                end

                if Toggle.BindCallback then
                    Library:SafeCall(Toggle.BindCallback, Toggle.Value)
                end
            end,
            OnAlways = function()
                SetValue(true)
            end
        })

        Toggle.OnChanged = Bind.Refresh
        Toggle.Bind = Bind

        return Bind
    end

    local function AttachSliderInput(Slider, SliderBar)
        local Width = 150
        local Items = { }
        local Follow

        local Input = {
            IsOpen = false
        }

        local function Build()
            Items["Popup"], Items["Inner"] = Library:CreateOverlayFrame({
                Size = UDim2New(0, Width, 0, 45 + Library.FrameBand * 2)
            })
            Items["Popup"].Instance.Visible = false
            Items["Popup"].Instance.Active = true

            Items["Title"] = PopupLabel(Items["Inner"].Instance, string.lower(Slider.Name), UDim2New(0, 8, 0, 5), UDim2New(1, -16, 0, 14))
            Items["Range"] = PopupLabel(Items["Inner"].Instance, "", UDim2New(0, 8, 0, 5), UDim2New(1, -16, 0, 14), Enum.TextXAlignment.Right, "Inactive Text")

            Items["Box"] = PopupField(Items["Inner"].Instance, UDim2New(1, -8, 0, 23), UDim2New(1, -16, 0, 16), true)
            Items["Box"].Instance.TextXAlignment = Enum.TextXAlignment.Left
            Items["Box"].Instance.PlaceholderText = "value"

            Instances:Create("UIPadding", {
                Parent = Items["Box"].Instance,
                PaddingLeft = UDimNew(0, 4)
            })

            Items["Box"]:Connect("FocusLost", function()
                local Number = tonumber(string.match(Items["Box"].Instance.Text, "%-?%d*%.?%d+"))
                if Number then
                    Slider:Set(MathClamp(Number, Slider.Min, Slider.Max))
                end
                Input:Close()
            end)

            SetZ(Items["Popup"].Instance, 10030)
        end

        function Input:Close()
            Input.IsOpen = false

            if Follow then
                Follow:Disconnect()
                Follow = nil
            end

            if Items["Popup"] then
                Items["Popup"].Instance.Visible = false
            end

            ClosedPopup(Input)
        end

        function Input:Open()
            if not Items["Popup"] then
                Build()
            end

            OpenPopup(Input)
            Input.IsOpen = true

            Items["Range"].Instance.Text = StringFormat("%s - %s", tostring(Slider.Min), tostring(Slider.Max))
            Items["Box"].Instance.Text = tostring(Slider.Value)

            Follow = FollowAnchor(Items["Popup"].Instance, SliderBar, function(Anchor)
                return UDim2New(0, Anchor.AbsolutePosition.X, 0, Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + 5)
            end, function()
                Input:Close()
            end)

            Items["Popup"].Instance.Visible = Input.IsOpen

            task.defer(function()
                if Input.IsOpen then
                    Items["Box"].Instance:CaptureFocus()
                end
            end)
        end

        return Input
    end

    local EspWhite = FromRGB(255, 255, 255)
    local EspBlack = FromRGB(0, 0, 0)

    Library.EspFlagNames = { "health", "speed", "reloading", "armor", "visible", "moving" }

    Library.CustomMaterials = {
        Chrome = { Base = "Metal", Reflectance = 1, Glow = false, Opaque = true },
        Mirror = { Base = "Glass", Reflectance = 1, Glow = false },
        Plasma = { Base = "Neon", Reflectance = 0.35, Glow = true },
        Aurora = { Base = "ForceField", Reflectance = 0.55, Glow = true },
    }

    Library.MaterialItems = {
        "Chrome", "Mirror", "Plasma", "Aurora",
        "ForceField", "Neon", "Glass", "Metal", "Foil", "Ice", "SmoothPlastic", "Plastic"
    }

    Library.ResolveMaterial = function(self, Name)
        if type(Name) ~= "string" or Name == "" then
            Name = "ForceField"
        end

        local Custom = self.CustomMaterials and self.CustomMaterials[Name]
        if Custom then
            local BaseName = Custom.Base
            local EnumValue = type(BaseName) == "string" and Enum.Material[BaseName] or nil
            return EnumValue or Enum.Material.Metal, Custom.Reflectance or 0, Custom.Glow == true, Custom
        end

        local EnumValue = Enum.Material[Name]
        if EnumValue then
            return EnumValue, EnumValue == Enum.Material.ForceField and 0.15 or 0, EnumValue == Enum.Material.Neon, nil
        end
        return Enum.Material.ForceField, 0.15, false, nil
    end

    Library.DefaultEspSettings = function(self)
        local Color = EspWhite

        local Settings = {
            Box = false, BoxColor = Color, BoxColor2 = Color, BoxAnimated = false, BoxAnimatedSpeed = 120,
            BoxGlow = false, BoxGlowColor = Color, BoxGlowIntensity = 0.5,
            BoxFill = false, BoxFillColor = Color, BoxFillOpacity = 0.2,
            BoxTransform = false, BoxThickness = 1,
            Skeleton = false, SkeletonColor = Color, SkeletonOutline = false, SkeletonThickness = 1, SkeletonHead = false,
            SkeletonTorso = false, SkeletonSpine = false, SkeletonJoints = false, SkeletonJointColor = Color, SkeletonJointSize = 2,

            Name = false, NameColor = Color, NameColor2 = Color, NameFont = "Tahoma",
            NameOffset = false, NameY = 0, NameTransform = false, NameSize = 12,
            Distance = false, DistanceColor = Color, DistanceColor2 = Color, DistanceFont = "Tahoma",
            DistanceOffset = false, DistanceY = 0, DistanceTransform = false, DistanceSize = 12,
            Weapon = false, WeaponColor = Color, WeaponColor2 = Color, WeaponFont = "Tahoma",
            WeaponOffset = false, WeaponY = 0, WeaponTransform = false, WeaponSize = 12,

            Arrows = false, ArrowsColor = Color, ArrowsColorAlpha = 0, ArrowsThrobColor = Color, ArrowsThrobColorAlpha = 0,
            ArrowsLength = 16, ArrowsWidth = 14, ArrowsRadius = 140,
            ArrowsBox = false, ArrowsAlways = false,
            ArrowsExtra = false, ArrowsName = false, ArrowsWeapon = false, ArrowsDistance = false, ArrowsHealth = false, ArrowsAmmo = false,
            ArrowsFont = "Tahoma", ArrowsTransform = false, ArrowsSize = 12,

            Health = false, HealthHigh = Color, HealthMid = Color, HealthLow = Color,
            HealthGlow = false, HealthGlowColor = Color, HealthGlowIntensity = 0.5,
            HealthFlag = false, HealthFlagColor = Color, HealthFlagColor2 = Color, HealthFlagFont = "Tahoma",
            HealthFlagTransform = false, HealthFlagSize = 12,
            HealthThickness = 2, HealthExtra = false, HealthBackColor = EspBlack, HealthDynamic = false,
            HealthTransform = false, HealthSide = "Left", HealthX = 0, HealthY = 0,

            Ammo = false, AmmoHigh = Color, AmmoMid = Color, AmmoLow = Color,
            AmmoGlow = false, AmmoGlowColor = Color, AmmoGlowIntensity = 0.5,
            AmmoFlag = false, AmmoFlagColor = Color, AmmoFlagColor2 = Color, AmmoFlagFont = "Tahoma",
            AmmoFlagTransform = false, AmmoFlagSize = 12,
            AmmoThickness = 2, AmmoExtra = false, AmmoBackColor = EspBlack, AmmoDynamic = false,
            AmmoTransform = false, AmmoSide = "Bottom", AmmoX = 0, AmmoY = 0,

            Flags = false, FlagsList = { "health", "speed", "reloading" }, FlagColors = { }, FlagsFont = "Tahoma",
            FlagsTransform = false, FlagsSize = 12,

            Chams = false,
            ChamsVisible = false, ChamsVisibleFill = Color, ChamsVisibleFillAlpha = 0, ChamsVisibleOutline = Color, ChamsVisibleOutlineAlpha = 0,
            ChamsOccluded = false, ChamsOccludedFill = Color, ChamsOccludedFillAlpha = 0.35, ChamsOccludedOutline = Color, ChamsOccludedOutlineAlpha = 0.35,

            MaterialChanger = false,
            MaterialType = "Chrome",
            MaterialColor = Color,
            MaterialColorAlpha = 0,
            MaterialWalls = true
        }

        for _, FlagName in Library.EspFlagNames do
            Settings.FlagColors[FlagName] = { Color, Color }
        end

        return Settings
    end

    local function EspGradient(A, B)
        return RGBSequence{ RGBSequenceKeypoint(0, A), RGBSequenceKeypoint(1, B) }
    end
    local GradientCache = setmetatable({ }, { __mode = "k" })

    local function SetGradient(Gradient, A, B)
        local Cached = GradientCache[Gradient]
        if Cached and Cached[1] == A and Cached[2] == B then
            return
        end

        GradientCache[Gradient] = { A, B }
        Gradient.Color = EspGradient(A, B)
    end

    local function EspShade(Color, Amount)
        return Color:Lerp(EspBlack, Amount)
    end

    local function EspThreeStop(Fraction, Low, Mid, High)
        if Fraction > 0.5 then
            return Mid:Lerp(High, (Fraction - 0.5) * 2)
        end
        return Low:Lerp(Mid, Fraction * 2)
    end

    local ReloadingFrames = { "reloading.", "reloading..", "reloading..." }

    local function ReloadingText()
        return ReloadingFrames[1 + MathFloor(os.clock() * 3) % 3]
    end

    local function CreateEspDrawing(Parent, BaseZ)
        local Z = { Glow = BaseZ, Fill = BaseZ, Esp = BaseZ + 1 }

        local Container = InstanceNew("Frame")
        Container.Name = "\0"
        Container.BackgroundTransparency = 1
        Container.BorderSizePixel = 0
        Container.Size = UDim2New(1, 0, 1, 0)
        Container.ZIndex = BaseZ
        Container.Parent = Parent

        local Seen = { }
        local Stamp = 0

        local function Show(Object)
            Seen[Object] = Stamp
            if not Object.Visible then
                Object.Visible = true
            end
        end

        local function MakeText(AnchorX, AnchorY, Alignment)
            local Label = InstanceNew("TextLabel")
            Label.Name = "\0"
            Label.BackgroundTransparency = 1
            Label.BorderSizePixel = 0
            Label.AnchorPoint = Vector2New(AnchorX, AnchorY)
            Label.Size = UDim2New(0, 0, 0, 14)
            Label.AutomaticSize = Enum.AutomaticSize.X
            Label.FontFace = Library.Font
            Label.TextSize = 12
            Label.TextColor3 = EspWhite
            Label.TextXAlignment = Alignment or Enum.TextXAlignment.Center
            Label.Visible = false
            Label.ZIndex = Z.Esp
            Label.Parent = Container

            local Stroke = InstanceNew("UIStroke")
            Stroke.LineJoinMode = Enum.LineJoinMode.Miter
            Stroke.Color = EspBlack
            Stroke.Parent = Label

            local Gradient = InstanceNew("UIGradient")
            Gradient.Rotation = 0
            Gradient.Parent = Label

            return { Label = Label, Gradient = Gradient, Stroke = Stroke, Font = nil, Alpha = 0 }
        end

        local function SetText(Text, Value)
            if Text.Value ~= Value then
                Text.Value = Value
                Text.Label.Text = Value
            end
        end

        local function SetLabel(Text, Value)
            Text.Format = nil
            SetText(Text, Value)
        end

        local function SetNumbers(Text, Format, A, B)
            if Text.Format ~= Format or Text.A ~= A or Text.B ~= B then
                Text.Format, Text.A, Text.B = Format, A, B
                SetText(Text, StringFormat(Format, A, B))
            end
        end

        local function StyleText(Text, Color1, Color2, FontName, Transform, Size, Alpha)
            SetGradient(Text.Gradient, Color1, Color2)

            Alpha = Alpha or 0
            if Text.Alpha ~= Alpha then
                Text.Alpha = Alpha
                Text.Label.TextTransparency = Alpha
                Text.Stroke.Transparency = Alpha
            end

            local TextSize = Transform and MathFloor(Size) or 12
            if Text.Size ~= TextSize then
                Text.Size = TextSize
                Text.Label.TextSize = TextSize
                Text.Label.Size = UDim2New(0, 0, 0, TextSize + 2)
            end

            local Face = Library:GetFont(FontName)
            if Text.Font ~= Face then
                Text.Font = Face
                Text.Label.FontFace = Face
            end
        end

        local function MakeBar(Horizontal)
            local Back = InstanceNew("Frame")
            Back.Name = "\0"
            Back.BorderSizePixel = 0
            Back.Visible = false
            Back.ZIndex = Z.Esp
            Back.BackgroundColor3 = EspBlack
            Back.Parent = Container

            local Fill = InstanceNew("Frame")
            Fill.Name = "\0"
            Fill.AnchorPoint = Horizontal and Vector2New(0, 0) or Vector2New(0, 1)
            Fill.Position = Horizontal and UDim2New(0, 1, 0, 1) or UDim2New(0, 1, 1, -1)
            Fill.Size = UDim2New(1, -2, 1, -2)
            Fill.BorderSizePixel = 0
            Fill.ZIndex = Z.Esp
            Fill.BackgroundColor3 = EspWhite
            Fill.Parent = Back

            local Gradient = InstanceNew("UIGradient")
            Gradient.Rotation = 0
            Gradient.Parent = Fill

            return Back, Fill, Gradient
        end

        local function MakeGlow(Rings)
            local Frame0 = InstanceNew("Frame")
            Frame0.Name = "\0"
            Frame0.BackgroundTransparency = 1
            Frame0.BorderSizePixel = 0
            Frame0.Visible = false
            Frame0.ZIndex = Z.Glow
            Frame0.Parent = Container

            local Strokes = { }

            for Ring = 1, Rings do
                local Frame = InstanceNew("Frame")
                Frame.Name = "\0"
                Frame.BackgroundTransparency = 1
                Frame.BorderSizePixel = 0
                Frame.ZIndex = Z.Glow
                Frame.Position = UDim2New(0, -(Ring - 1), 0, -(Ring - 1))
                Frame.Size = UDim2New(1, (Ring - 1) * 2, 1, (Ring - 1) * 2)
                Frame.Parent = Frame0

                if Ring > 2 then
                    local Corner = InstanceNew("UICorner")
                    Corner.CornerRadius = UDimNew(0, Ring - 2)
                    Corner.Parent = Frame
                end

                local Stroke = InstanceNew("UIStroke")
                Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                Stroke.LineJoinMode = Ring > 2 and Enum.LineJoinMode.Round or Enum.LineJoinMode.Miter
                Stroke.Thickness = 1
                Stroke.Parent = Frame

                Strokes[Ring] = Stroke
            end

            return { Container = Frame0, Strokes = Strokes, Rings = Rings }
        end

        local function SetGlow(Glow, Visible, X, Y, Width, Height, Color, Intensity)
            if not Visible then
                return
            end

            Show(Glow.Container)
            Glow.Container.Position = UDim2New(0, X, 0, Y)
            Glow.Container.Size = UDim2New(0, Width, 0, Height)

            if Glow.Color == Color and Glow.Intensity == Intensity then
                return
            end
            Glow.Color, Glow.Intensity = Color, Intensity

            for Ring, Stroke in Glow.Strokes do
                local Falloff = 1 - (Ring - 1) / Glow.Rings
                Stroke.Color = Color
                Stroke.Transparency = 1 - MathClamp(Intensity, 0, 1) * 0.9 * Falloff ^ 1.5
            end
        end

        local Items = { }

        Items.BoxGlow = MakeGlow(7)
        Items.HealthGlow = MakeGlow(6)
        Items.AmmoGlow = MakeGlow(6)

        Items.BoxFill = InstanceNew("Frame")
        Items.BoxFill.Name = "\0"
        Items.BoxFill.BorderSizePixel = 0
        Items.BoxFill.Visible = false
        Items.BoxFill.ZIndex = Z.Fill
        Items.BoxFill.Parent = Container

        Items.Box = InstanceNew("Frame")
        Items.Box.Name = "\0"
        Items.Box.BackgroundTransparency = 1
        Items.Box.BorderSizePixel = 0
        Items.Box.Visible = false
        Items.Box.ZIndex = Z.Esp
        Items.Box.Parent = Container

        Items.BoxStroke = InstanceNew("UIStroke")
        Items.BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Items.BoxStroke.LineJoinMode = Enum.LineJoinMode.Miter
        Items.BoxStroke.Color = EspWhite
        Items.BoxStroke.Parent = Items.Box

        Items.BoxGradient = InstanceNew("UIGradient")
        Items.BoxGradient.Rotation = 0
        Items.BoxGradient.Parent = Items.BoxStroke

        for _, Offset in { -1, 1 } do
            local Ring = InstanceNew("Frame")
            Ring.Name = "\0"
            Ring.BackgroundTransparency = 1
            Ring.BorderSizePixel = 0
            Ring.Position = UDim2New(0, Offset, 0, Offset)
            Ring.Size = UDim2New(1, -Offset * 2, 1, -Offset * 2)
            Ring.ZIndex = Z.Esp
            Ring.Parent = Items.Box

            local Stroke = InstanceNew("UIStroke")
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Stroke.LineJoinMode = Enum.LineJoinMode.Miter
            Stroke.Color = EspBlack
            Stroke.Parent = Ring

            Items[Offset == -1 and "BoxOuterStroke" or "BoxInnerStroke"] = Stroke

            if Offset == -1 then
                Items.BoxOuterRing = Ring
            end
        end

        Items.HealthBack, Items.HealthFill, Items.HealthGradient = MakeBar(false)
        Items.AmmoBack, Items.AmmoFill, Items.AmmoGradient = MakeBar(true)

        Items.NameTag = MakeText(0.5, 1)
        Items.DistanceTag = MakeText(0.5, 0)
        Items.HealthTag = MakeText(1, 0.5, Enum.TextXAlignment.Right)
        Items.AmmoTag = MakeText(0.5, 0)
        Items.WeaponTag = MakeText(0.5, 0)

        Items.ArrowPixels = { }
        Items.ArrowOutlines = { }
        Items.ArrowTexts = { Name = MakeText(0.5, 1), Weapon = MakeText(0.5, 0), Distance = MakeText(0.5, 0) }
        Items.ArrowBack, Items.ArrowFill, Items.ArrowGradient = MakeBar(false)
        Items.ArrowAmmoBack, Items.ArrowAmmoFill, Items.ArrowAmmoGradient = MakeBar(true)

        Items.FlagTags = { }
        for _, FlagName in Library.EspFlagNames do
            Items.FlagTags[FlagName] = MakeText(0, 0, Enum.TextXAlignment.Left)
        end

        Items.Pixels = { }
        Items.PixelOutlines = { }
        Items.Bones = { }
        Items.BoneOutlines = { }

        local function GetPixel(Pool, Index, ZIndex, Color)
            local Pixel = Pool[Index]
            if Pixel then
                return Pixel
            end

            local Frame = InstanceNew("Frame")
            Frame.Name = "\0"
            Frame.BorderSizePixel = 0
            Frame.Visible = false
            Frame.ZIndex = ZIndex
            Frame.BackgroundColor3 = Color
            Frame.Parent = Container

            Pixel = { Frame = Frame, Color = Color, Alpha = 0 }
            Pool[Index] = Pixel
            return Pixel
        end

        local function MakeCircle(Color)
            local Frame = InstanceNew("Frame")
            Frame.Name = "\0"
            Frame.AnchorPoint = Vector2New(0.5, 0.5)
            Frame.BackgroundTransparency = 1
            Frame.BorderSizePixel = 0
            Frame.Visible = false
            Frame.ZIndex = Z.Esp
            Frame.Parent = Container

            local Corner = InstanceNew("UICorner")
            Corner.CornerRadius = UDimNew(0.5, 0)
            Corner.Parent = Frame

            local Stroke = InstanceNew("UIStroke")
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Stroke.Color = Color
            Stroke.Parent = Frame

            return { Frame = Frame, Stroke = Stroke }
        end

        Items.HeadOutline = MakeCircle(EspBlack)
        Items.Head = MakeCircle(EspWhite)

        local ArrowFadeDuration = 0.22

        local Drawing = { Container = Container, Items = Items, ArrowFade = 0, ArrowCache = nil }

        function Drawing:StepArrowFade(Now, Active)
            local Dt = math.min(Now - (self.ArrowLastNow or Now), 0.05)
            self.ArrowLastNow = Now
            local Fade = self.ArrowFade or 0
            local Step = Dt / ArrowFadeDuration

            if Active then
                Fade = math.min(1, Fade + Step)
            else
                Fade = math.max(0, Fade - Step)
            end

            self.ArrowFade = Fade
            return Fade
        end

        local function SetArrowBarAlpha(Back, Fill, Fade)
            local BackAlpha = 1 - Fade
            if Back.BackgroundTransparency ~= BackAlpha then
                Back.BackgroundTransparency = BackAlpha
            end
            if Fill.BackgroundTransparency ~= BackAlpha then
                Fill.BackgroundTransparency = BackAlpha
            end
        end

        local PixelCount, OutlineCount = 0, 0

        local function PlacePixel(Pixel, X, Y, Width, Height, Color, Alpha)
            local Frame = Pixel.Frame
            Show(Frame)
            Frame.Position = UDim2New(0, X, 0, Y)
            Frame.Size = UDim2New(0, Width, 0, Height)

            if Pixel.Color ~= Color then
                Pixel.Color = Color
                Frame.BackgroundColor3 = Color
            end

            if Pixel.Alpha ~= Alpha then
                Pixel.Alpha = Alpha
                Frame.BackgroundTransparency = Alpha
            end
        end

        local function GetBone(Pool, Index, ZIndex)
            local Bone = Pool[Index]
            if Bone then
                return Bone
            end

            local Frame = InstanceNew("Frame")
            Frame.Name = "\0"
            Frame.AnchorPoint = Vector2New(0.5, 0.5)
            Frame.BorderSizePixel = 0
            Frame.Visible = false
            Frame.ZIndex = ZIndex
            Frame.Parent = Container

            local Corner = InstanceNew("UICorner")
            Corner.CornerRadius = UDimNew(1, 0)
            Corner.Parent = Frame

            Bone = { Frame = Frame, Color = nil, Alpha = nil }
            Pool[Index] = Bone
            return Bone
        end

        local function DrawLine(A, B, Thickness, Color, Outline, Alpha)
            local DX, DY = B.X - A.X, B.Y - A.Y
            local Length = math.sqrt(DX * DX + DY * DY)
            if Length < 1 then
                return
            end

            local MidX, MidY = (A.X + B.X) * 0.5, (A.Y + B.Y) * 0.5
            local Rotation = math.deg(math.atan2(DY, DX))

            local function Place(Pool, Index, ZIndex, LineThickness, LineColor, LineAlpha)
                local Bone = GetBone(Pool, Index, ZIndex)
                local Frame = Bone.Frame
                Show(Frame)
                Frame.Position = UDim2New(0, MidX, 0, MidY)
                Frame.Size = UDim2New(0, Length, 0, LineThickness)
                Frame.Rotation = Rotation
                if Bone.Color ~= LineColor then
                    Bone.Color = LineColor
                    Frame.BackgroundColor3 = LineColor
                end
                if Bone.Alpha ~= LineAlpha then
                    Bone.Alpha = LineAlpha
                    Frame.BackgroundTransparency = LineAlpha
                end
            end

            if Outline then
                OutlineCount += 1
                Place(Items.BoneOutlines, OutlineCount, Z.Glow, Thickness + 2, EspBlack, Alpha)
            end

            PixelCount += 1
            Place(Items.Bones, PixelCount, Z.Esp, Thickness, Color, Alpha)
        end

        local function Alpha(O, Key)
            return O[Key] or 0
        end

        local function BarAlpha(O, Key, Fraction)
            local Low, Mid, High = Alpha(O, Key .. "LowAlpha"), Alpha(O, Key .. "MidAlpha"), Alpha(O, Key .. "HighAlpha")
            if Fraction > 0.5 then
                return Mid + (High - Mid) * (Fraction - 0.5) * 2
            end
            return Low + (Mid - Low) * Fraction * 2
        end

        local BarDefaults = { Health = "Left", Ammo = "Bottom" }
        local BarKeys = { }
        for _, Key in { "Health", "Ammo" } do
            BarKeys[Key] = {
                Transform = Key .. "Transform", Side = Key .. "Side", X = Key .. "X", Y = Key .. "Y",
                Thickness = Key .. "Thickness", Extra = Key .. "Extra", Dynamic = Key .. "Dynamic",
                Back = Key .. "BackColor", BackAlpha = Key .. "BackColorAlpha",
                Glow = Key .. "Glow", GlowColor = Key .. "GlowColor", GlowIntensity = Key .. "GlowIntensity", GlowAlpha = Key .. "GlowColorAlpha",
                Low = Key .. "Low", Mid = Key .. "Mid", High = Key .. "High"
            }
        end

        Items.HealthBar = { Back = Items.HealthBack, Fill = Items.HealthFill, Gradient = Items.HealthGradient, Glow = Items.HealthGlow, Shade = 0.45 }
        Items.AmmoBar = { Back = Items.AmmoBack, Fill = Items.AmmoFill, Gradient = Items.AmmoGradient, Glow = Items.AmmoGlow, Shade = 0.55 }
        Items.Stack = { Left = 0, Right = 0, Top = 0, Bottom = 0 }

        local function DrawBar(O, Key, Bar, Fraction, MinX, MinY, MaxX, MaxY, BoxPad, Stack)
            local Keys = BarKeys[Key]
            local Transform = O[Keys.Transform]
            local Side = Transform and O[Keys.Side] or BarDefaults[Key]
            if not Stack[Side] then
                Side = BarDefaults[Key]
            end

            local Vertical = Side == "Left" or Side == "Right"
            local Thickness = MathClamp(MathFloor(O[Keys.Thickness] or 2), 1, 5) + 2
            local X, Y, W, H

            if Vertical then
                W, H = Thickness, (MaxY - MinY) + BoxPad * 2
                Y = MinY - BoxPad
                if Side == "Left" then
                    X = MinX - BoxPad - 1 - W - Stack.Left
                    Stack.Left += W + 2
                else
                    X = MaxX + BoxPad + 1 + Stack.Right
                    Stack.Right += W + 2
                end
                if Transform then
                    X += O[Keys.X] or 0
                end
            else
                W, H = (MaxX - MinX) + BoxPad * 2, Thickness
                X = MinX - BoxPad
                if Side == "Bottom" then
                    Y = MaxY + BoxPad + 2 + Stack.Bottom
                    Stack.Bottom += H + 2
                else
                    Y = MinY - BoxPad - 2 - H - Stack.Top
                    Stack.Top += H + 2
                end
                if Transform then
                    Y += O[Keys.Y] or 0
                end
            end

            local Back, Fill = Bar.Back, Bar.Fill
            if Bar.Vertical ~= Vertical then
                Bar.Vertical = Vertical
                Fill.AnchorPoint = Vertical and Vector2New(0, 1) or Vector2New(0, 0)
                Fill.Position = Vertical and UDim2New(0, 1, 1, -1) or UDim2New(0, 1, 0, 1)
            end

            Show(Back)

            local Extra = O[Keys.Extra]
            local BackColor = Extra and O[Keys.Back] or EspBlack
            local BackAlpha = Extra and Alpha(O, Keys.BackAlpha) or 0
            if Bar.BackColor ~= BackColor or Bar.BackAlpha ~= BackAlpha then
                Bar.BackColor, Bar.BackAlpha = BackColor, BackAlpha
                Back.BackgroundColor3 = BackColor
                Back.BackgroundTransparency = BackAlpha
            end

            local FillAlpha = BarAlpha(O, Key, Fraction)
            if Bar.FillAlpha ~= FillAlpha then
                Bar.FillAlpha = FillAlpha
                Fill.BackgroundTransparency = FillAlpha
            end

            local BX, BY, BW, BH = X, Y, W, H
            if Extra and O[Keys.Dynamic] then
                if Vertical then
                    local Filled = MathFloor((H - 2) * Fraction + 0.5)
                    BY, BH = Y + (H - 2) - Filled, Filled + 2
                else
                    BW = MathFloor((W - 2) * Fraction + 0.5) + 2
                end
                Fill.Size = UDim2New(1, -2, 1, -2)
            elseif Vertical then
                Fill.Size = UDim2New(1, -2, Fraction, -2 * Fraction)
            else
                Fill.Size = UDim2New(Fraction, -2 * Fraction, 1, -2)
            end

            Back.Position = UDim2New(0, BX, 0, BY)
            Back.Size = UDim2New(0, BW, 0, BH)
            SetGlow(Bar.Glow, O[Keys.Glow], BX, BY, BW, BH, O[Keys.GlowColor], (O[Keys.GlowIntensity] or 0.5) * (1 - Alpha(O, Keys.GlowAlpha)))

            local Color = EspThreeStop(Fraction, O[Keys.Low], O[Keys.Mid], O[Keys.High])
            SetGradient(Bar.Gradient, Color, EspShade(Color, Bar.Shade))

            return X, Y, W, H, Side
        end

        local TagAnchors = {
            Left = { Vector2New(1, 0.5), Enum.TextXAlignment.Right },
            Right = { Vector2New(0, 0.5), Enum.TextXAlignment.Left },
            Top = { Vector2New(0.5, 0.5), Enum.TextXAlignment.Center },
            Bottom = { Vector2New(0.5, 0.5), Enum.TextXAlignment.Center }
        }

        local function PlaceBarTag(Tag, Side, X, Y, W, H, Fraction, Stack)
            local Label = Tag.Label
            if Tag.Side ~= Side then
                Tag.Side = Side
                Label.AnchorPoint = TagAnchors[Side][1]
                Label.TextXAlignment = TagAnchors[Side][2]
            end

            if Side == "Left" then
                Label.Position = UDim2New(0, X - 2, 0, Y + 1 + MathFloor((H - 2) * (1 - Fraction)))
            elseif Side == "Right" then
                Label.Position = UDim2New(0, X + W + 2, 0, Y + 1 + MathFloor((H - 2) * (1 - Fraction)))
                Stack.Right += Label.TextBounds.X + 4
            else
                Label.Position = UDim2New(0, X + 1 + MathFloor((W - 2) * Fraction), 0, Y + MathFloor(H / 2))
                local Overhang = math.max(math.ceil((Label.TextSize + 2 - H) / 2), 0)
                if Side == "Bottom" then
                    Stack.Bottom += Overhang
                else
                    Stack.Top += Overhang
                end
            end
        end

        local function Off(Object)
            if Object.Visible then
                Object.Visible = false
            end
        end

        function Drawing:Hide()
            if self.Hidden then
                return
            end
            self.Hidden = true
            self.ArrowFade = 0
            self.ArrowCache = nil

            for Object in Seen do
                Off(Object)
            end
        end

        local function Sweep()
            for Object, Last in Seen do
                if Last ~= Stamp and Object.Visible then
                    Object.Visible = false
                end
            end
        end
        function Drawing:Destroy()
            Container:Destroy()
        end

        function Drawing:Render(O, D)
            Stamp += 1
            self.Hidden = false

            local MinX, MinY, MaxX, MaxY = D.MinX - 2, D.MinY - 2, D.MaxX + 2, D.MaxY + 2
            local BoxWidth, BoxHeight = MaxX - MinX, MaxY - MinY
            local CenterX = MathFloor((MinX + MaxX) / 2)
            local BoxThickness = O.BoxTransform and MathClamp(MathFloor(O.BoxThickness), 1, 5) or 1
            local BoxPad = BoxThickness + 1

            if O.Box then
                local Box = Items.Box
                Show(Box)
                Box.Position = UDim2New(0, MinX, 0, MinY)
                Box.Size = UDim2New(0, BoxWidth, 0, BoxHeight)
                SetGradient(Items.BoxGradient, O.BoxColor, O.BoxColor2)
                local Rotation = O.BoxAnimated and os.clock() * (O.BoxAnimatedSpeed or 120) % 360 or 0
                if Items.BoxGradient.Rotation ~= Rotation then
                    Items.BoxGradient.Rotation = Rotation
                end
                local BoxAlpha = Alpha(O, "BoxColorAlpha")
                if Items.LastThickness ~= BoxThickness then
                    Items.LastThickness = BoxThickness
                    Items.BoxStroke.Thickness = BoxThickness
                    Items.BoxOuterRing.Position = UDim2New(0, -BoxThickness, 0, -BoxThickness)
                    Items.BoxOuterRing.Size = UDim2New(1, BoxThickness * 2, 1, BoxThickness * 2)
                end

                if Items.LastBoxAlpha ~= BoxAlpha then
                    Items.LastBoxAlpha = BoxAlpha
                    Items.BoxStroke.Transparency = BoxAlpha
                    Items.BoxOuterStroke.Transparency = BoxAlpha
                    Items.BoxInnerStroke.Transparency = BoxAlpha
                end

                local Fill = Items.BoxFill
                if O.BoxFill then
                    Show(Fill)
                    Fill.Position = UDim2New(0, MinX + 1, 0, MinY + 1)
                    Fill.Size = UDim2New(0, math.max(BoxWidth - 2, 0), 0, math.max(BoxHeight - 2, 0))

                    local FillAlpha = 1 - MathClamp(O.BoxFillOpacity, 0, 1) * (1 - Alpha(O, "BoxFillColorAlpha"))
                    if Items.LastFillColor ~= O.BoxFillColor or Items.LastFillAlpha ~= FillAlpha then
                        Items.LastFillColor, Items.LastFillAlpha = O.BoxFillColor, FillAlpha
                        Fill.BackgroundColor3 = O.BoxFillColor
                        Fill.BackgroundTransparency = FillAlpha
                    end
                end

                SetGlow(Items.BoxGlow, O.BoxGlow, MinX - BoxPad, MinY - BoxPad, BoxWidth + BoxPad * 2, BoxHeight + BoxPad * 2, O.BoxGlowColor, O.BoxGlowIntensity * (1 - Alpha(O, "BoxGlowColorAlpha")))
            end

            if O.Skeleton and D.Bones then
                local Thickness = MathClamp(MathFloor(O.SkeletonThickness or 1), 1, 5)
                local BoneAlpha = Alpha(O, "SkeletonColorAlpha")
                PixelCount, OutlineCount = 0, 0

                local Bones = D.Bones
                for Index = 1, Bones.Count or #Bones do
                    local Pair = Bones[Index]
                    DrawLine(Pair[1], Pair[2], Thickness, O.SkeletonColor, O.SkeletonOutline, BoneAlpha)
                end

                if O.SkeletonHead and D.Head then
                    local Head = D.Head
                    local Diameter = MathFloor(Head.R * 2)

                    Show(Items.Head.Frame)
                    Items.Head.Frame.Position = UDim2New(0, Head.X, 0, Head.Y)
                    Items.Head.Frame.Size = UDim2New(0, Diameter, 0, Diameter)
                    Items.Head.Stroke.Color = O.SkeletonColor
                    Items.Head.Stroke.Thickness = Thickness
                    Items.Head.Stroke.Transparency = BoneAlpha
                    Items.HeadOutline.Stroke.Transparency = BoneAlpha

                    if O.SkeletonOutline then
                        Show(Items.HeadOutline.Frame)
                    end
                    Items.HeadOutline.Frame.Position = UDim2New(0, Head.X, 0, Head.Y)
                    Items.HeadOutline.Frame.Size = UDim2New(0, math.max(Diameter - 2, 0), 0, math.max(Diameter - 2, 0))
                    Items.HeadOutline.Stroke.Thickness = Thickness + 2

                    if D.Neck then
                        local Center = Vector2New(Head.X, Head.Y)
                        local Delta = Center - D.Neck
                        local Reach = Delta.Magnitude
                        local Edge = Reach > Head.R + 0.5 and Center - Delta.Unit * Head.R or Center
                        DrawLine(D.Neck, Edge, Thickness, O.SkeletonColor, O.SkeletonOutline, BoneAlpha)
                    end
                end
            end

            local Stack = Items.Stack
            Stack.Left, Stack.Right, Stack.Top, Stack.Bottom = 0, 0, 0, 0

            if O.Health and D.Health then
                local Fraction = MathClamp(D.Health, 0, 1)
                local X, Y, W, H, Side = DrawBar(O, "Health", Items.HealthBar, Fraction, MinX, MinY, MaxX, MaxY, BoxPad, Stack)

                if O.HealthFlag then
                    local Tag = Items.HealthTag
                    StyleText(Tag, O.HealthFlagColor, O.HealthFlagColor2, O.HealthFlagFont, O.HealthFlagTransform, O.HealthFlagSize, Alpha(O, "HealthFlagColorAlpha"))
                    Show(Tag.Label)
                    SetNumbers(Tag, "%d/%d", MathFloor(Fraction * D.MaxHealth + 0.5), D.MaxHealth)
                    PlaceBarTag(Tag, Side, X, Y, W, H, Fraction, Stack)
                end
            end

            if O.Ammo and D.Ammo then
                local Fraction = MathClamp(D.Infinite and 1 or D.Ammo, 0, 1)
                local X, Y, W, H, Side = DrawBar(O, "Ammo", Items.AmmoBar, Fraction, MinX, MinY, MaxX, MaxY, BoxPad, Stack)

                if O.AmmoFlag then
                    local Tag = Items.AmmoTag
                    StyleText(Tag, O.AmmoFlagColor, O.AmmoFlagColor2, O.AmmoFlagFont, O.AmmoFlagTransform, O.AmmoFlagSize, Alpha(O, "AmmoFlagColorAlpha"))
                    Show(Tag.Label)
                    if D.Reloading then
                        SetLabel(Tag, ReloadingText())
                    elseif D.Infinite then
                        SetLabel(Tag, "infinite")
                    else
                        SetNumbers(Tag, "%d/%d", D.AmmoCount or 0, D.MaxAmmo or 0)
                    end
                    PlaceBarTag(Tag, Side, X, Y, W, H, Fraction, Stack)
                end
            end

            if O.Name then
                local Tag = Items.NameTag
                StyleText(Tag, O.NameColor, O.NameColor2, O.NameFont, O.NameTransform, O.NameSize, Alpha(O, "NameColorAlpha"))
                Show(Tag.Label)
                SetLabel(Tag, D.Name or "player")
                Tag.Label.Position = UDim2New(0, CenterX, 0, MinY - BoxPad - 2 - Stack.Top + (O.NameOffset and O.NameY or 0))
            end

            local TextGap = Stack.Bottom > 0 and -1 or 2

            if O.Distance and D.Distance then
                local Tag = Items.DistanceTag
                StyleText(Tag, O.DistanceColor, O.DistanceColor2, O.DistanceFont, O.DistanceTransform, O.DistanceSize, Alpha(O, "DistanceColorAlpha"))
                Show(Tag.Label)
                SetNumbers(Tag, "%d st", MathFloor(D.Distance + 0.5))
                Tag.Label.Position = UDim2New(0, CenterX, 0, MaxY + BoxPad + TextGap + Stack.Bottom + (O.DistanceOffset and O.DistanceY or 0))
                Stack.Bottom += Tag.Label.TextSize + 1
            end

            if O.Weapon and D.Weapon then
                local Tag = Items.WeaponTag
                StyleText(Tag, O.WeaponColor, O.WeaponColor2, O.WeaponFont, O.WeaponTransform, O.WeaponSize, Alpha(O, "WeaponColorAlpha"))
                Show(Tag.Label)
                SetLabel(Tag, D.Weapon)
                Tag.Label.Position = UDim2New(0, CenterX, 0, MaxY + BoxPad + TextGap + Stack.Bottom + (O.WeaponOffset and O.WeaponY or 0))
            end
            if O.Flags and D.Values then
                local Line = 0

                for _, FlagName in Library.EspFlagNames do
                    local Text = Items.FlagTags[FlagName]
                    local Value = D.Values[FlagName]

                    if Value and TableFind(O.FlagsList, FlagName) then
                        local Colors = O.FlagColors[FlagName] or { EspWhite, EspWhite }
                        StyleText(Text, Colors[1], Colors[2], O.FlagsFont, O.FlagsTransform, O.FlagsSize, Colors[3])
                        Show(Text.Label)
                        SetLabel(Text, Value)
                        Text.Label.Position = UDim2New(0, MaxX + BoxPad + 2 + Stack.Right, 0, MinY - BoxPad + Line * (Text.Label.TextSize + 1))
                        Line += 1
                    end
                end
            end

            Sweep()
        end

        local ArrowCount, ArrowOutlineCount = 0, 0

        local function EdgeX(PX, PY, QX, QY, Sample)
            if (PY <= Sample and QY > Sample) or (QY <= Sample and PY > Sample) then
                return PX + (Sample - PY) * (QX - PX) / (QY - PY)
            end
        end

        local function PushRun(X, Y, Width, Height, Color, RunAlpha)
            ArrowCount += 1
            PlacePixel(GetPixel(Items.ArrowPixels, ArrowCount, Z.Esp, Color), X, Y, Width, Height, Color, RunAlpha)
            ArrowOutlineCount += 1
            PlacePixel(GetPixel(Items.ArrowOutlines, ArrowOutlineCount, Z.Glow, EspBlack), X - 1, Y - 1, Width + 2, Height + 2, EspBlack, RunAlpha)
        end

        local function FillTriangle(AX, AY, BX, BY, CX, CY, Color, RunAlpha)
            local Top = MathFloor(math.min(AY, BY, CY))
            local Bottom = math.ceil(math.max(AY, BY, CY)) - 1
            local RunX, RunY, RunWidth, RunHeight

            for Y = Top, Bottom do
                local Sample = Y + 0.5
                local Left, Right = math.huge, -math.huge

                local X1, X2, X3 = EdgeX(AX, AY, BX, BY, Sample), EdgeX(BX, BY, CX, CY, Sample), EdgeX(CX, CY, AX, AY, Sample)
                if X1 then Left, Right = math.min(Left, X1), math.max(Right, X1) end
                if X2 then Left, Right = math.min(Left, X2), math.max(Right, X2) end
                if X3 then Left, Right = math.min(Left, X3), math.max(Right, X3) end

                if Left <= Right then
                    local X = MathFloor(Left + 0.5)
                    local Width = math.max(MathFloor(Right + 0.5) - X, 1)

                    if RunX == X and RunWidth == Width then
                        RunHeight += 1
                    else
                        if RunX then
                            PushRun(RunX, RunY, RunWidth, RunHeight, Color, RunAlpha)
                        end
                        RunX, RunY, RunWidth, RunHeight = X, Y, Width, 1
                    end
                end
            end

            if RunX then
                PushRun(RunX, RunY, RunWidth, RunHeight, Color, RunAlpha)
            end
        end

        function Drawing:RenderArrow(O, A, Fade, Append)
            if not Append then
                Stamp += 1
            end
            self.Hidden = false
            ArrowCount, ArrowOutlineCount = 0, 0

            Fade = MathClamp(Fade or self.ArrowFade or 1, 0, 1)
            local LabelFade = 1 - Fade

            local Radius, Length, HalfWidth = O.ArrowsRadius or 140, O.ArrowsLength or 16, (O.ArrowsWidth or 14) / 2
            local DX, DY = A.DX, A.DY
            local BaseX, BaseY = A.CX + DX * Radius, A.CY + DY * Radius
            local TipX, TipY = BaseX + DX * Length, BaseY + DY * Length
            local PX, PY = -DY * HalfWidth, DX * HalfWidth

            local Pulse = (math.sin(os.clock() * 4) + 1) / 2
            local NameColor = O.NameColor or O.ArrowsColor or EspWhite
            local NameColor2 = O.NameColor2 or EspWhite
            local Solid = O.ArrowsColor or NameColor
            local Throb = O.ArrowsThrobColor or NameColor2
            local Color = Solid:Lerp(Throb, Pulse * 0.85)
            local ArrowAlpha = 1 - (1 - (O.ArrowsColorAlpha or 0)) * Fade

            local WingLX, WingLY = BaseX + PX, BaseY + PY
            local WingRX, WingRY = BaseX - PX, BaseY - PY
            local Bow = 0.38
            local Lcx, Lcy = (TipX + WingLX) * 0.5 + PX * Bow, (TipY + WingLY) * 0.5 + PY * Bow
            local Rcx, Rcy = (TipX + WingRX) * 0.5 - PX * Bow, (TipY + WingRY) * 0.5 - PY * Bow
            local BackX, BackY = BaseX - DX * Length * 0.28, BaseY - DY * Length * 0.28

            local function Bez(T, Ax, Ay, Cx, Cy, Bx, By)
                local U = 1 - T
                return U * U * Ax + 2 * U * T * Cx + T * T * Bx, U * U * Ay + 2 * U * T * Cy + T * T * By
            end

            local Steps = 4
            local Points = { }
            for Index = 0, Steps do
                local X, Y = Bez(Index / Steps, TipX, TipY, Lcx, Lcy, WingLX, WingLY)
                Points[#Points + 1] = { X, Y }
            end
            for Index = 1, Steps do
                local X, Y = Bez(Index / Steps, WingLX, WingLY, BackX, BackY, WingRX, WingRY)
                Points[#Points + 1] = { X, Y }
            end
            for Index = Steps - 1, 1, -1 do
                local X, Y = Bez(Index / Steps, TipX, TipY, Rcx, Rcy, WingRX, WingRY)
                Points[#Points + 1] = { X, Y }
            end

            local MidX, MidY = (TipX + BackX) * 0.5, (TipY + BackY) * 0.5
            for Index = 1, #Points do
                local A0 = Points[Index]
                local B0 = Points[Index % #Points + 1]
                FillTriangle(MidX, MidY, A0[1], A0[2], B0[1], B0[2], Color, ArrowAlpha)
            end

            local MinX = MathFloor(math.min(TipX, BaseX + PX, BaseX - PX))
            local MaxX = math.ceil(math.max(TipX, BaseX + PX, BaseX - PX))
            local MinY = MathFloor(math.min(TipY, BaseY + PY, BaseY - PY))
            local MaxY = math.ceil(math.max(TipY, BaseY + PY, BaseY - PY))
            local CenterX = MathFloor((TipX + BaseX) / 2 + 0.5)

            if O.ArrowsBox then
                local Pad = 4
                local BoxX, BoxY = MinX - Pad, MinY - Pad
                local BoxW = math.max(MaxX - MinX + Pad * 2, 8)
                local BoxH = math.max(MaxY - MinY + Pad * 2, 8)
                local Thickness = 1
                PushRun(BoxX, BoxY, BoxW, Thickness, Color, ArrowAlpha)
                PushRun(BoxX, BoxY + BoxH - Thickness, BoxW, Thickness, Color, ArrowAlpha)
                PushRun(BoxX, BoxY, Thickness, BoxH, Color, ArrowAlpha)
                PushRun(BoxX + BoxW - Thickness, BoxY, Thickness, BoxH, Color, ArrowAlpha)
            end

            if O.ArrowsExtra then
                if O.ArrowsHealth and A.Health then
                    local Fraction = MathClamp(A.Health, 0, 1)
                    local Back = Items.ArrowBack
                    local Height = math.max(MaxY - MinY, 8)
                    Show(Back)
                    Back.Position = UDim2New(0, MinX - 7, 0, MinY)
                    Back.Size = UDim2New(0, 4, 0, Height)
                    Items.ArrowFill.Size = UDim2New(1, -2, Fraction, -2 * Fraction)
                    SetArrowBarAlpha(Back, Items.ArrowFill, Fade)

                    local HealthColor = EspThreeStop(Fraction, O.HealthLow, O.HealthMid, O.HealthHigh)
                    SetGradient(Items.ArrowGradient, HealthColor, EspShade(HealthColor, 0.45))
                end

                if O.ArrowsName and A.Name then
                    local Tag = Items.ArrowTexts.Name
                    StyleText(Tag, NameColor, NameColor2, O.NameFont or O.ArrowsFont, O.NameTransform or O.ArrowsTransform, O.NameSize or O.ArrowsSize, LabelFade)
                    Show(Tag.Label)
                    SetLabel(Tag, A.Name)
                    Tag.Label.Position = UDim2New(0, CenterX, 0, MinY - 3)
                end

                local Y = MaxY + 2

                if O.ArrowsAmmo and A.Ammo then
                    local Fraction = MathClamp(A.Ammo, 0, 1)
                    local Back = Items.ArrowAmmoBack
                    Show(Back)
                    Back.Position = UDim2New(0, CenterX - 14, 0, Y)
                    Back.Size = UDim2New(0, 28, 0, 4)
                    Items.ArrowAmmoFill.Size = UDim2New(Fraction, -2 * Fraction, 1, -2)
                    SetArrowBarAlpha(Back, Items.ArrowAmmoFill, Fade)

                    local AmmoColor = EspThreeStop(Fraction, O.AmmoLow, O.AmmoMid, O.AmmoHigh)
                    SetGradient(Items.ArrowAmmoGradient, AmmoColor, EspShade(AmmoColor, 0.55))
                    Y += 7
                else
                    Y += 2
                end

                if O.ArrowsDistance and A.Distance then
                    local Tag = Items.ArrowTexts.Distance
                    StyleText(Tag, O.DistanceColor or NameColor, O.DistanceColor2 or NameColor2, O.DistanceFont or O.ArrowsFont, O.DistanceTransform or O.ArrowsTransform, O.DistanceSize or O.ArrowsSize, LabelFade)
                    Show(Tag.Label)
                    SetNumbers(Tag, "%d st", MathFloor(A.Distance + 0.5))
                    Tag.Label.Position = UDim2New(0, CenterX, 0, Y)
                    Y += Tag.Label.TextSize + 1
                end

                if O.ArrowsWeapon and A.Weapon then
                    local Tag = Items.ArrowTexts.Weapon
                    StyleText(Tag, O.WeaponColor or NameColor, O.WeaponColor2 or NameColor2, O.WeaponFont or O.ArrowsFont, O.WeaponTransform or O.ArrowsTransform, O.WeaponSize or O.ArrowsSize, LabelFade)
                    Show(Tag.Label)
                    SetLabel(Tag, A.Weapon)
                    Tag.Label.Position = UDim2New(0, CenterX, 0, Y)
                end
            end

            Sweep()
        end

        return Drawing

    end

    local BoundParts = {
        "Head", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot",
        "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"
    }

    local function CharacterParts(Model)
        local Parts = { }

        for _, Name in BoundParts do
            local Part = Model:FindFirstChild(Name)
            if Part and Part:IsA("BasePart") then
                TableInsert(Parts, Part)
            end
        end

        if #Parts >= 3 then
            return Parts
        end

        Parts = { }
        for _, Part in Model:GetChildren() do
            if Part:IsA("BasePart") and Part.Name ~= "HumanoidRootPart" and string.sub(Part.Name, 1, 6) ~= "Hitbox" and Part.Transparency < 1 then
                TableInsert(Parts, Part)
                if #Parts >= 16 then
                    break
                end
            end
        end

        return Parts
    end

    local R15Joints = {
        Neck = true, Waist = true,
        LeftShoulder = true, LeftElbow = true, LeftWrist = true,
        RightShoulder = true, RightElbow = true, RightWrist = true,
        LeftHip = true, LeftKnee = true, LeftAnkle = true,
        RightHip = true, RightKnee = true, RightAnkle = true
    }

    local R15Bones = {
        { "LeftShoulder", "LeftElbow", "LeftHand" },
        { "RightShoulder", "RightElbow", "RightHand" },
        { "LeftHip", "LeftKnee", "LeftFoot" },
        { "RightHip", "RightKnee", "RightFoot" }
    }

    local R6Bones = {
        { "LeftShoulder", "LeftArm" },
        { "RightShoulder", "RightArm" },
        { "LeftHip", "LeftLeg" },
        { "RightHip", "RightLeg" }
    }

    local LimbEnd = CFrame.new(0, -0.9, 0)

    local function BuildRig(Model)
        local Rig = { Points = { }, Bones = nil, Head = Model:FindFirstChild("Head") }
        local Points = Rig.Points

        if Model:FindFirstChild("UpperTorso") then
            Rig.Bones = R15Bones

            for _, Part in Model:GetChildren() do
                if Part:IsA("BasePart") then
                    for _, Joint in Part:GetChildren() do
                        if R15Joints[Joint.Name] and not Points[Joint.Name] then
                            if Joint:IsA("Motor6D") then
                                Points[Joint.Name] = { Joint = Joint }
                            elseif Joint:IsA("AnimationConstraint") then
                                local Attachment = Joint.Attachment0 or Joint.Attachment1
                                if Attachment then
                                    Points[Joint.Name] = { Attachment = Attachment }
                                end
                            end
                        end
                    end
                end
            end

            for _, Name in { "LeftHand", "RightHand", "LeftFoot", "RightFoot" } do
                local Part = Model:FindFirstChild(Name)
                if Part then
                    Points[Name] = { Part = Part }
                end
            end
        elseif Model:FindFirstChild("Torso") then
            local Torso = Model.Torso
            Rig.Bones = R6Bones

            Points.Neck = { Joint = Torso:FindFirstChild("Neck") }
            Points.Pelvis = { Base = Torso, Offset = CFrame.new(0, -1, 0) }
            Points.LeftShoulder = { Joint = Torso:FindFirstChild("Left Shoulder") }
            Points.RightShoulder = { Joint = Torso:FindFirstChild("Right Shoulder") }
            Points.LeftHip = { Joint = Torso:FindFirstChild("Left Hip") }
            Points.RightHip = { Joint = Torso:FindFirstChild("Right Hip") }
            Points.LeftArm = { Base = Model:FindFirstChild("Left Arm"), Offset = LimbEnd }
            Points.RightArm = { Base = Model:FindFirstChild("Right Arm"), Offset = LimbEnd }
            Points.LeftLeg = { Base = Model:FindFirstChild("Left Leg"), Offset = LimbEnd }
            Points.RightLeg = { Base = Model:FindFirstChild("Right Leg"), Offset = LimbEnd }
        end

        return Rig
    end

    local function RigPoint(Point)
        if not Point then
            return nil
        end

        local Joint = Point.Joint
        if Joint then
            return Joint.Part0 and (Joint.Part0.CFrame * Joint.C0).Position
        end

        if Point.Attachment then
            return Point.Attachment.WorldPosition
        end

        if Point.Part then
            return Point.Part.Position
        end

        if Point.Base then
            return (Point.Base.CFrame * Point.Offset).Position
        end
    end
    local Corners = {
        Vector3.new(-1, -1, -1), Vector3.new(-1, -1, 1), Vector3.new(-1, 1, -1), Vector3.new(-1, 1, 1),
        Vector3.new(1, -1, -1), Vector3.new(1, -1, 1), Vector3.new(1, 1, -1), Vector3.new(1, 1, 1)
    }

    local function ProjectBounds(Parts, Project, Scale)
        local MinX, MinY, MaxX, MaxY = math.huge, math.huge, -math.huge, -math.huge

        for _, Part in Parts do
            local Screen, Depth = Project(Part.Position)
            if Screen then
                local Size = Part.Size
                local Pixels = Scale / Depth
                local HalfX = math.max(Size.X, Size.Z) * 0.5 * Pixels
                local HalfY = Size.Y * 0.5 * Pixels
                local X, Y = Screen.X, Screen.Y

                if X - HalfX < MinX then MinX = X - HalfX end
                if Y - HalfY < MinY then MinY = Y - HalfY end
                if X + HalfX > MaxX then MaxX = X + HalfX end
                if Y + HalfY > MaxY then MaxY = Y + HalfY end
            end
        end

        if MinX == math.huge then
            return nil
        end

        return MathFloor(MinX), MathFloor(MinY), MathFloor(MaxX), MathFloor(MaxY)
    end

    local SkeletonRig, SkeletonProject, SkeletonScreen

    local function ScreenPoint(Name)
        local Cached = SkeletonScreen[Name]
        if Cached == nil then
            local World = RigPoint(SkeletonRig.Points[Name])
            Cached = World and SkeletonProject(World) or false
            SkeletonScreen[Name] = Cached
        end
        return Cached or nil
    end

    local function PushBone(Bones, A, B)
        local Count = Bones.Count + 1
        Bones.Count = Count

        local Pair = Bones[Count]
        if not Pair then
            Pair = { }
            Bones[Count] = Pair
        end
        Pair[1], Pair[2] = A, B
    end

    local function SkeletonBar(Bones, LeftName, RightName)
        local LeftWorld, RightWorld = RigPoint(SkeletonRig.Points[LeftName]), RigPoint(SkeletonRig.Points[RightName])
        if not (LeftWorld and RightWorld) then
            return nil
        end

        local Left, Right = SkeletonProject(LeftWorld), SkeletonProject(RightWorld)
        if not (Left and Right) then
            return nil
        end

        SkeletonScreen[LeftName], SkeletonScreen[RightName] = Left, Right
        PushBone(Bones, Left, Right)
        return (SkeletonProject((LeftWorld + RightWorld) / 2))
    end

    local function SkeletonData(Rig, Project, RightVector, Buffer, Options)
        Buffer = Buffer or { Bones = { Count = 0 }, Screen = { }, Head = { } }
        Options = Options or { }

        local Bones = Buffer.Bones
        Bones.Count = 0
        table.clear(Buffer.Screen)
        SkeletonRig, SkeletonProject, SkeletonScreen = Rig, Project, Buffer.Screen

        local Chains = Rig.Bones
        if not Chains then
            return Bones, nil, nil
        end

        local Collar = SkeletonBar(Bones, Chains[1][1], Chains[2][1])
        local Pelvis = SkeletonBar(Bones, Chains[3][1], Chains[4][1])

        if Collar and Pelvis then
            local Waist = Options.SkeletonSpine and ScreenPoint("Waist")
            if Waist then
                PushBone(Bones, Collar, Waist)
                PushBone(Bones, Waist, Pelvis)
            else
                PushBone(Bones, Collar, Pelvis)
            end
        end

        if Options.SkeletonSpine and Collar and not Options.SkeletonHead then
            local Neck = ScreenPoint("Neck")
            if Neck then
                PushBone(Bones, Collar, Neck)
            end
        end

        if Options.SkeletonTorso then
            for Side = 1, 2 do
                local Shoulder, Hip = ScreenPoint(Chains[Side][1]), ScreenPoint(Chains[Side + 2][1])
                if Shoulder and Hip then
                    PushBone(Bones, Shoulder, Hip)
                end
            end
        end

        for _, Chain in Chains do
            for Index = 1, #Chain - 1 do
                local A, B = ScreenPoint(Chain[Index]), ScreenPoint(Chain[Index + 1])
                if A and B then
                    PushBone(Bones, A, B)
                end
            end
        end

        local Head
        local HeadPart = Rig.Head

        if HeadPart and HeadPart.Parent then
            local Center = Project(HeadPart.Position)
            local Edge = Project(HeadPart.Position + RightVector * (HeadPart.Size.X * 0.5))
            if Center and Edge then
                Head = Buffer.Head
                Head.X, Head.Y, Head.R = Center.X, Center.Y, math.max((Edge - Center).Magnitude * 0.6, 2)
            end
        end

        return Bones, Head, Collar
    end
    Library.Pages.ModelPreview = function(self, Data)
        Data = Data or { }


        local Preview = {
            Name = Data.Name or Data.name or "Preview",
            Side = Data.Side or Data.side or 2,
            Speed = Data.Speed or Data.speed or 35,
            Height = Data.Height or Data.height,
            Spin = Data.Spin == true,
            Animate = false,
            Clothing = false,
            Zoom = 1,
            Material = "Default",
            Tint = nil,
            Accessories = false,
            Angle = 0,
            Model = nil,
            Class = "ModelPreview"
        }

        Preview.Overlay = Library:DefaultEspSettings(EspWhite)
        Preview.FlagNames = Library.EspFlagNames

        Preview.PostFX = {
            Enabled = false,
            Vignette = false, VignetteIntensity = 0.5,
            Grade = EspWhite
        }

        local Simulated = {
            Health = 1, ShownHealth = 1, MaxHealth = 100,
            Ammo = 12, MaxAmmo = 12, ShownAmmo = 1,
            NextShot = 0, Reloading = false, ReloadEnd = 0,
            Distance = 25, ShownDistance = 25,
            Speed = 16, Armor = 50
        }

        local Column = self.ColumnsData[Preview.Side].Instance

        local Z = { Back = 1, View = 3, Vignette = 4, Esp = 5, Button = 8 }

        local Items = { } do
            Items["Section"] = Instances:Create("Frame", {
                Parent = Column,
                Name = "\0",
                Size = UDim2New(1, 0, 0, Preview.Height or 200),
                BorderColor3 = FromRGB(34, 34, 34),
                BorderSizePixel = 1,
                BackgroundColor3 = Library.Theme["Page Background"]
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Outline"})

            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(8, 8, 8),
                Name = "\0",
                Thickness = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 6),
                PaddingTop = UDimNew(0, 8)
            })

            Library:AddTopHighlight(Items["Section"].Instance, 8)

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Preview.Name,
                Name = "\0",
                ZIndex = 5,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 16),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 8, 0, -8),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = EspWhite
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Back"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                Position = UDim2New(0, 6, 0, 4),
                Size = UDim2New(1, -12, 1, -4),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = Z.Back,
                BackgroundColor3 = Library.Theme.Inline
            })  Items["Back"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UIStroke", {
                Parent = Items["Back"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = Library.Theme.Border
            }):AddToTheme({Color = "Border"})

            Items["View"] = Instances:Create("ViewportFrame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                Position = UDim2New(0, 6, 0, 4),
                Size = UDim2New(1, -12, 1, -4),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                ZIndex = Z.View,
                Ambient = FromRGB(170, 170, 170),
                LightColor = EspWhite,
                LightDirection = Vector3.new(-1, -1, -1),
                BackgroundColor3 = FromRGB(0, 0, 0)
            })

            Items["Camera"] = InstanceNew("Camera")
            Items["Camera"].FieldOfView = 40
            Items["Camera"].Parent = Items["View"].Instance
            Items["View"].Instance.CurrentCamera = Items["Camera"]

            Items["Overlay"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                Position = UDim2New(0, 6, 0, 4),
                Size = UDim2New(1, -12, 1, -4),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                ZIndex = Z.Vignette,
                BackgroundColor3 = EspWhite
            })

            Items["Vignette"] = { }
            for Index, Edge in { { 0, 90 }, { 1, 270 }, { 2, 0 }, { 3, 180 } } do
                local Frame = InstanceNew("Frame")
                Frame.Name = "\0"
                Frame.BorderSizePixel = 0
                Frame.BackgroundColor3 = FromRGB(0, 0, 0)
                Frame.ZIndex = Z.Vignette
                Frame.Visible = false

                if Edge[1] == 0 then
                    Frame.Size = UDim2New(1, 0, 0.3, 0)
                elseif Edge[1] == 1 then
                    Frame.AnchorPoint = Vector2New(0, 1)
                    Frame.Position = UDim2New(0, 0, 1, 0)
                    Frame.Size = UDim2New(1, 0, 0.3, 0)
                elseif Edge[1] == 2 then
                    Frame.Size = UDim2New(0.35, 0, 1, 0)
                else
                    Frame.AnchorPoint = Vector2New(1, 0)
                    Frame.Position = UDim2New(1, 0, 0, 0)
                    Frame.Size = UDim2New(0.35, 0, 1, 0)
                end

                local Gradient = InstanceNew("UIGradient")
                Gradient.Rotation = Edge[2]
                Gradient.Parent = Frame

                Frame.Parent = Items["Overlay"].Instance
                Items["Vignette"][Index] = { Frame = Frame, Gradient = Gradient }
            end

            Items["Drawing"] = CreateEspDrawing(Items["Overlay"].Instance, Z.Esp)

            Items["Status"] = PopupLabel(Items["Overlay"].Instance, "waiting for character", UDim2New(0, 0, 0.5, -7), UDim2New(1, 0, 0, 14), Enum.TextXAlignment.Center, "Inactive Text")
            Items["Status"].Instance.ZIndex = Z.Esp

            Items["Dots"] = Instances:Create("TextButton", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, -10, 0, 8),
                Size = UDim2New(0, 16, 0, 12),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Text = "",
                ZIndex = Z.Button,
                BackgroundColor3 = EspWhite
            })

            Items["DotFrames"] = { }
            for Index = 1, 3 do
                local Dot = Instances:Create("Frame", {
                    Parent = Items["Dots"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, (Index - 2) * 5, 0.5, 0),
                    Size = UDim2New(0, 2, 0, 2),
                    BorderSizePixel = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 0.4,
                    ZIndex = Z.Button,
                    BackgroundColor3 = Library.Theme.Text
                })  Dot:AddToTheme({BackgroundColor3 = "Text"})

                Items["DotFrames"][Index] = Dot
            end

            Items["Dots"]:OnHover(function()
                for _, Dot in Items["DotFrames"] do
                    Dot:Tween(nil, {BackgroundTransparency = 0})
                end
            end)

            Items["Dots"]:OnHoverLeave(function()
                for _, Dot in Items["DotFrames"] do
                    Dot:Tween(nil, {BackgroundTransparency = 0.4})
                end
            end)
        end

        local CenterOffset = Vector3.new()
        local OriginalLooks = { }
        local Clothing = { }
        local Parts, Rig = { }, { Points = { } }

        local function FitCamera()
            if not Preview.Model then
                return
            end

            Preview.Model:PivotTo(CFrame.new())

            local BoxCFrame, BoxSize = Preview.Model:GetBoundingBox()
            if #Parts > 0 then
                local Low, High = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
                for _, Part in Parts do
                    for _, Corner in Corners do
                        local Point = Part.CFrame:PointToWorldSpace(Part.Size / 2 * Corner)
                        Low = Low:Min(Point)
                        High = High:Max(Point)
                    end
                end
                BoxCFrame, BoxSize = CFrame.new((Low + High) / 2), High - Low
            end

            CenterOffset = BoxCFrame.Position

            local View = Items["View"].Instance
            local Aspect = math.max(View.AbsoluteSize.X, 1) / math.max(View.AbsoluteSize.Y, 1)
            local VerticalFov = math.rad(Items["Camera"].FieldOfView)
            local HorizontalFov = 2 * math.atan(math.tan(VerticalFov / 2) * Aspect)

            local Margin = 1.3 * Preview.Zoom
            local HalfHeight = BoxSize.Y / 2 * Margin
            local HalfWidth = math.max(BoxSize.X, BoxSize.Z) / 2 * Margin

            local Distance = math.max(HalfHeight / math.tan(VerticalFov / 2), HalfWidth / math.tan(HorizontalFov / 2)) + math.max(BoxSize.X, BoxSize.Z) / 2

            Items["Camera"].CFrame = CFrame.lookAt(CenterOffset + Vector3.new(0, 0.6, -Distance), CenterOffset)
            Preview.Model:PivotTo(CFrame.Angles(0, Preview.Angle, 0))
        end

        local ForceFieldTextures = { }
        local ForceFieldTextureIds = {
            "rbxasset://textures/particles/forcefield_glow_main.dds",
            "rbxasset://textures/particles/forcefield_vortex_main.dds",
            "rbxasset://textures/particles/forcefield_alpha.dds",
        }

        local function ClearForceFieldTextures()
            for Texture in ForceFieldTextures do
                if Texture and Texture.Parent then
                    Texture:Destroy()
                end
            end
            table.clear(ForceFieldTextures)
        end

        local function ApplyLooks()
            if not Preview.Model then
                return
            end

            ClearForceFieldTextures()
            local UseCustom = type(Preview.Material) == "string" and Preview.Material ~= "Default"
            local MaterialEnum, Reflectance = Enum.Material.Plastic, 0
            if UseCustom then
                MaterialEnum, Reflectance = Library:ResolveMaterial(Preview.Material)
            end
            local UseForceField = MaterialEnum == Enum.Material.ForceField

            for Part, Look in OriginalLooks do
                if Part.Parent then
                    Part.Material = UseCustom and MaterialEnum or Look.Material
                    Part.Color = Preview.Tint or Look.Color
                    Part.Reflectance = UseCustom and MathClamp(Reflectance or 0, 0, 1) or 0

                    local IsAccessory = Part:FindFirstAncestorOfClass("Accessory") ~= nil
                    Part.Transparency = (IsAccessory and not Preview.Accessories) and 1 or Look.Transparency

                    if UseForceField and Part:IsA("BasePart") and Part.Transparency < 1 and Part.Name ~= "HumanoidRootPart" then
                        Part.Material = Enum.Material.ForceField
                        local Texture = InstanceNew("Texture")
                        Texture.Name = "\0"
                        Texture.Texture = ForceFieldTextureIds[(#ForceFieldTextures % #ForceFieldTextureIds) + 1]
                        Texture.Face = Enum.NormalId.Front
                        Texture.StudsPerTileU = 2.5
                        Texture.StudsPerTileV = 2.5
                        Texture.Transparency = 0.15
                        Texture.Color3 = Preview.Tint or Library.Theme.Accent
                        Texture.Parent = Part
                        ForceFieldTextures[Texture] = true
                    end
                end
            end

            for Item, Parent in Clothing do
                Item.Parent = (Preview.Clothing and not UseForceField) and Parent or nil
            end
        end

        local function ApplyPostFX()
            local FX = Preview.PostFX

            Items["View"].Instance.ImageColor3 = FX.Enabled and FX.Grade or EspWhite

            local ShowVignette = FX.Enabled and FX.Vignette
            local Strength = MathClamp(FX.VignetteIntensity, 0, 1)

            for _, Edge in Items["Vignette"] do
                Edge.Frame.Visible = ShowVignette
                Edge.Gradient.Transparency = NumSequence{
                    NumSequenceKeypoint(0, 1 - Strength * 0.75),
                    NumSequenceKeypoint(0.5, 1 - Strength * 0.25),
                    NumSequenceKeypoint(1, 1)
                }
            end
        end

        local function CloneCharacter(Character)
            if not Character then
                return nil
            end

            local Clone = InstanceNew("Model")
            Clone.Name = "\0"

            for _, Child in Character:GetChildren() do
                if Child.Archivable and not Child:IsA("BaseScript") and not Child:IsA("Tool") then
                    local Ok, Copy = pcall(Child.Clone, Child)
                    if Ok and Copy then
                        Copy.Parent = Clone
                    end
                end
            end

            if not Clone:FindFirstChildOfClass("Humanoid") then
                Clone:Destroy()
                return nil
            end

            local function Mirror(Attachment)
                local Owner = Attachment and Attachment.Parent
                local Part = Owner and Clone:FindFirstChild(Owner.Name)
                return Part and Part:FindFirstChild(Attachment.Name)
            end

            for _, Item in Clone:GetDescendants() do
                if Item:IsA("JointInstance") then
                    local Part0 = Item.Part0 and Clone:FindFirstChild(Item.Part0.Name, true)
                    local Part1 = Item.Part1 and Clone:FindFirstChild(Item.Part1.Name, true)
                    if Part0 and Part1 and Part0:IsA("BasePart") and Part1:IsA("BasePart") then
                        Item.Part0 = Part0
                        Item.Part1 = Part1
                    end
                elseif Item:IsA("AnimationConstraint") then
                    local Attachment0, Attachment1 = Mirror(Item.Attachment0), Mirror(Item.Attachment1)
                    if Attachment0 and Attachment1 then
                        Item.Attachment0 = Attachment0
                        Item.Attachment1 = Attachment1
                    end
                end
            end

            for _, Item in Clone:GetDescendants() do
                if Item:IsA("BaseScript") or Item:IsA("Sound") or Item:IsA("ForceField") or Item:IsA("BillboardGui") then
                    Item:Destroy()
                elseif Item:IsA("BasePart") then
                    if Item.Parent == Clone and (string.find(Item.Name, "Hitbox") or Item.Name == "FakeMass") then
                        Item:Destroy()
                    else
                        Item.Anchored = true
                        Item.CanCollide = false
                        Item.Transparency = 0
                        Item.LocalTransparencyModifier = 0
                    end
                elseif Item:IsA("Decal") then
                    Item.Transparency = 0
                end
            end

            local Root = Clone:FindFirstChild("HumanoidRootPart")
            if Root then
                Root.Transparency = 1
                Clone.PrimaryPart = Root
            end

            return Clone
        end

        function Preview:SetModel(Model)
            ClearForceFieldTextures()
            if Preview.Model then
                Preview.Model:Destroy()
                Preview.Model = nil
            end

            OriginalLooks = { }
            Clothing = { }
            Parts, Rig = { }, { Points = { } }

            if not Model then
                Items["Status"].Instance.Visible = true
                return
            end

            local Humanoid = Model:FindFirstChildOfClass("Humanoid")
            Simulated.MaxHealth = Humanoid and MathFloor(Humanoid.MaxHealth) or 100

            for _, Item in Model:GetDescendants() do
                if Item:IsA("BasePart") and Item.Name ~= "HumanoidRootPart" then
                    OriginalLooks[Item] = { Material = Item.Material, Color = Item.Color, Transparency = Item.Transparency }
                elseif Item:IsA("Clothing") or Item:IsA("ShirtGraphic") or Item:IsA("Decal") then
                    Clothing[Item] = Item.Parent
                end
            end

            Parts = CharacterParts(Model)
            Rig = BuildRig(Model)

            Model.Parent = Items["View"].Instance
            Preview.Model = Model
            Items["Status"].Instance.Visible = false
            FitCamera()
            ApplyLooks()
        end

        function Preview:SetSpeed(Speed)
            Preview.Speed = Speed
        end

        function Preview:SetSpin(Bool)
            Preview.Spin = Bool
        end

        function Preview:SetAnimate(Bool)
            Preview.Animate = Bool
        end

        function Preview:SetClothing(Bool)
            Preview.Clothing = Bool
            ApplyLooks()
        end

        function Preview:SetZoom(Zoom)
            Preview.Zoom = Zoom
            FitCamera()
        end

        function Preview:SetMaterial(Material)
            Preview.Material = Material
            ApplyLooks()
        end

        function Preview:SetTint(Color)
            Preview.Tint = Color
            ApplyLooks()
        end

        function Preview:SetAccessories(Bool)
            Preview.Accessories = Bool
            ApplyLooks()
        end

        function Preview:SetLighting(Ambient, LightColor)
            if Ambient then
                Items["View"].Instance.Ambient = Ambient
            end
            if LightColor then
                Items["View"].Instance.LightColor = LightColor
            end
        end

        function Preview:SetPostFX(Options)
            for Key, Value in Options or { } do
                Preview.PostFX[Key] = Value
            end
            ApplyPostFX()
        end

        function Preview:SetOverlay(Options)
            for Key, Value in Options or { } do
                if Key == "FlagColors" then
                    for FlagName, Colors in Value do
                        Preview.Overlay.FlagColors[FlagName] = Colors
                    end
                else
                    Preview.Overlay[Key] = Value
                end
            end
        end

        function Preview:Refresh()
            if Data.Model then
                Preview:SetModel(Data.Model:Clone())
                return
            end

            local Player = LocalPlayer
            Preview:SetModel(CloneCharacter(Player and Player.Character))
        end

        local function Simulate(Delta)
            local Now = os.clock()

            if not Preview.Animate then
                Simulated.ShownHealth = 1
                Simulated.ShownAmmo = 1
                Simulated.Ammo = Simulated.MaxAmmo
                Simulated.Reloading = false
                Simulated.ShownDistance = 25
                Simulated.Speed = 16
                return
            end

            Simulated.Health = 0.55 + 0.4 * math.sin(Now * 0.6) + 0.05 * math.sin(Now * 2.3)
            Simulated.ShownHealth += (Simulated.Health - Simulated.ShownHealth) * math.min(1, Delta * 5)

            if Simulated.Reloading then
                if Now >= Simulated.ReloadEnd then
                    Simulated.Reloading = false
                    Simulated.Ammo = Simulated.MaxAmmo
                end
            elseif Now >= Simulated.NextShot then
                Simulated.Ammo -= 1
                Simulated.NextShot = Now + 0.12 + (Simulated.Ammo % 4 == 0 and 0.6 or 0)
                if Simulated.Ammo <= 0 then
                    Simulated.Ammo = 0
                    Simulated.Reloading = true
                    Simulated.ReloadEnd = Now + 1.6
                end
            end

            local AmmoTarget = Simulated.Reloading and (1 - (Simulated.ReloadEnd - Now) / 1.6) or (Simulated.Ammo / Simulated.MaxAmmo)
            Simulated.ShownAmmo += (MathClamp(AmmoTarget, 0, 1) - Simulated.ShownAmmo) * math.min(1, Delta * 10)

            Simulated.Distance = 28 + 18 * math.sin(Now * 0.45)
            Simulated.ShownDistance += (Simulated.Distance - Simulated.ShownDistance) * math.min(1, Delta * 4)

            Simulated.Speed = 16 + 8 * math.max(0, math.sin(Now * 0.9))
        end

        local function MakeProject(Width, Height)
            local CameraCFrame = Items["Camera"].CFrame
            local TanY = math.tan(math.rad(Items["Camera"].FieldOfView) / 2)
            local TanX = TanY * (Width / Height)

            return function(Point)
                local Relative = CameraCFrame:PointToObjectSpace(Point)
                local Depth = -Relative.Z
                if Depth <= 0.01 then
                    return nil
                end

                return Vector2New((Relative.X / (Depth * TanX) + 1) / 2 * Width, (1 - Relative.Y / (Depth * TanY)) / 2 * Height), Depth
            end, Height / (2 * TanY)
        end

        local SkeletonBuffer = { Bones = { Count = 0 }, Screen = { }, Head = { } }
        local PreviewValues, PreviewData = { }, { }

        local function UpdateOverlay(Delta)
            local Drawing = Items["Drawing"]
            local O = Preview.Overlay

            if not Preview.Model or not (O.Box or O.Skeleton or O.Name or O.Distance or O.Health or O.Ammo or O.Flags) then
                Drawing:Hide()
                return
            end

            local View = Items["Overlay"].Instance
            local Width, Height = View.AbsoluteSize.X, View.AbsoluteSize.Y
            if Width < 2 or Height < 2 then
                Drawing:Hide()
                return
            end

            local Project, Scale = MakeProject(Width, Height)
            local MinX, MinY, MaxX, MaxY = ProjectBounds(Parts, Project, Scale)
            if not MinX then
                Drawing:Hide()
                return
            end

            Simulate(Delta)

            local Bones, Head, NeckPoint
            if O.Skeleton then
                Bones, Head, NeckPoint = SkeletonData(Rig, Project, Items["Camera"].CFrame.RightVector, SkeletonBuffer, O)
            end

            local Values = PreviewValues
            Values.health = StringFormat("%d hp", MathFloor(Simulated.ShownHealth * Simulated.MaxHealth + 0.5))
            Values.speed = StringFormat("%d sp", MathFloor(Simulated.Speed + 0.5))
            Values.reloading = Simulated.Reloading and ReloadingText() or nil
            Values.armor = StringFormat("%d ar", Simulated.Armor)
            Values.visible = "visible"
            Values.moving = Simulated.Speed > 17 and "moving" or nil

            local D = PreviewData
            D.MinX, D.MinY, D.MaxX, D.MaxY = MinX, MinY, MaxX, MaxY
            D.Bones, D.Head, D.Neck = Bones, Head, NeckPoint
            D.Joints = Bones and Bones.Joints or nil
            D.Name = LocalPlayer.DisplayName or "player"
            D.Health, D.MaxHealth = Simulated.ShownHealth, Simulated.MaxHealth
            D.Ammo, D.AmmoCount, D.MaxAmmo = Simulated.ShownAmmo, Simulated.Ammo, Simulated.MaxAmmo
            D.Reloading = Simulated.Reloading
            D.Distance = Simulated.ShownDistance
            D.Weapon = "Assault Rifle"
            D.Values = Values

            Drawing:Render(O, D)
        end

        local function FitHeight()
            if Preview.Height then
                return
            end

            local Padding = Column:FindFirstChildOfClass("UIPadding")
            local Top = Padding and Padding.PaddingTop.Offset or 0
            local Bottom = Padding and Padding.PaddingBottom.Offset or 0

            Items["Section"].Instance.Size = UDim2New(1, 0, 0, math.max(MathFloor(Column.AbsoluteSize.Y - Top - Bottom), 80))
        end

        local Settings = { IsOpen = false }
        local Follow

        local function BuildSettings()
            Items["Popup"], Items["PopupInner"] = Library:CreateOverlayFrame({
                AnchorPoint = Vector2New(1, 0),
                Size = UDim2New(0, 190, 0, 0)
            })
            Items["Popup"].Instance.Visible = false
            Items["Popup"].Instance.Active = true

            PopupLabel(Items["PopupInner"].Instance, "preview settings", UDim2New(0, 8, 0, 5), UDim2New(1, -16, 0, 14))

            Items["PopupContent"] = Instances:Create("Frame", {
                Parent = Items["PopupInner"].Instance,
                Name = "\0",
                Position = UDim2New(0, 8, 0, 24),
                Size = UDim2New(1, -16, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BackgroundColor3 = EspWhite
            })

            Instances:Create("UIListLayout", {
                Parent = Items["PopupContent"].Instance,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            local Section = setmetatable({
                Window = self.Window,
                Page = self,
                Elements = { Content = Items["PopupContent"] }
            }, Library.Sections)

            local FlagBase = "Preview " .. Preview.Name .. " "

            Section:Dropdown({
                Name = "Material",
                Flag = FlagBase .. "Material",
                Default = "Default",
                Items = { "Default", "Chrome", "Mirror", "Plasma", "Aurora", "SmoothPlastic", "Neon", "ForceField", "Glass", "Foil", "Ice", "Metal" },
                Callback = function(Value)
                    Preview:SetMaterial(Value)
                end,
            })

            local Tint = Section:Toggle({
                Name = "Tint",
                Flag = FlagBase .. "Tint",
                Default = false,
                Callback = function(Value)
                    local Picked = Library.Flags[FlagBase .. "Tint Color"]
                    Preview:SetTint(Value and (Picked and Picked.Color or FromRGB(96, 126, 255)) or nil)
                end,
            })

            Tint:Colorpicker({
                Name = "Tint color",
                Flag = FlagBase .. "Tint Color",
                Default = FromRGB(96, 126, 255),
                Callback = function(Color)
                    if Library.Flags[FlagBase .. "Tint"] then
                        Preview:SetTint(Color)
                    end
                end,
            })

            Section:Toggle({
                Name = "Accessories",
                Flag = FlagBase .. "Accessories",
                Default = false,
                Callback = function(Value)
                    Preview:SetAccessories(Value)
                end,
            })

            Section:Toggle({
                Name = "Clothes & decals",
                Flag = FlagBase .. "Clothing",
                Default = false,
                Callback = function(Value)
                    Preview:SetClothing(Value)
                end,
            })

            Section:Toggle({
                Name = "Spin",
                Flag = FlagBase .. "Spin",
                Default = Preview.Spin,
                Callback = function(Value)
                    Preview:SetSpin(Value)
                end,
            }):Children():Slider({
                Name = "Speed",
                Min = 5,
                Max = 180,
                Default = Preview.Speed,
                Decimals = 1,
                Suffix = "°/s",
                Flag = FlagBase .. "Speed",
                Callback = function(Value)
                    Preview:SetSpeed(Value)
                end,
            })

            Section:Toggle({
                Name = "Esp animations",
                Flag = FlagBase .. "Animate",
                Default = false,
                Callback = function(Value)
                    Preview:SetAnimate(Value)
                end,
            })

            Section:Slider({
                Name = "Zoom",
                Min = 0.7,
                Max = 1.8,
                Default = 1,
                Decimals = 0.05,
                Suffix = "x",
                Flag = FlagBase .. "Zoom",
                Callback = function(Value)
                    Preview:SetZoom(Value)
                end,
            })

            Section:Label({ Name = "Ambient", Alignment = "Left" }):Colorpicker({
                Name = "Ambient",
                Flag = FlagBase .. "Ambient",
                Default = FromRGB(170, 170, 170),
                Callback = function(Color)
                    Preview:SetLighting(Color, nil)
                end,
            })

            local PostFX = Section:Toggle({
                Name = "Post FX",
                Flag = FlagBase .. "Post FX",
                Default = false,
                Callback = function(Value)
                    Preview:SetPostFX({ Enabled = Value })
                end,
            }):Children()

            PostFX:Toggle({
                Name = "Vignette",
                Flag = FlagBase .. "Vignette",
                Default = false,
                Callback = function(Value)
                    Preview:SetPostFX({ Vignette = Value })
                end,
            }):Children():Slider({
                Name = "Intensity",
                Min = 0,
                Max = 100,
                Default = 50,
                Decimals = 1,
                Suffix = "%",
                Flag = FlagBase .. "Vignette Intensity",
                Callback = function(Value)
                    Preview:SetPostFX({ VignetteIntensity = Value / 100 })
                end,
            })

            PostFX:Label({ Name = "Color grade", Alignment = "Left" }):Colorpicker({
                Name = "Color grade",
                Flag = FlagBase .. "Grade",
                Default = EspWhite,
                Callback = function(Color)
                    Preview:SetPostFX({ Grade = Color })
                end,
            })

            local function Resize()
                local ContentHeight = Items["PopupContent"].Instance.AbsoluteSize.Y
                Items["Popup"].Instance.Size = UDim2New(0, 190, 0, 24 + ContentHeight + 8 + Library.FrameBand * 2)
            end

            Library:Connect(Items["PopupContent"].Instance:GetPropertyChangedSignal("AbsoluteSize"), Resize)
            Resize()
        end

        function Settings:Close()
            Settings.IsOpen = false

            if Follow then
                Follow:Disconnect()
                Follow = nil
            end

            if Items["Popup"] then
                Items["Popup"].Instance.Visible = false
            end
        end

        function Settings:Open()
            if not Items["Popup"] then
                BuildSettings()
            end

            Settings.IsOpen = true

            Follow = FollowAnchor(Items["Popup"].Instance, Items["Dots"].Instance, function(Anchor)
                return UDim2New(0, Anchor.AbsolutePosition.X + Anchor.AbsoluteSize.X, 0, Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + 6)
            end, function()
                Settings:Close()
            end)

            SetZ(Items["Popup"].Instance, 10000)
            Items["Popup"].Instance.Visible = Settings.IsOpen
        end

        Items["Dots"]:Connect("MouseButton1Click", function()
            if Settings.IsOpen then
                Settings:Close()
            else
                Settings:Open()
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType ~= Enum.UserInputType.MouseButton1 or not Settings.IsOpen then
                return
            end

            if Library.CurrentDropdown or Library.CurrentColorpicker or Library.CurrentPopup then
                return
            end

            if Library:IsMouseOverFrame(Items["Popup"]) or Library:IsMouseOverFrame(Items["Dots"]) then
                return
            end

            Settings:Close()
        end)

        Preview.Settings = Settings

        Library:Connect(Column:GetPropertyChangedSignal("AbsoluteSize"), function()
            FitHeight()
            FitCamera()
        end)

        Library:Connect(RunService.RenderStepped, function(Delta)
            if not Preview.Model or not IsShown(Items["View"].Instance) then
                return
            end

            local Angle = Preview.Angle
            if Preview.Spin then
                Angle = (Angle + math.rad(Preview.Speed) * Delta) % (math.pi * 2)
            elseif Angle ~= 0 then
                local Offset = (Angle + math.pi) % (math.pi * 2) - math.pi
                Offset -= Offset * math.min(Delta * 10, 1)
                Angle = math.abs(Offset) < 0.002 and 0 or Offset % (math.pi * 2)
            end

            if Angle ~= Preview.Angle or not Preview.Posed then
                Preview.Angle, Preview.Posed = Angle, true
                Preview.Model:PivotTo(CFrame.Angles(0, Angle, 0))
            end

            if Preview.Material == "ForceField" then
                local Scroll = os.clock() * 1.35
                for Texture in ForceFieldTextures do
                    if Texture.Parent then
                        Texture.OffsetStudsU = Scroll
                        Texture.OffsetStudsV = Scroll * 0.65
                        Texture.Color3 = Preview.Tint or Library.Theme.Accent
                    end
                end
            end

            UpdateOverlay(Delta)
        end)

        if not Data.Model then
            Library:Connect(LocalPlayer.CharacterAppearanceLoaded, function()
                task.wait(0.2)
                Preview:Refresh()
            end)

            Library:Connect(LocalPlayer.CharacterAdded, function(Character)
                local Deadline = os.clock() + 10
                while not Character:FindFirstChild("HumanoidRootPart") and os.clock() < Deadline do
                    task.wait(0.1)
                end
                task.wait(1)
                Preview:Refresh()
            end)
        end

        ApplyPostFX()
        FitHeight()
        task.defer(function()
            FitHeight()
            Preview:Refresh()
        end)

        return Preview
    end

    Library.IsHostileTeam = function(self, Mine, Theirs)
        -- FFA / unteamed: 0 or nil means everyone else is fair game.
        if Mine == nil or Mine == 0 or Theirs == nil or Theirs == 0 then
            return true
        end
        return Mine ~= Theirs
    end

    Library.IsHostileFighter = function(self, LocalFighter, Fighter)
        if not (LocalFighter and Fighter) or Fighter == LocalFighter then
            return false
        end

        local Mine = LocalFighter.Get and LocalFighter:Get("TeamID")
        local Theirs = Fighter.Get and Fighter:Get("TeamID")
        return self:IsHostileTeam(Mine, Theirs)
    end

    Library.GetEspTeam = function(self, Player)
        if Player.UserId == LocalPlayer.UserId then
            return "local"
        end

        local Mine, Theirs = LocalPlayer:GetAttribute("TeamID"), Player:GetAttribute("TeamID")
        if Mine ~= nil or Theirs ~= nil then
            return self:IsHostileTeam(Mine, Theirs) and "enemy" or "ally"
        end

        if not Player.Neutral and not LocalPlayer.Neutral and Player.Team and LocalPlayer.Team then
            return Player.Team == LocalPlayer.Team and "ally" or "enemy"
        end

        return "enemy"
    end

    local RivalsFighters, RivalsRetry = nil, 0

    local function GetRivalsFighters()
        if RivalsFighters or game.GameId ~= 6035872082 or os.clock() < RivalsRetry then
            return RivalsFighters
        end

        RivalsRetry = os.clock() + 2

        local Ok, Controller = pcall(function()
            return require(RealPlayer().PlayerScripts.Controllers.FighterController)
        end)

        if Ok and type(Controller) == "table" and type(rawget(Controller, "_player_to_fighter")) == "table" then
            RivalsFighters = rawget(Controller, "_player_to_fighter")
        end

        return RivalsFighters
    end

    local function FindFighter(Player, State)
        local Fighters = GetRivalsFighters()
        if not Fighters then
            return nil
        end

        local Fighter = Fighters[Player]
        if Fighter then
            return Fighter
        end

        local Owner = State.FighterOwner
        if Owner and Fighters[Owner] then
            return Fighters[Owner]
        end

        local Now = os.clock()
        if Now < (State.NextScan or 0) then
            return nil
        end
        State.NextScan = Now + 1

        for Candidate, Value in Fighters do
            if typeof(Candidate) == "Instance" and Candidate.UserId == Player.UserId then
                State.FighterOwner = Candidate
                return Value
            end
        end
    end

    local WeaponStates = setmetatable({ }, { __mode = "k" })

    Library.GetWeaponState = function(self, Player, Character)
        local State = WeaponStates[Player]
        if not State then
            State = { }
            WeaponStates[Player] = State
        end

        State.Ammo, State.MaxAmmo, State.Reserve, State.Reloading, State.Progress, State.Name = nil, nil, nil, false, nil, nil
        State.Type, State.Raycast, State.Infinite = nil, false, false
        State.LastShot, State.ShootCooldown, State.BounceCount, State.BounceAngle = nil, nil, 0, 0

        local function IsInfiniteAmmo(MaxAmmo)
            return type(MaxAmmo) == "number" and (MaxAmmo == math.huge or MaxAmmo >= 1e9)
        end

        local Fighter = FindFighter(Player, State)
        local Item = type(Fighter) == "table" and rawget(Fighter, "EquippedItem")

        if type(Item) == "table" then
            local ItemName = rawget(Item, "Name")
            State.Name = type(ItemName) == "string" and ItemName or nil
            State.LastShot = rawget(Item, "_last_shot")
            State.ShootCooldown = rawget(Item, "_shoot_cooldown")

            local ItemData, Info = rawget(Item, "Data"), rawget(Item, "Info")

            if type(Info) == "table" then
                State.Type = Info.Type
                State.Raycast = Info.Type == "Gun" and Info.IsRaycast == true
                State.BounceCount = tonumber(Info.RaycastBounceCount) or 0
                State.BounceAngle = tonumber(Info.RaycastBounceRedirectionAngle) or 0
            end

            if type(ItemData) == "table" and type(Info) == "table" and type(ItemData.Ammo) == "number" and type(Info.MaxAmmo) == "number" and Info.MaxAmmo > 0 then
                local Ammo = ItemData.Ammo
                local MaxAmmo = Info.MaxAmmo
                local Infinite = IsInfiniteAmmo(MaxAmmo) or IsInfiniteAmmo(Ammo)

                if not Infinite and rawget(Item, "_shot_but_ammo_hasnt_updated") then
                    Ammo = math.max(Ammo - 1, 0)
                end

                State.Infinite = Infinite
                State.Ammo, State.MaxAmmo, State.Reserve = Ammo, MaxAmmo, ItemData.AmmoReserve

                local Ends, Now = rawget(Item, "_reload_cooldown"), tick()
                if type(Ends) == "number" and Ends > Now and Ends < math.huge then
                    if State.ReloadEnds ~= Ends then
                        State.ReloadEnds, State.ReloadStart = Ends, Now
                    end
                    State.Reloading = true
                    State.Progress = MathClamp((Now - State.ReloadStart) / math.max(Ends - State.ReloadStart, 0.01), 0, 1)
                else
                    State.ReloadEnds, State.ReloadStart = nil, nil
                end

                return State
            end

            return State
        end

        local Tool = Character and Character:FindFirstChildOfClass("Tool")
        State.Name = Tool and Tool.Name or nil

        local Ammo = Character and Character:GetAttribute("Ammo") or Player:GetAttribute("Ammo")
        local MaxAmmo = Character and Character:GetAttribute("MaxAmmo") or Player:GetAttribute("MaxAmmo")
        if type(Ammo) == "number" and type(MaxAmmo) == "number" and MaxAmmo > 0 then
            State.Infinite = IsInfiniteAmmo(MaxAmmo) or IsInfiniteAmmo(Ammo)
            State.Ammo, State.MaxAmmo = Ammo, MaxAmmo
        end
        State.Reloading = (Character and Character:GetAttribute("Reloading")) or Player:GetAttribute("Reloading") or false

        return State
    end

-- __TAPOLOGY_LOGIC__

    Library.Sections.SetVisibility = function(self, Bool)
        if self.Frame then
            self.Frame.Visible = Bool
        end
    end

    Library.Sections.Toggle = function(self, Data)
        Data = Data or { }

        local Toggle = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Toggle",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or false,
            Callback = Data.Callback or Data.callback or function() end,

            Value = false,
            Class = "Toggle",

            Count = 0
        }

        local Items = { } do 
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Toggle.Section.Elements["Content"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 11),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(0, 10, 0, 10),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Indicator"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Indicator"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(70, 70, 70))}
            })

            Items["Fill"] = Instances:Create("Frame", {
                Parent = Items["Indicator"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 1),
                Position = UDim2New(0.5, 0, 1, -1),
                Size = UDim2New(1, -2, 0, 0),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = Library.Theme.Accent
            })  Items["Fill"]:AddToTheme({BackgroundColor3 = "Accent"})

            Instances:Create("UIGradient", {
                Parent = Items["Fill"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(85, 85, 85))}
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.48,
                Text = Toggle.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                Position = UDim2New(0, 18, 0, -1),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            if Data.Tag then
                Items["Tag"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Data.Tag,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2New(1, -18, 1, 0),
                    Position = UDim2New(1, 0, 0, -1),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Tag"]:AddToTheme({TextColor3 = "Inactive Text"})

                Instances:Create("UIStroke", {
                    Parent = Items["Tag"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0"
                }):AddToTheme({Color = "Text Border"})
            end

            Items["Toggle"]:OnHover(function()
                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})

                if not Toggle.Value then
                    Items["Text"]:Tween(nil, {TextTransparency = 0.25})
                end
            end)

            Items["Toggle"]:OnHoverLeave(function()
                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

                if not Toggle.Value then
                    Items["Text"]:Tween(nil, {TextTransparency = 0.48})
                end
            end)
        end
        
        function Toggle:Get()
            return Toggle.Value
        end

        function Toggle:Set(Bool)
            if Bool == nil then
                Toggle.Value = not Toggle.Value
            else
                Toggle.Value = Bool and true or false
            end

            Library.Flags[Toggle.Flag] = Toggle.Value

            if Toggle.Value then 
                Items["Fill"]:Tween(nil, {Size = UDim2New(1, -2, 1, -2)})
                Items["Text"]:Tween(nil, {TextTransparency = 0})
            else
                Items["Fill"]:Tween(nil, {Size = UDim2New(1, -2, 0, 0)})
                Items["Text"]:Tween(nil, {TextTransparency = 0.48})
            end

            if Items["Children"] then
                Items["Children"].Instance.Visible = Toggle.Value
            end

            if Toggle.OnChanged then
                Toggle.OnChanged()
            end

            if Toggle.Callback then 
                Library:SafeCall(Toggle.Callback, Toggle.Value)
            end
        end

        AttachToggleBind(Toggle, Items["Toggle"].Instance, Items["Text"])

        function Toggle:Children()
            if Toggle.ChildSection then
                return Toggle.ChildSection
            end

            Items["Children"] = Instances:Create("Frame", {
                Parent = Toggle.Section.Elements["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Visible = Toggle.Value,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIPadding", {
                Parent = Items["Children"].Instance,
                PaddingLeft = UDimNew(0, 12)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Children"].Instance,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            local Guide = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                Position = UDim2New(0, 4, 1, 3),
                Size = UDim2New(0, 1, 0, 0),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                Visible = false,
                BackgroundColor3 = Library.Theme.Outline
            })  Guide:AddToTheme({BackgroundColor3 = "Outline"})

            local function SyncGuide()
                local ChildFrame = Items["Children"].Instance
                Guide.Instance.Visible = ChildFrame.Visible
                Guide.Instance.Size = UDim2New(0, 1, 0, MathFloor(ChildFrame.AbsoluteSize.Y) + 3)
            end

            Items["Children"].Instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(SyncGuide)
            Items["Children"].Instance:GetPropertyChangedSignal("Visible"):Connect(SyncGuide)
            SyncGuide()

            Toggle.ChildSection = setmetatable({
                Window = Toggle.Window,
                Page = Toggle.Page,
                Elements = { Content = Items["Children"] }
            }, Library.Sections)

            return Toggle.ChildSection
        end

        function Toggle:SetVisiblity(Bool)
            Items["Toggle"].Instance.Visible = Bool
        end

        function Toggle:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Toggle"],
                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or false,
                Count = Toggle.Count,

                FadeSpeed = self.Window.FadeSpeed
            }

            Toggle.Count += 1
            Colorpicker.Count = Toggle.Count

            local Extension = Library:CreateColorpicker(Colorpicker)
            Library.Flags[Colorpicker.Flag] = Extension

            return Colorpicker, Extension
        end

        function Toggle:Keybind(Data)
            Data = Data or { }

            local Bind = Toggle.Bind
            Toggle.BindCallback = Data.Callback or Data.callback

            if Data.Default or Data.default then
                Bind:SetKey(ParseKey(Data.Default or Data.default))
            end

            Bind:SetMode(Data.Mode or Data.mode or "Always")

            local BindFlag = Toggle.Flag .. " Bind"

            if Data.Flag or Data.flag then
                Library.SetFlags[Data.Flag or Data.flag] = Library.SetFlags[BindFlag]
                Library.Flags[Data.Flag or Data.flag] = Library.Flags[BindFlag]
                Library:RememberDefault(Data.Flag or Data.flag)
            end

            Library:RememberDefault(BindFlag)
            return Toggle, Bind
        end

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Toggle:Set()
        end)

        if Toggle.Default then 
            Toggle:Set(true)
        else
            Library.Flags[Toggle.Flag] = false
        end

        Library.SetFlags[Toggle.Flag] = function(Value)
            Toggle:Set(Value)
        end

        Library:RememberDefault(Toggle.Flag)
        return Toggle
    end

    Library.Sections.Button = function(self, Data)
        Data = Data or { }

        local Button = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name,
            Callback = Data.Callback or Data.callback or function() end,
        }

        local Items = { } do 
            Items["Button"] = Instances:Create("TextButton", {
                Parent = Button.Section.Elements["Content"].Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 17),
                Selectable = false,
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

            Instances:Create("UIGradient", {
                Parent = Items["Button"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Button"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"}) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Button"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Button.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["TextBorder"] = Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Button"]:OnHover(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["Button"]:OnHoverLeave(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end)
        end

        function Button:Press()
            Library:SafeCall(Button.Callback)

            Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})

            task.wait(0.1)

            Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element"})

            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
        end

        function Button:SetVisiblity(Bool)
            Items["Button"].Instance.Visible = Bool
        end

        Items["Button"]:Connect("MouseButton1Down", function()
            Button:Press()
        end)

        Button.Instance = Items["Button"].Instance

        return Button
    end

    Library.Sections.ButtonRow = function(self, Buttons)
        local Gap = 7
        local Count = #Buttons

        local Row = Instances:Create("Frame", {
            Parent = self.Elements["Content"].Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2New(1, 0, 0, 17),
            BackgroundColor3 = FromRGB(255, 255, 255)
        })

        local Proxy = setmetatable({
            Window = self.Window,
            Page = self.Page,
            Elements = { Content = Row }
        }, Library.Sections)

        local Created = { }

        for Index, Data in Buttons do
            local NewButton = Library.Sections.Button(Proxy, Data)
            local Instance = NewButton.Instance

            Instance.Size = UDim2New(1 / Count, -Gap * (Count - 1) / Count, 1, 0)
            Instance.Position = UDim2New((Index - 1) / Count, (Index - 1) * Gap / Count, 0, 0)

            TableInsert(Created, NewButton)
        end

        local function Layout()
            local Usable = Row.Instance.AbsoluteSize.X - Gap * (Count - 1)
            if Usable <= 0 then
                return
            end

            local Each = MathFloor(Usable / Count)
            local Extra = Usable - Each * Count
            local X = 0

            for Index, NewButton in Created do
                local Width = Each + (Index <= Extra and 1 or 0)
                NewButton.Instance.Size = UDim2New(0, Width, 1, 0)
                NewButton.Instance.Position = UDim2New(0, X, 0, 0)
                X += Width + Gap
            end
        end

        Layout()
        Library:Connect(Row.Instance:GetPropertyChangedSignal("AbsoluteSize"), Layout)

        return Created
    end

    local function CreateTrack(Parent)
        local Track = Instances:Create("TextButton", {
            Parent = Parent,
            AnchorPoint = Vector2New(0, 1),
            Name = "\0",
            Position = UDim2New(0, 0, 1, 0),
            BorderColor3 = FromRGB(10, 10, 10),
            Text = "",
            AutoButtonColor = false,
            Size = UDim2New(1, 0, 0, 10),
            BorderSizePixel = 2,
            BackgroundColor3 = Library.Theme.Background
        })  Track:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

        Instances:Create("UIStroke", {
            Parent = Track.Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0",
            Color = Library.Theme.Outline
        }):AddToTheme({Color = "Outline"})

        Instances:Create("UIGradient", {
            Parent = Track.Instance,
            Rotation = 90,
            Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
        })

        Track:OnHover(function()
            Track:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
            Track:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
        end)

        Track:OnHoverLeave(function()
            Track:Tween(nil, {BackgroundColor3 = Library.Theme.Background})
            Track:ChangeItemTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
        end)

        return Track
    end

    local function CreateAccentFill(Parent)
        local Fill = Instances:Create("Frame", {
            Parent = Parent,
            Name = "\0",
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(0, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Accent
        })  Fill:AddToTheme({BackgroundColor3 = "Accent"})

        Instances:Create("UIGradient", {
            Parent = Fill.Instance,
            Rotation = 90,
            Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
        })

        return Fill
    end

    Library.Sections.RangeSlider = function(self, Data)
        Data = Data or { }

        local Range = {
            Name = Data.Name or Data.name or "Range",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Min = Data.Min or Data.min or 0,
            Max = Data.Max or Data.max or 100,
            Decimals = Data.Decimals or Data.decimals or 1,
            Suffix = Data.Suffix or Data.suffix or "",
            Callback = Data.Callback or Data.callback or function() end,

            Low = 0,
            High = 0,
            Dragging = nil,
            Class = "RangeSlider"
        }

        local Default = Data.Default or Data.default or { Range.Min, Range.Max }

        local Items = { } do
            Items["Holder"] = Instances:Create("Frame", {
                Parent = self.Elements["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 27),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Title"] = PopupLabel(Items["Holder"].Instance, Range.Name, UDim2New(0, 0, 0, 0), UDim2New(1, 0, 0, 13))
            Items["Track"] = CreateTrack(Items["Holder"].Instance)
            Items["Fill"] = CreateAccentFill(Items["Track"].Instance)
            Items["Value"] = PopupLabel(Items["Track"].Instance, "", UDim2New(0, 0, 0, -1), UDim2New(1, 0, 1, 0), Enum.TextXAlignment.Center)
            Items["Value"].Instance.ZIndex = 2
        end

        local function Alpha(Value)
            return (Value - Range.Min) / (Range.Max - Range.Min)
        end

        local function ValueFromMouse()
            local Track = Items["Track"].Instance
            local Mouse = UserInputService:GetMouseLocation()
            local Ratio = MathClamp((Mouse.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            return Range.Min + (Range.Max - Range.Min) * Ratio
        end

        function Range:Set(Low, High)
            Low = MathClamp(Library:Round(Low, Range.Decimals), Range.Min, Range.Max)
            High = MathClamp(Library:Round(High, Range.Decimals), Range.Min, Range.Max)

            if Low > High then
                Low, High = High, Low
            end

            Range.Low, Range.High = Low, High
            Library.Flags[Range.Flag] = { Low, High }

            Items["Fill"]:Tween(nil, {
                Position = UDim2New(Alpha(Low), 0, 0, 0),
                Size = UDim2New(Alpha(High) - Alpha(Low), 0, 1, 0)
            })

            Items["Value"].Instance.Text = StringFormat("%s%s - %s%s", tostring(Low), Range.Suffix, tostring(High), Range.Suffix)

            Library:SafeCall(Range.Callback, Low, High)
        end

        function Range:Get()
            return Range.Low, Range.High
        end

        local function Drag()
            local Value = ValueFromMouse()

            if Range.Dragging == "Low" then
                if Value > Range.High then
                    Range.Dragging = "High"
                    Range:Set(Range.High, Value)
                else
                    Range:Set(Value, Range.High)
                end
            else
                if Value < Range.Low then
                    Range.Dragging = "Low"
                    Range:Set(Value, Range.Low)
                else
                    Range:Set(Range.Low, Value)
                end
            end
        end

        Items["Track"]:Connect("MouseButton1Down", function()
            local Value = ValueFromMouse()
            Range.Dragging = math.abs(Value - Range.Low) <= math.abs(Value - Range.High) and "Low" or "High"
            Drag()
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Range.Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                Drag()
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Range.Dragging = nil
            end
        end)

        Library.SetFlags[Range.Flag] = function(Value)
            if type(Value) == "table" then
                Range:Set(Value[1] or Range.Min, Value[2] or Range.Max)
            end
        end

        Range:Set(Default[1], Default[2])
        Library:RememberDefault(Range.Flag)
        return Range
    end

    Library.Sections.Segment = function(self, Data)
        Data = Data or { }

        local Segment = {
            Name = Data.Name or Data.name,
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Options = Data.Items or Data.items or { "one", "two" },
            Callback = Data.Callback or Data.callback or function() end,
            Value = nil,
            Class = "Segment"
        }

        local Count = #Segment.Options
        local TitleHeight = Segment.Name and 15 or 0

        local Items = { } do
            Items["Holder"] = Instances:Create("Frame", {
                Parent = self.Elements["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, TitleHeight + 18),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            if Segment.Name then
                PopupLabel(Items["Holder"].Instance, Segment.Name, UDim2New(0, 0, 0, 0), UDim2New(1, 0, 0, 13))
            end

            Items["Bar"] = Instances:Create("Frame", {
                Parent = Items["Holder"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, TitleHeight + 1),
                Size = UDim2New(1, 0, 0, 16),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = Library.Theme.Inline
            })  Items["Bar"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UIStroke", {
                Parent = Items["Bar"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = Library.Theme.Border
            }):AddToTheme({Color = "Border"})

            Library:AddInsetShadow(Items["Bar"].Instance, {0, 0, 0, 0}, 6)

            Items["Chip"] = Instances:Create("Frame", {
                Parent = Items["Bar"].Instance,
                Name = "\0",
                Position = UDim2New(0, 1, 0, 1),
                Size = UDim2New(1 / Count, -2, 1, -2),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 1,
                BackgroundColor3 = Library.Theme.Element
            })  Items["Chip"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIGradient", {
                Parent = Items["Chip"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(130, 130, 130))}
            })

            Instances:Create("UIStroke", {
                Parent = Items["Chip"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = Library.Theme.Outline
            }):AddToTheme({Color = "Outline"})

            Items["Labels"] = { }
            Items["Buttons"] = { }

            for Index, Option in Segment.Options do
                local Button = Instances:Create("TextButton", {
                    Parent = Items["Bar"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    Position = UDim2New((Index - 1) / Count, 0, 0, 0),
                    Size = UDim2New(1 / Count, 0, 1, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                local Label = PopupLabel(Button.Instance, tostring(Option), UDim2New(0, 0, 0, -1), UDim2New(1, 0, 1, 0), Enum.TextXAlignment.Center)
                Label.Instance.ZIndex = 2
                Label.Instance.TextTransparency = 0.5

                Button:OnHover(function()
                    if Segment.Value ~= Option then
                        Label:Tween(nil, {TextTransparency = 0.25})
                    end
                end)

                Button:OnHoverLeave(function()
                    if Segment.Value ~= Option then
                        Label:Tween(nil, {TextTransparency = 0.5})
                    end
                end)

                Button:Connect("MouseButton1Down", function()
                    Segment:Set(Option)
                end)

                Items["Labels"][Option] = Label
                Items["Buttons"][Index] = Button
            end
        end

        local Slots = { }

        local function LayoutSegment()
            local Width = Items["Bar"].Instance.AbsoluteSize.X
            if Width <= 0 then
                return
            end

            local Each = MathFloor(Width / Count)
            local Extra = Width - Each * Count
            local X = 0

            for Index, Button in Items["Buttons"] do
                local Size = Each + (Index <= Extra and 1 or 0)
                Slots[Index] = { X, Size }
                Button.Instance.Position = UDim2New(0, X, 0, 0)
                Button.Instance.Size = UDim2New(0, Size, 1, 0)
                X += Size
            end

            local Slot = Slots[TableFind(Segment.Options, Segment.Value) or 0]
            if Slot then
                Items["Chip"].Instance.Position = UDim2New(0, Slot[1] + 1, 0, 1)
                Items["Chip"].Instance.Size = UDim2New(0, Slot[2] - 2, 1, -2)
            end
        end

        function Segment:Set(Option)
            local Index = TableFind(Segment.Options, Option)
            if not Index then
                return
            end

            Segment.Value = Option
            Library.Flags[Segment.Flag] = Option

            local Slot = Slots[Index]
            if Slot then
                Items["Chip"]:Tween(nil, {Position = UDim2New(0, Slot[1] + 1, 0, 1), Size = UDim2New(0, Slot[2] - 2, 1, -2)})
            else
                Items["Chip"]:Tween(nil, {Position = UDim2New((Index - 1) / Count, 1, 0, 1)})
            end

            for Name, Label in Items["Labels"] do
                local Active = Name == Option
                Label:ChangeItemTheme({TextColor3 = Active and "Accent" or "Text"})
                Label:Tween(nil, {TextColor3 = Active and Library.Theme.Accent or Library.Theme.Text, TextTransparency = Active and 0 or 0.5})
            end

            Library:SafeCall(Segment.Callback, Option)
        end

        function Segment:Get()
            return Segment.Value
        end

        Library.SetFlags[Segment.Flag] = function(Value)
            Segment:Set(Value)
        end

        Segment:Set(Data.Default or Data.default or Segment.Options[1])
        Library:RememberDefault(Segment.Flag)
        LayoutSegment()
        Library:Connect(Items["Bar"].Instance:GetPropertyChangedSignal("AbsoluteSize"), LayoutSegment)
        return Segment
    end

    Library.Sections.Graph = function(self, Data)
        Data = Data or { }

        local Graph = {
            Name = Data.Name or Data.name or "Graph",
            Max = Data.Max or Data.max,
            Points = Data.Points or Data.points or 32,
            Height = Data.Height or Data.height or 38,
            Suffix = Data.Suffix or Data.suffix or "",
            Decimals = Data.Decimals or Data.decimals or 1,
            Values = { },
            Class = "Graph"
        }

        local Items = { } do
            Items["Holder"] = Instances:Create("Frame", {
                Parent = self.Elements["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 16 + Graph.Height),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            PopupLabel(Items["Holder"].Instance, Graph.Name, UDim2New(0, 0, 0, 0), UDim2New(1, -60, 0, 13))
            Items["Value"] = PopupLabel(Items["Holder"].Instance, "--", UDim2New(1, -60, 0, 0), UDim2New(0, 60, 0, 13), Enum.TextXAlignment.Right, "Accent")

            Items["Box"] = Instances:Create("Frame", {
                Parent = Items["Holder"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 15),
                Size = UDim2New(1, 0, 0, Graph.Height),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                ClipsDescendants = true,
                BackgroundColor3 = Library.Theme.Inline
            })  Items["Box"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UIStroke", {
                Parent = Items["Box"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = Library.Theme.Border
            }):AddToTheme({Color = "Border"})

            Library:AddInsetShadow(Items["Box"].Instance, {0, 0, 0, 0}, 8)

            for _, Ratio in { 0.25, 0.5, 0.75 } do
                local Line = Instances:Create("Frame", {
                    Parent = Items["Box"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 0, Ratio, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 0.6,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundColor3 = Library.Theme.Outline
                })  Line:AddToTheme({BackgroundColor3 = "Outline"})
            end

            Items["Bars"] = { }

            for Index = 1, Graph.Points do
                local Bar = Instances:Create("Frame", {
                    Parent = Items["Box"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New((Index - 1) / Graph.Points, 0, 1, 0),
                    Size = UDim2New(1 / Graph.Points, -1, 0, 0),
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BackgroundColor3 = Library.Theme.Accent
                })  Bar:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("UIGradient", {
                    Parent = Bar.Instance,
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(80, 80, 80))}
                })

                Items["Bars"][Index] = Bar
            end
        end

        function Graph:Push(Value)
            if not Library then
                return
            end

            Value = tonumber(Value) or 0
            TableInsert(Graph.Values, Value)

            while #Graph.Values > Graph.Points do
                TableRemove(Graph.Values, 1)
            end

            local Peak = Graph.Max
            if not Peak then
                Peak = 1
                for _, Sample in Graph.Values do
                    Peak = math.max(Peak, Sample)
                end
                Peak *= 1.15
            end

            local Offset = Graph.Points - #Graph.Values

            for Index, Bar in Items["Bars"] do
                local Sample = Graph.Values[Index - Offset]
                local Ratio = Sample and MathClamp(Sample / Peak, 0, 1) or 0
                Bar:Tween(nil, {Size = UDim2New(1 / Graph.Points, -1, Ratio, 0)})
            end

            Items["Value"].Instance.Text = tostring(Library:Round(Value, Graph.Decimals)) .. Graph.Suffix
        end

        function Graph:Clear()
            Graph.Values = { }
            for _, Bar in Items["Bars"] do
                Bar.Instance.Size = UDim2New(1 / Graph.Points, -1, 0, 0)
            end
            Items["Value"].Instance.Text = "--"
        end

        return Graph
    end

    Library.Sections.Slider = function(self, Data)
        Data = Data or { }

        local Slider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Slider",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Min = Data.Min or Data.min or 0,
            Default = Data.Default or Data.default or 0,
            Max = Data.Max or Data.max or 100,
            Suffix = Data.Suffix or Data.suffix or "",
            Decimals = Data.Decimals or Data.decimals or 1,
            Callback = Data.Callback or Data.callback or function() end,
            Compact = Data.Compact or Data.compact or false,

            Value = 0,
            Sliding = false,
            Class = "Slider",
        }

        local Items = { } do 
            Items["Slider"] = Instances:Create("Frame", {
                Parent = Slider.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 27),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Slider"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Slider.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["RealSlider"] = Instances:Create("TextButton", {
                Parent = Items["Slider"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(1, 0, 0, 10),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealSlider"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["RealSlider"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["RealSlider"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0.5, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(96, 126, 255)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Indicator"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealSlider"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "50/100s",
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, -1),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Value"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            if Slider.Compact then 
                Items["Value"]:Clean()
                Items["Value"] = nil

                Items["Slider"].Instance.Size = UDim2New(1,0,0,10)
                Items["Text"].Instance.Parent = Items["RealSlider"].Instance
                Items["Text"].Instance.Position = UDim2New(0,0,0,-2)
                Items["Text"].Instance.TextXAlignment = Enum.TextXAlignment.Center
            end

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["RealSlider"]:OnHoverLeave(function()
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Background"]})
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            end)
        end

        function Slider:Set(Value)
            Slider.Value = MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max)

            Library.Flags[Slider.Flag] = Slider.Value
            
            local Suffix = tostring(Slider.Suffix or "")
            if #Suffix > 32 then
                Suffix = ""
            end
            if Slider.Compact then
                Items["Text"].Instance.Text = `{Slider.Name}: {Slider.Value}{Suffix}`
            else
                Items["Value"].Instance.Text = `{Slider.Value}{Suffix}`
            end

            Items["Indicator"]:Tween(TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})

            if Slider.Callback then 
                Library:SafeCall(Slider.Callback, Slider.Value)
            end
        end

        function Slider:Get()
            return Slider.Value
        end

        function Slider:SetVisibility(Bool)
            Items["Slider"].Instance.Visible = Bool
        end

        local ValueInput = AttachSliderInput(Slider, Items["RealSlider"].Instance)

        Items["RealSlider"]:Connect("MouseButton1Down", function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                ValueInput:Open()
                return
            end

            Slider.Sliding = true

            local MousePos = UserInputService:GetMouseLocation()

            local SizeX = (MousePos.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
            local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

            Slider:Set(Value)
        end)

        Items["RealSlider"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Slider.Sliding = false
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement and Slider.Sliding then
                local MousePos = UserInputService:GetMouseLocation()

                local SizeX = (MousePos.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                Slider:Set(Value)
            end
        end)

        if Slider.Default then
            Slider:Set(Slider.Default)
        end

        Library.SetFlags[Slider.Flag] = function(Value)
            Slider:Set(Value)
        end

        Library:RememberDefault(Slider.Flag)
        return Slider
    end

    Library.Sections.Dropdown = function(self, Data)
        Data = Data or { }

        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Dropdown",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or { "One", "Two", "Three" },
            Default = Data.Default or Data.default or nil,
            Callback = Data.Callback or Data.callback or function() end,
            Multi = Data.Multi or Data.multi or false,

            Value = { },
            IsOpen = false,
            Options = { },
            Class = "Dropdown",
        }

        local Items = { } do
            Items["Dropdown"] = Instances:Create("Frame", {
                Parent = Dropdown.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 34),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Dropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Dropdown.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["RealDropdown"] = Instances:Create("Frame", {
                Parent = Items["Dropdown"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 17),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["RealDropdown"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["RealDropdown"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Open"] = Instances:Create("TextButton", {
                Parent = Items["RealDropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "+",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2New(0, -4, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Open"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Open"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"}) 
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealDropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "--",
                Name = "\0",
                Size = UDim2New(1, -25, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2New(0, 5, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Value"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["OptionHolder"] = Instances:Create("ScrollingFrame", {
                Parent = Library.Holder.Instance,
                Visible = false,
                BorderColor3 = FromRGB(10, 10, 10),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                Size = UDim2New(0, 100, 0, 0),
                BorderSizePixel = 2,
                Active = true,
                CanvasSize = UDim2New(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                ElasticBehavior = Enum.ElasticBehavior.Never,
                ScrollBarThickness = 1,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})
            Library:ApplyScrollbar(Items["OptionHolder"].Instance, 1)
            
            Instances:Create("UIStroke", {
                Parent = Items["OptionHolder"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})

            Instances:Create("UIListLayout", {
                Parent = Items["OptionHolder"].Instance,
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["OptionHolder"].Instance,
                PaddingBottom = UDimNew(0, 2)
            })

            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["RealDropdown"]:OnHoverLeave(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Background"]})
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            end)
        end

        function Dropdown:Set(Option)
            if Dropdown.Multi then 
                if type(Option) ~= "table" then 
                    return
                end

                Dropdown.Value = Option

                for Index, Value in Option do 
                    local OptionData = Dropdown.Options[Value]
                    
                    if not OptionData then 
                        return
                    end

                    OptionData.Selected = true
                    OptionData:Toggle("Active")
                end

                Library.Flags[Dropdown.Flag] = Dropdown.Value

                Items["Value"].Instance.Text = TableConcat(Option, ", ")
            else
                if not Dropdown.Options[Option] then 
                    return
                end

                local OptionData = Dropdown.Options[Option]

                Dropdown.Value = OptionData.Name

                OptionData.Selected = true
                OptionData:Toggle("Active")

                for Index, Value in Dropdown.Options do 
                    if Value ~= OptionData then 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end
                end

                Library.Flags[Dropdown.Flag] = Dropdown.Value

                Items["Value"].Instance.Text = Option
            end

            if Dropdown.Callback then 
                Library:SafeCall(Dropdown.Callback, Option)
            end
        end

        function Dropdown:Get()
            return Dropdown.Value
        end

        function Dropdown:SetVisibility(Bool)
            Items["Dropdown"].Instance.Visible = Bool
        end

        function Dropdown:Add(Option)
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["OptionHolder"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(210, 210, 210),
                TextTransparency = 0.48,
                Text = Option,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, 0),
                Position = UDim2New(0, 5, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 5,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            OptionText:AddToTheme({TextColor3 = "Inactive Text"})

            Instances:Create("UIStroke", {
                Parent = OptionText.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            local OptionData = {
                Selected = false,
                Active = false,
                Name = Option,
                Text = OptionText,
                Button = OptionButton,
                Hovering = false
            }

            local function ApplyOptionOffset()
                local Pad = 5
                if OptionData.Active then
                    Pad = 11
                elseif OptionData.Hovering then
                    Pad = 9
                end
                OptionText:Tween(nil, {Position = UDim2New(0, Pad, 0, 0), Size = UDim2New(1, -Pad, 1, 0)})
            end

            function OptionData:Toggle(State)
                OptionData.Active = State == "Active"
                OptionData.Text:ChangeItemTheme({TextColor3 = OptionData.Active and "Text" or "Inactive Text"})
                OptionData.Text:Tween(nil, {TextTransparency = 0})
                ApplyOptionOffset()
            end

            function OptionData:Set()
                OptionData.Selected = not OptionData.Selected

                if Dropdown.Multi then
                    local Index = TableFind(Dropdown.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Dropdown.Value, Index)
                    else
                        TableInsert(Dropdown.Value, OptionData.Name)
                    end

                    Library.Flags[Dropdown.Flag] = Dropdown.Value

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"

                    Items["Value"].Instance.Text = TextFormat
                else
                    if OptionData.Selected then
                        Dropdown.Value = OptionData.Name

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        OptionData:Toggle("Active")
                        Items["Value"].Instance.Text = OptionData.Name

                        for Index, Value in Dropdown.Options do 
                            if Value ~= OptionData then 
                                Value.Selected = false
                                Value:Toggle("Inactive")
                            end
                        end
                    else
                        Dropdown.Value = nil

                        OptionData:Toggle("Inactive")
                        Items["Value"].Instance.Text = "--"
                    end
                end

                if Dropdown.Callback then 
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            OptionButton:OnHover(function()
                OptionData.Hovering = true
                ApplyOptionOffset()
            end)

            OptionButton:OnHoverLeave(function()
                OptionData.Hovering = false
                ApplyOptionOffset()
            end)

            OptionButton:Connect("MouseButton1Down", function()
                OptionData:Set()
            end)

            Dropdown.Options[Option] = OptionData
            return OptionData
        end

        function Dropdown:Remove(Option)
            if Dropdown.Options[Option] then 
                Dropdown.Options[Option].Button:Clean()
            end
        end

        function Dropdown:Refresh(List)
            for Index, Value in Dropdown.Options do 
                Dropdown:Remove(Value.Name)
            end

            for Index, Value in List do 
                Dropdown:Add(Value)
            end
        end

        local Follow

        function Dropdown:SetOpen(Bool)
            Dropdown.IsOpen = Bool

            if Follow then
                Follow:Disconnect()
                Follow = nil
            end

            local Holder = Items["OptionHolder"].Instance

            if Bool then 
                if Library.CurrentDropdown and Library.CurrentDropdown ~= Dropdown then
                    Library.CurrentDropdown:SetOpen(false)
                end
                Library.CurrentDropdown = Dropdown

                Items["Open"].Instance.Text = "-"
                Items["Open"].Instance.Position = UDim2New(0, -5, 0, -1)

                SetZ(Holder, 10020)

                local Count = 0
                for _ in Dropdown.Options do
                    Count += 1
                end
                local Height = math.min(Count, 15) * 15 + 2

                Follow = FollowAnchor(Holder, Items["RealDropdown"].Instance, function(Anchor)
                    Holder.Size = UDim2New(0, Anchor.AbsoluteSize.X, 0, Height)
                    return UDim2New(0, Anchor.AbsolutePosition.X, 0, Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + 5)
                end, function()
                    Dropdown:SetOpen(false)
                end)
            else
                Items["Open"].Instance.Text = "+"
                Items["Open"].Instance.Position = UDim2New(0, -4, 0, -1)

                if Library.CurrentDropdown == Dropdown then
                    Library.CurrentDropdown = nil
                end
            end

            Holder.Visible = Bool and Dropdown.IsOpen
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType ~= Enum.UserInputType.MouseButton1 or not Dropdown.IsOpen then
                return
            end

            if Library:IsMouseOverFrame(Items["OptionHolder"]) or Library:IsMouseOverFrame(Items["RealDropdown"]) then
                return
            end

            Dropdown:SetOpen(false)
        end)

        for Index, Value in Dropdown.Items do 
            Dropdown:Add(Value)
        end

        Items["Open"]:Connect("MouseButton1Down", function()
            Dropdown:SetOpen(not Dropdown.IsOpen)
        end)

        if Dropdown.Default then 
            Dropdown:Set(Dropdown.Default)
        end

        Library.SetFlags[Dropdown.Flag] = function(Value)
            Dropdown:Set(Value)            
        end

        Library:RememberDefault(Dropdown.Flag)
        return Dropdown
    end

    Library.Sections.Label = function(self, Data)
        Data = Data or { }

        local Label = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name,
            Alignment = Data.Alignment or Data.alignment or "Left",

            Count = 0
        }

        local Items = { } do 
            Items["Label"] = Instances:Create("Frame", {
                Parent = Label.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Label"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Label.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment[Label.Alignment],
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
            }):AddToTheme({Color = "Text Border"})

            Items["Text"].Instance.RichText = true
        end

        function Label:SetText(Text)
            Label.Name = Text
            Items["Text"].Instance.Text = Text
        end

        function Label:SetVisibility(Bool)
            Items["Label"].Instance.Visible = Bool
        end

        function Label:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Label"],
                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or false,
                Count = Label.Count,
                FadeSpeed = self.Window.FadeSpeed
            }

            Label.Count += 1
            Colorpicker.Count = Label.Count

            local Extension = Library:CreateColorpicker(Colorpicker)
            
            return Colorpicker, Extension
        end

        function Label:Keybind(Data)
            Data = Data or { }

            local Hitbox = Instances:Create("TextButton", {
                Parent = Items["Label"].Instance,
                Name = "\0",
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 0,
                Size = UDim2New(1, 0, 1, 0),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            local Callback = Data.Callback or Data.callback

            local Bind = AttachBind({
                Name = Label.Name,
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Button = Hitbox.Instance,
                Label = Items["Text"],
                ShowModes = false,
                KeyList = false,
                DefaultKey = Data.Default or Data.default,
                OnKey = function(Key)
                    if Callback then
                        Library:SafeCall(Callback, Key)
                    end
                end
            })

            Label.Bind = Bind
            return Label, Bind
        end

        return Label
    end

    Library.Sections.Textbox = function(self, Data)
        Data = Data or { }

        local Textbox = {
            Window = self.Window,
            Tab = self.Tab,
            Section = self,

            Name = Data.Name or Data.name or "Textbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Placeholder = Data.Placeholder or Data.placeholder or "...",
            Default = Data.Default or Data.default or "",
            Callback = Data.Callback or Data.callback or function() end,

            Value = "",
            Class = "Textbox"
        }

        local Items = { } do 
            Items["Textbox"] = Instances:Create("Frame", {
                Parent = Textbox.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 34),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Textbox"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Textbox.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Background"] = Instances:Create("Frame", {
                Parent = Items["Textbox"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 17),
                BorderSizePixel = 2,
                ClipsDescendants = true,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Background"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Background"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Background"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Inline"] = Instances:Create("TextBox", {
                Parent = Items["Background"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                BackgroundTransparency = 1,
                PlaceholderColor3 = FromRGB(178, 178, 178),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = false,
                ClipsDescendants = true,
                PlaceholderText = Textbox.Placeholder,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Inline"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Inline"].Instance,
                PaddingBottom = UDimNew(0, 3),
                PaddingLeft = UDimNew(0, 5),
                PaddingRight = UDimNew(0, 5)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Inline"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Background"]:OnHover(function()
                Items["Background"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Background"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["Background"]:OnHoverLeave(function()
                Items["Background"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Background"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end)
        end

        function Textbox:Get()
            return Textbox.Value
        end

        function Textbox:SetVisibility(Bool)
            Items["Textbox"].Instance.Visible = Bool
        end

        function Textbox:Set(Value)
            Textbox.Value = Value
            
            Items["Inline"].Instance.Text = Textbox.Value
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Text"})

            Library.Flags[Textbox.Flag] = Textbox.Value

            if Textbox.Callback then
                Library:SafeCall(Textbox.Callback, Textbox.Value)
            end
        end

        Items["Inline"]:Connect("Focused", function()
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Accent"})
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
        end)

        Items["Inline"]:Connect("FocusLost", function()
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Text})

            Textbox:Set(Items["Inline"].Instance.Text)
        end)

        if Textbox.Default then
            Textbox:Set(Textbox.Default)
        end

        Library.SetFlags[Textbox.Flag] = function(Value)
            Textbox:Set(Value)
        end

        Library:RememberDefault(Textbox.Flag)
        return Textbox
    end
    
    Library.Sections.Listbox = function(self, Data)
        Data = Data or {}

        local Listbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Items = Data.Items or Data.items or { },
            Multi = Data.Multi or Data.multi or false,
            Default = Data.Default or Data.default or 1,
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Callback = Data.Callback or Data.callback or function() end,
            RightClick = Data.RightClick,
            Size = Data.Size or Data.size or 175,

            Value = { },
            Options = { },
            Class = "Listbox",
        }

        local Items = { } do 
            Items["Listbox"] = Instances:Create("Frame", {
                Parent = Listbox.Section.Elements["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, Listbox.Size),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["RealListbox"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Listbox"].Instance,
                ScrollBarImageColor3 = FromRGB(96, 126, 255),
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                AnchorPoint = Vector2New(0, 1),
                Size = UDim2New(1, 0, 1, 0),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BackgroundColor3 = FromRGB(15, 15, 20),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 2,
                CanvasSize = UDim2New(0, 0, 0, 0)
            })  Items["RealListbox"]:AddToTheme({ScrollBarImageColor3 = "Accent", BackgroundColor3 = "Background", BorderColor3 = "Border"})
            Library:ApplyScrollbar(Items["RealListbox"].Instance, 1)
            
            Instances:Create("UIStroke", {
                Parent = Items["RealListbox"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"}) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["RealListbox"].Instance,
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Instances:Create("UIPadding", {
                Parent = Items["RealListbox"].Instance,
                PaddingBottom = UDimNew(0, 5),
                PaddingTop = UDimNew(0, 2)
            }) 
        end

        function Listbox:Set(Option)
            if Listbox.Multi then 
                if type(Option) ~= "table" then 
                    return
                end

                Listbox.Value = Option

                Library.Flags[Listbox.Flag] = Listbox.Value

                for Index, Value in Option do 
                    local OptionData = Listbox.Options[Value]
                    
                    if not OptionData then 
                        return
                    end

                    OptionData.Selected = true
                    OptionData:Toggle("Active")
                end
            else
                if not Listbox.Options[Option] then 
                    return
                end

                local OptionData = Listbox.Options[Option]

                Listbox.Value = OptionData.Name
                
                Library.Flags[Listbox.Flag] = Listbox.Value

                OptionData.Selected = true
                OptionData:Toggle("Active")

                for Index, Value in Listbox.Options do 
                    if Value ~= OptionData then 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end
                end
            end

            if Listbox.Callback then 
                Library:SafeCall(Listbox.Callback, Option)
            end
        end

        function Listbox:Get()
            return Listbox.Value
        end

        function Listbox:SetVisibility(Bool)
            Items["Listbox"].Instance.Visible = Bool
        end

        function Listbox:Remove(Option)
            if Listbox.Options[Option] then 
                Listbox.Options[Option].Button:Clean()
                Listbox.Options[Option] = nil
            end
        end

        function Listbox:Refresh(List)
            for Index, Value in Listbox.Options do 
                Listbox:Remove(Value.Name)
            end

            for Index, Value in List do 
                Listbox:Add(Value)
            end
        end

        function Listbox:Add(Option)
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["RealListbox"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.48,
                Text = Option,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -8, 1, 0),
                Position = UDim2New(0, 8, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                BorderSizePixel = 0,
                ZIndex = 5,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            OptionText:AddToTheme({TextColor3 = "Inactive Text"})

            Instances:Create("UIStroke", {
                Parent = OptionText.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            local OptionData = {
                Selected = false,
                Name = Option,
                Text = OptionText,
                Button = OptionButton
            }

            function OptionData:Toggle(State)
                OptionData.Text:ChangeItemTheme({TextColor3 = State == "Active" and "Text" or "Inactive Text"})
                OptionData.Text:Tween(nil, {TextTransparency = 0})
            end

            OptionButton:OnHover(function()
                if not OptionData.Selected then
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Text"})
                end
            end)

            OptionButton:OnHoverLeave(function()
                if not OptionData.Selected then
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Inactive Text"})
                end
            end)

            function OptionData:Set()
                OptionData.Selected = not OptionData.Selected

                if Listbox.Multi then
                    local Index = TableFind(Listbox.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Listbox.Value, Index)
                    else
                        TableInsert(Listbox.Value, OptionData.Name)
                    end

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    local TextFormat = #Listbox.Value > 0 and TableConcat(Listbox.Value, ", ") or "--"
                else
                    if OptionData.Selected then
                        Listbox.Value = OptionData.Name

                        OptionData:Toggle("Active")

                        for Index, Value in Listbox.Options do 
                            if Value ~= OptionData then 
                                Value.Selected = false
                                Value:Toggle("Inactive")
                            end
                        end
                    else
                        Listbox.Value = nil

                        OptionData:Toggle("Inactive")
                    end
                end

                if Listbox.Callback then 
                    Library:SafeCall(Listbox.Callback, Listbox.Value)
                end
            end

            OptionButton:Connect("MouseButton1Down", function()
                OptionData:Set()
            end)

            OptionButton:Connect("MouseButton2Click", function()
                if Listbox.RightClick then
                    Library:SafeCall(Listbox.RightClick, OptionData.Name)
                end
            end)

            Listbox.Options[Option] = OptionData
            return OptionData
        end

        for Index, Value in Listbox.Items do 
            Listbox:Add(Value)
        end

        if Listbox.Default then 
            Listbox:Set(Listbox.Default)
        end

        function Listbox:SetSize(Height)
            Listbox.Size = Height
            Items["Listbox"].Instance.Size = UDim2New(1, 0, 0, Height)
        end

        Library.SetFlags[Listbox.Flag] = function(Value)
            Listbox:Set(Value)
        end

        Library:RememberDefault(Listbox.Flag)
        return Listbox
    end

    Library.CloneRef = CloneRef
    Library.LocalPlayer = LocalPlayer
    Library.Services = {
        Players = Players, Workspace = Workspace, Lighting = Lighting, RunService = RunService,
        UserInputService = UserInputService, TweenService = TweenService, HttpService = HttpService,
        GuiService = GuiService, MarketplaceService = MarketplaceService, CoreGui = CoreGui
    }

    Library.GetService = function(self, Name)
        local Service = Library.Services[Name]
        if not Service then
            Service = GetService(Name)
            Library.Services[Name] = Service
        end
        return Service
    end
end

getgenv().Library = Library
return Library

