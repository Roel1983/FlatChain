include <../Utils/Config.inc>
include <../Utils/Constants.inc>
include <../Utils/Units.inc>

include <Pieces/Groove.inc>

function FloorConfig(
    groove_config       = GrooveConfig(),
    width               = mm(40.0),
    hub_length          = mm(60.0),
    overlap             = mm(10.0),
    thickness           = mm(3.8),
    hub_hexnut_wall     = nozzle(2),
    hub_hexnut_size     = mm([5.45, 2.5]),
    hub_screw_diameter  = mm(3.0),
    slot_clearance      = mm(0.03),
    straight_link_count = 30,
) = Config(undef,
    "GrooveConfig",
    let(
        link_config               = ConfigGet(groove_config, "link_config"),
        groove_wheel_clearance_xy = ConfigGet(groove_config, "wheel_clearance_xy"),
        groove_hub_bottom_outer   = ConfigGet(groove_config, "hub_bottom_outer"),
        link_size                 = ConfigGet(link_config,   "size"),
        wheel_radius              = ConfigGet(link_config,   "wheel_radius"),
        link_360_pair_count       = ConfigGet(link_config,   "360_pair_count"),
        slot_width                = nozzle(2),
        slot_edge_distance        = nozzle(3) + slot_clearance / 2,
        min_wall_thickness = (
            2 * slot_edge_distance + slot_width
        ), hub_position = (
            assert(link_360_pair_count % 2 == 0, "Not tested for odd pair counts")
            hub_length
            - floor(
                (
                    hub_length
                    - min_wall_thickness
                    - groove_hub_bottom_outer
                )
                / link_size
            ) * link_size
            
        ), hub_hexnut_pos = (
            wheel_radius
            + groove_wheel_clearance_xy
            + hub_hexnut_wall * 2 + slot_clearance
            + hub_hexnut_size[X] / 2
            + hub_position
        ), hub_cap_size = (
            hub_length
            - hub_position
            - overlap
        ), straight_len = (
            straight_link_count * link_size
        )
    ) [
        ["groove_config",      groove_config],
        ["width",              width],
        ["hub_length",         hub_length],
        ["overlap",            overlap],
        ["thickness",          thickness],
        ["hub_hexnut_wall",    hub_hexnut_wall],
        ["hub_hexnut_size",    hub_hexnut_size],
        ["hub_screw_diameter", hub_screw_diameter],
        ["slot_clearance",     slot_clearance],
        ["hub_cap_size",       hub_cap_size],
        ["straight_link_count", straight_link_count],
        /* Derived */
        ["hub_hexnut_pos",     hub_hexnut_pos],
        ["hub_position",       hub_position],
        ["slot_width",         slot_width],
        ["slot_edge_distance", slot_edge_distance],
        ["min_wall_thickness", min_wall_thickness],
        ["straight_len",       straight_len]
    ]
);
