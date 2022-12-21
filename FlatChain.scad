include <../Utils/Units.inc>
include <LinkA.inc>
include <LinkB.inc>
include <Wheel.inc>

%mirror([0,0,1]) linear_extrude(3) square([44, 46], true);

link_config  = LinkConfig();
wheel_config = WheelConfig(link_config = link_config) ;

link_size          = ConfigGet(link_config, "size");
link_angle         = ConfigGet(link_config, "angle");
echo(link_center_radius);
link_center_radius = (link_size / 2) / tan(link_angle / 2);
link_joint_radius  = sqrt(pow(link_center_radius, 2) + pow(link_size/2, 2));

Wheel(wheel_config);


translate([  0, -link_joint_radius]) LinkB(link_config);
translate([link_size, 0-link_joint_radius]) LinkA(link_config);
