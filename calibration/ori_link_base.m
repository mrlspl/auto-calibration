function output = ori_link_base( i )
%ORI_LINK_BASE determines the orientation of frame {i} relative to base
%frame {0}

if i==1
    output = ori_link_pre(1);
else
    output = ori_link_base(i-1) * ori_link_pre(i);
end

end

