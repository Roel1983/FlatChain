include <../Utils/LinearExtrude.inc>
include <../Utils/TransformIf.inc>
include <../Utils/Git.inc>
include <Floor.inc>
use <FloorHubBottom.scad>

$fn = 64;

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

FloorHubCap(floor_config, printable = true);

module FloorHubCap(config = FloorConfig(), printable=false) {
    
    slot_clearance       = ConfigGet(config, "slot_clearance");
    floor_hub_position   = ConfigGet(config, "hub_position");
    groove_config        = ConfigGet(config, "groove_config");
    overhang_thickness   = ConfigGet(groove_config, "overhang_thickness");
    groove_seam_position = ConfigGet(groove_config, "seam_position");
    groove_tolerance_z   = ConfigGet(groove_config, "tolerance_z");
    groove_wheel_clearance_xy = ConfigGet(groove_config, "wheel_clearance_xy");
    groove_wheel_axcel_clearance_xy = ConfigGet(groove_config, "wheel_axcel_clearance_xy");
    link_config          = ConfigGet(groove_config, "link_config");
    link_height          = ConfigGet(link_config, "height");
    link_top_height      = ConfigGet(link_config, "top_height");
    wheel_radius         = ConfigGet(link_config, "wheel_radius");
    
    
    floor_hub_hexnut_pos = ConfigGet(config, "hub_hexnut_pos");
    floor_hub_cap_size   = ConfigGet(config, "hub_cap_size");
    echo("floor_hub_cap_size", floor_hub_cap_size);
    bearing_size = mm([6.0, 2.0]);
    wheel_hub_diameter   = bearing_size[X] - nozzle(1);
    
    extra  = mm(1.0);
    height = mm(3.5);
    
    BIAS = 0.1;
    
    rotate_if(printable && !$preview, 180, VEC_X) {
        difference() {
            union() {
                translate([floor_hub_position, 0]) {
                    LinearExtrude(z_from= -groove_seam_position, z_to = 0) {
                        polygon(points_groove_bottom_inner(
                            groove_config = GrooveConfig(),
                            extra = floor_hub_cap_size
                        ));
                    }
                    hull() {
                        LinearExtrude(z_from= -overhang_thickness, z_to = extra) {
                            GrooveTopInner();
                        }
                        LinearExtrude(z_from=0, z_to = height) {
                            offset(-height + extra)GrooveTopInner();
                        }
                    }
                }
                FloorHubBottomSlotHub(config);
            }
            translate([floor_hub_position, 0]) {
                translate([23,0, height]) {
                    LinearExtrude(z_from = -layer(1.5), z_to=BIAS) {
                        rotate(90) CommitText(len = 4);
                    }
                }
                LinearExtrude(z_from= height - bearing_size[Y], z_to = height + BIAS) {
                    circle(d=bearing_size[X]);
                }
                LinearExtrude(
                    z_from= -link_height,
                    z_to = -link_top_height + groove_tolerance_z
                ) {
                    circle(r = wheel_radius + groove_wheel_clearance_xy);
                }
                LinearExtrude(z_from= -link_height, z_to = 3) {
                    circle(d = wheel_hub_diameter + groove_wheel_axcel_clearance_xy);
                }
            }
            translate([floor_hub_hexnut_pos,0]) {
                translate([0, 0, height + BIAS]) mirror(VEC_Z) {
                    cylinder(d1 = 6, d2 = 3, h=1.5);
                }
                LinearExtrude(z_from= -4, z_to=height) circle(d=mm(3.1));
            }
            FloorHubBottomHex(config, offset_xy = slot_clearance, offset_z = layer(0));
        }
    }
    
    module GrooveTopInner() {
        polygon(points_groove_top_inner(
            groove_config = GrooveConfig(),
            extra = floor_hub_cap_size
        ));
        
    }
}
