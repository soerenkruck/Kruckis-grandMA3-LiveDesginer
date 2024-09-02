local function main(displayHandle, args)
  gSelect = GetGroup(displayHandle)
  if gSelect then
    Printf("Selected Group:"..gSelect)
  end
  CreateBumpEditorLayout(displayHandle)
end

local colorTransparent = Root().ColorTheme.ColorGroups.Global.Transparent
local colorBackground = Root().ColorTheme.ColorGroups.Button.Background
local colorBackgroundPlease = Root().ColorTheme.ColorGroups.Button.BackgroundPlease
local colorPartlySelected = Root().ColorTheme.ColorGroups.Global.PartlySelected
local colorPartlySelectedPreset = Root().ColorTheme.ColorGroups.Global.PartlySelectedPreset
local colorFades = colorPartlySelectedPreset
local colorDelay = Root().ColorTheme.ColorGroups.Clock.Fixed

local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable = select(3, ...)
local myHandle = select(4, ...)

gSelect = 1
currentPreset = 1
local MAtricksIndex = 1

Preset = {
  fadeFromXVal = 0,
  fadeToXVal = 0,

  delayFromXVal = 0,
  delayToXVal = 0,

  wingsState = false,
  phaseDirectionState = false,
  phaseState = false
}

UIElement = {
  FadeFromXInput,
  FadeToXInput,
  DelayFromXInput,
  DelayToXInput,
  wingsCheckBox,
  phaseDirectionCheckBox,
  phaseCheckBox
}

function UIElement:new(dlgFrame)
  PresetSelector(dlgFrame)
  -- Create the checkbox grid.
  -- This is row 2 of the dlgFrame.
  function CreateCheckBoxGrid(inFrame)
    local checkBoxGrid = inFrame:Append("UILayoutGrid")
    checkBoxGrid.Columns = 3
    checkBoxGrid.Rows = 2
    checkBoxGrid.Anchors = {
      left = 0,
      right = 0,
      top = 1,
      bottom = 1
    }
    checkBoxGrid.Margin = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 5
    }

    local subTitle = checkBoxGrid:Append("UIObject")
    subTitle.Text = "Options"
    subTitle.ContentDriven = "Yes"
    subTitle.ContentWidth = "No"
    subTitle.TextAutoAdjust = "No"
    subTitle.TextalignmentH = "Left"
    subTitle.Anchors = {
      left = 0,
      right = 1,
      top = 0,
      bottom = 0
    }
    subTitle.Padding = {
      left = 20,
      right = 20,
      top = 15,
      bottom = 15
    }
    subTitle.Font = "Medium20"
    subTitle.HasHover = "No"
    subTitle.Visible = "Yes"
    subTitle.BackColor = colorTransparent

    local checkBox1 = checkBoxGrid:Append("CheckBox")
    checkBox1.Anchors = {
      left = 0,
      right = 0,
      top = 1,
      bottom = 1
    }
    checkBox1.Text = "Wings"
    checkBox1.TextalignmentH = "Left"
    checkBox1.State = 0
    checkBox1.PluginComponent = myHandle
    checkBox1.Clicked = "WingsClicked"

    local checkBox2 = checkBoxGrid:Append("CheckBox")
    checkBox2.Anchors = {
      left = 1,
      right = 1,
      top = 1,
      bottom = 1
    }
    checkBox2.Text = "Phase Direction"
    checkBox2.TextalignmentH = "Left"
    checkBox2.State = 0
    checkBox2.PluginComponent = myHandle
    checkBox2.Clicked = "PhaseDirectionClicked"

    local checkBox3 = checkBoxGrid:Append("CheckBox")
    checkBox3.Anchors = {
      left = 2,
      right = 2,
      top = 1,
      bottom = 1
    }
    checkBox3.Text = "Phase On/Off"
    checkBox3.TextalignmentH = "Left"
    checkBox3.State = 0
    checkBox3.PluginComponent = myHandle
    checkBox3.Clicked = "PhaseClicked"

    self.wingsCheckBox = checkBox1
    self.phaseDirectionCheckBox = checkBox2
    self.phaseCheckBox = checkBox3
  end
  CreateCheckBoxGrid(dlgFrame)

  -- Create the inputs grid.
  -- This is row 2 of the dlgFrame.
  local inputsGrid = dlgFrame:Append("UILayoutGrid")
  inputsGrid.Columns = 11
  inputsGrid.Rows = 4
  inputsGrid.Anchors = {
    left = 0,
    right = 0,
    top = 2,
    bottom = 2
  }
  inputsGrid.Margin = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 5
  }
  inputsGrid[1][1].SizePolicy = "Fixed"
  inputsGrid[1][1].Size = "60"
  inputsGrid[1][2].SizePolicy = "Fixed"
  inputsGrid[1][2].Size = "120"
  inputsGrid[1][3].SizePolicy = "Fixed"
  inputsGrid[1][3].Size = "60"
  inputsGrid[1][4].SizePolicy = "Fixed"
  inputsGrid[1][4].Size = "120"

  local fadesTitle = inputsGrid:Append("UIObject")
  fadesTitle.Text = "Fades"
  fadesTitle.ContentDriven = "Yes"
  fadesTitle.ContentWidth = "No"
  fadesTitle.TextAutoAdjust = "No"
  fadesTitle.Anchors = {
    left = 0,
    right = 1,
    top = 0,
    bottom = 0
  }
  fadesTitle.Padding = {
    left = 20,
    right = 20,
    top = 15,
    bottom = 15
  }
  fadesTitle.Font = "Medium10"
  fadesTitle.HasHover = "No"
  fadesTitle.BackColor = colorTransparent

  ---
  -- Creates a grid for the input section for fade from x
  --
  -- @return A new grid for the input section
  function InputFadeFromX(inputsGrid)
    local GridFadeFromXInput = inputsGrid:Append("UILayoutGrid")
    GridFadeFromXInput.Columns = 5
    GridFadeFromXInput.Rows = 2
    GridFadeFromXInput.Anchors = {
      left = 0,
      right = 4,
      top = 1,
      bottom = 1
    }
    GridFadeFromXInput.Margin = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 5
    }

    local input1Icon = GridFadeFromXInput:Append("Button")
    input1Icon.Text = ""
    input1Icon.Anchors = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 1
    }
    input1Icon.Icon = "Time"
    input1Icon.BackColor = colorFades
    input1Icon.Margin = {
      left = 0,
      right = 2,
      top = 0,
      bottom = 2
    }
    input1Icon.HasHover = "No";

    local input1Label = GridFadeFromXInput:Append("UIObject")
    input1Label.Text = "From X"
    input1Label.TextalignmentH = "Left"
    input1Label.BackColor = colorFades
    input1Label.Anchors = {
      left = 1,
      right = 1,
      top = 0,
      bottom = 0
    }
    input1Label.Padding = "5,5"
    input1Label.Margin = {
      left = 2,
      right = 2,
      top = 0,
      bottom = 2
    }
    input1Label.HasHover = "No"

    local input1LineEdit = GridFadeFromXInput:Append("LineEdit")
    input1LineEdit.Margin = {
      left = 2,
      right = 0,
      top = 0,
      bottom = 2
    }
    input1LineEdit.Prompt = "Value: "
    input1LineEdit.TextAutoAdjust = "Yes"
    input1LineEdit.BackColor = colorFades
    input1LineEdit.Anchors = {
      left = 2,
      right = 4,
      top = 0,
      bottom = 0
    }
    input1LineEdit.Padding = "5,5"
    input1LineEdit.Filter = "0123456789."
    input1LineEdit.VkPluginName = "TextInputNumOnly"
    input1LineEdit.Content = fadeFromXVal
    input1LineEdit.MaxTextLength = 6
    input1LineEdit.HideFocusFrame = "Yes"
    input1LineEdit.PluginComponent = myHandle
    input1LineEdit.TextChanged = "OnInput1TextChanged"

    -- Add input to class
    self.FadeFromXInput = input1LineEdit

    local DecOneFromFadeFromX = GridFadeFromXInput:Append("Button")
    DecOneFromFadeFromX.Text = "-1s"
    DecOneFromFadeFromX.Anchors = {
      left = 1,
      right = 2,
      top = 1,
      bottom = 1
    }
    DecOneFromFadeFromX.Icon = ""
    DecOneFromFadeFromX.Margin = {
      left = 2,
      right = 4,
      top = 0,
      bottom = 2
    }
    DecOneFromFadeFromX.HasHover = "No";
    DecOneFromFadeFromX.PluginComponent = myHandle
    DecOneFromFadeFromX.Clicked = "buttonFadeFromXDec"

    local AddOneFadeFromX = GridFadeFromXInput:Append("Button")
    AddOneFadeFromX.Text = "+1s"
    AddOneFadeFromX.Anchors = {
      left = 3,
      right = 4,
      top = 1,
      bottom = 1
    }
    AddOneFadeFromX.Icon = ""
    AddOneFadeFromX.Margin = {
      left = 0,
      right = 2,
      top = 0,
      bottom = 2
    }
    AddOneFadeFromX.HasHover = "No";
    AddOneFadeFromX.PluginComponent = myHandle
    AddOneFadeFromX.Clicked = "buttonFadeFromXAdd"

    signalTable.buttonFadeFromXAdd = function(caller)
      input1LineEdit.Content = tonumber(input1LineEdit.Content) + 1
    end
    signalTable.buttonFadeFromXDec = function(caller)
      input1LineEdit.Content = tonumber(input1LineEdit.Content) - 1
      if tonumber(input1LineEdit.Content) < 0 then input1LineEdit.Content = "0" end
    end
  end
  function InputFadeToX(inputsGrid)
    local GridFadeFromXInput = inputsGrid:Append("UILayoutGrid")
    GridFadeFromXInput.Columns = 5
    GridFadeFromXInput.Rows = 2
    GridFadeFromXInput.Anchors = {
      left = 6,
      right = 10,
      top = 1,
      bottom = 1
    }
    GridFadeFromXInput.Margin = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 5
    }

    local input1Icon = GridFadeFromXInput:Append("Button")
    input1Icon.Text = ""
    input1Icon.BackColor = colorFades
    input1Icon.Anchors = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 1
    }
    input1Icon.Icon = "Time"
    input1Icon.Margin = {
      left = 0,
      right = 2,
      top = 0,
      bottom = 2
    }
    input1Icon.HasHover = "No";

    local input1Label = GridFadeFromXInput:Append("UIObject")
    input1Label.Text = "To X"
    input1Label.BackColor = colorFades
    input1Label.TextalignmentH = "Left"
    input1Label.Anchors = {
      left = 1,
      right = 1,
      top = 0,
      bottom = 0
    }
    input1Label.Padding = "5,5"
    input1Label.Margin = {
      left = 2,
      right = 2,
      top = 0,
      bottom = 2
    }
    input1Label.HasHover = "No"

    local input1LineEdit = GridFadeFromXInput:Append("LineEdit")
    input1LineEdit.Margin = {
      left = 2,
      right = 0,
      top = 0,
      bottom = 2
    }
    input1LineEdit.Prompt = "X: "
    input1LineEdit.BackColor = colorFades
    input1LineEdit.TextAutoAdjust = "Yes"
    input1LineEdit.Anchors = {
      left = 2,
      right = 4,
      top = 0,
      bottom = 0
    }
    input1LineEdit.Padding = "5,5"
    input1LineEdit.Filter = "0123456789."
    input1LineEdit.VkPluginName = "TextInputNumOnly"
    input1LineEdit.Content = fadeToXVal
    input1LineEdit.MaxTextLength = 6
    input1LineEdit.HideFocusFrame = "Yes"
    input1LineEdit.PluginComponent = myHandle
    input1LineEdit.TextChanged = "OnInput1TextChanged"

    -- Add input to class
    self.FadeToXInput = input1LineEdit

    local DecOneFromToFadeX = GridFadeFromXInput:Append("Button")
    DecOneFromToFadeX.Text = "-1s"
    DecOneFromToFadeX.Anchors = {
      left = 1,
      right = 2,
      top = 1,
      bottom = 1
    }
    DecOneFromToFadeX.Icon = ""
    DecOneFromToFadeX.Margin = {
      left = 2,
      right = 4,
      top = 0,
      bottom = 2
    }
    DecOneFromToFadeX.Clicked = "buttonFadeToXDec"
    DecOneFromToFadeX.HasHover = "No";
    DecOneFromToFadeX.PluginComponent = myHandle

    local AddOnToFadeToX = GridFadeFromXInput:Append("Button")
    AddOnToFadeToX.Text = "+1s"
    AddOnToFadeToX.Anchors = {
      left = 3,
      right = 4,
      top = 1,
      bottom = 1
    }
    AddOnToFadeToX.Icon = ""
    AddOnToFadeToX.Margin = {
      left = 0,
      right = 2,
      top = 0,
      bottom = 2
    }
    AddOnToFadeToX.HasHover = "No";
    AddOnToFadeToX.Clicked = "buttonFadeToXAdd"
    AddOnToFadeToX.PluginComponent = myHandle

    signalTable.buttonFadeToXAdd = function(caller)
      input1LineEdit.Content = tonumber(input1LineEdit.Content) + 1
    end
    signalTable.buttonFadeToXDec = function(caller)
      input1LineEdit.Content = tonumber(input1LineEdit.Content) - 1
      if tonumber(input1LineEdit.Content) < 0 then input1LineEdit.Content = "0" end
    end
  end

  function InputDelayFromX(inputsGrid)
    local GridFadeFromXInput = inputsGrid:Append("UILayoutGrid")
    GridFadeFromXInput.Columns = 5
    GridFadeFromXInput.Rows = 2
    GridFadeFromXInput.Anchors = {
      left = 0,
      right = 4,
      top = 3,
      bottom = 3
    }
    GridFadeFromXInput.Margin = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 5
    }

    local input1Icon = GridFadeFromXInput:Append("Button")
    input1Icon.Text = ""
    input1Icon.BackColor = colorDelay
    input1Icon.Anchors = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 1
    }
    input1Icon.Icon = "Time"
    input1Icon.Margin = {
      left = 0,
      right = 2,
      top = 0,
      bottom = 2
    }
    input1Icon.HasHover = "No";

    local input1Label = GridFadeFromXInput:Append("UIObject")
    input1Label.Text = "From X"
    input1Label.BackColor = colorDelay
    input1Label.TextalignmentH = "Left"
    input1Label.Anchors = {
      left = 1,
      right = 1,
      top = 0,
      bottom = 0
    }
    input1Label.Padding = "5,5"
    input1Label.Margin = {
      left = 2,
      right = 2,
      top = 0,
      bottom = 2
    }
    input1Label.HasHover = "No"

    local input1LineEdit = GridFadeFromXInput:Append("LineEdit")
    input1LineEdit.Margin = {
      left = 2,
      right = 0,
      top = 0,
      bottom = 2
    }
    input1LineEdit.Prompt = "Value: "
    input1LineEdit.TextAutoAdjust = "Yes"
    input1LineEdit.BackColor = colorDelay
    input1LineEdit.Anchors = {
      left = 2,
      right = 4,
      top = 0,
      bottom = 0
    }
    input1LineEdit.Padding = "5,5"
    input1LineEdit.Filter = "0123456789."
    input1LineEdit.VkPluginName = "TextInputNumOnly"
    input1LineEdit.Content = delayFromXVal
    input1LineEdit.MaxTextLength = 6
    input1LineEdit.HideFocusFrame = "Yes"
    input1LineEdit.PluginComponent = myHandle
    input1LineEdit.TextChanged = "OnInput1TextChanged"

    -- Add input to class
    self.DelayFromXInput = input1LineEdit

    local DecOneFromInputDelayFromX = GridFadeFromXInput:Append("Button")
    DecOneFromInputDelayFromX.Text = "-1s"
    DecOneFromInputDelayFromX.Anchors = {
      left = 1,
      right = 2,
      top = 1,
      bottom = 1
    }
    DecOneFromInputDelayFromX.Icon = ""
    DecOneFromInputDelayFromX.Margin = {
      left = 2,
      right = 4,
      top = 0,
      bottom = 2
    }
    DecOneFromInputDelayFromX.HasHover = "No";
    DecOneFromInputDelayFromX.PluginComponent = myHandle
    DecOneFromInputDelayFromX.Clicked = "buttonDelayFromXDec"

    local AddOneDelayFromX = GridFadeFromXInput:Append("Button")
    AddOneDelayFromX.Text = "+1s"
    AddOneDelayFromX.Anchors = {
      left = 3,
      right = 4,
      top = 1,
      bottom = 1
    }
    AddOneDelayFromX.Icon = ""
    AddOneDelayFromX.Margin = {
      left = 0,
      right = 2,
      top = 0,
      bottom = 2
    }
    AddOneDelayFromX.HasHover = "No";
    AddOneDelayFromX.PluginComponent = myHandle
    AddOneDelayFromX.Clicked = "buttonDelayFromXAdd"

    signalTable.buttonDelayFromXAdd = function(caller)
      input1LineEdit.Content = tonumber(input1LineEdit.Content) + 1
    end
    signalTable.buttonDelayFromXDec = function(caller)
      input1LineEdit.Content = tonumber(input1LineEdit.Content) - 1
      if tonumber(input1LineEdit.Content) < 0 then
        input1LineEdit.Content = "0"
      end
    end
  end
  function InputDelayToX(inputsGrid)
    local GridFadeToXInput = inputsGrid:Append("UILayoutGrid")
    GridFadeToXInput.Columns = 5
    GridFadeToXInput.Rows = 2
    GridFadeToXInput.Anchors = {
      left = 6,
      right = 10,
      top = 3,
      bottom = 3
    }
    GridFadeToXInput.Margin = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 5
    }

    local input1Icon = GridFadeToXInput:Append("Button")
    input1Icon.Text = ""
    input1Icon.BackColor = colorDelay
    input1Icon.Anchors = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 1
    }
    input1Icon.Icon = "Time"
    input1Icon.Margin = {
      left = 0,
      right = 2,
      top = 0,
      bottom = 2
    }
    input1Icon.HasHover = "No";

    local input1Label = GridFadeToXInput:Append("UIObject")
    input1Label.Text = "To X"
    input1Label.BackColor = colorDelay
    input1Label.TextalignmentH = "Left"
    input1Label.Anchors = {
      left = 1,
      right = 1,
      top = 0,
      bottom = 0
    }
    input1Label.Padding = "5,5"
    input1Label.Margin = {
      left = 2,
      right = 2,
      top = 0,
      bottom = 2
    }
    input1Label.HasHover = "No"

    local input1LineEdit = GridFadeToXInput:Append("LineEdit")
    input1LineEdit.Margin = {
      left = 2,
      right = 0,
      top = 0,
      bottom = 2
    }
    input1LineEdit.Prompt = "Value: "
    input1LineEdit.TextAutoAdjust = "Yes"
    input1LineEdit.BackColor = colorDelay
    input1LineEdit.Anchors = {
      left = 2,
      right = 4,
      top = 0,
      bottom = 0
    }
    input1LineEdit.Padding = "5,5"
    input1LineEdit.Filter = "0123456789."
    input1LineEdit.VkPluginName = "TextInputNumOnly"
    input1LineEdit.Content = delayToXVal
    input1LineEdit.MaxTextLength = 6
    input1LineEdit.HideFocusFrame = "Yes"
    input1LineEdit.PluginComponent = myHandle
    input1LineEdit.TextChanged = "OnInput1TextChanged"

    -- Add input to class
    self.DelayToXInput = input1LineEdit

    local DecOneToInputDelayToX = GridFadeToXInput:Append("Button")
    DecOneToInputDelayToX.Text = "-1s"
    DecOneToInputDelayToX.Anchors = {
      left = 1,
      right = 2,
      top = 1,
      bottom = 1
    }
    DecOneToInputDelayToX.Icon = ""
    DecOneToInputDelayToX.Margin = {
      left = 2,
      right = 4,
      top = 0,
      bottom = 2
    }
    DecOneToInputDelayToX.HasHover = "No";
    DecOneToInputDelayToX.PluginComponent = myHandle
    DecOneToInputDelayToX.Clicked = "buttonDelayToXDec"

    local AddOneDelayToX = GridFadeToXInput:Append("Button")
    AddOneDelayToX.Text = "+1s"
    AddOneDelayToX.Anchors = {
      left = 3,
      right = 4,
      top = 1,
      bottom = 1
    }
    AddOneDelayToX.Icon = ""
    AddOneDelayToX.Margin = {
      left = 0,
      right = 2,
      top = 0,
      bottom = 2
    }
    AddOneDelayToX.HasHover = "No";
    AddOneDelayToX.PluginComponent = myHandle
    AddOneDelayToX.Clicked = "buttonDelayToXAdd"

    signalTable.buttonDelayToXAdd = function(caller)
      input1LineEdit.Content = tonumber(input1LineEdit.Content) + 1
    end
    signalTable.buttonDelayToXDec = function(caller)
      input1LineEdit.Content = tonumber(input1LineEdit.Content) - 1
      if tonumber(input1LineEdit.Content) < 0 then
        input1LineEdit.Content = "0"
      end
    end
  end

  InputFadeFromX(inputsGrid)
  InputFadeToX(inputsGrid)

  local delayTitle = inputsGrid:Append("UIObject")
  delayTitle.Text = "Delay"
  delayTitle.ContentDriven = "Yes"
  delayTitle.ContentWidth = "No"
  delayTitle.TextAutoAdjust = "No"
  delayTitle.Anchors = {
    left = 0,
    right = 1,
    top = 2,
    bottom = 2
  }
  delayTitle.Padding = {
    left = 20,
    right = 20,
    top = 15,
    bottom = 15
  }
  delayTitle.Font = "Medium10"
  delayTitle.HasHover = "No"
  delayTitle.BackColor = colorTransparent

  InputDelayFromX(inputsGrid)
  InputDelayToX(inputsGrid)

  return self
end

uiElements = 0

function CreateBumpEditorLayout(displayHandle)

  MAtricksIndex = calcMATricksIndex()
  Printf("MAtricksIndex: "..MAtricksIndex.." - Group "..gSelect)

  -- Get the index of the display on which to create the dialog.
  local displayIndex = Obj.Index(GetFocusDisplay())
  if displayIndex > 5 then
    displayIndex = 1
  end
  -- Get the overlay.
  local display = Root().GraphicsRoot.PultCollect:Ptr(1).DisplayCollect:Ptr(displayIndex)
  local screenOverlay = display.ScreenOverlay

  -- Delete any UI elements currently displayed on the overlay.
  screenOverlay:ClearUIChildren()

  -- Create the dialog base.
  local dialogWidth = 900
  local baseInput = screenOverlay:Append("BaseInput")
  baseInput.Name = "DMXTesterWindow"
  baseInput.H = "0"
  baseInput.W = dialogWidth
  baseInput.MaxSize = string.format("%s,%s", display.W * 0.8, display.H)
  baseInput.MinSize = string.format("%s,0", dialogWidth - 100)
  baseInput.Columns = 1
  baseInput.Rows = 2
  baseInput[1][1].SizePolicy = "Fixed"
  baseInput[1][1].Size = "60"
  baseInput[1][2].SizePolicy = "Stretch"
  baseInput.AutoClose = "No"
  baseInput.CloseOnEscape = "Yes"

  -- Create the title bar.
  local titleBar = baseInput:Append("TitleBar")
  titleBar.Columns = 2
  titleBar.Rows = 1
  titleBar.Anchors = "0,0"
  titleBar[2][2].SizePolicy = "Fixed"
  titleBar[2][2].Size = "50"
  titleBar.Texture = "corner3"

  local titleBarIcon = titleBar:Append("TitleButton")
  titleBarIcon.Text = "Dialog Example"
  titleBarIcon.Texture = "corner1"
  titleBarIcon.Anchors = "0,0"
  titleBarIcon.Icon = "star"

  local titleBarCloseButton = titleBar:Append("CloseButton")
  titleBarCloseButton.Anchors = "1,0"
  titleBarCloseButton.Texture = "corner2"

  -- Create the dialog's main frame.
  local dlgFrame = baseInput:Append("DialogFrame")
  dlgFrame.H = "100%"
  dlgFrame.W = "100%"
  dlgFrame.Columns = 1
  dlgFrame.Rows = 4
  dlgFrame.Anchors = {
    left = 0,
    right = 0,
    top = 1,
    bottom = 1
  }
  dlgFrame[1][1].SizePolicy = "Fixed"
  dlgFrame[1][1].Size = "60"
  dlgFrame[1][2].SizePolicy = "Fixed"
  dlgFrame[1][2].Size = "120"
  dlgFrame[1][3].SizePolicy = "Fixed"
  dlgFrame[1][3].Size = "420"
  dlgFrame[1][4].SizePolicy = "Fixed"
  dlgFrame[1][4].Size = "60"

  uiElements = UIElement:new(dlgFrame)
  loadStatesAndValues()

  -- Create the button grid.
  -- This is row 3 of the dlgFrame.
  local buttonGrid = dlgFrame:Append("UILayoutGrid")
  buttonGrid.Columns = 2
  buttonGrid.Rows = 1
  buttonGrid.Anchors = {
    left = 0,
    right = 0,
    top = 3,
    bottom = 3
  }

  local applyButton = buttonGrid:Append("Button");
  applyButton.Anchors = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  }
  applyButton.Textshadow = 1;
  applyButton.HasHover = "Yes";
  applyButton.Text = "Apply";
  applyButton.Font = "Medium20";
  applyButton.TextalignmentH = "Centre";
  applyButton.PluginComponent = myHandle
  applyButton.Clicked = "ApplyButtonClicked"

  local cancelButton = buttonGrid:Append("Button");
  cancelButton.Anchors = {
    left = 1,
    right = 1,
    top = 0,
    bottom = 0
  }
  cancelButton.Textshadow = 1;
  cancelButton.HasHover = "Yes";
  cancelButton.Text = "Cancel";
  cancelButton.Font = "Medium20";
  cancelButton.TextalignmentH = "Centre";
  cancelButton.PluginComponent = myHandle
  cancelButton.Clicked = "CancelButtonClicked"
  cancelButton.Visible = "Yes"

  InputHandler()

end

function PresetSelector(dlgFrame, self)
  local PresetGrid = dlgFrame:Append("UILayoutGrid")
  PresetGrid.Columns = 3
  PresetGrid.Rows = 1
  PresetGrid.Anchors = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  }

  local ButtonPreset1 = PresetGrid:Append("Button");
  ButtonPreset1.Anchors = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  }
  ButtonPreset1.Textshadow = 1;
  ButtonPreset1.HasHover = "Yes";
  ButtonPreset1.Text = "Preset 1";
  ButtonPreset1.Font = "Medium20";
  ButtonPreset1.TextalignmentH = "Centre";
  ButtonPreset1.PluginComponent = myHandle
  ButtonPreset1.Clicked = "SelectPreset1"
  ButtonPreset1.Visible = "Yes"

  local ButtonPreset2 = PresetGrid:Append("Button");
  ButtonPreset2.Anchors = {
    left = 1,
    right = 1,
    top = 0,
    bottom = 0
  }
  ButtonPreset2.Textshadow = 1;
  ButtonPreset2.HasHover = "Yes";
  ButtonPreset2.Text = "Preset 2";
  ButtonPreset2.Font = "Medium20";
  ButtonPreset2.TextalignmentH = "Centre";
  ButtonPreset2.PluginComponent = myHandle
  ButtonPreset2.Clicked = "SelectPreset2"
  ButtonPreset2.Visible = "Yes"

  local ButtonPreset3 = PresetGrid:Append("Button");
  ButtonPreset3.Anchors = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 0
  }
  ButtonPreset3.Textshadow = 1;
  ButtonPreset3.HasHover = "Yes";
  ButtonPreset3.Text = "Preset 3";
  ButtonPreset3.Font = "Medium20";
  ButtonPreset3.TextalignmentH = "Centre";
  ButtonPreset3.PluginComponent = myHandle
  ButtonPreset3.Clicked = "SelectPreset3"
  ButtonPreset3.Visible = "Yes"
end

function InputHandler()
  signalTable.WingsClicked = function(caller)
    Printf("Checkbox '" .. caller.Text .. "' clicked. State = " .. caller.State)
    if (caller.State == 1) then
      caller.State = 0
    else
      caller.State = 1
    end
  end

  signalTable.PhaseDirectionClicked = function(caller)
    Printf("Checkbox '" .. caller.Text .. "' clicked. State = " .. caller.State)
    if (caller.State == 1) then
      caller.State = 0
    else
      caller.State = 1
    end
  end

  signalTable.PhaseClicked = function(caller)
    Printf("Checkbox '" .. caller.Text .. "' clicked. State = " .. caller.State)
    if (caller.State == 1) then
      caller.State = 0
    else
      caller.State = 1
    end
  end

  -- Handlers.
  signalTable.CancelButtonClicked = function(caller)
    Echo("Cancel button clicked.")
    Printf("Fenster geschlossen")
    Obj.Delete(screenOverlay, Obj.Index(baseInput))
  end

  signalTable.SelectPreset1 = function(caller)
    currentPreset = 1
    MAtricksIndex = calcMATricksIndex()
    loadStatesAndValues()
  end
  signalTable.SelectPreset2 = function(caller)
    currentPreset = 2
    MAtricksIndex = calcMATricksIndex()
    loadStatesAndValues()
  end
  signalTable.SelectPreset3 = function(caller)
    currentPreset = 3
    MAtricksIndex = calcMATricksIndex()
    loadStatesAndValues()
  end

  signalTable.ApplyButtonClicked = function(caller)
    apply()
  end
end

function GetGroup(displayHandle)
  local groups = {}
  for groupIndex = 1,2,1 do
    if DataPool().Groups[groupIndex] then
      groups[groupIndex] = DataPool().Groups[groupIndex].Name
      local g = DataPool().Groups[groupIndex].Name
      Printf("Added Group"..groupIndex.." \""..g)
    end
  end

  local descTable = {
    title = "Select Group",
    caller = displayHandle,
    items = groups,
    selectedValue = "Some",
    add_args = {FilterSupport="Yes"},
  }
  local a,b = PopupInput(descTable)
  return a
end
function calcMATricksIndex()
  local newIndex = gSelect * (currentPreset*2) - 1
  Printf("calculted index: "..newIndex)
  return newIndex
end
function loadStatesAndValues()
  Printf("Load new Preset")
  local loadedTrick = DataPool().MAtricks[MAtricksIndex]
  Preset.fadeFromXVal = tonumber(loadedTrick:Get("FadeFromX", Enums.Roles.Display)) or 0
  Preset.fadeToXVal = tonumber(loadedTrick:Get("FadeToX", Enums.Roles.Display)) or 0
  Preset.delayFromXVal = tonumber(loadedTrick:Get("DelayFromX", Enums.Roles.Display)) or 0
  Preset.delayToXVal = tonumber(loadedTrick:Get("DelayToX", Enums.Roles.Display)) or 0

  if (loadedTrick:Get("PhaseToX", Enums.Roles.Display) == "360°") then
    Preset.phaseState = 1
  else
    Preset.phaseState = 0
  end
  if loadedTrick:Get("PhaseToX", Enums.Roles.Display) == "0°" and loadedTrick:Get("PhaseFromX", Enums.Roles.Display) == "360°" then
    Preset.phaseDirectionState = 1
  else
    Preset.phaseDirectionState = 0
  end
  if loadedTrick:Get("XWings", Enums.Roles.Display) == "2" then
    Preset.wingsState = 1
  else
    Preset.wingsState = 0
  end

  uiElements.FadeFromXInput.Content = Preset.fadeFromXVal
  uiElements.FadeToXInput.Content = Preset.fadeToXVal
  uiElements.DelayFromXInput.Content = Preset.delayFromXVal
  uiElements.DelayToXInput.Content = Preset.delayToXVal

  uiElements.phaseCheckBox.State = Preset.phaseState
  uiElements.phaseDirectionCheckBox.State = Preset.phaseDirectionState
  uiElements.wingsCheckBox.State = Preset.wingsState

end
function saveTricks()
  local loadedTrick = DataPool().MAtricks[MAtricksIndex]
  loadedTrick:Set("FadeFromX", Preset.FadeFromX)
  loadedTrick:Set("FadeToX", Preset.FadeToX)
  loadedTrick:Set("DelayFromX", Preset.DelayFromX)
  loadedTrick:Set("DelayToX", Preset.DelayToX)

  if Preset.wingsState == 1 then
    loadedTrick:Set("XWings", 2)
  else
    loadedTrick:Set("XWings", "None")
  end
  if Preset.phaseState == 1 then
    if Preset.phaseDirectionState == 0 then
      loadedTrick:Set("PhaseFromX", "0°")
      loadedTrick:Set("PhaseToX", "360°")
    else
      loadedTrick:Set("PhaseFromX", "360°")
      loadedTrick:Set("PhaseToX", "0°")
    end
  else
    loadedTrick:Set("PhaseFromX", "0°")
    loadedTrick:Set("PhaseToX", "0°")
  end
end

function apply()
  Preset.FadeFromX = tonumber(uiElements.FadeFromXInput.Content)
  Preset.FadeToX = tonumber(uiElements.FadeToXInput.Content)
  Preset.DelayFromX = tonumber(uiElements.DelayFromXInput.Content)
  Preset.DelayToX = tonumber(uiElements.DelayToXInput.Content)
  Preset.wingsState = uiElements.wingsCheckBox.State
  Preset.phaseState = uiElements.phaseCheckBox.State
  Preset.phaseDirectionState = uiElements.phaseDirectionCheckBox.State
  saveTricks()
end
return main