include <../Utils/Constants.inc>
include <../Utils/Box.inc>
include <../Utils/LinearExtrude.inc>
include <../Utils/Shapes.inc>
include <../Utils/TransformCopy.inc>
include <../Utils/TransformIf.inc>
include <../Utils/Units.inc>
include <Links.inc>
include <Pieces/Groove.inc>
include <Floor.inc>
include <FloorHub.inc>

$fn=32;

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);


if($preview) %FloorHub(floor_config);
GearedMiniMotorMount(floor_config, is_printable=true);

module GearedMiniMotorMount(floor_config, is_printable=false) {
    wall_z       = mm(.5);
    wall_xy      = nozzle(2);
    gearbox_size = mm([9.95,11.9, 9.0]);
    gearbox_axel = mm(4.1);
    thickness    = mm(2.0);
    BIAS         = 0.1;

    floor_hub_position = ConfigGet(floor_config, "hub_position");
    floor_thickness    = ConfigGet(floor_config, "thickness");
    floor_width        = ConfigGet(floor_config, "width");
    floor_hub_hexnut_size    = ConfigGet(floor_config, "hub_hexnut_size");
    floor_hub_screw_diameter = ConfigGet(floor_config, "hub_screw_diameter");
    
    rotate_if(!$preview && is_printable, 180, VEC_X) {

        difference() {
            union() {
                Box(
                    x_from = 0, x_to = floor_hub_position + mm(10),
                    y_from = -floor_width/2, y_to=floor_width/2,
                    z_from = -floor_thickness - thickness, z_to =  -floor_thickness
                );
                translate([floor_hub_position, 0, -floor_thickness]) {
                    LinearExtrude(z_from = -gearbox_size[Z] - wall_z, z_to = -BIAS) {
                        square([gearbox_size[X] + 2*wall_xy, gearbox_size[Y] + 2*wall_xy], true);
                    }
                }
            }

            translate([floor_hub_position, 0, -floor_thickness]) {
                LinearExtrude(z_from = -gearbox_size[Z] - wall_z - BIAS, z_to = -wall_z) {
                    r = mm(.5);
                    offset(r) offset(-r) square([gearbox_size[X], gearbox_size[Y]], true);
                }
                LinearExtrude(z_from = BIAS, z_to = -wall_z - BIAS) {
                    circle(d = gearbox_axel);
                }
            }
            mirror(VEC_Z) {
                mirror_copy(VEC_Y) {
                    translate([mm(5), floor_width / 2 - mm(5)]) {
                        cylinder(
                            d=floor_hub_screw_diameter,
                            h=floor_thickness + thickness + 2 * BIAS
                        );
                        translate([0,0, floor_thickness + wall_z]) {
                            LinearExtrude(z_from= 0, z_to= floor_hub_hexnut_size[Y]) {
                                Hex(floor_hub_hexnut_size[X]);
                            }
                        }
                    }
                }
            }
        }
    }
}