include <../Utils/Units.inc>
include <../Utils/Config.inc>
include <Links.inc>
use <Wheel.scad>

function WheelConfig(
    link_config = LinkConfig(),
    axcel       = 3.0,
    hub_height  = 8.0
) = Config(undef,
    "WheelConfig",
    [
        ["link_config", link_config],
        ["axcel",       axcel],
        ["hub_height",  hub_height]
    ]
);
