include <../Utils/Units.inc>
include <LinkA.inc>
include <LinkB.inc>
include <Wheel.inc>

%mirror([0,0,1]) linear_extrude(3) square([44, 50], true);

link_config  = LinkConfig();
wheel_config = WheelConfig(link_config = link_config) ;

link_size          = ConfigGet(link_config, "size");
link_angle         = ConfigGet(link_config, "angle");
link_center_radius = ConfigGet(link_config, "center_radius");
link_joint_radius  = ConfigGet(link_config, "joint_radius");

Wheel(wheel_config);


translate([  0, -link_center_radius]) LinkA(link_config);
translate([link_size, 0-link_center_radius]) LinkB(link_config);
