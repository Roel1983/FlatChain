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

FloorStraightTopInner(floor_config, printable = true);

module FloorStraightTopInner(config = FloorConfig(), printable = false) {
    
    hub_cap_size       = ConfigGet(config, "hub_cap_size");
    
    floor_width          = ConfigGet(config, "width");
    floor_overlap        = ConfigGet(config, "overlap");
    floor_straight_len           = ConfigGet(config,        "straight_len");
    link_config          = ConfigGet(groove_config, "link_config");
    groove_depth         = ConfigGet(groove_config, "depth");
    groove_seam_position      = ConfigGet(groove_config, "seam_position");
    groove_overhang_thickness = ConfigGet(groove_config, "overhang_thickness");
    
    straight_top_inner = ConfigGet(groove_config, "straight_top_inner");
    straight_bottom_inner = ConfigGet(groove_config, "straight_bottom_inner");
    
    rotate_if(printable && !$preview, 180, VEC_X) {
        Box(
            x_from = -floor_overlap,
            x_to   = floor_straight_len - floor_overlap,
            y_from = -straight_top_inner,
            y_to   = straight_top_inner,
            z_from = -groove_overhang_thickness,
            z_to   = 0
        );
        Box(
            x_from = -floor_overlap,
            x_to   = floor_straight_len - floor_overlap,
            y_from = -straight_bottom_inner,
            y_to   = straight_bottom_inner,
            z_from = -groove_seam_position,
            z_to   = 0
        );
        FloorStraightBottomInnerSlots(config);
        
        translate([-floor_straight_len, 0]) {
            FloorStraightBottomSlotInnerOverlap(config);
        }
    }
}
