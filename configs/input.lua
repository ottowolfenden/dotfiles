hl.config({
    input = {
        kb_layout = "gb",
        kb_variant = "",
        kb_model = "",
        kb_options = "fkeys:basic_13-24",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0.05,
        touchpad = { natural_scroll = true, scroll_factor = 0.1 }
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.6
})
