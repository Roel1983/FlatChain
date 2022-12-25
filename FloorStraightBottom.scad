include <Floor.inc>
include <../Utils/Box.inc>
include <../Utils/Constants.inc>
include <../Utils/Git.inc>
include <../Utils/LinearExtrude.inc>
include <../Utils/Points.inc>
include <Floor.inc>
use<FloorHubBottom.scad>

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

FloorStraightBottom(floor_config);

module FloorStraightBottom(
    config                    = FloorConfig()
) {
    floor_width                  = ConfigGet(config,        "width");
    floor_thickness              = ConfigGet(config,        "thickness");
    floor_straight_len           = ConfigGet(config,        "straight_len");
    slot_clearance               = ConfigGet(config,        "slot_clearance");
    groove_config                = ConfigGet(config,        "groove_config");
    groove_seam_position         = ConfigGet(groove_config, "seam_position");
    groove_straight_bottom_outer = ConfigGet(groove_config, "straight_bottom_outer");
    groove_straight_bottom_inner = ConfigGet(groove_config, "straight_bottom_inner");
    groove_depth                 = ConfigGet(groove_config, "depth");
    link_config                  = ConfigGet(groove_config, "link_config");
    link_size                    = ConfigGet(link_config,   "size");
    
    difference() {
        LinearExtrude(
            x_from = 0,
            x_to   = floor_straight_len
        ) {
            points_side = [
                [
                    floor_width / 2,
                    -floor_thickness
                ], [
                    floor_width / 2,
                    -groove_seam_position
                ], [
                    groove_straight_bottom_outer,
                    -groove_seam_position
                ], [
                    groove_straight_bottom_outer,
                    -groove_depth
                ], [
                    groove_straight_bottom_inner,
                    -groove_depth
                ], [
                    groove_straight_bottom_inner,
                    -groove_seam_position
                ]
            ];
            polygon(concat(
                points_side,
                points_mirror(vec = VEC_X, points = points_side, reverse=true)
            ));
        }
        BIAS = 0.1;
        #translate([floor_straight_len/2,0, -floor_thickness]) {
            LinearExtrude(z_from = layer(1.5), z_to=-BIAS) {
                rotate(90) CommitText();
            }
        }
        FloorStraightBottomSlots(config, offset_xy=slot_clearance, offset_z=layer(1));
    }
}

module FloorStraightBottomSlotOuterOverlap(config, offset_xy = 0, offset_z = 0) {
    floor_hub_length   = ConfigGet(config, "hub_length");
    floor_straight_len = ConfigGet(config, "straight_len");
    translate([-floor_hub_length + floor_straight_len, 0]) {
        FloorHubBottomSlotOuterOverlap(config, offset_xy, offset_z);
    }
}

module FloorStraightBottomSlotInnerOverlap(config, offset_xy = 0, offset_z = 0) {
    floor_hub_length   = ConfigGet(config, "hub_length");
    floor_straight_len = ConfigGet(config, "straight_len");
    translate([-floor_hub_length + floor_straight_len, 0]) {
        FloorHubBottomSlotInnerOverlap(config, offset_xy, offset_z);
    }
}

module FloorStraightBottomOuterSlots(config, offset_xy = 0, offset_z = 0) {
    floor_straight_len   = ConfigGet(config, "straight_len");
    floor_overlap      = ConfigGet(config, "overlap");
    floor_slot_width = ConfigGet(config, "slot_width");
    floor_slot_edge_distance  = ConfigGet(config, "slot_edge_distance");
    groove_seam_position      = ConfigGet(groove_config, "seam_position");
    floor_width      = ConfigGet(config, "width");
    
    separation = 2 * floor_slot_edge_distance;
    distance = (floor_straight_len - floor_overlap - floor_slot_edge_distance);
    count = floor(distance / mm(20));
    slot_period = distance / count;
    slot_length = slot_period - separation;
    z_from = -mm(2.7) - offset_z;
    BIAS = 0.1;
    for(i = [0 : count - 1]) {
        x = floor_slot_edge_distance + slot_period * i;
        Box(
            x_from = x - offset_xy / 2,
            x_to   = x + slot_length + offset_xy / 2,
            y_from = floor_width / 2 - floor_slot_edge_distance 
                     - floor_slot_width - offset_xy / 2,
            y_to   = floor_width / 2 - floor_slot_edge_distance + offset_xy / 2,
            z_from = z_from, z_to = -groove_seam_position + BIAS
        );
    }
}

module FloorStraightBottomInnerSlots(config, offset_xy = 0, offset_z = 0) {
    floor_straight_len   = ConfigGet(config, "straight_len");
    floor_overlap      = ConfigGet(config, "overlap");
    floor_slot_width = ConfigGet(config, "slot_width");
    floor_slot_edge_distance  = ConfigGet(config, "slot_edge_distance");
    groove_seam_position      = ConfigGet(groove_config, "seam_position");
    floor_width      = ConfigGet(config, "width");
    
    separation = 2 * floor_slot_edge_distance;
    distance = (floor_straight_len - floor_overlap - floor_slot_edge_distance);
    count = floor(distance / mm(20));
    slot_period = distance / count;
    slot_length = slot_period - separation;
    z_from = -mm(2.7) - offset_z;
    BIAS = 0.1;
    for(i = [0 : count - 1]) {
        x = floor_slot_edge_distance + slot_period * i;
        Box(
            x_from = x - offset_xy / 2,
            x_to   = x + slot_length + offset_xy / 2,
            y_from = -floor_slot_width / 2 - offset_xy / 2,
            y_to   = floor_slot_width / 2 + offset_xy / 2,
            z_from = z_from, z_to = -groove_seam_position + BIAS
        );
    }
}

module FloorStraightBottomSlots(config, offset_xy = 0, offset_z = 0) {
    floor_straight_len   = ConfigGet(config, "straight_len");
    
    FloorStraightBottomSlotOuterOverlap(config, offset_xy, offset_z);
    FloorStraightBottomSlotInnerOverlap(config, offset_xy, offset_z);
    FloorStraightBottomOuterSlots(config, offset_xy, offset_z);
    FloorStraightBottomInnerSlots(config, offset_xy, offset_z);
    translate([floor_straight_len, 0]) rotate(180) {
        FloorStraightBottomOuterSlots(config, offset_xy, offset_z);
        FloorStraightBottomSlotOuterOverlap(config, offset_xy, offset_z);
    }
}