hl.config({
    general = {
        gaps_in = 3.5,
        gaps_out = 3.5 * 2,
        border_size = 0,
        layout = "dwindle"
    },

    decoration = {
        rounding = 5,
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
