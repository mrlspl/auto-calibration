function output = posi_link_base_link( i )
%POSI_LINK_BASE_LINKf determines the position of frame {i} relative to base
%frame {0}, expressed in frame {i}

if i==0
    output = ori_link_pre(i)' * posi_link_pre_pre(i);
else
    output = ori_link_pre(i)' * (posi_link_pre_pre(i) + posi_link_base_link(i-1));

end

