UNITS_NOZZLE = mm(0.4);
UNITS_LAYER  = mm(0.1);
include <../Utils/Units.inc>
include <../Utils/Config.inc>

function LinkConfig(
    // Size of the link from pivot to pivot
    size               = mm(8),
    // Thickness of the sliding wall
    thickness          = nozzle(3),
    // Thickness of the tooth drving this link
    tooth_size         = nozzle(3),
    // Tolerance in the X-Y-plane direction for the moving parts
    tolerance_xy       = mm(0.03),
    360_pair_count     = 4,
    // Total height of the link (exclusive tolerance)
    height             = layer(28),
    // Height of the top part of the link
    top_height         = layer(7),
    // Height of the bottom part of the link
    bottom_height      = layer(6),
    tolerance_z        = layer(1),
    // Tolerance of compensate hanging bridges
    bridge_tolerance_z = layer(3)
) = Config(undef,
    "LinkConfig",
    let(
        angle      = (
            180 / 360_pair_count
        ), joint_size = (
            size
            - tooth_size
            - 2 * thickness
            - 4 * tolerance_xy
        ), joint_path_radius = (
            0.5 * joint_size
            + tolerance_xy
            + 0.5 * thickness
        ), joint_path_width = (
            thickness 
            + 2 * tolerance_xy
        ), inner_angle = asin(
            (
                joint_size / 2
                - thickness * 1.5
                - tolerance_xy
            ) / joint_path_radius
        ), grip_angle = (
            inner_angle + angle
        ), center_radius = (
            (size / 2) / tan(angle / 2)
        ), joint_radius = (
            sqrt(pow(center_radius, 2) + pow(size/2, 2))
        ), top_outer_side = (
            0.5 * joint_size
            + 2 * tolerance_xy
            + 1 * thickness
        ), top_inner_side = (
            joint_size / 2
        ), bottom_inner_side = (
            top_outer_side - tolerance_xy
        ), bottom_outer_edge_radius = (
            norm([
                size / 2 + sin(inner_angle) * joint_path_radius,
                center_radius + cos(inner_angle) * joint_path_radius
            ]) + 1.5 * thickness + tolerance_xy
        ), bottom_outer_side = (
            bottom_outer_edge_radius - center_radius
        ), wheel_radius = (
            center_radius + tooth_size / 2
        )
    )
    assert(
        grip_angle >= 15,
        str("Grip angle too low: ", grip_angle, " < ", 90)
    )
    [
        ["size",               size],
        ["thickness",          thickness],
        ["tooth_size",         tooth_size],
        ["tolerance_xy",       tolerance_xy],
        ["360_pair_count",     360_pair_count],
        ["height",             height],
        ["top_height",         top_height],
        ["bottom_height",      bottom_height],
        ["tolerance_z",        tolerance_z],
        ["bridge_tolerance_z", bridge_tolerance_z],
        /* Derived */
        ["angle",              angle],
        ["joint_size",         joint_size],
        ["joint_path_radius",  joint_path_radius],
        ["joint_path_width",   joint_path_width],
        ["inner_angle",        inner_angle],
        ["center_radius",      center_radius],
        ["joint_radius",       joint_radius],
        ["top_outer_side",     top_outer_side],
        ["top_inner_side",     top_inner_side],
        ["bottom_outer_side",  bottom_outer_side],
        ["bottom_inner_side",  bottom_inner_side],
        ["bottom_outer_edge_radius", bottom_outer_edge_radius],
        ["wheel_radius",       wheel_radius]
    ]
);
