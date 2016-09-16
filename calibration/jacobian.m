function J = jacobian(endPosition_base_base)
%JACOBIAN Summary of this function goes here
%   Detailed explanation goes here

J = zeros(6, chainLength());
for i = 1:chainLength()
    z_i = ori_link_base(i) * [0; 0; 1];
    r_i = posi_link_base_base(chainLength()) - posi_link_base_base(i) + endPosition_base_base;
    J(1:3, i) = cross(z_i, r_i);
    J(4:6, i) = z_i;
end

end

