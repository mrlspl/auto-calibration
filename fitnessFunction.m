function [F, J] = fitnessFunction(x)
    global robot INTER_REF z joints intersections
    robot.calibrationOffsets = x;

    J = zeros(z*9*2, 20);
    F = zeros(z*9*2, 1);
    for i=1:z %-- For each Sample
        %-- Reading Joint data
        robot.encoderData = [joints(16:-1:11, i); joints(22:-1:17, i); joints(1:2, i)];
        %-- This part below is duo to difference between NAOqi and B-Human
        %   Joint space in kinematics design.
        robot.encoderData(1) = -robot.encoderData(1);
        robot.encoderData(5) = -robot.encoderData(5);
        robot.encoderData(6) = -robot.encoderData(6);
        robot.encoderData(14) = -robot.encoderData(14);
        
        %-- Calculate Jacobian of the current configuration
        [J_cs_js, ori_bCam_origin, ori_tCam_origin, posi_bCam_origin, posi_tCam_origin] = Jacobian_inCameraSpace_fromJointSpace(robot);
        
        if (joints(end, i) == 0) %-- Sample is from bottom camera
            J_cs_js = J_cs_js(1:6, :);
        else
            J_cs_js = J_cs_js(7:12, :);
        end

        if (i == 1) %-- Draw the data
            figure(1);
            pause(0.1);
            hold off
            plot([INTER_REF(1, 2) INTER_REF(2, 2) INTER_REF(3, 2) INTER_REF(6, 2) INTER_REF(5, 2) INTER_REF(4, 2) INTER_REF(7, 2) INTER_REF(8, 2) INTER_REF(9, 2) INTER_REF(3, 2) INTER_REF(2, 2) INTER_REF(8, 2) INTER_REF(7, 2) INTER_REF(1, 2)], ...
                 [INTER_REF(1, 1) INTER_REF(2, 1) INTER_REF(3, 1) INTER_REF(6, 1) INTER_REF(5, 1) INTER_REF(4, 1) INTER_REF(7, 1) INTER_REF(8, 1) INTER_REF(9, 1) INTER_REF(3, 1) INTER_REF(2, 1) INTER_REF(8, 1) INTER_REF(7, 1) INTER_REF(1, 1)], ...
                 'b');
            hold on
            for k=1:size(INTER_REF, 1)
                text(INTER_REF(k, 2), INTER_REF(k, 1), ['\leftarrow' num2str(k)]);
            end
        end
        
        for j=1:9 %-- Intersections
            ith = (i-1)*9*2+(j-1)*2+1;
            ith_2 = (i-1)*9+j;
            
            if (joints(end, i) == 0) %-- Sample is from bottom camera
                [J_fs_cs, points] = Jacobian_inFieldSpace_fromCameraSpace(posi_bCam_origin, ori_bCam_origin, intersections(ith_2, :)');
            else
                [J_fs_cs, points] = Jacobian_inFieldSpace_fromCameraSpace(posi_tCam_origin, ori_tCam_origin, intersections(ith_2, :)');
            end
            
            
            F(ith:ith+1) = points - INTER_REF(j, :)';
            
            Ji = J_fs_cs * J_cs_js;
            J(ith:ith+1, :) = Ji;
            
            if (i == 1) %-- Draw the data
                figure(1);
                hold on;                
                plot(points(2), points(1), 'r*');
                plot(INTER_REF(j, 2), INTER_REF(j, 1), 'b*');
                plot([points(2) INTER_REF(j, 2)], [points(1) INTER_REF(j, 1)], 'b');
                grid on;
                
                text(points(2), points(1), ['\leftarrow' num2str(j)]);
% %                 axis([0 +1000 -10 2000]);
            end
        end
    end
    global itrF 
    
%     J = J(:, 1:17);
    
    itrF = itrF + 1;
    disp(['Iteration  :: (' num2str(itrF) ')']);
    disp(['Jacobs Rank : ' num2str(rank(J))]);
    disp(['Determinent : ' num2str(log(det(J' * J)))]);
    disp(['Conditional : ' num2str(log(cond(J' * J)))]);
    disp(['Error Mean  : ' num2str(mean(abs(F)))]);
    disp('----------------------------------------');
end