function outImage = correctWhiteBalance(inputImage)

    wC1 = 255/mean(mean(inputImage(:,:,1)));
    wC2 = 255/mean(mean(inputImage(:,:,2)));
    wC3 = 255/mean(mean(inputImage(:,:,3)));
    
    inputImage(:, :, 1) = inputImage(:, :, 1) * wC1;
    inputImage(:, :, 2) = inputImage(:, :, 2) * wC2;
    inputImage(:, :, 3) = inputImage(:, :, 3) * wC3;
    
    outImage = inputImage;

end