Sharky = Sharky or {}

/*--------------------
      Misc Stuff
--------------------*/
Sharky.DisconnectEffectEnabled = true

Sharky.SpawnSoundEnabled = true
Sharky.SpawnSound = 'sound/sharky/return_by_death.mp3'

Sharky.DisabledSpawnTabs = {
      ['Spawnlists'] = false,
      ['Weapons'] = false,
      ['Entities'] = false,
      ['NPCs'] = true,
      ['Vehicles'] = true,
      ['Post Process'] = true,
      ['Dupes'] = true,
      ['Saves'] = true,
}

Sharky.SoundEnabled = true
Sharky.ClickSound = 'sound/sharky/buttonclick.mp3'
Sharky.HoverSound = 'sound/sharky/buttonhover.mp3'
Sharky.UnHoverSound = 'sound/sharky/buttonunhover.mp3'

Sharky.PanelCloseMode = CreateClientConVar('sharky_panelclosemode', '0', true)
Sharky.MusicEnabled = CreateClientConVar('sharky_musicenabled', '0', true)
Sharky.RoundedUI = CreateClientConVar('sharky_roundedcorners', '8', true)

/*--------------------
      UI Config
--------------------*/

/*General Colors*/
Sharky.ColorTheme = Color(143, 64, 245) -- Color accent used for every main color
Sharky.BGColor = Color(65, 65, 65)
Sharky.BGColor2 = Color(50, 50, 50)
Sharky.BGColor3 = Color(35, 35, 35)
Sharky.BGColor4 = Color(20, 20, 20)
Sharky.TextColor = Color(255, 255, 255)
Sharky.DisabledTextColor = Color(152, 152, 152)

Sharky.Rainbow = color_white

hook.Add('Think', 'Sharky:RainbowColorThink', function()
      Sharky.Rainbow = HSVToColor(SysTime()*60%360, 1, 1)
end)

/*Button Type Colors*/
Sharky.HoverColor = Color(255, 255, 255, 0)

/*Checkbox Colors*/
Sharky.CheckBoxCheckColor = Sharky.ColorTheme
Sharky.CheckBoxBGColor = Sharky.BGColor3

/*Dropdown Colors*/
Sharky.ComboBoxHamburgerColor = Sharky.BGColor
Sharky.ComboBoxHamburgerColor2 = Sharky.ColorTheme
Sharky.ComboBoxLineColor = Sharky.ColorTheme

/*Scroller Colors*/
Sharky.ScrollerButtonColor = Sharky.ColorTheme
Sharky.ScrollerColor = Sharky.BGColor3

/*Text Entry Colors*/
Sharky.TextEntryBGColor = Color(25, 25, 25, 255)
Sharky.TextEntryCursorColor = Color(255, 255, 255)
Sharky.TextEntryHighlightColor = ColorAlpha(Sharky.ColorTheme, 100)
Sharky.TextEntryIndicatorColor = Color(255, 255, 255)
Sharky.TextEntryIndicatorColorNotSaved = Color(255, 150, 150)

/*Slider Colors*/
Sharky.SliderBGColor = Sharky.BGColor3
Sharky.SliderDotColor = Sharky.ColorTheme

/*Property Sheet Colors*/
Sharky.PSTabInactiveColor = ColorAlpha(Sharky.BGColor3, 0)
Sharky.PSTabActiveColor = Sharky.BGColor3
Sharky.PSTabHoverColor = Sharky.HoverColor
Sharky.PSUnderlineDefaultColor = Color(255, 255, 255)
Sharky.PSUnderlineActiveColor = Sharky.ColorTheme

/*Color Picker Options*/
Sharky.ColorPickerGradient = Material('sharky/gradient.png', 'smooth mips')
Sharky.ColorPickerWheel = Material('sharky/colorwheel.png', 'smooth mips')
Sharky.ColorPickerPicker = Material('sharky/picker.png', 'smooth mips')