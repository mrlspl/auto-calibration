function output = Rot_x(theta)
% ROT_X determines orientation of dummy frame {B1} relative to dummy frame
% {B0}, if {B1} is oriented after rotating {B0} about its x-axis by angle
% theta
output = [1    0            0      ;...
          0 cos(theta) -sin(theta) ;...
          0 sin(theta)  cos(theta) ];
end