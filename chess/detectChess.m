function intersections = detectChess(img, isYCbCr)
    %% Parameters
    CENTER_POINT = [240; 320];
    NEGLIGIBLE_CONTOURS = 10;

    %% Load Image
    if (isYCbCr)
%         ycbcr = img;
        image = ycbcr2rgb(img);
    else
%         ycbcr = rgb2ycbcr(img);
        image = img;
    end
    hsl = rgb2hsv(image);

%     %% Find Contur
%     for i = 1:size(image, 1)
%         for j = 1:size(image, 2)
%             if isBlack(hsl(i, j, :))
%                 image(i, j, 1) = 127;
%                 image(i, j, 2) = 0;
%                 image(i, j, 3) = 250;
%             elseif  isWhite(hsl(i, j, :))
%                 image(i, j, 1) = 0;
%                 image(i, j, 2) = 255;
%                 image(i, j, 3) = 0;
%             end
%         end
%     end
%     figure(9);
%     imshow(image);
%     hold on
      
    thetas = 0:0.1:(2*pi);
    lengths = zeros(size(thetas));
    for i = 1:length(thetas)
        u = [cos(thetas(i)); sin(thetas(i))];
        l = 10;
        outCount = 0;
        while outCount < NEGLIGIBLE_CONTOURS
            p = floor(l * u) + CENTER_POINT;
            if ~isInImage(p, size(image)) || ~isBlack(hsl(p(1), p(2), :)) && ~isWhite(hsl(p(1), p(2), :))
                outCount = outCount + 1;
            else
                outCount = 0;
            end
            l = l + 1; % This may result in reapated pixels!
        end
        l = l - outCount;
        lengths(i) = l;
    end

    xs = floor(CENTER_POINT(1) + lengths .* cos(thetas));
    ys = floor(CENTER_POINT(2) + lengths .* sin(thetas));

    xMax = max(xs);
    xMin = min(xs);
    yMax = max(ys);
    yMin = min(ys);


%     % Show Result
%     plot(CENTER_POINT(2), CENTER_POINT(1), 'y*');
%     plot([yMax yMin yMin yMax yMax], [xMax xMax xMin xMin xMax], 'y');
%     plot(ys, xs, 'yx-');

    clear CENTER_POINT NEGLIGIBLE_CONTOURS i l length lengths outCount p thetas u ys xs
    %% Do Line Search
    FinePoints = [];
    STEP=1;
    MAX_NOISE=10;

    former = 0; %-- -1: black +1: white 0: other
    noise=0;
    
    if (xMin <= 0)
        xMin = 1;
    end
    if (yMin <= 0)
        yMin = 1;
    end
    if (xMax > size(hsl, 1))
        xMax = size(hsl, 1);
    end
    if (yMax > size(hsl, 2))
        yMax = size(hsl, 2);
    end
    
    
    for x=xMin:STEP:xMax
        for y=yMin:STEP:yMax
            thisColor = getColor(hsl(x, y, :));

            if (former == thisColor) %-- Nothing has changed...
                continue;
            end

            if (thisColor == 0)
                if (noise < MAX_NOISE) %-- Might be either a noise or out of boundary
                    noise = noise + 1;
                    continue;
                else %-- If the noise max boundary has been passed
                    former = 0;
                    noise = 0;
                    continue;
                end
            end

            if (former == 0) %-- Edge of entering into a new colored region
                former = thisColor;
                continue;
            end


            FinePoints = checkPoint(x, y, 'ko', FinePoints, hsl, STEP);
            former = thisColor;
        end
    end

    for y=yMin:STEP:yMax
        for x=xMin:STEP:xMax
            thisColor = getColor(hsl(x, y, :));

            if (former == thisColor) %-- Nothing has changed...
                continue;
            end

            if (thisColor == 0)
                if (noise < MAX_NOISE) %-- Might be either a noise or out of boundary
                    noise = noise + 1;
                    continue;
                else %-- If the noise max boundary has been passed
                    former = 0;
                    noise = 0;
                    continue;
                end
            end

            if (former == 0) %-- Edge of entering into a new colored region
                former = thisColor;
                continue;
            end


            FinePoints = checkPoint(x, y, 'yo', FinePoints, hsl, STEP);
            former = thisColor;
        end
    end

    % plot(FinePoints(:, 1), FinePoints(:, 2), 'b*');
    clear STEP x y former xMin xMax yMin yMax
    %% Do Line Fitting
    lines = lineFit(FinePoints);

    linesHR = lines(find(lines(:,1)<1), :);
    linesHR = sortrows(linesHR, 2);
    linesVR = lines(find(lines(:,1)>1), :);
    linesVR = sortrows(linesVR, 2);
    lines = [linesHR; linesVR];
    
%     figure(10)
    % for lId=1:size(lines, 1)
    %     l = lines(lId, :);

%     for l=lines'
%         x1 = 0;
%         y1 = l(2) / sin(l(1));
%         x2 = size(image, 2);
%         y2 = (l(2) - x2*cos(l(1))) / sin(l(1));
%         plot([x1 x2], [y1 y2]);
% 
%         y1 = 0;
%         x1 = l(2) / cos(l(1));
%         y2 = size(image, 1);
%         x2 = (l(2) - y2*sin(l(1))) / cos(l(1));
%         plot([x1 x2], [y1 y2], 'y--');
%     end

    clear x1 x2 y1 y2 thisColor noise lld l MAX_NOISE linesHR linesVR
    %% Extract Intersect Points
    % figure(2);
    % for l_id = 1:size(lines, 1)
    %     l = lines(l_id, :);
    %     x1 = 0;
    %     y1 = l(2) / sin(l(1));
    %     x2 = size(image, 2);
    %     y2 = (l(2) - x2*cos(l(1))) / sin(l(1));
    % 
    %     for l_id_2=l_id+1:size(lines, 1)
    %         l = lines(l_id_2, :);
    %         x3 = 0;
    %         y3 = l(2) / sin(l(1));
    %         x4 = size(image, 2);
    %         y4 = (l(2) - x4*cos(l(1))) / sin(l(1));
    %         
    %         intersect = findIntersect(x1, x2, x3, x4, y1, y2, y3, y4);
    %          if (intersect(1) > 0 && intersect(1) < size(image, 1) && ...
    %              intersect(2) > 0 && intersect(2) < size(image, 2))
    %             plot(intersect(1), intersect(2), 'r*');
    %             hold on
    %          end
    %     end
    % end

    intersections = [];
    for i = 1:size(lines, 1)
        [p1, u1] = hesseToParametric(lines(i, 1), lines(i, 2));
        for j = i:size(lines, 1)
            [p2, u2] = hesseToParametric(lines(j, 1), lines(j, 2));
            intersection = getIntersection(p1, u1, p2, u2);
            
            if (~isnan(intersection(1)) && intersection(1) > 0 && intersection(1) < size(image, 1) && ...
                ~isnan(intersection(2)) && intersection(2) > 0 && intersection(2) < size(image, 2))
                intersections = [intersections; intersection'];
            else
%                 disp(intersection);
            end
            
            
%             plot(intersection(1), intersection(2), 'rx', 'MarkerSize', 12);
        end
    end

end