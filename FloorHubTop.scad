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
    link_config          = ConfigGet(groove_config, "link_config");
    groove_depth         = ConfigGet(groove_config, "depth");
    groove_overhang_thickness = ConfigGet(groove_config, "overhang_thickness");
    
    mirror_if(printable, VEC_Z) {
        difference() {
            BIAS = 0.1;
            Box(x_from=-20, x_to=40, y_from = -20, y_to=20, z_from=-2, z_to = 0);
            LinearExtrude(z_from= -groove_depth, z_to = BIAS) {
                polygon(points_groove_top_outer(
                    groove_config = groove_config,
                    extra         = floor_hub_length - floor_width / 2 + BIAS
                ));
            }
            LinearExtrude(z_from= -groove_depth, z_to = -groove_overhang_thickness) {
                polygon(points_groove_bottom_outer(
                    groove_config = groove_config,
                    extra         = floor_hub_length - floor_width / 2 + BIAS
                ));
            }
            translate([-17.8,0, 0]) {
                LinearExtrude(z_from = -layer(1.5), z_to=BIAS) {
                    rotate(90) mirror(VEC_X) CommitText();
                }
            }
        }
        BottomTopOuterSlots(config);
    }
}
