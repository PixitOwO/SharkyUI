local PANEL = {}

function PANEL:Init()
	self:SetContentAlignment(4)
	self:SetTextInset(4, 0)
	self:SetFont('Sharky.28')
	
	self.Color = ColorAlpha(Sharky.ColorTheme, Sharky.ColorTheme.a)
    self.Overlay = ColorAlpha(Sharky.HoverColor, Sharky.HoverColor.a)
    self.OverlayA = self.Overlay.a
	self.TextMove = 0
	self.TextMove = self:GetTall()+20
end

function PANEL:DoClick()
	self:GetParent():Toggle()
end

function PANEL:UpdateColours(skin)
	if !self:GetParent():GetExpanded() then
		self:SetExpensiveShadow(0, Sharky.CollapsibleCategoryClosedShadowColor)
		return self:SetTextStyleColor(skin.Colours.Category.Header_Closed)
	end

	self:SetExpensiveShadow(1, Sharky.CollapsibleCategoryExpandedShadowColor)
	return self:SetTextStyleColor(skin.Colours.Category.Header)
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
	draw.RoundedBox(Sharky.RoundedUI:GetInt(), 0, 0, w, h, self.Overlay)

	if !self:GetParent():GetExpanded() then
		self.TextMove = Lerp(7.5 * FT, self.TextMove or 0, h/2)
	else
		self.TextMove = Lerp(7.5 * FT, self.TextMove or 0, h+20)
	end

	draw.SimpleText('V', 'Sharky.32', w - Sharky.resFormat(10), self.TextMove, Sharky.CollapsibleCategoryExpandIconColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
end

derma.DefineControl('Sharky.CategoryHeader', 'Category Header', PANEL, 'Sharky.Button')

local PANEL = {}

AccessorFunc(PANEL, 'm_bSizeExpanded', 'Expanded', FORCE_BOOL)
AccessorFunc(PANEL, 'm_iContentHeight',	'StartHeight')
AccessorFunc(PANEL, 'm_fAnimTime', 'AnimTime')
AccessorFunc(PANEL, 'm_bDrawBackground', 'PaintBackground', FORCE_BOOL)
AccessorFunc(PANEL, 'm_bDrawBackground', 'DrawBackground', FORCE_BOOL) -- deprecated
AccessorFunc(PANEL, 'm_iPadding', 'Padding')
AccessorFunc(PANEL, 'm_pList', 'List')

function PANEL:Init()
	self.Header = vgui.Create('Sharky.CategoryHeader', self)
	self.Header:Dock(TOP)
	self.Header:SetSize(Sharky.resFormat(25), Sharky.resFormat(25))

	self:SetSize(16, 16)
	self:SetExpanded(true)
	self:SetMouseInputEnabled(true)

	self:SetAnimTime(0.2)
	self.animSlide = Derma_Anim('Anim', self, self.AnimSlide)

	self:SetPaintBackground(true)
end

function PANEL:Add(strName)
	local button = vgui.Create('Sharky.Button', self)

	button:SetHeight(17)
	button:SetTextInset(4, 0)

	button:SetContentAlignment(4)
	button:DockMargin(1, 0, 1, 0)
	button.DoClickInternal = function()
		if self:GetList() then
			self:GetList():UnselectAll()
		else
			self:UnselectAll()
		end
		button:SetSelected(true)
	end

	button:Dock(TOP)
	button:SetText(strName)

	self:InvalidateLayout(true)
	self:UpdateAltLines()

	return button
end

function PANEL:UnselectAll()
	local children = self:GetChildren()
	for _, v in pairs(children) do
		if v.SetSelected then
			v:SetSelected(false)
		end
	end
end

function PANEL:UpdateAltLines()
	local children = self:GetChildren()
	for k, v in pairs(children) do
		v.AltLine = k % 2 ~= 1
	end
end

function PANEL:Think()
	self.animSlide:Run()
end

function PANEL:SetLabel(strLabel)
	self.Header:SetText( strLabel )
end

function PANEL:SetHeaderHeight(height)
	self.Header:SetTall(height)
end

function PANEL:GetHeaderHeight()
	return self.Header:GetTall()
end

function PANEL:SetContents(pContents)
	self.Contents = pContents
	self.Contents:SetParent(self)
	self.Contents:Dock(FILL)
	self.Contents:DockMargin(Sharky.resFormat(10), 0, Sharky.resFormat(10), 0)

	if not self:GetExpanded() then
		self.OldHeight = self:GetTall()
	elseif self:GetExpanded() and IsValid(self.Contents) and self.Contents:GetTall() < 1 then
		self.Contents:SizeToChildren(false, true)
		self.OldHeight = self.Contents:GetTall()
		self:SetTall(self.OldHeight)
	end

	self:InvalidateLayout(true)
end

function PANEL:SetExpanded(expanded)
	self.m_bSizeExpanded = tobool(expanded)
	if not self:GetExpanded() then
		if not self.animSlide.Finished and self.OldHeight then
			return
		end
		self.OldHeight = self:GetTall()
	end
end

function PANEL:Toggle()
	self:SetExpanded(not self:GetExpanded())

	self.animSlide:Start(self:GetAnimTime(), {
		From = self:GetTall()
	})

	self:InvalidateLayout(true)
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()

	local open = '1'
	if not self:GetExpanded() then
		open = '0'
	end

	self:SetCookie('Open', open)
	self:OnToggle(self:GetExpanded())
end

function PANEL:OnToggle(expanded) end

function PANEL:DoExpansion(b)
	if self:GetExpanded() == b then
		return
	end
	self:Toggle()
end

function PANEL:PerformLayout()
	if IsValid(self.Contents) then
		if self:GetExpanded() then
			self.Contents:InvalidateLayout(true)
			self.Contents:SetVisible(true)
		else
			self.Contents:SetVisible(false)
		end
	end

	if self:GetExpanded() then
		if IsValid(self.Contents) and #self.Contents:GetChildren() > 0 then
			self.Contents:SizeToChildren(false, true)
		end
		self:SizeToChildren(false, true)
	else
		if IsValid(self.Contents) and not self.OldHeight then
			self.OldHeight = self.Contents:GetTall()
		end
		self:SetTall(self:GetHeaderHeight())
	end

	self.Header:ApplySchemeSettings()
	self.animSlide:Run()
	self:UpdateAltLines()
end

function PANEL:OnMousePressed(mCode)
	if not self:GetParent().OnMousePressed then
		return
	end
	return self:GetParent():OnMousePressed(mCode)
end

function PANEL:AnimSlide(anim, delta, data)
	self:InvalidateLayout()
	self:InvalidateParent()

	if anim.Started then
		if not IsValid(self.Contents) and (self.OldHeight or 0) < self.Header:GetTall() then
			self.OldHeight = 0
			for _, pnl in pairs(self:GetChildren()) do
				self.OldHeight = self.OldHeight + pnl:GetTall()
			end
		end

		if self:GetExpanded() then
			data.To = math.max(self.OldHeight, self:GetTall())
		else
			data.To = self:GetTall()
		end
	end

	if IsValid(self.Contents) then
		self.Contents:SetVisible(true)
	end

	self:SetTall(Lerp(delta, data.From, data.To))
end

function PANEL:LoadCookies()
	local op = self:GetCookieNumber('Open', 1) == 1

	self:SetExpanded(op)
	self:InvalidateLayout(true)
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()
end

derma.DefineControl('Sharky.CollapsibleCategory', 'Collapsable Category Panel', PANEL, 'Panel')