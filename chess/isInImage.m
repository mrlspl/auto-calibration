function output = isInImage( point , size_image )
%ISINIMAGE Summary of this function goes here
%   Detailed explanation goes here
    
    if point(1) < 1
        output = 0;
        return;
    end
    
    if point(2) < 1
        output = 0;
        return;
    end
    
    if point(1) > size_image(1)
        output = 0;
        return;
    end
    
    if point(2) > size_image(2)
        output = 0;
        return;
    end
    
    output = 1;

end

