include <../../Utils/Units.inc>
include <../../Utils/Config.inc>
include <../Links.inc>

use<Groove.scad>

function GrooveConfig(
    link_config                  = LinkConfig(),
    tolerance_xy_hub_top         = mm(.25),
    tolerance_xy_hub_bottom      = mm(.15),
    tolerance_xy_straight_top    = mm(.20),
    tolerance_xy_straight_bottom = mm(.30),
    tolerance_z                  = mm(.35),
    wheel_clearance_xy           = mm(.2),
    wheel_axcel_clearance_xy     = mm(.1),
) = Config(undef,
    "GrooveConfig",
    let(
        link_height        = ConfigGet(link_config, "height"),
        link_top_height    = ConfigGet(link_config, "top_height"),
        overhang_thickness = (
            link_top_height - tolerance_z
        ), seam_position = (
            (link_top_height + link_height) / 2
        ), depth = (
            link_height
        )
    ) [
        ["link_config",                  link_config],
        ["tolerance_xy_hub_top",         tolerance_xy_hub_top],
        ["tolerance_xy_hub_bottom",      tolerance_xy_hub_bottom],
        ["tolerance_xy_straight_top",    tolerance_xy_straight_top],
        ["tolerance_xy_straight_bottom", tolerance_xy_straight_bottom],
        ["tolerance_z",                  tolerance_z],
        ["wheel_clearance_xy",           wheel_clearance_xy],
        ["wheel_axcel_clearance_xy",     wheel_axcel_clearance_xy],
        /* Derived */
        ["overhang_thickness",           overhang_thickness],
        ["seam_position",                seam_position],
        ["depth",                        depth]
    ]
);


