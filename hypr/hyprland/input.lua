hl.config({
    input = {
        kb_layout = "gb",
        kb_options = "fkeys:basic_13-24",
        follow_mouse = 1,
        sensitivity = 0.05,
        touchpad = { natural_scroll = true, scroll_factor = 0.1 }
    },
    binds = { scroll_event_delay = 40 }
})

hl.device({
    name = "mouse",
    sensitivity = -0.6
})
