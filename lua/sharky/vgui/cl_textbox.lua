local PANEL = {}

AccessorFunc(PANEL, 'Text', 'Text', FORCE_STRING)
AccessorFunc(PANEL, 'Font', 'Font', FORCE_STRING)
AccessorFunc(PANEL, 'Align', 'Align', FORCE_NUMBER)
AccessorFunc(PANEL, 'TextColor', 'TextColor')
AccessorFunc(PANEL, 'AutoHeight', 'AutoHeight', FORCE_BOOL)
AccessorFunc(PANEL, 'AutoWidth', 'AutoWidth', FORCE_BOOL)
AccessorFunc(PANEL, 'Wrap', 'Wrap', FORCE_BOOL)

function PANEL:Init()
	self:SetText('Text')
	self:SetFont('Sharky.16')
	self:SetTextColor(Sharky.TextEntryTextColor)
	self:SetAlign(TEXT_ALIGN_LEFT)
end

function PANEL:SetText(text)
    self.Text = text
    self.OriginalText = text
end

function PANEL:ReLayout()
    surface.SetFont(self:GetFont())
    return surface.GetTextSize(self:GetText())
end

function PANEL:PerformLayout(w, h)
    local desiredW, desiredH = self:ReLayout()

    if self:GetAutoWidth() then
        self:SetWide(desiredW)
    end

    if self:GetAutoHeight() then
        self:SetTall(desiredH)
    end

    if self:GetWrap() then
		self.Text = Sharky.WrapText(self.OriginalText, w, self:GetFont())
    end
end

function PANEL:Paint(w, h)
    local align = self:GetAlign()

    if align == TEXT_ALIGN_CENTER then
        --draw.DrawText(self.Text, self:GetFont(), (w/2)-1, 0+1, ColorAlpha(color_black, self:GetTextColor().a*0.75), self:GetAlign())
	    draw.DrawText(self.Text, self:GetFont(), (w/2), 0, self:GetTextColor(), self:GetAlign())
    elseif align == TEXT_ALIGN_RIGHT then
        --draw.DrawText(self.Text, self:GetFont(), (w)-1, 0+1, ColorAlpha(color_black, self:GetTextColor().a*0.75), self:GetAlign())
	    draw.DrawText(self.Text, self:GetFont(), (w), 0, self:GetTextColor(), self:GetAlign())
    elseif align == TEXT_ALIGN_LEFT then
        --draw.DrawText(self.Text, self:GetFont(), 0-1, 0+1, ColorAlpha(color_black, self:GetTextColor().a*0.75), self:GetAlign())
	    draw.DrawText(self.Text, self:GetFont(), 0, 0, self:GetTextColor(), self:GetAlign())
    end
end

derma.DefineControl('Sharky.TextBox', 'Custom themed text label, should be themed around Pixits style.', PANEL, 'Panel')