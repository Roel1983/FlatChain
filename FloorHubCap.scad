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
    
    bearing_size = mm([6.0, 2.0]);
    wheel_hub_diameter   = bearing_size[X] - nozzle(1);
    
    extra  = mm(1.0);
    height = mm(3.5);
    
    BIAS = 0.1;
    
    mirror_if(printable && !$preview, VEC_Z) {
        difference() {
            union() {
                LinearExtrude(z_from= -groove_seam_position, z_to = 0) {
                    polygon(points_groove_bottom_inner(
                        groove_config = GrooveConfig(),
                        extra = mm(30)
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
                BottomTopInnerHubSlots(config);
                translate([23,0, height]) {
                    LinearExtrude(z_from = -BIAS, z_to=layer(1.5)) {
                        rotate(90) mirror(VEC_X) CommitText(len = 4);
                    }
                }
            }
            BottomHex(config, offset_xy = slot_clearance, offset_z = layer(0));
            LinearExtrude(z_from= height - bearing_size[Y], z_to = height + BIAS) {
                circle(d=bearing_size[X]);
            }
            LinearExtrude(z_from= -link_height, z_to = -link_top_height + groove_tolerance_z) {
                circle(r = wheel_radius + groove_wheel_clearance_xy);
            }
            LinearExtrude(z_from= -link_height, z_to = 3) {
                circle(d = wheel_hub_diameter + groove_wheel_axcel_clearance_xy);
            }
            translate([floor_hub_hexnut_pos,0]) {
                translate([0, 0, height + BIAS]) mirror(VEC_Z) cylinder(d1 = 6, d2 = 3, h=1.5);
                LinearExtrude(z_from= -4, z_to=height) circle(d=mm(3.1));
            }
        }
    }
    
    module GrooveTopInner() {
        polygon(points_groove_top_inner(
            groove_config = GrooveConfig(),
            extra = mm(30)
        ));
        
    }
}

/*module FloorHubCap(config = FloorConfig()) {
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
            BottomTopInnerHubSlots();
        }
        BottomHex(offset_xy = slot_clearance, offset_z = layer(0));
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
}*/