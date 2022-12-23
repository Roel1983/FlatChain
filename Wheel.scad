include <../Utils/Units.inc>
include <../Utils/TransformCopy.inc>
include <../Utils/Constants.inc>
include <Pieces/MultiCorner.inc>
include <Wheel.inc>

$fn = 64;
Wheel();

module Wheel(config = WheelConfig()) {
    link_axcel      = ConfigGet(config, "axcel");
    link_hub_height = ConfigGet(config, "hub_height");
    link_config     = ConfigGet(config, "link_config");
    
    link_size               = ConfigGet(link_config, "size");
    link_thickness          = ConfigGet(link_config, "thickness");
    link_tooth_size         = ConfigGet(link_config, "tooth_size");
    link_tolerance_xy       = ConfigGet(link_config, "tolerance_xy");
    link_360_pair_count     = ConfigGet(link_config, "360_pair_count");
    link_height             = ConfigGet(link_config, "height");
    link_top_height         = ConfigGet(link_config, "top_height");
    link_bottom_height      = ConfigGet(link_config, "bottom_height");
    link_tolerance_z        = ConfigGet(link_config, "tolerance_z");
    link_bridge_tolerance_z = ConfigGet(link_config, "bridge_tolerance_z");
    link_angle              = ConfigGet(link_config, "angle");
    link_joint_size         = ConfigGet(link_config, "joint_size");
    link_hub_diameter       = ConfigGet(config, "hub_diameter");
    
    link_center_radius = (link_size / 2) / tan(link_angle / 2);
    
    
    difference() {
        union() {
            translate([0, 0, -link_height+ link_tolerance_z]) {
                cylinder(d=link_hub_diameter, 
                    h=link_hub_height);
            }
            difference() {
                d1 = link_joint_size + 2 * link_thickness + 4 * link_tolerance_xy;
                union() {
                    translate([0,0, -link_height + link_tolerance_z]) linear_extrude(link_height - link_top_height - link_tolerance_z) {
                        difference() {
                            union() {
                                MultiCorner(link_360_pair_count * 2, link_center_radius);
                                for (i = [0:link_360_pair_count-1]) {
                                    rotate((i + .5) * (link_angle * 2)){
                                        translate([0, link_center_radius]) {
                                            circle(d=link_tooth_size);
                                        }
                                    }
                                }
                            }
                            for (i = [0:link_360_pair_count -1]) rotate(i * link_angle * 2){
                                hull() mirror_copy(VEC_X) translate([link_size / 2, link_center_radius]) {
                                    circle(d=d1);
                                }
                            }
                        }
                    }
                    
                    translate([0,0,-link_height + link_tolerance_z]) {
                        linear_extrude(link_bottom_height - 2 * link_tolerance_z) difference() {
                            union() {
                                MultiCorner(link_360_pair_count * 2, link_center_radius);
                                for (i = [0:link_360_pair_count * 2-1]) rotate(i * link_angle){
                                    translate([0, link_center_radius]) circle(d=link_tooth_size);
                                }
                            }
                            for (i = [0:link_360_pair_count * 2 -1]) rotate(i * link_angle){
                                translate([link_size / 2, link_center_radius]) {
                                    circle(d=d1);
                                }
                            }
                        }
                    }
                }
                translate([0,0,-link_top_height-link_bridge_tolerance_z]) {
                
                    for (i = [0:link_360_pair_count-1]) {
                        rotate((i + .5) * (link_angle * 2)){
                            translate([0, link_center_radius]) {
                                linear_extrude(link_top_height + link_bridge_tolerance_z) {
                                    square(link_joint_size + 4 * link_tolerance_xy, true);
                                }
                                translate([0, 0, -link_joint_size / 20])
                                rotate(-10, [1, 0, 0]) {
                                    linear_extrude(link_top_height + link_bridge_tolerance_z) {
                                        square(link_joint_size + 4 * link_tolerance_xy, true);
                                    }
                                }
                            }
                        }
                    
                    }
                }
                
                mirror([0,0,1])linear_extrude(link_height /2 + link_tolerance_z / 2){
                    circle(r=link_center_radius-d1 /2 - nozzle(2));
                }
            }
        }
        axel();
    }
    module axel() {
        cylinder(d=link_axcel, h= link_hub_height*2.1, center= true);
    }
}

