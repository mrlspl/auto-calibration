clc
clear
close all

addpath('calibration/', 'chess/');
global robot INTER_REF dataSet z joints intersections itrF

%% Pre-Loading Image Processing
% name = './samples/calibration_1253147384';
name = './samples/calibration_1253146175';
SAMPLE_SIZE = 7;
sampleCheck = zeros(SAMPLE_SIZE, 1);
intersections = [];

for sample = 1:SAMPLE_SIZE
    %% Loading Image Sample
    img  = load([name '_' num2str(sample-1) '.image']);
    img = reshape(img, [3 320 240]);
    img_c1(:,:) = img(1, :, :);
    img_c2(:,:) = img(2, :, :);
    img_c3(:,:) = img(3, :, :);
    img_c1 = img_c1';
    img_c2 = img_c2';
    img_c3 = img_c3';
    imgR(:, :, 1) = img_c1;
    imgR(:, :, 2) = img_c2;
    imgR(:, :, 3) = img_c3;
    img = ycbcr2rgb(imresize(uint8(imgR), 2));
    clear imgR img_c1 img_c2 img_c3
    
    %% Detecting Chess Mark
    intersection = detectChess(img, false);
    
    if (size(intersection, 1) ~= 9)
        disp(['Skipping sample because (not enough / too much) intersection detected... [happend in sample : ' num2str(sample) ' => ' num2str(size(intersection, 1)) ']']);
%         continue;
    else
        intersections = [intersections; intersection];
        sampleCheck(sample) = 1;
    end
%         figure(sample);
%         pause(0.01); %-- In order to ignore confusion of figures
%         imshow(img);
%         hold on
%         plot(intersection(:, 1), intersection(:, 2), 'yx', 'MarkerSize', 12);
%         for k=1:size(intersection, 1)
%             text(intersection(k, 1), intersection(k, 2), ['\leftarrow' num2str(k)]);
%         end
%         pause(0.01); %-- In order to ignore confusion of figures
%     end
end
clear img intersection sample

%% Initialization
robot = initalRobot();
INTER_REF = [700 -100; 600 -100; 500 -100; 700 0; 600 0; 500 0; 700 +100; 600 +100; 500 +100];

%% Load Joint Data
global testX
dataSet = find(sampleCheck);
z = size(dataSet, 1);
joints = zeros(23, z);
testX = cell(1, z);
for i=1:z
    l = load([name '_' num2str(dataSet(i) - 1) '.joint']);
    joints(:, i) = l(1:23);
    testX{i} = l(24:end);
end

%% Main Part
options.Algorithm = 'levenberg-marquardt';
% options.CheckGradients = false;
% options.Diagnostics = 'off';
% options.Display = 'iter-detailed';
options.FunctionTolerance = 1;
options.MaxIterations = 800;
x0 = zeros(20, 1);
itrF = 0;
e = lsqnonlin(@fitnessFunction, x0, [],[],options);
disp(e);
