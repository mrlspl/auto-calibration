function output = pose_link_base( i )
%POSE_LINK_BASE determines the pose (position+orientation) of frame {i}
%relative to base frame {0}

if i==1
    output = pose_link_pre(i);
else
    output = pose_link_base(i - 1) * pose_link_pre(i);

end

