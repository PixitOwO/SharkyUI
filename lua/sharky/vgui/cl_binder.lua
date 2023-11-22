local PANEL = {}

    AccessorFunc(PANEL, 'm_iSelectedNumber', 'SelectedNumber')

    Derma_Install_Convar_Functions(PANEL)

    function PANEL:Init()
    	self:SetSelectedNumber(0)
    	self:SetSize(60, 30)
    end

    function PANEL:UpdateText()
    	local str = input.GetKeyName(self:GetSelectedNumber())
    	if (!str) then str = 'NONE' end

    	str = language.GetPhrase(str)

    	self:SetText(str)
    end

    function PANEL:DoClick()
    	self:SetText('PRESS A KEY')
    	input.StartKeyTrapping()
    	self.Trapping = true
    end

    function PANEL:DoRightClick()
    	self:SetText('NONE')
    	self:SetValue(0)
    end

    function PANEL:SetSelectedNumber(iNum)
    	self.m_iSelectedNumber = iNum
    	self:ConVarChanged(iNum)
    	self:UpdateText()
    	self:OnChange(iNum)
    end

    function PANEL:Think()
    	if (input.IsKeyTrapping() && self.Trapping) then

    		local code = input.CheckKeyTrapping()
    		if (code) then
    			if (code == KEY_ESCAPE) then
                    self:SetValue(self:GetSelectedNumber())
    			else
    				self:SetValue(code)
    			end
    			self.Trapping = false
    		end
    	end

    	self:ConVarNumberThink()
    end

    function PANEL:SetValue(iNumValue)
    	self:SetSelectedNumber(iNumValue)
    end

    function PANEL:GetValue()
    	return self:GetSelectedNumber()
    end

	function PANEL:SetConVar(cvar)
		self.ConVar = cvar
		self:SetSelectedNumber(cvar:GetInt())
	end

    function PANEL:OnChange(num)
		if self.ConVar then
			self.ConVar:SetInt(self:GetSelectedNumber())
		end
	end

derma.DefineControl('Sharky.Binder', 'Custom themed binder, should be themed around Pixits style.', PANEL, 'Sharky.Button')

local PANEL = {}

    AccessorFunc(PANEL, 'm_iSelectedNumber', 'SelectedNumber')

    function PANEL:Init()
    	if self.Button then
    		self.Button:Remove()
    	end

    	self.Button = vgui.Create('Sharky.Binder', self)

    	self.Label = vgui.Create('Sharky.TextBox', self)
    	self.Label:SetFont('Sharky.16')
    	self.Label:SetTextColor(color_white)

    	self:DockMargin(Sharky.resFormat(5), Sharky.resFormat(5), Sharky.resFormat(5), Sharky.resFormat(5))
    end

    function PANEL:UpdateText()
    	local str = input.GetKeyName(self.Button:GetSelectedNumber())
    	if (!str) then str = 'NONE' end

    	str = language.GetPhrase(str)

    	self.Button:SetText(str)
    end

    function PANEL:SetSelectedNumber(iNum)
    	self.Button.m_iSelectedNumber = iNum
    	self.Button:ConVarChanged(iNum)
    	self.Button:UpdateText()
    	self.Button:OnChange(iNum)
    end

    function PANEL:SetValue(iNumValue)
    	self.Button:SetSelectedNumber(iNumValue)
    end

    function PANEL:GetValue()
    	return self.Button:GetSelectedNumber()
    end

	function PANEL:SetConVar(cvar)
		self.Button.ConVar = cvar
		self.Button:SetSelectedNumber(cvar:GetInt())
	end

    function PANEL:OnChange(num)
		if self.Button.ConVar then
			self.Button.ConVar:SetInt(self.Button:GetSelectedNumber())
		end
	end

    function PANEL:SetText(strText)
    	self.Label:SetText(strText)
    end

    function PANEL:GetText()
    	return self.Label:GetText()
    end

    function PANEL:SetIndent(iIndent)
    	self.m_iIndent = iIndent
    end

    function PANEL:SetFont(strFont)
    	self.Label:SetFont(strFont)
    end

    function PANEL:SetTextColor(col)
    	self.Label:SetTextColor(col)
    end

    function PANEL:PerformLayout()
    	local x = self.m_iIndent or 0

    	self.Button:SetSize(self:GetTall()*2, self:GetTall())
    	self.Button:SetPos(0, math.floor((self:GetTall() - self.Button:GetTall() ) / 2))

    	self.Label:SizeToContents()
    	self.Label:SetPos(x + self.Button:GetWide(), 0)
        self.Label:SetSize(self:GetWide() - self.Button:GetWide(), self:GetTall())
    end

    function PANEL:Paint(w, h)
    end

derma.DefineControl('Sharky.BinderLabel', 'Custom themed binder label, should be themed around Pixits style.', PANEL, 'DPanel')