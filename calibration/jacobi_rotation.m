function output = jacobi_rotation( R, n )
%JACOBI_ROTATION Summary of this function goes here
%   Detailed explanation goes here

    output = zeros(n * 3);
    for i = 1:n
        l = 3 * (i - 1) + 1;
        u = l + 2;
        output(l:u, l:u) = R;
    end

end

