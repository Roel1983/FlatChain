include <../Utils/LinearExtrude.inc>
include <../Utils/TransformIf.inc>
include <../Utils/Box.inc>
include <../Utils/Git.inc>
include <Floor.inc>
use <FloorHubBottom.scad>

$fn = 64;

link_config     = LinkConfig();
groove_config   = GrooveConfig(link_config = link_config);
floor_config    = FloorConfig(groove_config = groove_config);

FloorHubTopInner(floor_config, printable = true);

module FloorHubTopInner(config = FloorConfig(), printable = false) {
    rotate_if(printable && !$preview, 180, VEC_X) {
        Box
    }
}
