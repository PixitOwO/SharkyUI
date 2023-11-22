local customstuff = {
    ['STEAM_0:1:26929632'] = 'pixit_disconnect'
}

if Sharky.DisconnectEffectEnabled then
    hook.Add('PlayerDisconnected', 'Sharky.DisconnectEffect', function(ply)
        if ply:IsListenServerHost() then return end
        if (player.GetCount() < 2) then return end
        local pos = ply:LocalToWorld(ply:OBBCenter())
    	local checker = customstuff[ply:SteamID()]
    	if checker then
            if util.IsInWorld(pos) then
                local fx = EffectData()
                fx:SetOrigin(pos)
                fx:SetScale(10)
                fx:SetStart(ply:GetPlayerColor()*255)
                util.Effect(checker, fx, true, true)
            end
        else
            if util.IsInWorld(pos) then
                local fx = EffectData()
                fx:SetOrigin(pos)
                fx:SetScale(10)
                fx:SetStart(ply:GetPlayerColor()*255)
                util.Effect('balloon_pop', fx, true, true)
            end
    	end
    end)
end