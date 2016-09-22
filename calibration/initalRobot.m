function robot = initalRobot()
    robot = [];
    
    % Left Leg Kinematic Parameters - Proximal DH Table
    robot.leftLegLinkTwist = [0; pi/2; 0; 0; -pi/2; pi/2]; % rad
    robot.leftLegLinkLength = [45.11; 0; 102.75; 100; 0; 0]; % mm
    robot.leftLegLinkOffset = [0; 0; 0; 0; 0; 0; 0];
    robot.leftLegJointOffset = [0; 0; 0; 0; 0; pi/4; 0];
    robot.posi_leftLeg_origin_origin = [0; 50; 0];
    robot.ori_leftLeg_origin = Rot_y(-pi/2);
    robot.ori_torso_LHYP = Rot_y(pi/4) * Rot_z(-pi/2);
    robot.posi_torso_LHYP_LHYP = robot.ori_torso_LHYP * [0; -50; 85];

    % Right Leg Kinematic Parameters - Proximal DH Table
    robot.rightLegLinkTwist = [0; pi/2; 0; 0; -pi/2; -pi/2]; % rad
    robot.rightLegLinkLength = [45.11; 0; 102.75; 100; 0; 0]; % mm
    robot.rightLegLinkOffset = [0; 0; 0; 0; 0; 0; 0];
    robot.rightLegJointOffset = [0; 0; 0; 0; 0; -pi/4; 0];
    robot.posi_rightLeg_origin_origin = [0; -50; 0];
    robot.ori_rightLeg_origin = Rot_y(-pi/2);
    robot.ori_torso_RHYP = Rot_y(pi/4) * Rot_z(pi/2);
    robot.posi_torso_RHYP_RHYP = robot.ori_torso_RHYP * [0; 50; 85];

    % Head Kinematic Parameters - Proximal DH Table
    robot.headLinkTwist = [0; pi/2]; % rad
    robot.headLinkLength = [0; 0; 0]; % mm
    robot.headLinkOffset = [0; 211.5; 0];
    robot.headJointOffset = [0; 0; -pi/2];

    % Camera Positions
    rot_cam = [1   0   0;
               0  -1   0;
               0   0  -1];
    robot.posi_bCam_HP_HP = [17.74; 50.71; 0];
    robot.ori_bCam_HP = Rot_z(0.6929) * rot_cam;
    robot.posi_tCam_HP_HP = [63.64; 58.71; 0];
    robot.ori_tCam_HP = Rot_z(0.0209) * rot_cam;

end