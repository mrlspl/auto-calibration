function former = myFunc1(x, y, k, w, former)
    if k
        if (former ~= -1)
            checkPoint(x,y,'m*');
        end

        former = -1;
    elseif w
        if (former ~= +1)
            checkPoint(x,y,'g*');
        end

        former = +1;
    else
        former = 0;
    end
end