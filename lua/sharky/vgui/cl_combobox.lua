local PANEL = {}

	function PANEL:Init()
		if self['DropButton'] then
			self['DropButton']:Remove()
		end

		self.Color = Sharky.BGColor3
		self.LineColor  = Sharky.ComboBoxLineColor
		self.Overlay = ColorAlpha(Sharky.HoverColor, Sharky.HoverColor.a)
		self.OverlayA = self.Overlay.a
		self.HamburgerColor = Sharky.ComboBoxHamburgerColor
		self.MoveOut = 0

		self['DropButton'] = vgui.Create('DPanel', self)

		self['DropButton'].Paint = function(panel, w, h)
			local FT = FrameTime()
			--[[CT = SysTime()
			if self:IsMenuOpen() then
				if self.OpenAnimStartTime > 0 and CT > self.OpenAnimStartTime + 0.2 then
					self.OpenAnimStartTime = -1
				end

				if self.OpenAnimStartTime > 0 and CT < self.OpenAnimStartTime + 0.2 then
					self.OpenBarScale = 6 / 0.2 * (CT - self.OpenAnimStartTime)
				end

				self.OpenBarColor = Sharky.LerpColor(2.5 * FrameTime(), self.OpenBarColor, self:GetSelectedID() and Sharky.ComboBoxOpenBarChosenColor or Sharky.ComboBoxOpenBarOpenedColor)
			else
				if self.OpenAnimStartTime < 0 and not self:GetSelectedID() then
					self.OpenAnimStartTime = CT
				end

				if self.OpenAnimStartTime > 0 and CT < self.OpenAnimStartTime + 0.2 and not self:GetSelectedID() then
					self.OpenBarScale = 6 - 6 / 0.2 * (CT - self.OpenAnimStartTime)
				end

				self.OpenBarColor = Sharky.LerpColor(2.5 * FrameTime(), self.OpenBarColor, self:GetSelectedID() and Sharky.ComboBoxOpenBarChosenColor or Sharky.ComboBoxOpenBarColor)
			end

			surface.SetDrawColor(self.OpenBarColor)

			drawLine(4, h * 0.5, 12)
			if self.OpenBarScale > 0 then
				drawLine(4, h * 0.5 - self.OpenBarScale, 12)
				drawLine(4, h * 0.5 + self.OpenBarScale, 12)
			end]]

			draw.RoundedBox(50, 4, h/2-2, w-8, 4, self.HamburgerColor)

			draw.RoundedBox(50, 4, h/2-2, w-8, 4, self.Overlay)
			if self:IsMenuOpen() then
				self.HamburgerColor = Sharky.LerpColor(7.5 * FT, self.HamburgerColor, Sharky.ComboBoxHamburgerColor2)
				self.MoveOut = Lerp(7.5 * FT, self.MoveOut, 8)
			else
				self.MoveOut = Lerp(7.5 * FT, self.MoveOut, 0)
				self.HamburgerColor = Sharky.LerpColor(7.5 * FT, self.HamburgerColor, self:GetSelectedID() and Sharky.ComboBoxHamburgerColor2 or Sharky.ComboBoxHamburgerColor)
			end

			if self.MoveOut > 0.1 then
				draw.RoundedBox(50, 4, (h/2-2)+self.MoveOut, w-8, 4, self.HamburgerColor)
				draw.RoundedBox(50, 4, (h/2-2)-self.MoveOut, w-8, 4, self.HamburgerColor)

				draw.RoundedBox(50, 4, (h/2-2)+self.MoveOut, w-8, 4, self.Overlay)
				draw.RoundedBox(50, 4, (h/2-2)-self.MoveOut, w-8, 4, self.Overlay)
			end
		end

		self['DropButton']:SetMouseInputEnabled(false)
		self['DropButton'].ComboBox = self

		self:SetFont('Sharky.22')
		self:SetTextColor(Sharky.TextColor)

		self:SetTooltipPanelOverride('Sharky.Tooltip')
	end

	function PANEL:PerformLayout()
		self['DropButton']:SetSize(self:GetTall(), self:GetTall())
		self['DropButton']:AlignRight(0)
		self['DropButton']:CenterVertical()
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

		draw.RoundedBox(Sharky.RoundedUI:GetInt(), 0, 0, w, h, self.Color)
		
		draw.NoTexture()
		surface.SetDrawColor(self.LineColor)
		surface.DrawRect(self['DropButton']:GetPos() - 1, 0, 2, h)

		surface.SetDrawColor(self.Overlay)
		surface.DrawRect(self['DropButton']:GetPos() - 1, 0, 2, h)
	end

	function PANEL:OpenMenu(pControlOpener)
		if pControlOpener and pControlOpener == self.TextEntry then
			return
		end

		if #self.Choices == 0 then
			return
		end

		if IsValid(self.Menu) then
			self.Menu:Remove()
			self.Menu = nil
		end

		self.Menu = vgui.Create('Sharky.Menu', self)

		if self:GetSortItems() then
			local sorted = {}
			for k, v in pairs(self.Choices) do
				local val = tostring(v)
				if string.len(val) > 1 and not tonumber(val) and val:StartWith('#') then
					val = language.GetPhrase(val:sub(2))
				end

				table.insert(sorted, {
					id = k,
					data = v,
					label = val
				})
			end

			for _, v in SortedPairsByMemberValue(sorted, 'label') do
				local option = self.Menu:AddOption(v.data, function()
					self:ChooseOption(v.data, v.id)
				end)
				if self.ChoiceIcons[v.id] then
					option:SetIcon(self.ChoiceIcons[v.id])
				end
			end
		else
			for k, v in pairs(self.Choices) do
				local option = self.Menu:AddOption(v, function()
					self:ChooseOption(v, k)
				end)
				if self.ChoiceIcons[k] then
					option:SetIcon(self.ChoiceIcons[k])
				end
			end
		end

		local x, y = self:LocalToScreen(0, self:GetTall())
		self.Menu:SetMinimumWidth(self:GetWide())
		self.Menu:Open(x, y, false, self)
	end

	function PANEL:OnCursorEntered()
		if self:GetDisabled() then return end
		Sharky.PlaySoundFile(Sharky.HoverSound, Sharky.VolumeUI:GetInt()*0.1)
	end

	function PANEL:OnCursorExited()
		if self:GetDisabled() then return end
		Sharky.PlaySoundFile(Sharky.UnHoverSound, Sharky.VolumeUI:GetInt()*0.1)
	end

	function PANEL:OnDepressed()
	    if self:GetDisabled() then return end
		Sharky.PlaySoundFile(Sharky.ClickSound, Sharky.VolumeUI:GetInt()*0.1)
	end

derma.DefineControl('Sharky.ComboBox', '', PANEL, 'DComboBox')