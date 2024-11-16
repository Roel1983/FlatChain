include <Floor.inc>
use <FloorStraightBottom.scad>

use <FloorStraightTopLeft.scad>

$fn = 64;

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

FloorStraightTopRight(floor_config, printable = true);

module FloorStraightTopRight(config = FloorConfig(), printable = false) {
    floor_straight_len = ConfigGet(config, "straight_len");
    
    translate([floor_straight_len, 0]) {
        rotate(180) FloorStraightTopLeft(config);
    }
}
