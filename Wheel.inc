include <../Utils/Units.inc>
include <../Utils/Config.inc>
include <Links.inc>
use <Wheel.scad>

function WheelConfig(
    link_config = LinkConfig(),
    axcel       = 3.0,
    hub_height  = 4.0
) = Config(undef,
    "WheelConfig",
    let(
        link_center_radius = ConfigGet(link_config, "center_radius"),
        link_tooth_size    = ConfigGet(link_config, "tooth_size"),
        link_thickness     = ConfigGet(link_config, "thickness"),
        hub_diameter       = axcel + 2 * link_thickness,
        radius = (
            link_center_radius + link_tooth_size / 2
        )
    )
    [
        ["link_config", link_config],
        ["axcel",       axcel],
        ["hub_height",  hub_height],
        /* Derived */
        ["hub_diameter", hub_diameter],
        ["radius",       radius]
    ]
);
