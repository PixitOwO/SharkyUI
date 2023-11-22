local PANEL = {}

    function PANEL:Init()
        self:MakePopup()
        self:RequestFocus()

        local ply = LocalPlayer()

        self.open = true
	    self:Center()

        self['check'] = vgui.Create('DButton')
        self['check']:SetText('')
        self['check']:SetZPos(0)
        self['check']:SetSize(ScrW(), ScrH())
	    self['check']:Center()

        if Sharky.PanelCloseMode:GetBool() then
            self['check']:SetDisabled(true)
            self['check'].OnCursorEntered = function()
                if IsValid(self) then
                    self.open = false
                end
            end
            self['check'].PanelText = 'Hover onto empty space to close'
        else
            self['check'].DoClick = function()
                if IsValid(self) then
                    self.open = false
                end
            end
            self['check'].PanelText = 'Click in empty space to close'
        end

        self['check'].Paint = function(s, w, h)
            Sharky.DrawBlur(s, 5, self.alpha)
            Sharky.DrawShadowText(self['check'].PanelText, 'Sharky.42', w/2, (h-self.Tall)/4, ColorAlpha(color_white, self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, 1)
            Sharky.DrawShadowText(self['check'].PanelText, 'Sharky.42', w/2, h-(h-self.Tall)/4, ColorAlpha(color_white, self.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, 1)
            -- draw text self['check'].PanelText
        end
    end

    function PANEL:SetMenuSize(w, h)
        self.Wide = w or (Sharky.ScrW/2.5)
        self.Tall = h or (Sharky.ScrH/2)
    end

    function PANEL:Think()
		if self.open then
			self.expand = Lerp(RealFrameTime()*20, self.expand or 0, self.Tall)
			self.alpha = Lerp(RealFrameTime()*20, self.alpha or 0, 255)
		else
			self.expand = Lerp(RealFrameTime()*20, self.expand or self.Tall, 0)
			if self.expand < 50 then
				self.alpha = Lerp(RealFrameTime()*20, self.alpha or 255, 0)
			end
			if self.alpha < 10 then
				self:Remove()
                self['check']:Remove()
			end
		end
        self:SetSize(self.Wide, self.expand)
        self:Center()
    end

    function PANEL:OnRemove()
        if IsValid(self['check']) then
            self['check']:Remove()
        end
    end 

    function PANEL:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(Sharky.BGColor2, math.Round(self.alpha)))
		draw.RoundedBox(0, 0, h-4, w, 4, ColorAlpha(Sharky.ColorTheme, math.Round(self.alpha)))
		draw.RoundedBox(0, 0, 0, w, 4, ColorAlpha(Sharky.ColorTheme, math.Round(self.alpha)))
    end

derma.DefineControl('Sharky.Panel', 'Custom themed button, should be themed around Pixits style.', PANEL, 'EditablePanel')