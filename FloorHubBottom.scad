include <../Utils/Box.inc>
include <../Utils/Constants.inc>
include <../Utils/Git.inc>
include <../Utils/LinearExtrude.inc>
include <../Utils/Shapes.inc>
include <../Utils/Units.inc>

include <Pieces/Groove.inc>

$fn = 64;

groove_config = GrooveConfig(
    link_config = LinkConfig()
);

groove_seam_position      = ConfigGet(groove_config, "seam_position");
groove_depth              = ConfigGet(groove_config, "depth");
groove_wheel_clearance_xy = ConfigGet(groove_config, "wheel_clearance_xy");

link_config               = ConfigGet(groove_config, "link_config");
wheel_radius              = ConfigGet(link_config, "wheel_radius");

floor_width      = mm(40);
floor_hub_length = mm(60);
floor_thickness  = mm(3.8);

floor_hub_hexnut_wall    = nozzle(2);
floor_hub_hexnut_size    = mm([5.5, 2.5]);
floor_hub_screw_diameter = mm(3.0);

slot_clearance = mm(0.05);

floor_hub_hexnut_pos  = (
    wheel_radius
    + groove_wheel_clearance_xy
    + floor_hub_hexnut_wall * 2 + slot_clearance
    + floor_hub_hexnut_size[X] / 2
);

difference() {
    BIAS = .1;
    union() {
        LinearExtrude(
            z_from = -floor_thickness,
            z_to   = -groove_seam_position
        ) {
            difference() {
                Box(
                    x_from = -floor_width / 2,
                    x_to   = floor_hub_length - floor_width / 2,
                    y_from = -floor_width / 2,
                    y_to   = floor_width / 2
                );
                circle(d=mm(3.1));
            }
        }
        BottomHex();
    }
    LinearExtrude(z_to = -floor_thickness - BIAS, z_from = -floor_thickness + layer(1.5)) {
        translate([floor_width/4,0])rotate(-90) CommitText();
    }
    LinearExtrude(z_from= -groove_depth, z_to = 0) {
        polygon(points_groove_bottom(
            groove_config = groove_config,
            extra         = floor_hub_length - floor_width / 2 + BIAS
        ));
        circle(r = wheel_radius + groove_wheel_clearance_xy);
    }
    translate([
        floor_hub_hexnut_pos,
        0,
        -floor_thickness
    ]) {
        LinearExtrude(z_from= -BIAS, z_to=floor_thickness + 1) {
            circle(d=floor_hub_screw_diameter);
        }
        hull() {
            LinearExtrude(z_from= -BIAS, z_to= floor_hub_hexnut_size[Y]) {
                Hex(floor_hub_hexnut_size[X]);
            }
            LinearExtrude(z_from= -BIAS, z_to= floor_hub_hexnut_size[Y] + .8) {
                circle(d=floor_hub_screw_diameter);
            }
        }
    }
    BottomSlots(offset_xy=slot_clearance, offset_z=layer(1));
}

module BottomHex(offset_xy = 0, offset_z = 0) {
    translate([floor_hub_hexnut_pos,0]) {
        LinearExtrude(z_from=-floor_thickness, z_to=0 + offset_z) {
            Hex(floor_hub_hexnut_size[X] + 2 * floor_hub_hexnut_wall + offset_xy);
        }
    }
}

module BottomTopInnerHubSlots(offset_xy = 0, offset_z = 0) {
    z_from = -mm(2.7) - offset_z;
    width  = nozzle(2) + offset_xy;
    translate([24,0]) {
        LinearExtrude(z_from= z_from, z_to=-1.5) square([8.1, width], true);
    }   
}

module BottomTopOuterSlots(offset_xy = 0, offset_z = 0) {
    z_from = -mm(2.7) - offset_z;
    width  = nozzle(2) + offset_xy;
    translate([-18,0]) {
        LinearExtrude(z_from= z_from, z_to=-1.5) square([width, 18.1], true);
    }
    translate([15,18]) {
        LinearExtrude(z_from= z_from, z_to=-1.5) square([30.1, width], true);
    }
    translate([15,-18]) {
        LinearExtrude(z_from= z_from, z_to=-1.5) square([30.1, width], true);
    }
}

module BottomTopInnerStraight(offset_xy = 0, offset_z = 0) {
    z_from = -mm(2.7) - offset_z;
    width  = nozzle(2) + offset_xy;
    translate([34.5,0]) {
        LinearExtrude(z_from= z_from, z_to=-1.5) square([6.1, width], true);
    }
}

module BottomSlots(offset_xy = 0, offset_z = 0) {
    BottomTopInnerHubSlots(offset_xy, offset_z);
    BottomTopOuterSlots(offset_xy, offset_z);
    BottomTopInnerStraight(offset_xy, offset_z);
}