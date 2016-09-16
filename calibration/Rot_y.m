function output = Rot_y(theta)
% ROT_Y determines orientation of dummy frame {B1} relative to dummy frame
% {B0}, if {B1} is oriented after rotating {B0} about its y-axis by angle
% theta

output = [ cos(theta) 0 sin(theta) ;...
              0       1     0      ;...
          -sin(theta) 0 cos(theta) ];
end