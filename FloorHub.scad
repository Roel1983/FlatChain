use <FloorHubBottom.scad>
use <FloorHubCap.scad>
use <FloorHubTop.scad>
use <FloorHubTopInner.scad>
include <LinkA.inc>
include <LinkB.inc>
include <Wheel.inc>

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

FloorHub(floor_config, show_links = true);

module FloorHub(
    floor_config  = FloorConfig(),
    show_links    = false,
    inner_overlap = false
) {
    
    FloorHubBottom(floor_config);
    FloorHubCap(floor_config);
    FloorHubTop(floor_config);
    FloorHubTopInner(floor_config, inner_overlap = inner_overlap);

    groove_config   = ConfigGet(floor_config, "groove_config");
    link_config     = ConfigGet(groove_config, "link_config");
    wheel_config    = WheelConfig(link_config = link_config);
    size            = ConfigGet(link_config, "size");
    joint_radius    = ConfigGet(link_config, "joint_radius");
    center_radius   = ConfigGet(link_config, "center_radius");
    angle           = ConfigGet(link_config, "angle");
    floor_hub_position = ConfigGet(floor_config, "hub_position");

    if(show_links) {
        translate([floor_hub_position, 0]) {
            color("blue") Wheel(wheel_config);
            for (i = [1 : 3]) {
                rotate(-i * angle) translate([0, -center_radius]) {
                    if(i % 2 == 0) {
                        color("red") render() LinkA(link_config);
                    } else {
                        color("green") LinkB(link_config);
                    }
                }
            }

            translate([1*size, -joint_radius]) color("green") LinkB(link_config);
        }
    }
}