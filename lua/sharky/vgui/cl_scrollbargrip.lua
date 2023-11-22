local PANEL = {}

function PANEL:Init()
	self.BarScale = 6
	self.Color = ColorAlpha(Sharky.ColorTheme, Sharky.ColorTheme.a)
	self.ColorA = self.Color.a
end

function PANEL:OnMousePressed()
	self:GetParent():Grip(1)
end

function PANEL:Think()
	if self:IsHovered() or self:GetParent().Dragging then
		self.BarScale = Lerp(10 * FrameTime(), self.BarScale, self:GetWide())
	else
		self.BarScale = Lerp(10 * FrameTime(), self.BarScale, 6)
	end

	if self:GetParent().Dragging then
		self.Color.a = Lerp(10 * FrameTime(), self.Color.a, 255)
	else
		self.Color.a = Lerp(10 * FrameTime(), self.Color.a, self.ColorA)
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(Sharky.RoundedUI:GetInt(), w - self.BarScale, 0, self.BarScale, h, self.Color)
	return true
end

derma.DefineControl('Sharky.ScrollBarGrip', '', PANEL, 'DPanel')