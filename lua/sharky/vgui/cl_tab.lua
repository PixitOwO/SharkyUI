local PANEL = {}

AccessorFunc(PANEL, 'm_pPropertySheet', 'PropertySheet')
AccessorFunc(PANEL, 'm_pPanel', 'Panel')

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetContentAlignment(7)
	self:SetTextInset(0, 4)
	self.Color = Sharky.PSTabInactiveColor
	self.LineColor = ColorAlpha(Sharky.PSUnderlineActiveColor, 0)
	self.Overlay = ColorAlpha(Sharky.PSTabHoverColor, Sharky.PSTabHoverColor.a)
    self.OverlayA = self.Overlay.a
end

function PANEL:Setup(label, pPropertySheet, pPanel, strMaterial)
	self:SetText(label)
	self:SetFont('Sharky.26')

	self:SetPropertySheet(pPropertySheet)
	self:SetPanel(pPanel)

	local extraInset = 6
	if strMaterial then
		self.Image = vgui.Create('DImage', self)
		self.Image:SetImage(strMaterial)
		self.Image:SizeToContents()
		self:InvalidateLayout()

		extraInset = 10 + self.Image:GetWide()
	end

	self:SetTextInset(extraInset, 4)
	self:SizeToContentsX(6)
	self:SetTall(18)
end

function PANEL:IsActive()
	return self:GetPropertySheet():GetActiveTab() == self
end

function PANEL:DoClick()
	self:GetPropertySheet():SetActiveTab(self)
end
function PANEL:OnDepressed()
    if self:GetDisabled() then return end
	Sharky.PlaySoundFile(Sharky.ClickSound, 0.1)
end

function PANEL:OnCursorEntered()
	if self:GetDisabled() then return end
	Sharky.PlaySoundFile(Sharky.HoverSound, 0.1)
end

function PANEL:OnCursorExited()
	if self:GetDisabled() then return end
	Sharky.PlaySoundFile(Sharky.UnHoverSound, 0.1)
end

function PANEL:UpdateColours()
	if self:GetDisabled() then
		return self:SetTextStyleColor(Sharky.DisabledTextColor)
	else
		return self:SetTextStyleColor(Sharky.TextColor)
	end
end

function PANEL:Paint(w,h)
	local FT = FrameTime()
	if self:IsHovered() then
		self.Overlay.a = Lerp(7.5 * FT, self.Overlay.a, self.OverlayA + 25)
	else
		self.Overlay.a = Lerp(7.5 * FT, self.Overlay.a, self.OverlayA)
	end

	if self:IsDown() then
		self.Overlay.a = Lerp(7.5 * FT, self.Overlay.a, self.OverlayA + 100)
	end

	if self:IsActive() then
		self.Color = Sharky.LerpColor(7.5 * FrameTime(), self.Color, Sharky.PSTabActiveColor)
		self.LineColor.a = Lerp(7.5 * FrameTime(), self.LineColor.a or 0, 255)
	else
		self.Color = Sharky.LerpColor(7.5 * FrameTime(), self.Color, Sharky.PSTabInactiveColor)
		self.LineColor.a = Lerp(7.5 * FrameTime(), self.LineColor.a or 255, 0)
	end
	draw.RoundedBoxEx(Sharky.RoundedUI:GetInt(), 0, 0, w, h-2, self.Color, true, true, false, false)
	draw.RoundedBoxEx(Sharky.RoundedUI:GetInt(), 0, 0, w, h-2, self.Overlay, true, true, false, false)

	surface.SetDrawColor(self.LineColor)
	surface.DrawRect(0, h-2, w, 2)
end

function PANEL:PerformLayout()
	self:ApplySchemeSettings()

	if not self.Image then
		return
	end

	self.Image:SetPos(7, 3)

	if not self:IsActive() then
		self.Image:SetImageColor(ColorAlpha(color_white, 155))
	else
		self.Image:SetImageColor(color_white)
	end

end

function PANEL:GetTabHeight()
	return 24
end

function PANEL:DragHoverClick(hoverTime)
	self:DoClick()
end

function PANEL:DoRightClick()
	if not IsValid(self:GetPropertySheet()) then
		return
	end

	local tabs = Sharky.Menu()
	for _, v in pairs(self:GetPropertySheet().Items) do
		if not v or not IsValid(v.Tab) or not v.Tab:IsVisible() then
			continue
		end
		local option = tabs:AddOption(v.Tab:GetText(), function()
			if not v or not IsValid(v.Tab) or not IsValid(self:GetPropertySheet()) or not IsValid(self:GetPropertySheet().tabScroller) then
				return
			end
			v.Tab:DoClick()
			self:GetPropertySheet().tabScroller:ScrollToChild(v.Tab)
		end )
		if IsValid(v.Tab.Image) then
			option:SetIcon(v.Tab.Image:GetImage())
		end
	end
	tabs:Open()
end

derma.DefineControl('Sharky.Tab', '', PANEL, 'DButton')

local PANEL = {}

AccessorFunc(PANEL, 'm_pActiveTab', 'ActiveTab')
AccessorFunc(PANEL, 'm_iPadding', 'Padding')
AccessorFunc(PANEL, 'm_fFadeTime', 'FadeTime')

AccessorFunc(PANEL, 'm_bShowIcons', 'ShowIcons')

function PANEL:Init()
	self:SetShowIcons(true)

	self.tabScroller = vgui.Create('Sharky.HorizontalScroller', self)
	self.tabScroller:SetTall(60)
	self.tabScroller:SetOverlap(-10)
	self.tabScroller:Dock(TOP)
	self.tabScroller:DockMargin(0, 0, 0, 0)
	self:InvalidateParent()

	self.tabScroller.Paint = function(tbs, w, h)
		surface.SetDrawColor(Sharky.PSUnderlineDefaultColor)
		surface.DrawRect(0, 34, w, 2)
	end

	self:SetFadeTime(0.1)
	self:SetPadding(0)

	self.animFade = Derma_Anim('Fade', self, self.CrossFade)

	self.Items = {}
end

function PANEL:AddSheet(label, panel, material, noStretchX, noStretchY, tooltip)
	if not IsValid(panel) then
		ErrorNoHalt( 'AddSheet tried to add invalid panel!' )
		debug.Trace()
		return
	end

	local sheet = {}
	sheet.Name = label

	sheet.Tab = vgui.Create( 'Sharky.Tab', self )
	sheet.Tab:SetTooltip(tooltip)
	sheet.Tab:Setup(label, self, panel, material)

	sheet.Panel = panel
	sheet.Panel.NoStretchX = noStretchX
	sheet.Panel.NoStretchY = noStretchY
	sheet.Panel:SetPos(self:GetPadding(), 26 + self:GetPadding())
	sheet.Panel:SetVisible(false)

	panel:SetParent(self)

	table.insert(self.Items, sheet)

	if not self:GetActiveTab() then
		self:SetActiveTab(sheet.Tab)
		sheet.Panel:SetVisible(true)
	end

	self.tabScroller:AddPanel(sheet.Tab)

	return sheet
end

function PANEL:SetActiveTab(active)
	if not IsValid(active) or self.m_pActiveTab == active then
		return
	end

	if not IsValid(self.m_pActiveTab) then
		self:OnActiveTabChanged(self.m_pActiveTab, active)
		if self:GetFadeTime() > 0 then
			self.animFade:Start(self:GetFadeTime(), {
				OldTab = self.m_pActiveTab,
				NewTab = active
			})
		else
			self.m_pActiveTab:GetPanel():SetVisible(false)
		end
	end

	self.m_pActiveTab = active
	self:InvalidateLayout()
end

function PANEL:OnActiveTabChanged(old, new) end

function PANEL:Think()
	self.animFade:Run()
end

function PANEL:GetItems()
	return self.Items
end

function PANEL:CrossFade(anim, delta, data)
	if not data or not IsValid(data.OldTab) or not IsValid(data.NewTab) then
		return
	end

	local old = data.OldTab:GetPanel()
	local new = data.NewTab:GetPanel()

	if not IsValid(old) and not IsValid(new) then
		return
	end

	if anim.Finished then
		if IsValid(old) then
			old:SetAlpha(255)
			old:SetZPos(0)
			old:SetVisible(false)
		end

		if IsValid(new) then
			new:SetAlpha(255)
			new:SetZPos(0)
			new:SetVisible(true) -- in case new == old
		end

		return
	end

	if anim.Started then
		if IsValid(old) then
			old:SetAlpha(255)
			old:SetZPos(0)
		end

		if IsValid(new) then
			new:SetAlpha(0)
			new:SetZPos(1)
		end
	end

	if IsValid(old) then
		old:SetVisible(true)
		if not IsValid(new) then
			old:SetAlpha(255 * (1 - delta))
		end
	end

	if IsValid(new) then
		new:SetVisible(true)
		new:SetAlpha(255 * delta)
	end
end

function PANEL:PerformLayout()
	local activeTab = self:GetActiveTab()
	local padding = self:GetPadding()

	if not IsValid(activeTab) then
		return
	end

	activeTab:InvalidateLayout(true)

	local activePanel = activeTab:GetPanel()

	for _, v in pairs(self.Items) do
		if v.Tab:GetPanel() == activePanel then
			if IsValid(v.Tab:GetPanel()) then
				v.Tab:GetPanel():SetVisible(true)
			end
			v.Tab:SetZPos(100)
		else
			if IsValid(v.Tab:GetPanel()) then
				v.Tab:GetPanel():SetVisible(false)
			end
			v.Tab:SetZPos(1)
		end
		v.Tab:ApplySchemeSettings()
	end

	if IsValid(activePanel) then
		if not activePanel.NoStretchX then
			activePanel:SetWide(self:GetWide() - padding * 2)
		else
			activePanel:CenterHorizontal()
		end

		if not activePanel.NoStretchY then
			local _, y = activePanel:GetPos()
			activePanel:SetTall(self:GetTall() - y - padding)
		else
			activePanel:CenterVertical()
		end

		activePanel:InvalidateLayout()
	end

	self.animFade:Run()
end

function PANEL:SizeToContentWidth()
	local wide = 0
	for _, v in pairs(self.Items) do
		if IsValid(v.Panel) then
			v.Panel:InvalidateLayout(true)
			wide = math.max(wide, v.Panel:GetWide() + self:GetPadding() * 2)
		end
	end
	self:SetWide(wide)
end

function PANEL:SwitchToName(name)
	for _, v in pairs(self.Items) do
		if v.Name == name then
			v.Tab:DoClick()
			return true
		end
	end
	return false
end

function PANEL:CloseTab(tab, bRemovePanelToo)
	for k, v in pairs(self.Items) do
		if v.Tab ~= tab then
			continue
		end
		table.remove(self.Items, k)
	end

	for k, v in pairs(self.tabScroller.Panels) do
		if v ~= tab then
			continue
		end
		table.remove(self.tabScroller.Panels, k)
	end

	self.tabScroller:InvalidateLayout(true)

	if tab == self:GetActiveTab() then
		self.m_pActiveTab = self.Items[#self.Items].Tab
	end

	local pnl = tab:GetPanel()
	if bRemovePanelToo then
		pnl:Remove()
	end

	tab:Remove()
	self:InvalidateLayout(true)

	return pnl
end

derma.DefineControl('Sharky.PropertySheet', '', PANEL, 'Panel')