function output = posi_link_base_base( i )
%POSI_LINK_BASE_BASE determines the position of frame {i} relative to base
%frame {0} expressed in {0}.

if i==1
    output = posi_link_pre_pre(i);
else
    output = ori_link_base(i - 1) * posi_link_pre_pre(i) + posi_link_base_base(i - 1);   

end

