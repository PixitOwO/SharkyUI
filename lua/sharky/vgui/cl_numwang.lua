local PANEL = {}

function PANEL:Init()
    self:SetNumeric(true)

    self.Min = 0
    self.Max = 100
    
    self.Increase = vgui.Create('Sharky.Button', self)
    self.Increase:SetText('+')
    self.Increase:SetGlint(false)
    self.Increase.DoClick = function()
        if self:GetDisabled() then return end
        if self:GetValue() + 1 > self.Max then return end
        self:SetValue(self:GetValue() + 1)
    end

    self.Decrease = vgui.Create('Sharky.Button', self)
    self.Decrease:SetText('-')
    self.Decrease:SetGlint(false)
    self.Decrease.DoClick = function()
        if self:GetDisabled() then return end
        if self:GetValue() - 1 < self.Min then return end
        self:SetValue(self:GetValue() - 1)
    end

    if self:GetDisabled() then
        self.Increase:SetDisabled(true)
        self.Decrease:SetDisabled(true)
    end
end

function PANEL:SetMin(min)
    self.Min = min
end

function PANEL:SetMax(max)
    self.Max = max
end

function PANEL:SetMinMax(min, max)
    self:SetMin(min)
    self:SetMax(max)
end

function PANEL:GetValue()
    return tonumber(self:GetText())
end

function PANEL:HideWang()
	self.Increase:Hide()
	self.Decrease:Hide()
end

function PANEL:SetValue(value)
    self:SetText(tostring(value))
end

function PANEL:PerformLayout()
    local size = self:GetTall()/2
    self.Increase:SetSize(size, size)
    self.Increase:SetPos(self:GetWide() - size, 0)

    self.Decrease:SetSize(size, size)
    self.Decrease:SetPos(self:GetWide() - size, self:GetTall() - size)
end

derma.DefineControl('Sharky.NumberWang', 'Custom themed numbe wang, should be themed around Pixits style.', PANEL, 'Sharky.TextEntry')