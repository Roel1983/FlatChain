include <../../Utils/Constants.inc>
include <../../Utils/Debug.inc>
include <../../Utils/Points.inc>
include <Groove.inc>

$fn=46;

groove_config   = GrooveConfig();
link_config     = ConfigGet(groove_config, "link_config");

points = points_groove_top(extra = 10);
DebugPoints(points);
polygon(points);

function points_groove_top_outer(
    groove_config = GrooveConfig(),
    extra
) = (
    let(
        groove_tolerance_xy_straight_top = (
            ConfigGet(groove_config, "tolerance_xy_straight_top")
        ), groove_tolerance_xy_hub_top   = (
            ConfigGet(groove_config, "tolerance_xy_hub_top")
        ), link_config                   = (
            ConfigGet(groove_config, "link_config")
        ), link_center_radius           = (
            ConfigGet(link_config,   "center_radius")
        ), link_size = (
            ConfigGet(link_config,   "size")
        ), link_joint_size = (
            ConfigGet(link_config,   "joint_size")
        ), link_top_outer_side = (
            ConfigGet(link_config,   "top_outer_side")
        )
    )
    points_groove(
        link_config            = link_config,
        normal_offset_straight = (
            link_top_outer_side + groove_tolerance_xy_straight_top / 2
        ),
        normal_offset_curve    = (
            norm([
                link_center_radius + link_top_outer_side,
                (link_size + link_joint_size) / 2
            ]) - link_center_radius
            + groove_tolerance_xy_hub_top / 2
        ),
        extra                  = extra
    )
);

function points_groove_top_inner(
    groove_config = GrooveConfig(),
    extra
) = (
    let(
        groove_tolerance_xy_straight_top = (
            ConfigGet(groove_config, "tolerance_xy_straight_top")
        ), groove_tolerance_xy_hub_top   = (
            ConfigGet(groove_config, "tolerance_xy_hub_top")
        ), link_config                   = (
            ConfigGet(groove_config, "link_config")
        ), link_top_inner_side           = (
            ConfigGet(link_config,   "top_inner_side")
        ), link_top_inner_edge_radius = (
            ConfigGet(link_config,   "top_inner_side")
        )
    )
    points_groove(
        link_config            = link_config,
        normal_offset_straight = (
            - link_top_inner_side
            - groove_tolerance_xy_straight_top / 2
        ),
        normal_offset_curve    = (
            -link_top_inner_edge_radius
            - groove_tolerance_xy_hub_top / 2
        ),
        extra                  = extra
    )
);

function points_groove_bottom_outer(
    groove_config = GrooveConfig(),
    extra
) = (
    let(
        groove_tolerance_xy_straight_bottom = (
            ConfigGet(groove_config, "tolerance_xy_straight_bottom")
        ), groove_tolerance_xy_hub_bottom   = (
            ConfigGet(groove_config, "tolerance_xy_hub_bottom")
        ), link_config                   = (
            ConfigGet(groove_config, "link_config")
        ), link_bottom_outer_side           = (
            ConfigGet(link_config,   "bottom_outer_side")
        ), link_bottom_outer_edge_radius = (
            ConfigGet(link_config,   "bottom_outer_side")
        )
    )
    points_groove(
        link_config            = link_config,
        normal_offset_straight = (
            link_bottom_outer_side
            + groove_tolerance_xy_straight_bottom / 2
        ),
        normal_offset_curve    = (
            link_bottom_outer_edge_radius
            + groove_tolerance_xy_hub_bottom / 2
        ),
        extra                  = extra
    )
);

function points_groove_bottom_inner(
    groove_config = GrooveConfig(),
    extra
) = (
    let(
        groove_tolerance_xy_straight_bottom = (
            ConfigGet(groove_config, "tolerance_xy_straight_bottom")
        ), groove_tolerance_xy_hub_bottom   = (
            ConfigGet(groove_config, "tolerance_xy_hub_bottom")
        ), link_config                   = (
            ConfigGet(groove_config, "link_config")
        ), link_bottom_inner_side           = (
            ConfigGet(link_config,   "bottom_inner_side")
        ), link_bottom_inner_edge_radius = (
            ConfigGet(link_config,   "bottom_inner_side")
        )
    )
    points_groove(
        link_config            = link_config,
        normal_offset_straight = (
            - link_bottom_inner_side
            - groove_tolerance_xy_straight_bottom / 2
        ),
        normal_offset_curve    = (
            -link_bottom_inner_edge_radius
            - groove_tolerance_xy_hub_bottom / 2
        ),
        extra                  = extra
    )
);

function points_groove_bottom(
    groove_config = GrooveConfig(),
    extra
) = (
    concat(
        points_groove_bottom_outer(
            groove_config = groove_config,
            extra         = extra
        ),
        points_reverse(points_groove_bottom_inner(
            groove_config = groove_config,
            extra         = extra
        ))
    )
);

function points_groove_top(
    groove_config = GrooveConfig(),
    extra
) = (
    concat(
        points_groove_top_outer(
            groove_config = groove_config,
            extra         = extra
        ),
        points_reverse(points_groove_top_inner(
            groove_config = groove_config,
            extra         = extra
        ))
    )
);


function points_groove(
    link_config            = LinkConfig(),
    normal_offset_straight = 0,
    normal_offset_curve    = 0,
    extra                  = undef
) = (
    let(
        link_size          = ConfigGet(link_config, "size"),
        link_joint_radius  = ConfigGet(link_config, "joint_radius"),
        link_center_radius = ConfigGet(link_config, "center_radius"),
        transition_angle = (
            atan(
                (link_size / 2)
                /
                link_joint_radius
            ) * 2
        )
    ) (
        let(
            step_max = ceil(
                points_fn(link_joint_radius + normal_offset_straight)
                * (90 - transition_angle) / 360
            ), points_groove_transition = [
                for(step = [0: step_max]) (
                    let(
                        i = step / step_max,
                        a = transition_angle * i,
                        normal_offset = (
                            (1-i) * normal_offset_straight 
                            + i * normal_offset_curve
                        ), 
                        p1 = [
                            cos(a + 90) * link_joint_radius,
                            sin(a + 90) * link_joint_radius
                        ],
                        p2 = [
                            p1[X] + sqrt(pow(link_size, 2) - pow(link_joint_radius - p1[Y], 2)),
                            link_joint_radius
                        ],
                        p3 = (p1 + p2) / 2,
                        
                        vec    = (p1 - p2) / norm(p1 - p2),
                        normal = [vec[Y], -vec[X]],
                        p4 = p3 + normal * normal_offset
                    )
                    p4
                )
            ], angle_start_circle = (
                atan(
                    -points_groove_transition[step_max][X]
                    /
                    points_groove_transition[step_max][Y]
                )
                
            ), points_groove_circle = (
                points_trim(
                    first = 1,
                    last  = 1,
                    
                    points_of_circle(
                        r = link_center_radius + normal_offset_curve,
                        a1 = 90 + angle_start_circle,
                        a2 = 270 - angle_start_circle
                    )
                )
            ), point_extra = (
                (is_undef(extra) || (extra <= 0)) ? [
                ]: (
                    assert(points_groove_transition[0][X] < extra)
                    [
                        [
                            extra,
                            link_joint_radius + normal_offset_straight
                            
                        ]
                    ]
                )
            )
        )
        concat(
            point_extra,
            points_groove_transition,
            points_groove_circle,
            points_reverse(points_mirror(VEC_Y,
                points_groove_transition
            )),
            points_mirror(VEC_Y, point_extra)
        )
    )
);

