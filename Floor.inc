include <../Utils/Config.inc>
include <../Utils/Constants.inc>
include <../Utils/Units.inc>

include <Pieces/Groove.inc>

function FloorConfig(
    groove_config      = GrooveConfig(),
    width              = mm(40),
    hub_length         = mm(60),
    thickness          = mm(3.8),
    hub_hexnut_wall    = nozzle(2),
    hub_hexnut_size    = mm([5.5, 2.5]),
    hub_screw_diameter = mm(3.0),
    slot_clearance     = mm(0.05),
) = Config(undef,
    "GrooveConfig",
    let(
        link_config               = ConfigGet(groove_config, "link_config"),
        groove_wheel_clearance_xy = ConfigGet(groove_config, "wheel_clearance_xy"),
        wheel_radius              = ConfigGet(link_config,   "wheel_radius"),
        hub_hexnut_pos  = (
            wheel_radius
            + groove_wheel_clearance_xy
            + hub_hexnut_wall * 2 + slot_clearance
            + hub_hexnut_size[X] / 2
        )
    ) [
        ["groove_config",      groove_config],
        ["width",              width],
        ["hub_length",         hub_length],
        ["thickness",          thickness],
        ["hub_hexnut_wall",    hub_hexnut_wall],
        ["hub_hexnut_size",    hub_hexnut_size],
        ["hub_screw_diameter", hub_screw_diameter],
        ["slot_clearance",     slot_clearance],
        ["hub_hexnut_pos",     hub_hexnut_pos],
    ]
);
