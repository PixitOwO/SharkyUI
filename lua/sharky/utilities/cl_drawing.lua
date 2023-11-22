Sharky = Sharky or {}

local distance = 250
Sharky.DisplayEnt = function(ent, text, mat, height, text2)
	local ply = LocalPlayer()
    if ply:GetPos():Distance(ent:GetPos()) > (distance*2) then return end

    local Pos = ent:GetPos()
    local line = LocalPlayer():GetEyeTrace()
    local tr = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
    if ply:GetPos():Distance(ent:GetPos()) < distance then
        ent.alpha = Lerp(RealFrameTime()*10, ent.alpha or 0, 255)
    else
        ent.alpha = Lerp(RealFrameTime()*10, ent.alpha or 255, 0)
    end

    if tr.Entity:IsValid() and tr.Entity == ent and LocalPlayer():GetPos():Distance(ent:GetPos()) < 250 then 
        ent.alphalook = Lerp(RealFrameTime()*10, ent.alphalook or 0, 255)
    else
        ent.alphalook = Lerp(RealFrameTime()*10, ent.alphalook or 255, 0)
    end

	if ent.alpha < 1 then return end

	surface.SetFont("Sharky.NoScale.50")
	local textsize = surface.GetTextSize(text)

    cam.Start3D2D(Pos + Vector(0, 0, height), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
		Sharky.DrawRectangle((-textsize-70)/2+50, 0, textsize+20, 50, ColorAlpha(Sharky.BGColor4, ent.alphalook))
		Sharky.DrawRectangle((-textsize-70)/2, 0, 50, 50, ColorAlpha(Sharky.BGColor2, ent.alphalook))
		Sharky.DrawRectangle((-textsize-70)/2, 50, textsize+70, 4, ColorAlpha(Sharky.ColorTheme, ent.alphalook))
		Sharky.DrawRectangle((-textsize-70)/2, -4, textsize+70, 4, ColorAlpha(Sharky.ColorTheme, ent.alphalook))

		Sharky.Icon((-textsize-52)/2, 7, 35, 35, mat, ColorAlpha(Sharky.TextColor, ent.alpha))

		Sharky.DrawShadowText(text, 'Sharky.NoScale.50', (-textsize+50)/2, 0, ColorAlpha(Sharky.TextColor, ent.alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, -2, 2)
    
        if text2 then
            Sharky.DrawShadowText(text2, 'Sharky.NoScale.25', 0, -40, ColorAlpha(Sharky.ColorTheme, ent.alphalook), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

    cam.End3D2D()
end

local gradientdown = Material('gui/gradient_down', 'smooth mips')
local gradientup = Material('gui/gradient_up', 'smooth mips')
Sharky.DrawGradientBox = function(x, y, w, h, color1, color2, upwards)
    surface.SetDrawColor(color1)
    surface.DrawRect(x, y, w, h)

	if upwards then
    	surface.SetMaterial(gradientup)
	else
		surface.SetMaterial(gradientdown)
	end
    surface.SetDrawColor(color2)
    surface.DrawTexturedRect(x, y, w, h)
end

Sharky.DrawTexturedRotatedBox = function(x, y, w, h, ang, color)
	Sharky.ResetTexture()
	surface.SetDrawColor(color or color_white)
	surface.DrawTexturedRectRotated(x, y, w, h, ang)
    surface.SetMaterial(Material('gui/gradient_down', 'smooth mips'))
    surface.SetDrawColor(Color(0, 0, 0, 150))
	surface.DrawTexturedRectRotated(x, y, w, h, ang)
end

Sharky.DrawCircle = function(x, y, radius, seg)
	local cir = {}

	table.insert(cir, { x = x, y = y, u = 0.5, v = 0.5 })
	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(cir, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(cir, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })

	draw.NoTexture()
	surface.DrawPoly(cir)
end

local pan_x, pan_y
local blur = Material("pp/blurscreen")
Sharky.DrawBlur = function(panel, amount, alpha)
	pan_x, pan_y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor(color_white)
	if alpha then
		surface.SetDrawColor(ColorAlpha(color_white, alpha))
	end
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(pan_x * -1, pan_y * -1, ScrW(), ScrH())
	end
end

Sharky.DrawShadowText = function(text, font, x, y, colortext, xalign, yalign, xoffset, yoffset, rainbow)
    text = text or 'ERROR'
    font = font or 'Sharky.25'
    x = x or ScrW()/2
    y = y or ScrH()/2
    colortext = colortext or color_white
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_CENTER
    xoffset = xoffset or -2
    yoffset = yoffset or 2
	rainbow = rainbow or false

	if rainbow then
		draw.SimpleText(text, font, x + (xoffset), y + (yoffset), Color(0, 0, 0, colortext.a*0.8), xalign, yalign)
		local texte = string.Explode('', text)
    	surface.SetFont(font)
    	local chars_x = 0
    	for i = 1, #texte do
    	    color = ColorAlpha(HSVToColor((i*2)+(SysTime()*60%360), 1, 1), alpha)
    	    local char = texte[i]
    	    local textw, texth = surface.GetTextSize(text)
    	    local charw, charh = surface.GetTextSize(char)
    	    draw.SimpleText(char, font, (x + chars_x), y, Color(color.r, color.g, color.b, alpha), xalign, yalign)
    	    chars_x = chars_x + charw
    	end
	else
		draw.SimpleText(text, font, x + (xoffset), y + (yoffset), Color(0, 0, 0, colortext.a*0.8), xalign, yalign)
		draw.SimpleText(text, font, x, y, colortext, xalign, yalign)
	end
end

Sharky.Icon = function(x, y, w, h, mat, color, rainbow)
    if rainbow then
        color = ColorAlpha(Sharky.Rainbow, alpha)
    end

	surface.SetMaterial(mat)
	surface.SetDrawColor(Color(0, 0, 0, color.a*0.8))
	surface.DrawTexturedRect(x - (w*0.1), y + 1, w, h)

	surface.SetMaterial(mat)
	surface.SetDrawColor(color or Sharky.ColorTheme)
	surface.DrawTexturedRect(x, y, w, h)
end

Sharky.DrawRectangle = function(x, y, w, h, col)
	Sharky.ResetTexture()
	surface.SetDrawColor(col.r, col.g, col.b, col.a)
	surface.DrawRect(x, y, w, h)
end

Sharky.DrawTexturedRectangle = function(x, y, w, h, mat, col)
	surface.SetDrawColor(col.r, col.g, col.b, col.a)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(x, y, w, h)
end

Sharky.DrawTexturedRotatedRectangle = function(x, y, w, h, ang, mat, color)
	Sharky.ResetTexture()
	surface.SetDrawColor(color or color_white)
	surface.SetMaterial(mat)
	surface.DrawTexturedRectRotated(x, y, w, h, ang)
end

Sharky.DrawOutlinedRectangle = function(x, y, w, h, col)
	Sharky.ResetTexture()
	surface.SetDrawColor(col.r, col.g, col.b, col.a)
	surface.DrawOutlinedRect(x, y, w, h)
end

local resetmat = Material('vgui/white', 'noclamp smooth')
Sharky.ResetTexture = function()
	surface.SetMaterial(resetmat)
end
