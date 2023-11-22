local customstuff = {
    ['STEAM_0:1:26929632'] = 'sound/sharky/return_by_death.mp3'
}

if Sharky.SpawnSoundEnabled then
    hook.Add('PlayerSpawn', 'Sharky:SpawnSoundSpawn', function(ply)
        if customstuff[ply:SteamID()] then
            ply:EmitSound(customstuff[ply:SteamID()], 50, 100)
        else
            ply:EmitSound(Sharky.SpawnSound, 50, 100)
        end
    end)

    hook.Add('PlayerInitialSpawn', 'Sharky:SpawnSoundInitSpawn', function(ply)
        if customstuff[ply:SteamID()] then
            ply:EmitSound(customstuff[ply:SteamID()], 50, 100)
        else
            ply:EmitSound(Sharky.SpawnSound, 50, 100)
        end
    end)
end