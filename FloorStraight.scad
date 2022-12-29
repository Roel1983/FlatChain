use <FloorStraightBottom.scad>
use <FloorStraightTopInner.scad>
use <FloorStraightTopOuter.scad>
include <Floor.inc>
include <LinkA.inc>
include <LinkB.inc>

$fn = 64;

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

FloorStraight(floor_config);

module FloorStraight(floor_config = FloorConfig()) {
    
    floor_straight_len = ConfigGet(floor_config, "straight_len");
    groove_config       = ConfigGet(floor_config, "groove_config");
    link_config        = ConfigGet(groove_config, "link_config");
    size               = ConfigGet(link_config, "size");
    joint_radius       = ConfigGet(link_config, "joint_radius");
    
    FloorStraightBottom(floor_config);
    FloorStraightTopInner(floor_config);
    FloorStraightTopOuter(floor_config);
    
    translate([floor_straight_len, 0]) {
        rotate(180) FloorStraightTopOuter(floor_config);
    }
    
    translate([1*size, -joint_radius]) color("green") LinkB(link_config);
    translate([2*size, -joint_radius]) color("red") LinkA(link_config);
    translate([3*size, -joint_radius]) color("green") LinkB(link_config);
}
