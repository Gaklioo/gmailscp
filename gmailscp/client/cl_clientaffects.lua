include("gmailscp/sh_mailscp.lua")

gMail.PinkScreen = {
    [ "$pp_colour_addr" ] = 0.00,
	[ "$pp_colour_addg" ] = 0.00,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 19,
	[ "$pp_colour_mulg" ] = 0.00,
	[ "$pp_colour_mulb" ] = 3
}

net.Receive("gMailSCP_ChangePlayerColor", function()
    local ply = LocalPlayer()
    hook.Add("RenderScreenspaceEffects", "gMailSCP_ChangePlayerScreenColor" .. ply:SteamID(), function()
        DrawColorModify(gMail.PinkScreen)
    end)
end)

net.Receive("gMailSCP_RemovePlayerColor", function()
    local ply = LocalPlayer()
    hook.Remove("RenderScreenspaceEffects", "gMailSCP_ChangePlayerScreenColor" .. ply:SteamID())
end)

net.Receive("gMailSCp_StartToyTown", function()
    local ply = LocalPlayer()

    hook.Add("RenderScreenspaceEffects", "gMailSCP_StartToyTownClient" .. ply:SteamID(), function()
        DrawToyTown(10, ScrH())
    end)
end)

net.Receive("gMailSCP_RemovePlayerToyTown", function()
    local ply = LocalPlayer()

    hook.Remove("RenderScreenspaceEffects", "gMailSCP_StartToyTownClient" .. ply:SteamID())
end)