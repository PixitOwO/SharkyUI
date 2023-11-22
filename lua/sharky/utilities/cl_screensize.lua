Sharky = Sharky or {}

Sharky.ScrW = ScrW() or 1920
Sharky.ScrH = ScrH() or 1080

hook.Add('OnScreenSizeChanged', 'Sharky.ScreenSize', function(oldW, oldH)
    if oldW == ScrW() and oldH == ScrH() then return end
    Sharky.ScrW = ScrW() or 1920
    Sharky.ScrH = ScrH() or 1080
end)