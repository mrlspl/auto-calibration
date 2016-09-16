function output = pose_link_pre( i, time )
%POSE_LINK_PRE determines the pose of frame {i} relative to frame {i-1}

output = [ori_link_pre(i, time) posi_link_pre_pre(i, time); ...
                    0   0   0                         1                 ];


end

