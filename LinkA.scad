include <../Utils/Units.inc>
include <../Utils/TransformCopy.inc>
include <../Utils/Constants.inc>
include <Pieces/RoundedCurve.inc>
include <Links.inc>

$fn = 64;
LinkA();

module LinkA(config = LinkConfig()) {
    link_size              = ConfigGet(config, "size");
    link_thickness         = ConfigGet(config, "thickness");
    link_tolerance_xy      = ConfigGet(config, "tolerance_xy");
    link_height            = ConfigGet(config, "height");
    link_top_height        = ConfigGet(config, "top_height");
    link_bottom_height     = ConfigGet(config, "bottom_height");
    
    link_inner_angle       = ConfigGet(config, "inner_angle");
    link_width_1           = ConfigGet(config, "top_outer_side");
    link_joint_path_radius = ConfigGet(config, "joint_path_radius");
    link_joint_size        = ConfigGet(config, "joint_size");
    link_center_radius     = ConfigGet(config, "center_radius");
    link_bottom_outer_edge_radius = ConfigGet(config, "bottom_outer_edge_radius");
        
    translate([0,0,-link_top_height]) linear_extrude(link_top_height) {
        hull() {
            mirror_copy(VEC_X) {
                translate([link_size / 2, 0]) circle(d = link_joint_size);
                rotate(180) {
                    square([link_size / 2 + link_joint_size / 2, link_width_1]);
                }
            }
            
        }
    }
    
    // mid
    translate([0,0, -link_height + link_bottom_height]) {
        linear_extrude(link_height - link_top_height - link_bottom_height){
            difference() {
                union() {
                    hull() {
                        mirror_copy(VEC_X) {
                            translate([link_size / 2, 0]) {
                                circle(d = link_joint_size);
                                aa = 1.5 * link_thickness + link_tolerance_xy;
                                rotate(link_inner_angle) {
                                    translate([0, -link_joint_path_radius]) {
                                        circle(r=aa);
                                    }
                                }
                            }
                            /* round edge */
                            translate([0, link_center_radius]) {
                                intersection() {
                                    circle(r=link_bottom_outer_edge_radius);
                                    a = (
                                        0.5 * (link_size + link_joint_size) -
                                        1.0 * link_tolerance_xy -
                                        1.5 * link_thickness
                                    );
                                    b = link_center_radius + link_joint_path_radius;
                                    c = atan(a / b);
                                    
                                    rotate(180 + c) {
                                        square(link_bottom_outer_edge_radius);
                                    }
                                    rotate(-90 -c) {
                                        square(link_bottom_outer_edge_radius);
                                    }
                                    translate([0, -b - a]) {
                                        square(2*a + link_joint_size, center = true);
                                    }
                                }
                            }
                        }
                    }
                    a = link_joint_size / 2 + link_thickness + link_tolerance_xy;
                    polygon([
                        [-link_size / 2, 0],
                        [-link_size / 2 + a, a],
                        [ link_size / 2 - a, a],
                        [ link_size / 2, 0]
                    ]);
                }
                mirror_copy(VEC_X) {
                    translate([-link_size / 2, 0]) {
                        RoundedCurve(
                            2 * link_joint_path_radius, 
                            link_thickness + 2 * link_tolerance_xy, 
                            -90-link_inner_angle, 180);
                    }
                }
            }
        }
    }
}
