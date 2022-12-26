include <../Utils/LinearExtrude.inc>
include <../Utils/TransformIf.inc>
include <../Utils/Box.inc>
include <../Utils/Git.inc>
include <Floor.inc>
use <FloorStraightBottom.scad>

$fn = 64;

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

FloorStraightTopOuter(floor_config, printable = true);

module FloorStraightTopOuter(config = FloorConfig(), printable = false) {
    
    hub_cap_size              = ConfigGet(config, "hub_cap_size");
    
    floor_width               = ConfigGet(config,        "width");
    floor_overlap             = ConfigGet(config,        "overlap");
    floor_straight_len        = ConfigGet(config,        "straight_len");
    link_config               = ConfigGet(groove_config, "link_config");
    groove_depth              = ConfigGet(groove_config, "depth");
    groove_seam_position      = ConfigGet(groove_config, "seam_position");
    groove_overhang_thickness = ConfigGet(groove_config, "overhang_thickness");
    
    straight_top_outer        = ConfigGet(groove_config, "straight_top_outer");
    straight_bottom_outer     = ConfigGet(groove_config, "straight_bottom_outer");
    
    rotate_if(printable && !$preview, 180, VEC_X) {
        LinearExtrude(
            x_from = -floor_overlap,
            x_to   = floor_straight_len - floor_overlap
        ) polygon([
            [
                straight_bottom_outer,
                -groove_seam_position
            ], [
                floor_width / 2,
                -groove_seam_position
            ], [
                floor_width / 2,
                0
            ], [
                straight_top_outer,
                0
            ], [
                straight_top_outer,
                0 - groove_overhang_thickness
            ], [
                straight_bottom_outer,
                0 - groove_overhang_thickness
            ]
        ]);
        
        FloorStraightBottomOuterSlots(config);
        
        translate([-floor_straight_len, 0]) {
            FloorStraightBottomSlotOuterOverlap(config);
        }
    }
}
