local function RemoveSpawnTabs()
    for k, v in pairs(g_SpawnMenu.CreateMenu.Items) do
        if Sharky.DisabledSpawnTabs[v.Tab:GetText()] and Sharky.DisabledSpawnTabs[v.Tab:GetText()] == true then
            g_SpawnMenu.CreateMenu:CloseTab(v.Tab, true)
            RemoveSpawnTabs()
        end
    end
end
hook.Add('SpawnMenuOpen', 'Sharky:RemoveSpawnTabs', RemoveSpawnTabs)