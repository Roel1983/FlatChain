include <../Utils/Box.inc>
include <../Utils/Constants.inc>
include <../Utils/Git.inc>
include <../Utils/LinearExtrude.inc>
include <../Utils/Shapes.inc>
include <../Utils/Units.inc>
include <../Utils/TransformCopy.inc>
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
    floor_hub_position       = ConfigGet(config, "hub_position");

    difference() {
        BIAS = .1;
        union() {
            LinearExtrude(
                z_from = -floor_thickness,
                z_to   = -groove_seam_position
            ) {
                difference() {
                    Box(
                        x_from = 0,
                        x_to   = floor_hub_length,
                        y_from = -floor_width / 2,
                        y_to   = floor_width / 2
                    );
                    translate([floor_hub_position, 0]) {
                        circle(d=mm(3.1));
                    }
                }
            }
            FloorHubBottomHex(config);
        }
        translate([floor_hub_position, 0]) {
            LinearExtrude(
                z_to = -floor_thickness - BIAS,
                z_from = -floor_thickness + layer(1.5)
            ) {
                translate([floor_width/4/*TODO*/,0])rotate(-90) CommitText();
            }
            LinearExtrude(z_from= -groove_depth, z_to = 0) {
                polygon(points_groove_bottom(
                    groove_config = groove_config,
                    extra         = floor_hub_length - floor_width / 2 + BIAS
                ));
                circle(r = wheel_radius + groove_wheel_clearance_xy);
            }
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
        FloorHubBottomSlots(config, offset_xy=slot_clearance, offset_z=layer(1));
        FloorHubBottomScrewHoles(config);
    }
}

module FloorHubBottomHex(config, offset_xy = 0, offset_z = 0) {
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

module FloorHubBottomSlotHub(config, offset_xy = 0, offset_z = 0) {
    
    floor_hub_length      = ConfigGet(config, "hub_length");
    floor_slot_width      = ConfigGet(config, "slot_width");
    floor_overlap         = ConfigGet(config, "overlap");
    floor_hub_hexnut_size = ConfigGet(config, "hub_hexnut_size");
    floor_hub_hexnut_wall = ConfigGet(config, "hub_hexnut_wall");
    floor_slot_clearance  = ConfigGet(config, "slot_clearance");
    floor_slot_edge_distance  = ConfigGet(config, "slot_edge_distance");
    floor_hub_hexnut_pos      = ConfigGet(config, "hub_hexnut_pos");
    
    groove_config             = ConfigGet(config,        "groove_config");
    groove_seam_position      = ConfigGet(groove_config, "seam_position");
    
    z_from = -mm(2.7) - offset_z;
    BIAS = 0.1;
    
    Box(
        x_from = (
            floor_hub_hexnut_pos 
            + floor_hub_hexnut_size[X] / 2
            + floor_hub_hexnut_wall
            + floor_slot_edge_distance
        ) - offset_xy / 2,
        x_to   = (
            floor_hub_length
            - floor_overlap
            - floor_slot_edge_distance
        ) + offset_xy / 2,
        y_from = - floor_slot_width / 2 - offset_xy / 2,
        y_to   = floor_slot_width / 2 + offset_xy / 2,
        z_from = z_from, z_to = -groove_seam_position + BIAS
    );
}

module FloorHubBottomSlotInnerOverlap(config, offset_xy = 0, offset_z = 0) {
    groove_config             = ConfigGet(config,        "groove_config");
    groove_seam_position      = ConfigGet(groove_config, "seam_position");
    floor_hub_length = ConfigGet(config, "hub_length");
    floor_width      = ConfigGet(config, "width");
    floor_overlap    = ConfigGet(config, "overlap");
    floor_slot_width = ConfigGet(config, "slot_width");
    floor_slot_edge_distance = ConfigGet(config, "slot_edge_distance");
    
    z_from = -mm(2.7) - offset_z;
    BIAS = 0.1;
    Box(
        x_from = floor_hub_length - floor_overlap + floor_slot_edge_distance - offset_xy / 2,
        x_to   = floor_hub_length - floor_slot_edge_distance + offset_xy / 2,
        y_from = - floor_slot_width / 2 - offset_xy / 2,
        y_to   = floor_slot_width / 2 + offset_xy / 2,
        z_from = z_from, z_to = -groove_seam_position + BIAS
    );
}

module FloorHubBottomTopOuterSlots(config, offset_xy = 0, offset_z = 0) {
    groove_config             = ConfigGet(config,        "groove_config");
    groove_seam_position      = ConfigGet(groove_config, "seam_position");
    floor_hub_length = ConfigGet(config, "hub_length");
    floor_width      = ConfigGet(config, "width");
    floor_overlap    = ConfigGet(config, "overlap");
    floor_slot_width = ConfigGet(config, "slot_width");
    floor_slot_edge_distance = ConfigGet(config, "slot_edge_distance");
    
    z_from = -mm(2.7) - offset_z;
    BIAS = 0.1;
    Box(
        x_from = floor_slot_edge_distance - offset_xy / 2,
        x_to   = floor_slot_edge_distance + floor_slot_width + offset_xy / 2,
        y_from = -floor_width / 2 + 10 - offset_xy / 2,
        y_to   = floor_width / 2 - 10 + offset_xy / 2,
        z_from = z_from, z_to = -groove_seam_position + BIAS
    );
    Box(
        x_from = 10 - offset_xy / 2,
        x_to   = floor_hub_length / 2 - floor_slot_edge_distance + offset_xy / 2,
        y_from = floor_width / 2 - floor_slot_edge_distance - floor_slot_width - offset_xy / 2,
        y_to   = floor_width / 2 - floor_slot_edge_distance + offset_xy / 2,
        z_from = z_from, z_to = -groove_seam_position + BIAS
    );
    Box(
        x_from = floor_hub_length / 2 + floor_slot_edge_distance - offset_xy / 2,
        x_to   = (
            floor_hub_length
            - floor_overlap
            - floor_slot_edge_distance
        ) + offset_xy / 2,
        y_from = floor_width / 2 - floor_slot_edge_distance - floor_slot_width - offset_xy / 2,
        y_to   = floor_width / 2 - floor_slot_edge_distance + offset_xy / 2,
        z_from = z_from, z_to = -groove_seam_position + BIAS
    );
    
    Box(
        x_from = 10 - offset_xy / 2,
        x_to   = floor_hub_length / 2 - floor_slot_edge_distance + offset_xy / 2,
        y_from = -floor_width / 2 + floor_slot_edge_distance - offset_xy / 2,
        y_to   = -floor_width / 2 + floor_slot_edge_distance + floor_slot_width + offset_xy / 2,
        z_from = z_from, z_to = -groove_seam_position + BIAS
    );
    Box(
        x_from = floor_hub_length / 2 + floor_slot_edge_distance - offset_xy / 2,
        x_to   = floor_hub_length - floor_slot_edge_distance + offset_xy / 2,
        y_from = -floor_width / 2 + floor_slot_edge_distance - offset_xy / 2,
        y_to   = -floor_width / 2 + floor_slot_edge_distance + floor_slot_width + offset_xy / 2,
        z_from = z_from, z_to = -groove_seam_position + BIAS
    );
    
}

module FloorHubBottomSlotOuterOverlap(config, offset_xy = 0, offset_z = 0) {
    groove_config             = ConfigGet(config,        "groove_config");
    groove_seam_position      = ConfigGet(groove_config, "seam_position");
    floor_hub_length = ConfigGet(config, "hub_length");
    floor_width      = ConfigGet(config, "width");
    floor_overlap    = ConfigGet(config, "overlap");
    floor_slot_width = ConfigGet(config, "slot_width");
    floor_slot_edge_distance = ConfigGet(config, "slot_edge_distance");
    
    z_from = -mm(2.7) - offset_z;
    width  = nozzle(2) + offset_xy;
    BIAS = 0.1;
    Box(
        x_from = floor_hub_length - floor_overlap + floor_slot_edge_distance - offset_xy / 2,
        x_to   = floor_hub_length - floor_slot_edge_distance + offset_xy / 2,
        y_from = floor_width / 2 - floor_slot_edge_distance - floor_slot_width - offset_xy / 2,
        y_to   = floor_width / 2 - floor_slot_edge_distance + offset_xy / 2,
        z_from = z_from, z_to = -groove_seam_position + BIAS
    );

}

module FloorHubBottomSlots(config, offset_xy = 0, offset_z = 0) {
    FloorHubBottomSlotOuterOverlap(config, offset_xy, offset_z);
    FloorHubBottomSlotInnerOverlap(config, offset_xy, offset_z);
    FloorHubBottomSlotHub         (config, offset_xy, offset_z);
    FloorHubBottomTopOuterSlots   (config, offset_xy, offset_z);
}

module FloorHubBottomScrewHoles(config) {
    floor_width      = ConfigGet(config, "width");
    floor_thickness  = ConfigGet(config, "thickness");
    mirror_copy(VEC_Y) {
        BIAS = 0.1;
        translate([5, floor_width / 2 - 5, BIAS]) {
            mirror(VEC_Z) {
                cylinder(d1 = 7, d2 = 3, h = 2);
                cylinder(d=3.1, h = floor_thickness + 2 * BIAS);
            }
        }
    }
}