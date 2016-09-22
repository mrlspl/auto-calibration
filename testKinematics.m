clc
clear all
close all

addpath('calibration/', 'chess/');
global robot INTER_REF dataSet z joints intersections itrF

%% Initialization
name = './samples/calibration_1253146175';
robot = initalRobot();
robot.calibrationOffsets = zeros(20, 1);

%% Load Joint Data
joints = zeros(23, z);
l = load([name '_' num2str(0) '.joint']);
joints(:, 1) = l(1:23);

robot.encoderData = [joints(16:-1:11, 1); joints(22:-1:17, 1); joints(1:2, 1)];
%-- This part below is duo to difference between NAOqi and B-Human
%   Joint space in kinematics design.
robot.encoderData(1) = -robot.encoderData(1); % LAR
robot.encoderData(5) = -robot.encoderData(5); % LHR
robot.encoderData(6) = -robot.encoderData(6); % LHYP
robot.encoderData(14) = -robot.encoderData(14); % Head Pitch

%-- Calculate Jacobian of the current configuration
[J_cs_js, ori_bCam_origin, ori_tCam_origin, posi_bCam_origin, posi_tCam_origin] = Jacobian_inCameraSpace_fromJointSpace(robot);

%% Load B-Human data
data = load([name '_' num2str(0) '.camera']);
ori_bCam = [data(1:3)' data(4:6)' data(7:9)']
ori_bCam_origin
posi_bCam = data(10:12)'
posi_bCam_origin