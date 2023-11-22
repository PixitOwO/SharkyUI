local PANEL = {}

	function PANEL:Init()
		self:SetFont('Sharky.23')
		self:SetText('')
	
		--self:SetTooltipPanelOverride('Sharky.Tooltip')
	
		self:SizeToContents()
	
		self:SetDoubleClickingEnabled(false)
		self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))
	
		self.GlintHover = true

		self.Color = ColorAlpha(Sharky.ColorTheme, Sharky.ColorTheme.a)
	    self.Overlay = ColorAlpha(Sharky.HoverColor, Sharky.HoverColor.a)
	    self.OverlayA = self.Overlay.a
	end
	
	function PANEL:OnDepressed()
	    if self:GetDisabled() then return end
		Sharky.PlaySoundFile(Sharky.ClickSound, Sharky.VolumeUI:GetInt()*0.1)
	end
	
	function PANEL:OnCursorEntered()
		if self:GetDisabled() then return end
		Sharky.PlaySoundFile(Sharky.HoverSound, Sharky.VolumeUI:GetInt()*0.1)
	end
	
	function PANEL:OnCursorExited()
		if self:GetDisabled() then return end
		Sharky.PlaySoundFile(Sharky.UnHoverSound, Sharky.VolumeUI:GetInt()*0.1)
	end

	function PANEL:SetGlint(bool)
		self.GlintHover = bool
	end
	
	function PANEL:Paint(w, h)
		local FT = FrameTime()
		if self:IsHovered() then
			self.Overlay.a = Lerp(7.5 * FT, self.Overlay.a, self.OverlayA + 25)
		else
			self.Overlay.a = Lerp(7.5 * FT, self.Overlay.a, self.OverlayA)
		end
	
		if self:IsDown() then
			self.Overlay.a = Lerp(7.5 * FT, self.Overlay.a, self.OverlayA + 100)
		end
	
		if self.GlintHover and self:IsHovered() then
			self.Shimmer = Lerp(5 * FT, self.Shimmer, w + (h*4))
		else
			self.Shimmer = 0-h*2
		end
	
		draw.NoTexture()
		surface.SetDrawColor(self.Color)
		surface.DrawRect(0, 0, w, h)
	
		if self.GlintHover then
			surface.SetDrawColor(255, 255, 255, 150)
			surface.DrawTexturedRectRotated(self.Shimmer, 0, w*2, h*2, 60)
			surface.DrawTexturedRectRotated(self.Shimmer-h*2, 0, w*2, h, 60)
			surface.DrawTexturedRectRotated(self.Shimmer-h*3.1, 0, w*2, h/2, 60)
		end

		surface.SetDrawColor(self.Overlay)
		surface.DrawRect(0, 0, w, h)
	end
	
	function PANEL:UpdateColours()
		if self:GetDisabled() then
			return self:SetTextStyleColor(Sharky.DisabledTextColor)
		else
			return self:SetTextStyleColor(Sharky.TextColor)
		end
	end

derma.DefineControl('Sharky.Button', 'Custom themed button, should be themed around Pixits style.', PANEL, 'DButton')

local PANEL = {}

	function PANEL:Init()
		self:SetFont('Sharky.23')
		self:SetText('')
	
		--self:SetTooltipPanelOverride('Sharky.Tooltip')
	
		self:SizeToContents()
	
		self:SetDoubleClickingEnabled(false)
		self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))
	
		self.Color = ColorAlpha(Sharky.ColorTheme, Sharky.ColorTheme.a)
	    self.Overlay = ColorAlpha(Sharky.HoverColor, Sharky.HoverColor.a)
	    self.OverlayA = self.Overlay.a
	end

	function PANEL:OnDepressed()
	    if self:GetDisabled() then return end
		Sharky.PlaySoundFile(Sharky.ClickSound, Sharky.VolumeUI:GetInt()*0.1)
	end

	function PANEL:OnCursorEntered()
		if self:GetDisabled() then return end
		Sharky.PlaySoundFile(Sharky.HoverSound, Sharky.VolumeUI:GetInt()*0.1)
	end

	function PANEL:OnCursorExited()
		if self:GetDisabled() then return end
		Sharky.PlaySoundFile(Sharky.UnHoverSound, Sharky.VolumeUI:GetInt()*0.1)
	end

	function PANEL:Paint(w, h)
		local FT = FrameTime()
		if self:IsHovered() then
			self.Overlay.a = Lerp(7.5 * FT, self.Overlay.a, self.OverlayA + 25)
		else
			self.Overlay.a = Lerp(7.5 * FT, self.Overlay.a, self.OverlayA)
		end
	
		if self:IsDown() then
			self.Overlay.a = Lerp(7.5 * FT, self.Overlay.a, self.OverlayA + 100)
		end
	
		if self:IsHovered() then
			self.Shimmer = Lerp(5 * FT, self.Shimmer, w + (h*4))
		else
			self.Shimmer = 0-h*2
		end
	
		draw.NoTexture()
		surface.SetDrawColor(self.Color)
		surface.DrawRect(0, 0, w, h)
	
		surface.SetDrawColor(255, 255, 255, 150)
		surface.DrawTexturedRectRotated(self.Shimmer, 0, w*2, h*2, 60)
		surface.DrawTexturedRectRotated(self.Shimmer-h*2, 0, w*2, h, 60)
		surface.DrawTexturedRectRotated(self.Shimmer-h*3.1, 0, w*2, h/2, 60)
	
		surface.SetDrawColor(self.Overlay)
		surface.DrawRect(0, 0, w, h)
	end

	function PANEL:UpdateColours()
		if self:GetDisabled() then
			return self:SetTextStyleColor(Sharky.DisabledTextColor)
		else
			return self:SetTextStyleColor(Sharky.TextColor)
		end
	end

derma.DefineControl('Sharky.ButtonConfirm', 'Custom themed confirm button, should be themed around Pixits style.', PANEL, 'DButton')