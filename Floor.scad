use <FloorHub.scad>
use <FloorStraight.scad>
include <Floor.inc>

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

floor_hub_len      = ConfigGet(floor_config, "hub_length");
floor_straight_len = ConfigGet(floor_config, "straight_len");

FloorHub(floor_config);
translate([floor_hub_len, 0]) FloorStraight(floor_config);
translate([2 * floor_hub_len  +floor_straight_len, 0]) rotate(180) FloorHub(floor_config);

