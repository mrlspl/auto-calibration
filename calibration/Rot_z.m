function output = Rot_z(theta)
% ROT_Z determines orientation of dummy frame {B1} relative to dummy frame
% {B0}, if {B1} is oriented after rotating {B0} about its z-axis by angle
% theta

output = [ cos(theta) -sin(theta) 0 ;...
           sin(theta)  cos(theta) 0 ;...
               0           0      1 ];
end