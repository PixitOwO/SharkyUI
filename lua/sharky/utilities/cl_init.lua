Sharky = Sharky or {}

Sharky.IsMenuOpen = false

Sharky.resFormat = function(v)
    return math.Round(math.max(v * (ScrH() / 1080), 1))
end

function Sharky.DotOff(text, limit)
    text = text or 'ERROR'
    limit = limit or Sharky.resFormat(100)

    --[[local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char..'...')

        if totalWidth >= limit then
            return char
        end

        return char
    end)]]

    local expandedtext = string.Explode('', text)

    local totalWidth = 0
    for _, char in pairs(expandedtext) do
        totalWidth = totalWidth + surface.GetTextSize(char..'...')

        if totalWidth >= limit then
        end
    end

    return text
end

function Sharky.LerpColor(t, from, to)
	return Color(
		(1 - t) * from.r + t * to.r,
		(1 - t) * from.g + t * to.g,
		(1 - t) * from.b + t * to.b,
		(1 - t) * from.a + t * to.a
	)
end

local function hueToRgb(p, q, t)
    if t < 0 then t = t + 1 end
    if t > 1 then t = t - 1 end
    if t < 1 / 6 then return p + (q - p) * 6 * t end
    if t < 1 / 2 then return q end
    if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
    return p
end

function Sharky.HSLToColor(h, s, l, a)
    local r, g, b
    local t = h / (2 * math.pi)

    if s == 0 then
        r, g, b = l, l, l
    else
        local q
        if l < 0.5 then
            q = l * (1 + s)
        else
            q = l + s - l * s
        end

        local p = 2 * l - q
        r = hueToRgb(p, q, t + 1 / 3)
        g = hueToRgb(p, q, t)
        b = hueToRgb(p, q, t - 1 / 3)
    end

    return Color(r * 255, g * 255, b * 255, (a or 1) * 255)
end

function Sharky.PlaySoundFile(path, volume)
	if Sharky.SoundEnabled then
		sound.PlayFile(path, 'mono', function(station)
			if !IsValid(station) then return end
			station:Play()
			station:SetVolume(volume or 0.1)
		end)
	end
end

local textWrapCache = {}

local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        if totalWidth >= remainingWidth then
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

function Sharky.WrapText(text, width, font)
    local chachedName = text .. width .. font
    if textWrapCache[chachedName] then return textWrapCache[chachedName] end

    surface.SetFont(font)
    local textWidth = surface.GetTextSize(text)

    if textWidth <= width then
        textWrapCache[chachedName] = text
        return text
    end

    local totalWidth = 0
    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
        local char = string.sub(word, 1, 1)
        if char == "\n" or char == "\t" then
            totalWidth = 0
        end

        local wordlen = surface.GetTextSize(word)
        totalWidth = totalWidth + wordlen

        if wordlen >= width then
            local splitWord, splitPoint = charWrap(word, width - (totalWidth - wordlen), width)
            totalWidth = splitPoint
            return splitWord
        elseif totalWidth < width then
            return word
        end

        if char == ' ' then
            totalWidth = wordlen - spaceWidth
            return '\n' .. string.sub(word, 2)
        end

        totalWidth = wordlen
        return '\n' .. word
    end)

    textWrapCache[chachedName] = text
    return text
end

local int = 0
for i=0,50 do
    int = int + 1
	surface.CreateFont('Sharky.' .. int, {size = Sharky.resFormat(int), weight = 300, antialias = true, extended = true, font = 'cream DEMO'})
end

local int = 0
for i=0,50 do
    int = int + 1
	surface.CreateFont('Sharky.NoScale.' .. int, {size = int, weight = 300, antialias = true, extended = true, font = 'cream DEMO'})
end