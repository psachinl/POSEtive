function Prahnav_Orientation_RealTime(input_file)
%-------------------------------------------------------------------------%
% Housekeeping
addpath('ximu_matlab_library');	% include x-IMU MATLAB library
addpath('quaternion_library');	% include quatenrion library
% close all;                     	% close all figures
% clear;                         	% clear all variables
% clc; 

% Sensor Axis
% Top flat = +z, Short side power = +y, long side = +x;

%-------------------------------------------------------------------------%
% Variable Initializations

%Sample Period
samplePeriod = 1/64;

% Rotation Matrix describing Sensor Relative to Earth
R = zeros(3,3,1);     

% Tilt Compensated Acceleration
tcAcc = zeros(1,3);  % accelerometer in Earth frame

% Linear Velocity
linVel = zeros(1,3);

% Linear Position
linPos = zeros(1,3);  
    

% High-pass filter linear velocity to remove drift
order_V = 1;
filtCutOff_V = 0.1; %0.1
[b_V, a_V] = butter(order_V, (2*filtCutOff_V)/(1/samplePeriod), 'high');

% High-pass filter linear position to remove drift
order_P = 1;
filtCutOff_P = 0.1; %0.1
[b_P, a_P] = butter(order_P, (2*filtCutOff_P)/(1/samplePeriod), 'high');

% Initialize AHRS
ahrs = MahonyAHRS('SamplePeriod', samplePeriod, 'Kp', 1);
%   ahrs = MadgwickAHRS('SamplePeriod', samplePeriod, 'Beta', 0.1);

%-------------------------------------------------------------------------%
% Real Time Implementation
fig1 = figure
while(1)

    % File Reading
    data = csvread(input_file,1);
    
    % Filter Duplicates
    [~,idx]=unique(data,'rows','first');
    out=data(idx,:);
    
    % Split File Data into Accelerometer, Gyroscope and Magnetometer
    [time,acc,gyr,mag]=splitData(out);
    clear csv_data
   
    
    % Core Processing
    %---------------------------------------------------------------------%
    % Process Data through AHRS Algorithm (Calculate Orientation)

    %Update AHRS and ensure Gyroscope Units are in Radians
    ahrs.UpdateIMU(gyr(end,:) * (pi/180), acc(end,:));	
    
    % Transpose because AHRS provides Earth relative to sensor
    R = quatern2rotMat(ahrs.Quaternion)';    
    
    % Calculate 'tilt-compensated' accelerometer
    tcAcc = R * acc(end,:)';
    
    % Calculate linear acceleration in Earth frame (subtracting gravity)
    linAcc = tcAcc - [0,0,1];
    
    % Convert from 'g' to m/s/s
    linAcc = linAcc * 9.81;     
    
    % Calculate Linear Velocity (Integrate Acceleartion
    linVel = linVel + linAcc * samplePeriod;

    % High Pass Filter Linear Velocity
%     linVelHP = filtfilt(b_V, a_V, linVel);
     
    % Calculate Linear Position (Integrate Velocity)
    linPos = linPos + linVel * samplePeriod;
    
    % High Pass Filter Linear Position
%   linPosHP = filtfilt(b_P, a_P, linPos);
    
    % Figures for Result
    %---------------------------------------------------------------------%
    % Plot Gyroscope
    % figure;
    % hold on;
    % plot(gyr(:,1), 'r');
    % plot(gyr(:,2), 'g');
    % plot(gyr(:,3), 'b');
    % xlabel('sample');
    % ylabel('dps');
    % title('Gyroscope');
    % legend('X', 'Y', 'Z');
     
    % Plot Acceleration
    % figure;
    % hold on;
    % plot(acc(:,1), 'r');
    % plot(acc(:,2), 'g');
    % plot(acc(:,3), 'b');
    % xlabel('sample');
    % ylabel('g');
    % title('Accelerometer');
    % legend('X', 'Y', 'Z');
    
    % Plot Tilt Compensated Accelerometer
    % figure;
    % hold on;
    % plot(tcAcc(:,1), 'r');
    % plot(tcAcc(:,2), 'g');
    % plot(tcAcc(:,3), 'b');
    % xlabel('sample');
    % ylabel('g');
    % title('''Tilt-compensated'' accelerometer');
    % legend('X', 'Y', 'Z');
    
    % Plot Linear Acceleration
    % figure;
    % hold on;
    % plot(linAcc(:,1), 'r');
    % plot(linAcc(:,2), 'g');
    % plot(linAcc(:,3), 'b');
    % xlabel('sample');
    % ylabel('g');
    % title('Linear acceleration');
    % legend('X', 'Y', 'Z');
    
    % Plot Linear Velocity
    % figure;
    % hold on;
    % plot(linVel(:,1), 'r');
    % plot(linVel(:,2), 'g');
    % plot(linVel(:,3), 'b');
    % xlabel('sample');
    % ylabel('g');
    % title('Linear velocity');
    % legend('X', 'Y', 'Z');
    
    % Plot High Pass Filtered Linear Velocity
    % figure;
    % hold on;
    % plot(linVelHP(:,1), 'r');
    % plot(linVelHP(:,2), 'g');
    % plot(linVelHP(:,3), 'b');
    % xlabel('sample');
    % ylabel('g');
    % title('High-pass filtered linear velocity');
    % legend('X', 'Y', 'Z');
    
    % Plot Linear Position
    % figure;
    % hold on;
    % plot(linPos(:,1), 'r');
    % plot(linPos(:,2), 'g');
    % plot(linPos(:,3), 'b');
    % xlabel('sample');
    % ylabel('g');
    % title('Linear position');
    % legend('X', 'Y', 'Z');
    
    % Plot High Pass Filtered Linear Position
    % figure;
    % hold on;
    % plot(linPosHP(:,1), 'r');
    % plot(linPosHP(:,2), 'g');
    % plot(linPosHP(:,3), 'b');
    % xlabel('sample');
    % ylabel('g');
    % title('High-pass filtered linear position');
    % legend('X', 'Y', 'Z');
    
    % Play animation

    ModSixDOFanimation(linPos, R, 'Figure', fig1);
    clf(fig1)
%   ModSixDOFanimation(linPosHP,...
%                     R, ...
%                     'SamplePlotFreq', 1,...
%                     'Trail', 'Off', ...
%                     'LimitRatio',1, ...
%                     'Position', [9 39 1280 720], ...
%                     'AxisLength', 1,...
%                     'ShowArrowHead', 'on', ...
%                     'Xlabel', 'X (m)',...
%                     'Ylabel', 'Y (m)',...
%                     'Zlabel', 'Z (m)',...
%                     'ShowLegend', 'true',...
%                     'Title', 'Unfiltered',...
%                     'CreateAVI', false,...
%                     'AVIfileNameEnum', false,...
%                     'AVIfps', ((1/samplePeriod) / SamplePlotFreq));  
end

%% End of script