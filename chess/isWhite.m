function output = isWhite( ycrcbPixel )
    output = abs(ycrcbPixel(:, :, 1) - 0.08) < 0.07;
end

