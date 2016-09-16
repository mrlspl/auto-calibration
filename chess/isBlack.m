function output = isBlack( ycrcbPixel )
    output = abs(ycrcbPixel(:, :, 1) - 0.52) < 0.07;
end

