local spacing = 8

hl.config({
    general = {
        gaps_in = spacing / 2,
        gaps_out = {
            top = spacing + 2,
            left = spacing,
            bottom = spacing,
            right = spacing
        },
        border_size = 0
    },

    decoration = {
        rounding = 8,
        rounding_power = 2,

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
