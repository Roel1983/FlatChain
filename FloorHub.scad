use <FloorHubBottom.scad>
use <FloorHubCap.scad>
use <FloorHubTop.scad>
include <LinkA.inc>
include <LinkB.inc>
include <Wheel.inc>

link_config     = LinkConfig();
wheel_config    = WheelConfig(link_config = link_config);
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

%FloorHubBottom(floor_config);
FloorHubCap(floor_config);
FloorHubTop(floor_config);

size            = ConfigGet(link_config, "size");
joint_radius    = ConfigGet(link_config, "joint_radius");
center_radius   = ConfigGet(link_config, "center_radius");
angle           = ConfigGet(link_config, "angle");

color("blue") Wheel(wheel_config);
for (i = [0 : 4]) {
    rotate(-i * angle) translate([0, -center_radius]) {
        if(i % 2 == 0) {
            color("red") render() LinkA(link_config);
        } else {
            color("green") LinkB(link_config);
        }
    }
}

translate([2*size, -joint_radius]) color("green") LinkB(link_config);