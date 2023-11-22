Sharky = Sharky or {}

if CLIENT then
	-- thx le me
	local _R = debug.getregistry()
	local COLOR = _R.Color
	local CONVAR = _R.ConVar
	function Sharky.SetColorVar(convar, color)
		if debug.getmetatable(convar) ~= CONVAR then return end -- Not a convar
		if not convar:IsFlagSet(FCVAR_LUA_CLIENT) then return end -- Not a convar we can modify

		if not color then -- Passed nil, assume reset
			color = Color(255, 255, 255, 255)
		end

		if not IsColor(color) and color.r then -- Nice "color" retard
			if not debug.setmetatable(color, COLOR) then
				return -- Failed to set for some reason
			end
		end

		convar:SetString(tostring(color))  
	end

	function Sharky.GetColorVar(convar)
		return string.ToColor(convar:GetString()) -- string.ToColor handles epic fails for us
	end
end

function Sharky.DateFormat(time)
    local s = tostring(time) or '0'
    return string.format('%.2d:%.2d:%.2d', s/(60*60), s/60%60, s%60)
end

function Sharky.TimeFormat(time)
	local tmp = time / 60 / 60

	if tmp < 1 then
		tmp = math.Round(tmp * 60)
		return tmp .. ' m'
	elseif tmp < 10 then
		local minutes = tmp - math.floor(tmp)
		minutes = (math.Round(minutes * 60))
		return math.floor(tmp) .. ':' .. Format('%.2d', minutes) .. ' h'
	else
		tmp = math.Round(tmp)
		return tmp ..  ' h'
	end
end