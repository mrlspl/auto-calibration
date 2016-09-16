function FinePoints = checkPoint(X, Y, c, FinePoints_old, ycbcr, STEP)
    bestX = X;%-STEP;
    bestY = Y;%-STEP;
    
%     for x=X-STEP:X+STEP
%         for y=Y-STEP:Y+STEP
%             if (isBlack(ycbcr(x, y, :)))
%                 bestX = x;
%                 bestY = y;
%             end
%         end
%     end
%     
    FinePoints = [FinePoints_old; bestY,bestX];
%     hold on
%     plot(bestY,bestX,c);
end