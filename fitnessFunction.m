function [F, J] = fitnessFunction(x)
    global robot INTER_REF z joints intersections testX
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
        
        for j=1:9 %-- Intersections
            ith = (i-1)*9*2+(j-1)*2+1;
            ith_2 = (i-1)*9+j;
            
            if (joints(end, i) == 0) %-- Sample is from bottom camera
                [J_fs_cs, points] = Jacobian_inFieldSpace_fromCameraSpace(posi_bCam_origin, ori_bCam_origin, intersections(ith_2, :)');
            else
                [J_fs_cs, points] = Jacobian_inFieldSpace_fromCameraSpace(posi_tCam_origin, ori_tCam_origin, intersections(ith_2, :)');
            end
            
            F(ith:ith+1) = points - INTER_REF(i, :)';
            
            Ji = J_fs_cs * J_cs_js;
            J(ith:ith+1, :) = Ji;
        end
    end
    global itrF 
    
    itrF = itrF + 1;
    disp(['Iteration  :: (' num2str(itrF) ')']);
    disp(['Jacobs Rank : ' num2str(rank(J))]);
    disp(['Determinent : ' num2str(log(det(J' * J)))]);
    disp(['Conditional : ' num2str(log(cond(J' * J)))]);
    disp(['Error Mean  : ' num2str(mean(abs(F)))]);
    disp('----------------------------------------');
end