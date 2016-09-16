function output = ori_link_pre( i )
%ORI_LINK_PRE determines the orientation of frame {i} relative to frame
%{i-1}

output = [          cos(q(i))            -sin(q(i))                  0;
          sin(q(i))*cos(alpha(i-1)) cos(q(i))*cos(alpha(i-1)) -sin(alpha(i-1));
          sin(q(i))*sin(alpha(i-1)) cos(q(i))*sin(alpha(i-1))  cos(alpha(i-1))];

end

