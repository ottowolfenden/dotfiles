hl.config({
    general = {
        gaps_in = 7,
        gaps_out = 7 * 2,

        border_size = 1,

        col = {
            active_border = "#89ddff",
            inactive_border = "rgba(0,0,0,0)"
        },

        resize_on_border = true,

        layout = "dwindle"
    },

    decoration = {
        rounding = 5,
        rounding_power = 2, -- circular

        active_opacity = 1.0,
        inactive_opacity = 0.8,

        blur = {
            enabled = true,
            size = 5,
            passes = 3,
            vibrancy = 0.1696,
        },

        shadow = { enabled = false }
    },

    animations = { enabled = true }
})
