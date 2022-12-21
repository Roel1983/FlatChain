include <../Utils/Units.inc>
include <../Utils/TransformCopy.inc>
include <../Utils/Constants.inc>
include <Pieces/RoundedCurve.inc>
include <Links.inc>

$fn = 64;
LinkB();

module LinkB(config = LinkConfig()) {
    link_size               = ConfigGet(config, "size");
    link_thickness          = ConfigGet(config, "thickness");
    link_tooth_size         = ConfigGet(config, "tooth_size");
    link_tolerance_xy       = ConfigGet(config, "tolerance_xy");
    link_height             = ConfigGet(config, "height");
    link_top_height         = ConfigGet(config, "top_height");
    link_bottom_height      = ConfigGet(config, "bottom_height");
    link_bridge_tolerance_z = ConfigGet(config, "bridge_tolerance_z");
    link_angle              = ConfigGet(config, "angle");
    link_joint_size         = ConfigGet(config, "joint_size");
    link_joint_path_radius  = ConfigGet(config, "joint_path_radius");
    link_joint_path_width   = ConfigGet(config, "joint_path_width");
    link_inner_angle        = ConfigGet(config, "inner_angle");
    link_width_1            = ConfigGet(config, "width_1");
    link_width_2 = (
        link_joint_size / 2 + link_tolerance_xy
    );
    link_center_width = (
        link_tooth_size +
        2 * link_joint_path_width -
        2 * link_tolerance_xy
    );
    link_center_l = (
        link_width_1
        + link_thickness
    );
    
    r1 = 1.5 * link_thickness + link_tolerance_xy;
    // Top
    
    translate([0,0, -link_bottom_height]) {
        linear_extrude(link_bottom_height) {
            difference() {
                union() {
                    translate([0, link_width_2/2]) {
                        square([link_size, link_width_2], true);
                    }
                    translate([-link_center_width / 2, -link_width_1]) {
                        square([link_center_width, link_width_1 + link_width_2]);
                    }
                }
                mirror_copy(VEC_X) translate([link_size / 2, 0]) {
                    r = link_joint_size / 2 +  link_tolerance_xy;
                    circle(r);
                    rotate(link_angle)square(r);
                }
            }
        }
    }
    
    // mid
    render() difference() { 
        translate([0,0, -link_height + link_bottom_height]) {
            linear_extrude(link_height - link_top_height - link_bottom_height) {
                mirror_copy(VEC_X) translate([link_size / 2, 0]) {
                    RoundedCurve(2 * link_joint_path_radius,
                    link_thickness,
                    -90 - link_inner_angle + link_angle, 180);
                }

                difference() {
                    h = link_center_l - 0.5 * link_thickness;
                    union() {
                        translate([0, -h/2]) {
                            square([link_center_width, h], true);
                        }
                        hull() mirror_copy(VEC_X) {
                            translate([(link_center_width - link_thickness) / 2 ,
                                        -h])
                            {
                                circle(d = link_thickness);
                            }
                        }
                    }
                    circle(d=link_tooth_size + 2 * link_tolerance_xy);
                }
            }
        }
        mirror_copy(VEC_X) translate([link_size/2, 0,
                                 -link_top_height - link_bridge_tolerance_z])
        {
            linear_extrude(link_top_height + link_bridge_tolerance_z) {
                a = link_joint_path_radius * 2;
                rotate(link_angle ) translate([0, -a]) square([
                    link_joint_size / 2 + link_tolerance_xy + link_thickness + 0.1,
                    a + (link_joint_size / 2 + link_tolerance_xy)]);
                rotate(270) translate([0, -link_joint_size/2]) square(a);
            }
        }
    }
    
    // Bottom
    translate([0,0, -link_height]) linear_extrude(link_bottom_height) {
        r = link_joint_size / 2+ link_thickness + link_tolerance_xy;
        mirror_copy(VEC_X) translate([link_size / 2, 0]) {
            rotate(-link_inner_angle) {
                circle(r);
            }
        }
        difference() {
            h = link_center_l - 0.5 * link_thickness;
            union() {
                translate([-link_size / 2, -r])square([link_size, r]);
                translate([0, -h/2]) {
                    square([link_center_width, h], true);
                }
                hull() mirror_copy(VEC_X) {
                    translate([(link_center_width - link_thickness) / 2 ,
                                -h])
                    {
                        circle(d = link_thickness);
                    }
                }
            }
            circle(d=link_tooth_size + 2 * link_tolerance_xy);
        }
        
    }
}


/*** ***/

