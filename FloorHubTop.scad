include <../Utils/Box.inc>
include <../Utils/LinearExtrude.inc>
include <../Utils/TransformIf.inc>
include <Floor.inc>
use <FloorHubBottom.scad>

$fn = 64;

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

FloorHubTop(floor_config, printable=true);

BIAS = 0.1;

module FloorHubTop(config = FloorConfig(), printable=false) {
    floor_hub_length     = ConfigGet(config, "hub_length");
    floor_width          = ConfigGet(config, "width");
    floor_thickness      = ConfigGet(config, "thickness");
    floor_overlap        = ConfigGet(config, "overlap");
    floor_hub_position   = ConfigGet(config, "hub_position");
    groove_config        = ConfigGet(config, "groove_config");
    link_config          = ConfigGet(groove_config, "link_config");
    groove_seam_position      = ConfigGet(groove_config, "seam_position");
    groove_overhang_thickness = ConfigGet(groove_config, "overhang_thickness");
    
    rotate_if(printable && !$preview, 180, VEC_X) {
        difference() {
            BIAS = 0.1;
            LinearExtrude(
                z_from = -groove_seam_position, 
                z_to   = 0
            ) polygon([
                [
                    0,
                    floor_width/2
                ], [
                    floor_hub_length - floor_overlap,
                    floor_width/2
                ], [
                    floor_hub_length - floor_overlap,
                    0
                ], [
                    floor_hub_length + floor_overlap,
                    0
                ], [
                    floor_hub_length + floor_overlap,
                    -floor_width/2
                ], [
                    0,
                    -floor_width/2
                ]
            
            ]);
            translate([floor_hub_position, 0]) {
                LinearExtrude(z_from= -groove_seam_position - BIAS, z_to = BIAS) {
                    polygon(points_groove_top_outer(
                        groove_config = groove_config,
                        extra         = floor_hub_length - floor_hub_position / 2 + floor_overlap + BIAS
                    ));
                }
                LinearExtrude(
                    z_from= -groove_seam_position - BIAS,
                    z_to = -groove_overhang_thickness
                ) {
                    polygon(points_groove_bottom_outer(
                        groove_config = groove_config,
                        extra         = floor_hub_length - floor_hub_position / 2 + floor_overlap + BIAS
                    ));
                }
                translate([-17.6,0, 0]) {
                    LinearExtrude(z_from = -layer(1.5), z_to=BIAS) {
                        rotate(90) CommitText();
                    }
                }
                
                
            }
            FloorHubBottomScrewHoles(config);
        }
        FloorHubBottomTopOuterSlots(config);
        translate([2 * floor_hub_length, 0])rotate(180) {
            FloorHubBottomSlotOuterOverlap(config);
        }
    }
}
