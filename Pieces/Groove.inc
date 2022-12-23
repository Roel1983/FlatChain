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
        link_height            = ConfigGet(link_config, "height"),
        link_top_height        = ConfigGet(link_config, "top_height"),
        link_joint_radius      = ConfigGet(link_config, "joint_radius"),
        link_bottom_inner_side = ConfigGet(link_config, "bottom_inner_side"),
        link_top_outer_side    = ConfigGet(link_config, "top_outer_side"),
        link_top_inner_side    = ConfigGet(link_config, "top_inner_side"),
        link_bottom_outer_side = ConfigGet(link_config, "bottom_outer_side"),
        overhang_thickness = (
            link_top_height - tolerance_z
        ), seam_position = (
            (link_top_height + link_height) / 2
        ), depth = (
            link_height
        ), straight_top_inner = (
            link_joint_radius
            - link_top_inner_side
            - tolerance_xy_straight_top / 2
        ), straight_top_outer = (
            link_joint_radius
            + link_top_outer_side
            + tolerance_xy_straight_top / 2
        ), straight_bottom_inner = (
            link_joint_radius
            - link_bottom_inner_side
            - tolerance_xy_straight_bottom / 2
        ), straight_bottom_outer = (
            link_joint_radius
            + link_bottom_outer_side
            + tolerance_xy_straight_bottom / 2
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
        ["depth",                        depth],
        ["straight_top_inner",           straight_top_inner],
        ["straight_top_outer",           straight_top_outer],
        ["straight_bottom_inner",        straight_bottom_inner],
        ["straight_bottom_outer" ,       straight_bottom_outer]
    ]
);


