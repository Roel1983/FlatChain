include <../Utils/Box.inc>
include <../Utils/Bezier.inc>
include <../Utils/Debug.inc>
include <../Utils/Constants.inc>
include <../Utils/Functions.inc>
include <../Utils/LinearExtrude.inc>
include <../Utils/Points.inc>
include <../Utils/Shapes.inc>
include <LinkA.inc>
include <LinkB.inc>
include <Wheel.inc>
$fn=64;


link_config     = LinkConfig();
wheel_config    = WheelConfig(link_config = link_config);

size            = ConfigGet(link_config, "size");
link_height     = ConfigGet(link_config, "height");
link_top_height = ConfigGet(link_config, "top_height");
link_tooth_size = ConfigGet(link_config, "tooth_size");
joint_size      = ConfigGet(link_config, "joint_size");
360_pair_count  = ConfigGet(link_config, "360_pair_count");
angle           = ConfigGet(link_config, "angle");
link_inner_angle = ConfigGet(link_config, "inner_angle");
center_radius   = ConfigGet(link_config, "center_radius");
joint_radius    = ConfigGet(link_config, "joint_radius");
top_outer_side  = ConfigGet(link_config, "top_outer_side");
top_inner_side  = ConfigGet(link_config, "top_inner_side");
bottom_outer_side  = ConfigGet(link_config, "bottom_outer_side");
bottom_inner_side  = ConfigGet(link_config, "bottom_inner_side");
joint_path_radius = ConfigGet(link_config, "joint_path_radius");
link_thickness    = ConfigGet(link_config, "thickness");
link_tolerance_xy = ConfigGet(link_config, "tolerance_xy");
link_bottom_outer_edge_radius = ConfigGet(link_config, "bottom_outer_edge_radius");

wheel_radius       = ConfigGet(wheel_config, "radius");
wheel_hub_diameter = ConfigGet(wheel_config, "hub_diameter");

groove_tolerance_xy_hub_top         = mm(.25);
groove_tolerance_xy_hub_bottom      = mm(.3);
groove_tolerance_xy_straight_top    = mm(.2);
groove_tolerance_xy_straight_bottom = mm(.5);
groove_tolerance_z                  = mm(.3);
groove_wheel_clearance_xy           = mm(.2);
groove_wheel_axcel_clearance_xy     = mm(.1);

groove_hub_top_outer_radius = norm([
    center_radius + top_outer_side,
    (size + joint_size) / 2
]) + groove_tolerance_xy_hub_top / 2;
groove_hub_top_inner_radius = (
    center_radius - top_inner_side
) - groove_tolerance_xy_hub_top / 2;
groove_straight_top_outer = (
    joint_radius + top_outer_side
    + groove_tolerance_xy_straight_top / 2
);
groove_straight_top_inner = (
    joint_radius - top_inner_side
    - groove_tolerance_xy_straight_top / 2
);
groove_hub_bottom_outer_radius = (
    link_bottom_outer_edge_radius
    + groove_tolerance_xy_hub_bottom / 2
);
groove_hub_bottom_inner_radius = (
    center_radius - bottom_inner_side
    - groove_tolerance_xy_hub_bottom / 2
);
groove_straight_bottom_outer = (
    joint_radius + bottom_outer_side
    + groove_tolerance_xy_straight_bottom / 2
);
groove_straight_bottom_inner = (
    joint_radius - bottom_inner_side
    - groove_tolerance_xy_straight_bottom / 2
);

Bottom();
TopInnerHub();
!TopOuter();
module TopOuter() {
    render() union() {
        difference() {
            BIAS = 0.1;
            Box(x_from=-20, x_to=40, y_from = -20, y_to=20, z_from=-2, z_to = 0);
            LinearExtrude(z_from= -link_height, z_to = BIAS) {
                polygon(points_top_outer(35));
            }
            LinearExtrude(z_from= -link_height, z_to = -link_top_height + groove_tolerance_z) {
                polygon(points_bottom_outer(35));
            }
        }
        translate([-18,0]) {
            LinearExtrude(z_from= -2.7, z_to=-1.5) square([.8, 18.0], true);
        }
        translate([15,18]) {
            LinearExtrude(z_from= -2.7, z_to=-1.5) square([30., .8], true);
        }
        translate([15,-18]) {
            LinearExtrude(z_from= -2.7, z_to=-1.5) square([30., .8], true);
        }
    }
}

module TopInnerHub() {
    difference() {
        BIAS = 0.1;
        union() {
            LinearExtrude(z_from= -2, z_to = -BIAS) {
                polygon(points_bottom_inner(17.5));
            }
            hull() {
                LinearExtrude(z_from= -link_top_height + groove_tolerance_z, z_to = 0) {
                    polygon(points_top_inner(17.5));
                }
                translate([0,0,3]) {
                    LinearExtrude(z_from= -link_top_height + groove_tolerance_z, z_to = 0) {
                        offset(-3)polygon(points_top_inner(17.5 - 3/2));
                    }
                }
            }
            translate([24,0]) {
                LinearExtrude(z_from= -2.7, z_to=-1.5) square([8.0, .8], true);
            }
        }
        translate([15,0]) {
            LinearExtrude(z_from= -3, z_to=0.3) Hex(mm(5.6) + nozzle(4));
        }
        LinearExtrude(z_from= 1, z_to = 3 + BIAS) {
            circle(d=6);
        }
        
        LinearExtrude(z_from= -link_height, z_to = -link_top_height + groove_tolerance_z) {
            circle(r = wheel_radius + groove_wheel_clearance_xy);
        }
        
        translate([15,0]) {
            translate([0, 0, .8]) cylinder(d1 = 3, d2 = 7, h=3);
            LinearExtrude(z_from= -4, z_to=1) circle(d=mm(3.1));
        }
        LinearExtrude(z_from= -link_height, z_to = 3) {
            circle(d = wheel_hub_diameter + groove_wheel_axcel_clearance_xy);
        }
    }
}
module Bottom() {
    difference() {
        union() {
            Box(x_from=-20, x_to=40, y_from = -20, y_to=20, z_from=-3.8, z_to = -2);
            translate([15,0]) {
                LinearExtrude(z_from= -3, z_to=0) Hex(mm(5.5) + nozzle(4));
            }
        }
        LinearExtrude(z_from= -link_height, z_to = 0) {
            
            polygon(points_bottom(35));
            circle(r = wheel_radius + groove_wheel_clearance_xy);
        }
        LinearExtrude(z_from= -4, z_to=1) circle(d=mm(3.1));
        translate([15,0]) {
            LinearExtrude(z_from= -4, z_to=2) circle(d=mm(3.1));
            hull() {
                LinearExtrude(z_from= -4, z_to=-3.8 + 2.5) Hex(mm(5.5));
                LinearExtrude(z_from= -4, z_to=-3.8 + 2.5 + .8) circle(d=mm(3.1));
            }
        }
        translate([-18,0]) {
            LinearExtrude(z_from= -3, z_to=-1.5) square([.9, 18.1], true);
        }
        translate([24,0]) {
            LinearExtrude(z_from= -3, z_to=-1.5) square([8.1, .9], true);
        }
        translate([34.5,0]) {
            LinearExtrude(z_from= -3, z_to=-1.5) square([6.1, .9], true);
        }
        translate([15,18]) {
            LinearExtrude(z_from= -3, z_to=-1.5) square([30.1, .9], true);
        }
        translate([15,-18]) {
            LinearExtrude(z_from= -3, z_to=-1.5) square([30.1, .9], true);
        }
    }
}


hub_path_length = size * 2 - mm(5);

function points_top_outer(extra) = groove_points(
    groove_straight    = groove_straight_top_outer,
    groove_radius      = groove_hub_top_outer_radius,
    groove_path_length = hub_path_length,
    extra = extra
);
function points_top_inner(extra) = groove_points(
    groove_straight    = groove_straight_top_inner,
    groove_radius      = groove_hub_top_inner_radius,
    groove_path_length = hub_path_length,
    extra = extra
);
function points_bottom_outer(extra) = groove_points(
    groove_straight    = groove_straight_bottom_outer,
    groove_radius      = groove_hub_bottom_outer_radius,
    groove_path_length = hub_path_length,
    extra = extra
);
function points_bottom_inner(extra) = groove_points(
    groove_straight    = groove_straight_bottom_inner,
    groove_radius      = groove_hub_bottom_inner_radius,
    groove_path_length = hub_path_length,
    extra = extra
);

function points_bottom(extra) = concat(
    points_bottom_outer(extra),
    points_reverse(points_bottom_inner(extra))
);
function points_top(extra) = concat(
    points_top_outer(extra),
    points_reverse(points_top_inner(extra))
);
*%polygon(points_top());
*%polygon(points_bottom());

function groove_points(
    groove_straight,
    groove_radius,
    groove_path_length,
    extra = undef
) = (
    let(
        points_bezier1 = concat(
            is_undef(extra)?[]:[
                [groove_path_length + extra, groove_straight]
            ],
            bezier_points(
                p0 = [groove_path_length, groove_straight],
                p1 = [groove_path_length * 2/3, groove_straight],
                p2 = [0, groove_radius]
            )
        ),
        points_circle = points_trim(
            first  = 1,
            last   = 1,
            points = points_of_circle(
                r = groove_radius,
                a1 = 90,
                a2 = -90
            )
        ),
        points_bezier2 = points_mirror(VEC_Y,
            points_reverse(points_bezier1)
        )
    )
    concat(
        points_bezier1,
        points_circle,
        points_bezier2
    )
);

*%union() {
    Box(y_from=groove_straight_top_inner, y_to=groove_straight_top_outer, x_from=0, x_to=30);
    difference() {
        $fn= 128;
        circle(groove_hub_top_outer_radius);
        circle(groove_hub_top_inner_radius);
    }
}

Wheel(wheel_config);
for (i = [0 : 4]) {
    rotate(-i * angle) translate([0, -center_radius]) {
        if(i % 2 == 0) {
            color("red") LinkA(link_config);
        } else {
            color("green") LinkB(link_config);
        }
    }
}
translate([2*size, -joint_radius]) color("green") LinkB(link_config);