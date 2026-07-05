local gaps = 4

hl.config({
    general = {
        gaps_in = gaps,
        gaps_out = { top = gaps * 2 + 2, left = gaps * 2, bottom = gaps * 2, right = gaps * 2 },
        border_size = 0,
        layout = "dwindle"
    },

    decoration = {
        rounding = 8,
        rounding_power = 2, -- circular

        active_opacity = 1.0,
        inactive_opacity = 0.85,

        blur = {
            enabled = true,
            size = 10,
            passes = 4,
            vibrancy = 0,
        },

        shadow = { enabled = false }
    },

    animations = { enabled = true }
})
