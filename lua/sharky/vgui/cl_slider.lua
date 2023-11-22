local PANEL = {}

    function PANEL:Init()
        self:SetText('')
        self.Fraction = 0

        self.Grip = vgui.Create('DButton', self)
        self.Grip:NoClipping(true)
        self.Grip:SetText('')
        self.Grip.Paint = nil

        self.Grip.OnCursorMoved = function(pnl, x, y)
            if not pnl.Depressed then return end

            x, y = pnl:LocalToScreen(x, y)
            x = self:ScreenToLocal(x, y)

            self.Fraction = math.Clamp(x / self:GetWide(), 0, 1)

            self:OnValueChanged(self.Fraction)
            self:InvalidateLayout()
        end
    end

    function PANEL:OnMousePressed()
        local w = self:GetWide()

        self.Fraction = math.Clamp(self:CursorPos() / w, 0, 1)
        self:OnValueChanged(self.Fraction)
        self:InvalidateLayout()
    end

    function PANEL:SetConVar(cvar)
        self.ConVar = cvar
        self:SetFraction(math.Remap(cvar:GetInt(), self.MinValue, self.MaxValue, 0, 1))
    end

    function PANEL:OnValueChanged(fraction)
        if self.ConVar then
            self.ConVar:SetInt(math.Remap(fraction, 0, 1, self.MinValue, self.MaxValue))
        end
    end

    function PANEL:SetFraction(fraction)
        self.Fraction = fraction
    end

    function PANEL:SetMin(min)
        self.MinValue = min
    end

    function PANEL:SetMax(max)
        self.MaxValue = max
    end
 
    function PANEL:Paint(w, h)
        local rounding = h * .5
        draw.RoundedBox(Sharky.RoundedUI:GetInt(), 0, 0, w, h, Sharky.BGColor)
        draw.RoundedBox(Sharky.RoundedUI:GetInt(), 0, 0, self.Fraction * w, h, Sharky.ColorTheme)
    end

    function PANEL:PerformLayout(w, h)
        self.Grip:SetSize(h, h)
        self.Grip:SetPos((self.Fraction * w) - (h * .5), 0)
    end

derma.DefineControl('Sharky.Slider', 'Custom themed slider, should be themed around Pixits style.', PANEL, 'DButton')


local PANEL = {}

    function PANEL:Init()
        self.slider = vgui.Create('Sharky.Slider', self)
        self.slider:Dock(LEFT)

        self.label = vgui.Create('Sharky.TextBox', self)
        self.label:Dock(FILL)

        self:DockMargin(Sharky.resFormat(5), Sharky.resFormat(5), Sharky.resFormat(5), Sharky.resFormat(5))
    end

    function PANEL:SetConVar(cvar)
        self.slider.ConVar = cvar
        self.slider:SetFraction(math.Remap(cvar:GetInt(), self.slider.MinValue, self.slider.MaxValue, 0, 1))
    end

    function PANEL:OnValueChanged(fraction)
        if self.slider.ConVar then
            self.slider.ConVar:SetInt(math.Remap(fraction, 0, 1, self.slider.MinValue, self.slider.MaxValue))
        end
    end

    function PANEL:SetFraction(fraction)
        self.slider.Fraction = fraction
    end

    function PANEL:SetMin(min)
        self.slider.MinValue = min
    end

    function PANEL:SetMax(max)
        self.slider.MaxValue = max
    end

    function PANEL:SetSliderWidth(width)
        self.slider:SetWide(width)
    end

    function PANEL:SetFont(strFont)
    	self.label:SetFont(strFont)
    end

    function PANEL:SetTextColor(col)
    	self.label:SetTextColor(col)
    end

    function PANEL:SetText(strText)
    	self.label:SetText(strText)
    end

    function PANEL:GetText()
    	return self.label:GetText()
    end

    function PANEL:Paint(w, h)
    end

    --[[function PANEL:PerformLayout()
    	self.slider:SetSize(self.slider:GetWide() or self:GetWide()/2, self:GetTall())
    	--self.slider:SetPos(0, math.floor((self:GetTall() - self.Button:GetTall() ) / 2))

    	self.Label:SizeToContents()
    	self.Label:SetPos(self.slider:GetWide(), 0)
        self.Label:SetSize(self:GetWide() - self.Button:GetWide(), self:GetTall())
    end]]

derma.DefineControl('Sharky.SliderLabel', 'Custom themed slider label, should be themed around Pixits style.', PANEL, 'DPanel')

local PANEL = {}

    function PANEL:Init()
        self.slider = vgui.Create('Sharky.Slider', self)
        self.slider:Dock(LEFT)
        self.slider:DockMargin(0, 0, Sharky.resFormat(5), 0)

        self.slider.OnValueChanged = function(pnl, value)
            if self.slider.ConVar then
                self.slider.ConVar:SetInt(math.Remap(value, 0, 1, self.slider.MinValue, self.slider.MaxValue))
                self.wang:SetValue(math.Round(math.Remap(value, 0, 1, self.slider.MinValue, self.slider.MaxValue)))
            end
        end

        self.wang = vgui.Create('Sharky.NumberWang', self)
        self.wang:Dock(LEFT)
        self.wang:SetWide(Sharky.resFormat(50))
        self.wang:HideWang()

        self.label = vgui.Create('Sharky.TextBox', self)
        self.label:Dock(FILL)

        self:DockMargin(Sharky.resFormat(5), Sharky.resFormat(5), Sharky.resFormat(5), Sharky.resFormat(5))
    end

    function PANEL:SetConVar(cvar)
        self.slider.ConVar = cvar
        self.wang:SetConVar(cvar)
        self.slider:SetFraction(math.Remap(cvar:GetInt(), self.slider.MinValue, self.slider.MaxValue, 0, 1))
    end

    function PANEL:SetFraction(fraction)
        self.slider.Fraction = fraction
    end

    function PANEL:SetMin(min)
        self.slider.MinValue = min
    end

    function PANEL:SetMax(max)
        self.slider.MaxValue = max
    end

    function PANEL:SetSliderWidth(width)
        self.slider:SetWide(width)
    end

    function PANEL:SetFont(strFont)
    	self.label:SetFont(strFont)
        self.wang:SetFont(strFont)
    end

    function PANEL:SetTextColor(col)
    	self.label:SetTextColor(col)
    end

    function PANEL:SetText(strText)
    	self.label:SetText(strText)
    end

    function PANEL:GetText()
    	return self.label:GetText()
    end

    function PANEL:Paint(w, h)
    end

    --[[function PANEL:PerformLayout()
    	self.slider:SetSize(self.slider:GetWide() or self:GetWide()/2, self:GetTall())
    	--self.slider:SetPos(0, math.floor((self:GetTall() - self.Button:GetTall() ) / 2))

    	self.Label:SizeToContents()
    	self.Label:SetPos(self.slider:GetWide(), 0)
        self.Label:SetSize(self:GetWide() - self.Button:GetWide(), self:GetTall())
    end]]

derma.DefineControl('Sharky.SliderLabelWang', 'Custom themed slider label with a wang, should be themed around Pixits style.', PANEL, 'DPanel')