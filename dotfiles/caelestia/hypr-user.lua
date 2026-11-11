hl.config({
    input = {
        kb_layout = "latam",
        kb_variant = "nodeadkeys",
    },
})

local dirs = {
    H = "left",
    J = "down",
    K = "up",
    L = "right",
}

for key, dir in pairs(dirs) do
    hl.bind(
        "SUPER + " .. key,
        hl.dsp.focus({ direction = dir })
    )

    hl.bind(
        "SUPER + SHIFT + " .. key,
        hl.dsp.window.move({ direction = dir })
    )
end

hl.bind(
    "SUPER + P",
    hl.dsp.exec_cmd(
        "sh ~/.config/sway/cambiar_audio.sh"
    )
)
hl.bind(
    "SUPER + Y",
    hl.dsp.exec_cmd(
        "flatpak run org.jellyfin.JellyfinDesktop"
    )
)
hl.on("hyprland.start", function()
    hl.exec_cmd("lxqt-policykit-agent")
    hl.exec_cmd("udiskie")
end)
