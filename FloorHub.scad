use <FloorHubBottom.scad>
use <FloorHubCap.scad>
use <FloorHubTop.scad>

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

FloorHubBottom(floor_config);
FloorHubCap(floor_config);
FloorHubTop(floor_config);