function lines=lineFit(points)
    STP = .01;
    RES = 5;
    MOOO = 3000;
    
    houghSpace = zeros(ceil(pi / STP), MOOO);
    
    for pId=1:size(points)
        p = points(pId, :);
        
        for theta=-1:STP:(pi-1)
            d = p(1)*cos(theta) + p(2)*sin(theta);
            
            d = floor(d * 2 + MOOO/2);
            d = floor(d / RES) * RES;
            if d > MOOO || d < 1
                continue
            end
            
            theta = floor((theta + 1) / STP + 1);
%             [theta, d]
            houghSpace(theta, d) = houghSpace(theta, d) + 1;
        end
    end
    
    
    houghSpace = uint8((houghSpace ./ max(max(houghSpace))) * 255);
%      figure, imshow(houghSpace)
%      figure, hist(double(reshape(houghSpace, [], 1)));
    
    THRESHOLD = 100;
    MATCH_THR_D = 20;
    MATCH_THR_T = 0.5;
    lines=[];
    for i = 1:size(houghSpace, 1)
        for j = 1:size(houghSpace, 2)
            if houghSpace(i, j) > THRESHOLD
                newLine = [(i - 1) * STP - 1, (j - MOOO / 2) / 2, double(houghSpace(i, j))];
                
                isMatched = false;
                for k=1:size(lines, 1)
                    if abs(newLine(1) - lines(k, 1))<MATCH_THR_T && ...
                       abs(newLine(2) - lines(k, 2))<MATCH_THR_D
                        
                        if (newLine(3) > lines(k, 3))
                            lines(k, :) = newLine;
                        end
                        
                        isMatched = true;
                        break
                    end
                end
                
                if (~isMatched)
                    lines = [lines; newLine];
                end
            end
        end
    end
    
end