local PANEL = {}

function PANEL:Init()
	self:SetDrawBorder(false)
	self:SetDrawBackground(false)
	self:SetTextColor(Sharky.TextColor)
	self:SetFont('Sharky.16')
	self:SetCursorColor(Sharky.ColorTheme)
	self:SetHighlightColor(Sharky.TextEntryHighlightColor)

	self.IndicatorColor = Color(255, 255, 255)

	--self:SetTooltipPanelOverride('Sharky.Tooltip')
	--self:SetTooltip(false)
end

function PANEL:IndicatorLayout()
	local FT = FrameTime()
	if self:HasFocus() then
		self.IndicatorColor = Sharky.LerpColor(5 * FT, self.IndicatorColor, Sharky.ColorTheme)
	else
		self.IndicatorColor = Sharky.LerpColor(5 * FT, self.IndicatorColor, Sharky.TextEntryIndicatorColor)
	end
end

function PANEL:Paint(w,h)
	self:IndicatorLayout()

    draw.RoundedBox(0, 0, 0, w, h, Sharky.TextEntryBGColor)

	draw.NoTexture()
	surface.SetDrawColor(self.IndicatorColor)
    surface.DrawRect(0, 4, 2, h-8)

	derma.SkinHook('Paint', 'TextEntry', self, w, h)
end

function PANEL:SetConVar(cvar)
	self.ConVar = cvar
	self:SetValue(cvar:GetString())
end

function PANEL:OnValueChange(value)
	if self.ConVar then
		self.ConVar:SetInt(tonumber(value))
	end
end

derma.DefineControl('Sharky.TextEntry', 'Custom themed text entry, should be themed around Pixits style.', PANEL, 'DTextEntry')