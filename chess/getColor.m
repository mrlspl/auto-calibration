function c = getColor(clr)  %-- -1: black +1: white 0: other
    if isBlack(clr)
        c = +1;
    elseif isWhite(clr)
        c = -1;
    else
        c = 0;
    end
end