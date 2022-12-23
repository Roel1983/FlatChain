include <../Utils/Box.inc>
include <../Utils/Constants.inc>
include <../Utils/Git.inc>
include <../Utils/LinearExtrude.inc>
include <../Utils/Shapes.inc>
include <../Utils/Units.inc>
include <Floor.inc>

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

$fn = 64;

FloorHubBottom(floor_config);

module FloorHubBottom(config = FloorConfig()) {

    groove_config             = ConfigGet(config,        "groove_config");
    groove_seam_position      = ConfigGet(groove_config, "seam_position");
    groove_depth              = ConfigGet(groove_config, "depth");
    groove_wheel_clearance_xy = ConfigGet(groove_config, "wheel_clearance_xy");

    link_config               = ConfigGet(groove_config, "link_config");
    wheel_radius              = ConfigGet(link_config, "wheel_radius");

    floor_width      = ConfigGet(config, "width");
    floor_hub_length = ConfigGet(config, "hub_length");
    floor_thickness  = ConfigGet(config, "thickness");

    floor_hub_hexnut_wall    = ConfigGet(config, "hub_hexnut_wall");
    floor_hub_hexnut_size    = ConfigGet(config, "hub_hexnut_size");
    floor_hub_screw_diameter = ConfigGet(config, "hub_screw_diameter");

    slot_clearance           = ConfigGet(config, "slot_clearance");

    floor_hub_hexnut_pos     = ConfigGet(config, "hub_hexnut_pos");

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
            BottomHex(config);
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
        BottomSlots(config, offset_xy=slot_clearance, offset_z=layer(1));
    }
}

module BottomHex(config, offset_xy = 0, offset_z = 0) {
    floor_hub_hexnut_pos  = ConfigGet(config, "hub_hexnut_pos");
    floor_thickness       = ConfigGet(config, "thickness");
    floor_hub_hexnut_wall = ConfigGet(config, "hub_hexnut_wall");
    floor_hub_hexnut_size = ConfigGet(config, "hub_hexnut_size");
    
    translate([floor_hub_hexnut_pos,0]) {
        LinearExtrude(z_from=-floor_thickness, z_to=0 + offset_z) {
            Hex(floor_hub_hexnut_size[X] + 2 * floor_hub_hexnut_wall + offset_xy);
        }
    }
}

module BottomTopInnerHubSlots(config, offset_xy = 0, offset_z = 0) {
    z_from = -mm(2.7) - offset_z;
    width  = nozzle(2) + offset_xy;
    translate([24,0]) {
        LinearExtrude(z_from= z_from, z_to=-1.5) square([8.1, width], true);
    }   
}

module BottomTopOuterSlots(config, offset_xy = 0, offset_z = 0) {
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

module BottomTopInnerStraight(config, offset_xy = 0, offset_z = 0) {
    z_from = -mm(2.7) - offset_z;
    width  = nozzle(2) + offset_xy;
    translate([34.5,0]) {
        LinearExtrude(z_from= z_from, z_to=-1.5) square([6.1, width], true);
    }
}

module BottomSlots(config, offset_xy = 0, offset_z = 0) {
    BottomTopInnerHubSlots(config, offset_xy, offset_z);
    BottomTopOuterSlots(config, offset_xy, offset_z);
    BottomTopInnerStraight(config, offset_xy, offset_z);
}