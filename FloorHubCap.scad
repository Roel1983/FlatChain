include <../Utils/LinearExtrude.inc>

include <Groove.inc>

FloorHubCap();


module FloorHubCap() {
    difference() {
        BIAS = 0.1;
        union() {
            LinearExtrude(z_from= -2, z_to = -BIAS) {
                polygon(points_bottom_inner(17.5));
            }
            hull() {
                extra = .5;
                LinearExtrude(z_from= -link_top_height + groove_tolerance_z, z_to = extra) {
                    polygon(points_top_inner(17.5));
                }
                b = 2.5;
                translate([0,0,b]) {
                    LinearExtrude(z_from= -link_top_height + groove_tolerance_z, z_to = extra) {
                        offset(-b)polygon(points_top_inner(17.5 - 3/2));
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