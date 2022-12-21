
include <../Utils/LinearExtrude.inc>
include <../Utils/Constants.inc>
include <../Utils/TransformCopy.inc>
include <LinkA.inc>
include <LinkB.inc>

link_config = LinkConfig(
    tolerance_xy = .2,
    tolerance_z  = .2
);

link_size         = ConfigGet(link_config, "size");
link_height       = ConfigGet(link_config, "height");
link_top_height   = ConfigGet(link_config, "top_height");
top_inner_side    = ConfigGet(link_config, "top_inner_side");
top_outer_side    = ConfigGet(link_config, "top_outer_side");
bottom_inner_side = ConfigGet(link_config, "bottom_inner_side");
bottom_outer_side = ConfigGet(link_config, "bottom_outer_side");

groove_top_tolerance_xy    = mm(.2);
groove_top_tolerance_z     = mm(.3);
groove_bottom_tolerance_xy = mm(.3);
slide_size  = [nozzle(2), mm(.15)];

floor_thickness = mm(3.8);
floor_seam_pos  = max(-floor_thickness / 2, -link_height - groove_top_tolerance_z);

floor_length = mm(40.0);

overlap = mm(10.0);

module FloorTop_2D() {
    polygon([
        [
            (floor_length + overlap) / 2,
            0
        ], [
            (floor_length + overlap) / 2 - .05,
            -mm(0.45) + .05
        ], [
            (floor_length + overlap) / 2 + (-floor_seam_pos - mm(1.05)) * 1,
            floor_seam_pos + mm(.6)
        ], [
            (floor_length + overlap) / 2 + (-floor_seam_pos - mm(1.05)) * 1,
            floor_seam_pos
        ], [
            -(floor_length - overlap) / 2 + (-floor_seam_pos - mm(.9)) * 1,
            floor_seam_pos
        ], [
            -(floor_length - overlap) / 2 + (-floor_seam_pos - mm(.9)) * 1,
            floor_seam_pos + mm(.45)
        ], [
            -(floor_length - overlap) / 2 + 0.05,
            -mm(.45) - 0.05
        ], [
            -(floor_length - overlap) / 2,
            0
        ]
    ]);
}
module FloorBottom_2D() {
    polygon([
        [
            (floor_length - overlap) / 2,
            floor_seam_pos
        ], [
            (floor_length - overlap) / 2 - .05,
            floor_seam_pos-mm(.45) + .05
        ], [
            (floor_length - overlap) / 2 + (-floor_seam_pos - mm(.9)) * 1 - .05,
            -floor_thickness + mm(.45) + .05
        ], [
            (floor_length - overlap) / 2 + (-floor_seam_pos - mm(.9)) * 1,
            -floor_thickness
        ], [
            -(floor_length + overlap) / 2 + (-floor_seam_pos - mm(.9)) * 1,
            -floor_thickness
        ], [
            -(floor_length + overlap) / 2 + (-floor_seam_pos - mm(.9)) * 1 + .05,
            -floor_thickness + mm(.45) - .05
        ], [
            -(floor_length + overlap) / 2 + .05,
            floor_seam_pos-mm(.45) - .05
        ], [
            -(floor_length + overlap) / 2,
            floor_seam_pos
        ]
    ]);
}


difference() {
    union() {
        LinearExtrude(y_from = -10, y_to = 10) {
            rotate(180)FloorTop_2D();
        }
        translate([12, -20 / 2 + 2.5, floor_seam_pos + 1 / 2]) {
            cube([5, .8, 1],true);
        }
        translate([12, 20 / 2 - 2.5, floor_seam_pos + 1 / 2]) {
            cube([5, .8, 1],true);
        }
    }
    LinearExtrude(x_from = 30, x_to = -30) Groove_2D();
    translate([-1, 20 / 2 - 1, floor_seam_pos]) {
        cube([20.1, .9, 1.5],true);
    }
    translate([-1, 20 / 2 - 4.5, floor_seam_pos]) {
        cube([20.1, .9, 1.5],true);
    }
    translate([-1, -20 / 2 + 2.5, floor_seam_pos]) {
        cube([20.1, .9, 1.5],true);
    }
    translate([-28, -20 / 2 + 2.5, floor_seam_pos + 1 / 2]) {
        cube([5.6, .9, 2],true);
    }
    translate([-28, 20 / 2 - 2.5, floor_seam_pos + 1 / 2]) {
        cube([5.6, .9, 2],true);
    }
}

difference() {
    union() {
        LinearExtrude(y_from = -10, y_to = 10) {
            rotate(180)FloorBottom_2D();
        }
        translate([-1, 20 / 2 - 1, floor_seam_pos]) {
            cube([20, .8, 1.0],true);
        }
        translate([-1, 20 / 2 - 4.5, floor_seam_pos]) {
            cube([20, .8, 1.0],true);
        }
        translate([-1, -20 / 2 + 2.5, floor_seam_pos]) {
            cube([20, .8, 1.0],true);
        }
        translate([20, -20 / 2 + 2.5, -floor_thickness + 1 / 2]) {
            cube([5, .8, 1],true);
        }
        translate([20, 20 / 2 - 2.5, -floor_thickness + 1 / 2]) {
            cube([5, .8, 1],true);
        }
    }
    translate([-19.5, -20 / 2 + 2.5, -floor_thickness]) {
        cube([5, .9, 2],true);
    }
    translate([-19.5, 20 / 2 - 2.5, -floor_thickness ]) {
        cube([5, .9, 2],true);
    }
    LinearExtrude(x_from = 30, x_to = -30) Groove_2D();
}



BIAS = 0.1;
module Groove_2D() {
    
    polygon([
        [
            -top_inner_side + slide_size[X],
            -link_height - slide_size[Y]
        ], [
            -top_inner_side + slide_size[X],
            -link_height
        ], [
            -top_inner_side,
            -link_height
        ], [
            -top_inner_side,
            -link_height - slide_size[Y]
        ], [
            -bottom_inner_side - groove_bottom_tolerance_xy,
            -link_height - slide_size[Y]
        ], [
            -bottom_inner_side - groove_bottom_tolerance_xy,
            -link_top_height + groove_top_tolerance_z
        ], [
            -top_inner_side - groove_bottom_tolerance_xy / 2,
            -link_top_height + groove_top_tolerance_z
        ], [
            -top_inner_side - groove_bottom_tolerance_xy / 2,
            BIAS
        ], [
            top_outer_side + groove_bottom_tolerance_xy / 2,
            BIAS
        ], [
            top_outer_side + groove_bottom_tolerance_xy / 2,
            -link_top_height + groove_top_tolerance_z
        ], [
            bottom_outer_side  + groove_bottom_tolerance_xy,
            -link_top_height + groove_top_tolerance_z
        ], [
            bottom_outer_side + groove_bottom_tolerance_xy,
            -link_height - slide_size[Y]
        ], [
            bottom_inner_side,
            -link_height - slide_size[Y]
        ], [
            bottom_inner_side,
            -link_height
        ], [
            bottom_inner_side - slide_size[X],
            -link_height
        ], [
            bottom_inner_side - slide_size[X],
            -link_height - slide_size[Y]
        ]
    ]);
}
*LinearExtrude(x_from = 20, x_to = -20) Groove_2D();


translate([link_size / 2, 0]) LinkA(link_config);
translate([-link_size / 2, 0]) LinkB(link_config);