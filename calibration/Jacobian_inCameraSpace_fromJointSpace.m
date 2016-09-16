function [Jacobian, ori_bCam_origin, ori_tCam_origin, posi_bCam_origin, posi_tCam_origin] = Jacobian_inCameraSpace_fromJointSpace(robot)
    [Jacobian, ori_bCam_origin, ori_tCam_origin, posi_bCam_origin, posi_tCam_origin] = calculateKinematics(robot);
end