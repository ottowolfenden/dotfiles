import QtQuick
import QtQuick.Shapes
import ".."

Shape {
    id: s
    property int c: 20
    property int h: height
    property int w: width
    property int r: Config.radius

    ShapePath {
        strokeWidth: 0
        startX: 0
        startY: s.h - s.r

        PathLine {
            x: 0
            y: 3 * s.r + s.c
        }
        PathArc {
            x: s.r
            y: 2 * s.r + s.c
            radiusX: Config.radius
            radiusY: Config.radius
        }
        PathLine {
            x: s.r + s.c
            y: 2 * s.r + s.c
        }
        PathArc {
            x: 2 * s.r + s.c
            y: s.r + s.c
            radiusX: Config.radius
            radiusY: Config.radius
            direction: PathArc.Counterclockwise
        }
        PathLine {
            x: 2 * s.r + s.c
            y: s.r
        }
        PathArc {
            x: 3 * s.r + s.c
            y: 0
            radiusX: Config.radius
            radiusY: Config.radius
        }
        PathLine {
            x: s.w - 3 * s.r - s.c
            y: 0
        }
        PathArc {
            x: s.w - 2 * s.r - s.c
            y: s.r
            radiusX: Config.radius
            radiusY: Config.radius
        }
        PathLine {
            x: s.w - 2 * s.r - s.c
            y: s.r + s.c
        }
        PathArc {
            x: s.w - s.r - s.c
            y: 2 * s.r + s.c
            direction: PathArc.Counterclockwise
            radiusX: Config.radius
            radiusY: Config.radius
        }
        PathLine {
            x: s.w - s.r
            y: 2 * s.r + s.c
        }
        PathArc {
            x: s.w
            y: 3 * s.r + s.c
            radiusX: Config.radius
            radiusY: Config.radius
        }
        PathLine {
            x: s.w
            y: s.h - s.r
        }
        PathArc {
            x: s.w - s.r
            y: s.h
            radiusX: Config.radius
            radiusY: Config.radius
        }
        PathLine {
            x: s.r
            y: s.h
        }
        PathArc {
            x: 0
            y: s.h - s.r
            radiusX: Config.radius
            radiusY: Config.radius
        }
    }
}
