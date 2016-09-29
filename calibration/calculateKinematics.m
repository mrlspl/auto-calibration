function [mergedJacobian, ori_bCam_origin, ori_tCam_origin, posi_bCam_origin, posi_tCam_origin] = calculateKinematics(robot)


%% These guys are for parameter input of kinematic calculations.
global linkTwist linkLength linkOffset jointOffset calibration encoder


%% Torso to Head Pitch
linkTwist = robot.headLinkTwist;
linkLength = robot.headLinkLength;
linkOffset = robot.headLinkOffset;
jointOffset = robot.headJointOffset;
calibration = [0; robot.calibrationOffsets(13:14)];
encoder = [0; robot.encoderData(13:14)];

posi_head_torso_torso = posi_link_base_base(2);
ori_head_torso = ori_link_base(2);
jaco_head_torso = [jacobian(robot.posi_bCam_HP_HP); jacobian(robot.posi_tCam_HP_HP)];

%% Torso to Camera
posi_bCam_torso_torso = posi_head_torso_torso + ori_head_torso * robot.posi_bCam_HP_HP;
ori_bCam_torso = ori_head_torso * robot.ori_bCam_HP;
posi_tCam_torso_torso = posi_head_torso_torso + ori_head_torso * robot.posi_tCam_HP_HP;
ori_tCam_torso = ori_head_torso * robot.ori_tCam_HP;

%% Origin to Torso via Left Leg
linkTwist = robot.leftLegLinkTwist;
linkLength = robot.leftLegLinkLength;
linkOffset = robot.leftLegLinkOffset;
jointOffset = robot.leftLegJointOffset;
calibration = [0; robot.calibrationOffsets(1:6)];
encoder = [0; robot.encoderData(1:6)];

posiL_torso_origin_origin = robot.posi_leftLeg_origin_origin + robot.ori_leftLeg_origin * (posi_link_base_base(6) + ori_link_base(6) * robot.posi_torso_LHYP_LHYP);
oriL_torso_origin = robot.ori_leftLeg_origin * ori_link_base(6) * robot.ori_torso_LHYP;
jacoL_torso_origin = jacobi_rotation(robot.ori_leftLeg_origin, 4) * [jacobian(posi_bCam_torso_torso); jacobian(posi_tCam_torso_torso)];

%% Origin to Torso via Right Leg
linkTwist = robot.rightLegLinkTwist;
linkLength = robot.rightLegLinkLength;
linkOffset = robot.rightLegLinkOffset;
jointOffset = robot.rightLegJointOffset;
calibration = [0; robot.calibrationOffsets(7:12)];
encoder = [0; robot.encoderData(7:12)];

posiR_torso_origin_origin = robot.posi_rightLeg_origin_origin + robot.ori_rightLeg_origin * (posi_link_base_base(6) + ori_link_base(6) * robot.posi_torso_RHYP_RHYP);
oriR_torso_origin = robot.ori_rightLeg_origin * ori_link_base(6) * robot.ori_torso_RHYP;
jacoR_torso_origin = jacobi_rotation(robot.ori_rightLeg_origin, 4) * [jacobian(posi_bCam_torso_torso); jacobian(posi_tCam_torso_torso)];

%% Origin to Torso Average
posi_torso_origin_origin = (posiL_torso_origin_origin + posiR_torso_origin_origin) / 2;
ori_torso_origin = (oriL_torso_origin + oriR_torso_origin) / 2;
jaco_torso_origin = [jacoL_torso_origin, jacoR_torso_origin] / 2;


%% Origin to Head Pitch
posi_head_origin_origin = posi_torso_origin_origin + ori_torso_origin * posi_head_torso_torso;
ori_head_origin = ori_torso_origin * ori_head_torso;
jaco_head_origin = jacobi_rotation(ori_torso_origin, 4) * jaco_head_torso;

%% Origin to Cameras
posi_bCam_origin = posi_head_origin_origin + ori_head_origin * robot.posi_bCam_HP_HP;
ori_bCam_origin = ori_head_origin * robot.ori_bCam_HP;
jaco_bCam_origin = jacobi_rotation(ori_bCam_origin, 4) * [zeros(3); eye(3); zeros(6, 3)];

posi_tCam_origin = posi_head_origin_origin + ori_head_origin * robot.posi_tCam_HP_HP;
ori_tCam_origin = ori_head_origin * robot.ori_tCam_HP;
jaco_tCam_origin = jacobi_rotation(ori_tCam_origin, 4) * [zeros(9, 3); eye(3)];

%% Merged Jacobian
mergedJacobian = [jaco_torso_origin, jaco_head_torso, jaco_bCam_origin, jaco_tCam_origin];

end
