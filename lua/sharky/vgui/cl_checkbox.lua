local PANEL = {}

function PANEL:Init()
	self:SetText('')
	self:SetTooltipPanelOverride('Sharky.Tooltip')

    self.Overlay = ColorAlpha(Sharky.HoverColor, Sharky.HoverColor.a)
    self.OverlayA = self.Overlay.a

	self.CheckSize = 0

    self.HoverSize = 0

	self:DockMargin(Sharky.resFormat(5), Sharky.resFormat(5), Sharky.resFormat(5), Sharky.resFormat(5))
end

function PANEL:Paint(w, h)
	local FT = FrameTime()
	if self:IsHovered() then
		self.Overlay.a = Lerp(FT * 10, self.Overlay.a, self.OverlayA+25)
        self.HoverSize = Lerp(FT * 10, self.HoverSize, w*0.05)
	else
		self.Overlay.a = Lerp(FT * 10, self.Overlay.a, self.OverlayA)
        self.HoverSize = Lerp(FT * 10, self.HoverSize, 0)
	end

	if self:IsDown() then
        self.Overlay.a = Lerp(FT * 10, self.Overlay.a, self.OverlayA+100)
        if self:GetChecked() then
			self.CheckSize = Lerp(FT * 10, self.CheckSize, w/3-self.HoverSize-(w*0.05))
		else
			self.CheckSize = Lerp(FT * 10, self.CheckSize, (w*0.05))
		end
	else
		if self:GetChecked() then
			self.CheckSize = Lerp(FT * 10, self.CheckSize, w/3-self.HoverSize)
		else
			self.CheckSize = Lerp(FT * 10, self.CheckSize, 0)
		end
	end

    surface.SetDrawColor(Sharky.ColorTheme)
    Sharky.DrawCircle(w/2, h/2, w/2-self.HoverSize, 50)

    surface.SetDrawColor(self.Overlay)
    Sharky.DrawCircle(w/2, h/2, w/2-self.HoverSize, 50)

    surface.SetDrawColor(Sharky.CheckBoxBGColor)
    Sharky.DrawCircle(w/2, h/2, w/2-(w*0.025)-self.HoverSize, 50)

    surface.SetDrawColor(Sharky.CheckBoxCheckColor)
    Sharky.DrawCircle(w/2, h/2, self.CheckSize, 50)

    surface.SetDrawColor(self.Overlay)
    Sharky.DrawCircle(w/2, h/2, self.CheckSize, 50)
end

function PANEL:OnCursorEntered(val)
	Sharky.PlaySoundFile(Sharky.HoverSound, 0.1)
end

function PANEL:OnCursorExited(val)
	Sharky.PlaySoundFile(Sharky.UnHoverSound, 0.1)
end

-- Done like this instead of OnChange, because using a convar will play sound twice
function PANEL:OnDepressed()
	if !self:GetChecked() then
		Sharky.PlaySoundFile(Sharky.ClickSound, 0.1)
	end
end

derma.DefineControl('Sharky.CheckBox', '', PANEL, 'DCheckBox')

local PANEL = {}

function PANEL:Init()
	if self.Button then
		self.Button:Remove()
	end

	self.Button = vgui.Create('Sharky.CheckBox', self)

	if self.Label then
		self.Label:SetFont('Sharky.16')
		self.Label:SetTextColor(color_white)

		function self.Label:OnCursorEntered()
			if not self:GetDisabled() then
				Sharky.PlaySoundFile(Sharky.HoverSound, 0.1)
			end
		end

        function self.Label:OnCursorExited()
            if not self:GetDisabled() then
        	    Sharky.PlaySoundFile(Sharky.UnHoverSound, 0.1)
            end
        end
	end

	self:DockMargin(Sharky.resFormat(5), Sharky.resFormat(5), Sharky.resFormat(5), Sharky.resFormat(5))
end

function PANEL:PerformLayout()
	local x = self.m_iIndent or 0

	self.Button:SetSize(self:GetTall(), self:GetTall())
	self.Button:SetPos(0, math.floor((self:GetTall() - self.Button:GetTall() ) / 2))

	self.Label:SizeToContents()
	self.Label:SetPos(x + self.Button:GetWide(), 0)
end

derma.DefineControl('Sharky.CheckBoxLabel', '', PANEL, 'DCheckBoxLabel')