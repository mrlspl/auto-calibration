function [ intersection, t1, t2 ] = getIntersection( p1, u1, p2, u2 )
%GETINTERSECTION Summary of this function goes here
%   Detailed explanation goes here

    if rank([u1, u2]) < 2
        intersection = [nan; nan];
        t1 = nan;
        t2 = nan;
        return;
    end
    
    parameters = [u1, u2] \ (p1 -p2);
    t1 = - parameters(1);
    t2 = parameters(2);
    
    intersection = p2 + t2 * u2;

end

