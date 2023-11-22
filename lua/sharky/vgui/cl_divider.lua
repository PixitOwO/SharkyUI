local PANEL = {}

    AccessorFunc(PANEL, 'AutoHeight', 'AutoHeight', FORCE_BOOL)
    AccessorFunc(PANEL, 'AutoWidth', 'AutoWidth', FORCE_BOOL)

    function PANEL:Init()
        self.expand = 0
        self:DockPadding(Sharky.resFormat(10), Sharky.resFormat(10), Sharky.resFormat(10), Sharky.resFormat(10))
    end

    function PANEL:Think()
        self.expand = Lerp(RealFrameTime()*10, self.expand or 0, self:GetWide())
    end

    function PANEL:PerformLayout(w, h)
        local wide, tall = self:GetAutoWidth(), self:GetAutoHeight()

        self:SizeToChildren(wide, tall)
    end

    function PANEL:Paint(w, h)
        draw.RoundedBox(0, (w/2)-(self.expand/2), 0, self.expand, 4, Sharky.ColorTheme)
        --draw.RoundedBox(0, (w/2)-(self.expand/2), h-4, self.expand, 4, Sharky.ColorTheme)
    end

derma.DefineControl('Sharky.Divider', 'A simple divider that will hold content.', PANEL, 'EditablePanel')