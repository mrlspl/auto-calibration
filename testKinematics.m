clc
clear all
close all

addpath('calibration/', 'chess/');
global robot z joints

%% Initialization
% name = './samples/calibration_1253146175';
% name = './samples/calibration_1476002609';
name = './samples/calibration_1476009301';
robot = initalRobot();
robot.calibrationOffsets = zeros(20, 1);

%% Load Joint Data
joints = zeros(22, z);
l = load([name '_' num2str(0) '.joint']);
joints(:, 1) = l(1:22);

robot.encoderData = [joints(16:-1:11, 1); joints(22:-1:17, 1); joints(1:2, 1)];
%-- This part below is duo to difference between NAOqi and B-Human
%   Joint space in kinematics design.
robot.encoderData(1) = -robot.encoderData(1); % LAR
robot.encoderData(5) = -robot.encoderData(5); % LHR
robot.encoderData(6) = -robot.encoderData(6); % LHYP
robot.encoderData(14) = -robot.encoderData(14); % Head Pitch

% robot.encoderData = zeros(14, 1);
% robot.calibrationOffsets(1:12) = [0.3787; -1.544; 1.36346; 3.2959; -1.07; 0.0539; 0.1407; -1.407; 0.023; 4.3289; -1; 0.05395] * pi / 180;

%-- Calculate Jacobian of the current configuration
[J_cs_js, ori_bCam_origin, ori_tCam_origin, posi_bCam_origin, posi_tCam_origin] = Jacobian_inCameraSpace_fromJointSpace(robot);

%% Load B-Human data
% data = load([name '_' num2str(1) '.camera'])
% ori_bCam = [data(1:3)' data(4:6)' data(7:9)'];
ori = [0.75283 0.02998 -0.65753; -0.0426 0.99909 -0.00322; 0.65683 0.03043 0.75342]'
ori_bCam_origin
% posi_bCam = data(10:12)';
posi = [72; 2; 453]
posi_bCam_origin

%% Unproject;
% [J_cs_js, ori_bCam_origin, ori_tCam_origin, posi_bCam_origin, posi_tCam_origin] = Jacobian_inCameraSpace_fromJointSpace(robot);
[J_fs_cs, points] = Jacobian_inFieldSpace_fromCameraSpace(posi_bCam_origin, ori_bCam_origin, [321; 239])