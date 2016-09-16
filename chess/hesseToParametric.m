function [ p0, u, n ] = hesseToParametric( theta, d )
%HESSIETOPARAMETRIC Summary of this function goes here
%   Detailed explanation goes here

    n = [cos(theta);
         sin(theta)];
    u = [0, -1;
         1, 0] * n;
    p0 = d * n;

end

