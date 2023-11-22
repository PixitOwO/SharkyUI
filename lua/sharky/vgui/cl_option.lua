function Sharky.Menu(parentMenu, parent)
	if not parentMenu then
		CloseDermaMenus()
	end

	local sharkyMenu = vgui.Create('Sharky.Menu', parent)
	return sharkyMenu
end

local PANEL = {}

	AccessorFunc(PANEL, 'm_bBorder', 'DrawBorder')
	AccessorFunc(PANEL, 'm_bDeleteSelf', 'DeleteSelf')
	AccessorFunc(PANEL, 'm_iMinimumWidth', 'MinimumWidth')
	AccessorFunc(PANEL, 'm_bDrawColumn', 'DrawColumn')
	AccessorFunc(PANEL, 'm_iMaxHeight', 'MaxHeight')
	AccessorFunc(PANEL, 'm_pOpenSubMenu', 'OpenSubMenu')

	function PANEL:Init()
		self.startTime = SysTime()

		self.RealTall = 0

		self:SetIsMenu(true)
		self:SetDrawBorder(true)
		self:SetPaintBackground(true)
		self:SetMinimumWidth(100)
		self:SetDrawOnTop(true)
		self:SetMaxHeight(ScrH() / 1.2)
		self:SetDeleteSelf(true)

		local x, y = input.GetCursorPos()
		self:SetPos(x, y)

		self:MakePopup()
		self:SetPadding(0)

		RegisterDermaMenuForClose(self)
	end

	function PANEL:AddPanel(pnl)
		self:AddItem(pnl)
		pnl.ParentMenu = self
	end

	function PANEL:AddOption(strText, funcFunction)
		local pnl = vgui.Create('Sharky.MenuOption', self)
		pnl:SetMenu(self)

		pnl:SetText(strText)
		pnl:SetTextColor(color_white)
		pnl:SetFont('Sharky.23')
		pnl:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

		if funcFunction then
			pnl.DoClick = funcFunction
		end

		self.RealTall = self.RealTall + 24

		local mx, my = input.GetCursorPos()
		self:SetPos(mx, math.Clamp(my - self.RealTall + 24, 0, ScrH()))

		self:AddPanel(pnl)

		return pnl
	end

	function PANEL:AddCVar(strText, convar, on, off, funcFunction)
		local pnl = vgui.Create('DMenuOptionCVar', self)
		pnl:SetMenu(self)

		pnl:SetText(strText)
		pnl:SetTextColor(color_white)
		pnl:SetFont('Sharky.23')
		pnl:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

		if funcFunction then
			pnl.DoClick = funcFunction
		end

		pnl:SetConVar(convar)
		pnl:SetValueOn(on)
		pnl:SetValueOff(off)

		self:AddPanel(pnl)

		return pnl
	end

	function PANEL:AddSpacer(strText, funcFunction)
		local pnl = vgui.Create('DPanel', self)

		pnl.Paint = function(p, w, h)
			return
		end

		pnl:SetTall(10)
		self:AddPanel(pnl)

		return pnl
	end

	function PANEL:AddSubMenu(strText, funcFunction)
		local pnl = vgui.Create('Sharky.MenuOption', self)
		local SubMenu = pnl:AddSubMenu(strText, funcFunction)

		pnl:SetText(strText)
		pnl:SetTextColor(color_white)
		pnl:SetFont('Sharky.23')
		pnl:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

		if funcFunction then
			pnl.DoClick = funcFunction
		end

		self:AddPanel(pnl)

		return SubMenu, pnl
	end

	function PANEL:Hide()
		local openmenu = self:GetOpenSubMenu()
		if openmenu then
			openmenu:Hide()
		end

		self:SetVisible(false)
		self:SetOpenSubMenu(nil)
	end

	function PANEL:OpenSubMenu(item, menu)
		local openmenu = self:GetOpenSubMenu()
		if IsValid(openmenu) and openmenu:IsVisible() then
			if menu and openmenu == menu then
				return
			end
			self:CloseSubMenu(openmenu)
		end

		if not IsValid(menu) then
			return
		end

		local x, y = item:LocalToScreen(self:GetWide(), 0)
		menu:Open(x - 3, y, false, item)

		self:SetOpenSubMenu(menu)
	end

	function PANEL:CloseSubMenu(menu)
		menu:Hide()
		self:SetOpenSubMenu(nil)
	end

	function PANEL:Paint(w, h)
		if not self:GetPaintBackground() then
			return
		end

		if not self.FirstInit then -- We need to pre-cache shape for better performance
			self.FirstInit = true
		end

		draw.RoundedBox(Sharky.RoundedUI:GetInt(), 0, 0, w, h - 1, Sharky.BGColor)

		return true
	end

	function PANEL:ChildCount()
		return #self:GetCanvas():GetChildren()
	end

	function PANEL:GetChild(num)
		return self:GetCanvas():GetChildren()[num]
	end

	function PANEL:PerformLayout()
		local w = self:GetMinimumWidth()
		for _, pnl in pairs(self:GetCanvas():GetChildren()) do
			pnl:PerformLayout()
			w = math.max(w, pnl:GetWide())
		end

		self:SetWide(w)

		local y = 0
		for _, pnl in pairs(self:GetCanvas():GetChildren()) do
			pnl:SetWide(w)
			pnl:SetPos(0, y)
			pnl:InvalidateLayout(true)

			y = y + pnl:GetTall() + 1
		end

		y = math.min(y, self:GetMaxHeight())

		self:SetTall(y)

		derma.SkinHook('Layout', 'Menu', self)

		self.BaseClass.PerformLayout(self)
	end

	function PANEL:Open(x, y, skipanimation, ownerpanel)
		RegisterDermaMenuForClose(self)

		local maunal = x and y

		x = x or gui.MouseX()
		y = y or gui.MouseY()

		local OwnerHeight = 0
		local OwnerWidth = 0
		if ownerpanel then
			OwnerWidth, OwnerHeight = ownerpanel:GetSize()
		end

		self:PerformLayout()

		local w = self:GetWide()
		local h = self:GetTall()

		self:SetSize(w, h)

		if y + h > ScrH() then
			y = ((maunal and ScrH()) or (y + OwnerHeight)) - h
		end

		if x + w > ScrW() then
			x = ((maunal and ScrW()) or x) - w
		end

		if y < 1 then
			y = 1
		end

		if x < 1 then
			x = 1
		end

		self:SetPos(x, y)
		self:MakePopup()
		self:SetVisible(true)
		self:SetKeyboardInputEnabled(false)
	end

	function PANEL:OptionSelectedInternal(option)
		self:OptionSelected(option, option:GetText())
	end

	function PANEL:OptionSelected(option, text) end

	function PANEL:ClearHighlights()
		for _, pnl in pairs(self:GetCanvas():GetChildren()) do
			pnl.Highlight = nil
		end
	end

	function PANEL:HighlightItem(item)
		for _, pnl in pairs(self:GetCanvas():GetChildren()) do
			if pnl == item then
				pnl.Highlight = true
			end
		end
	end

derma.DefineControl('Sharky.Menu', '', PANEL, 'Sharky.ScrollPanel')

local PANEL = {}

	AccessorFunc(PANEL, 'm_pMenu', 'Menu')
	AccessorFunc(PANEL, 'm_bChecked', 'Checked')
	AccessorFunc(PANEL, 'm_bCheckable', 'IsCheckable')
	
	function PANEL:Init()
		self:SetContentAlignment(4)
		self:SetTextInset(30, 0)
		self:SetTextColor(Color(10, 10, 10))
		self:SetChecked(false)

		self.Color = ColorAlpha(Sharky.ColorTheme, Sharky.ColorTheme.a)
	    self.Overlay = ColorAlpha(Sharky.HoverColor, Sharky.HoverColor.a)
	    self.OverlayA = self.Overlay.a
	
		self:SetTooltipPanelOverride('Sharky.Tooltip')
	end
	
	function PANEL:SetSubMenu(menu)
		self.SubMenu = menu
	
		if not IsValid(self.SubMenuArrow) then
			self.SubMenuArrow = vgui.Create('DPanel', self)
			self.SubMenuArrow.Paint = function(panel, w, h)
				derma.SkinHook('Paint', 'MenuRightArrow', panel, w, h)
			end
		end
	end
	
	function PANEL:AddSubMenu()
		local subMenu = Sharky.Menu(self)
		subMenu:SetVisible(false)
		subMenu:SetParent(self)
	
		self:SetSubMenu(subMenu)
		return subMenu
	end
	
	function PANEL:OnCursorEntered()
		if IsValid(self.ParentMenu) then
			self.ParentMenu:OpenSubMenu(self, self.SubMenu)
			return
		end
		self:GetParent():OpenSubMenu(self, self.SubMenu)
	end
	
	function PANEL:OnCursorExited() end
	
	local pos_x, pos_y
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
	
		pos_x, pos_y = self:GetPos()
		if pos_y == self:GetParent():GetTall() - h then
			draw.RoundedBoxEx(Sharky.RoundedUI:GetInt(), 0, 0, w, h, self.Color, false, false, true, true)
			draw.RoundedBoxEx(Sharky.RoundedUI:GetInt(), 0, 0, w, h, self.Overlay, false, false, true, true)
		elseif pos_y == 0 then
			draw.RoundedBoxEx(Sharky.RoundedUI:GetInt(), 0, 0, w, h, self.Color, true, true)
			draw.RoundedBoxEx(Sharky.RoundedUI:GetInt(), 0, 0, w, h, self.Overlay, true, true)
		else
			draw.RoundedBox(0, 0, 0, w, h, self.Color)
			draw.RoundedBox(0, 0, 0, w, h, self.Overlay)
		end
	end
	
	function PANEL:OnMousePressed(mousecode)
		self.m_MenuClicking = true
		DButton.OnMousePressed(self, mousecode)
	end
	
	function PANEL:OnMouseReleased(mousecode)
		DButton.OnMouseReleased(self, mousecode)
		if self.m_MenuClicking and mousecode == MOUSE_LEFT then
			self.m_MenuClicking = false
			CloseDermaMenus()
		end
	end
	
	function PANEL:DoRightClick()
		if self:GetIsCheckable() then
			self:ToggleCheck()
		end
	end
	
	function PANEL:DoClickInternal()
		if self:GetIsCheckable() then
			self:ToggleCheck()
		end
		if self.m_pMenu then
			self.m_pMenu:OptionSelectedInternal(self)
		end
	end
	
	function PANEL:ToggleCheck()
		self:SetChecked(not self:GetChecked())
		self:OnChecked(self:GetChecked())
	end
	
	function PANEL:OnChecked(b) end
	
	function PANEL:PerformLayout()
		self:SizeToContents()
		self:SetWide(self:GetWide() + 30)
	
		local w = math.max(self:GetParent():GetWide(), self:GetWide())
		self:SetSize(w, 22)
	
		if IsValid(self.SubMenuArrow) then
			self.SubMenuArrow:SetSize(15, 15)
			self.SubMenuArrow:CenterVertical()
			self.SubMenuArrow:AlignRight(4)
		end
	
		DButton.PerformLayout(self)
	end

derma.DefineControl('Sharky.MenuOption', '', PANEL, 'Sharky.Button')