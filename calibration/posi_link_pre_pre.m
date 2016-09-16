function output = posi_link_pre_pre( i )
%POSI_LINK_PRE_PRE determines the position of frame {i} relative to frame
%{i-1} expressed in frame {i-1}
% Note: In a robot with all revolute joints (as in the case of NAO), this
% function is not dependent upon FrameNumber. However, since other
% functions are taking frameNumber as input, it's also considered as the
% input of this function.


output = [      a(i - 1);
          -d(i) * sin(alpha(i - 1));
           d(i) * cos(alpha(i - 1))];

end

