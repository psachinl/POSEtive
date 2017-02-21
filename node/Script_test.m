%% Housekeeping
 
addpath('ximu_matlab_library');	% include x-IMU MATLAB library
addpath('quaternion_library');	% include quatenrion library
close all;                     	% close all figures
clear;                         	% clear all variables
clc;                          	% clear the command terminal
 
%% Import data

xIMUdata = xIMUdataClass('LoggedData/LoggedData');

samplePeriod = 1/256;

% gyr = [xIMUdata.CalInertialAndMagneticData.Gyroscope.X...
%        xIMUdata.CalInertialAndMagneticData.Gyroscope.Y...
%        xIMUdata.CalInertialAndMagneticData.Gyroscope.Z];        % gyroscope
% acc = [xIMUdata.CalInertialAndMagneticData.Accelerometer.X...
%        xIMUdata.CalInertialAndMagneticData.Accelerometer.Y...
%        xIMUdata.CalInertialAndMagneticData.Accelerometer.Z];	% accelerometer

data = csvread('All3Axis.csv',1);
acc = data(1:end,2:4);
gyr = data(1:end,8:10);
  
% Plot
figure;
hold on;
plot(gyr(:,1), 'r');
plot(gyr(:,2), 'g');
plot(gyr(:,3), 'b');
xlabel('sample');
ylabel('dps');
title('Gyroscope');
legend('X', 'Y', 'Z');

figure;
hold on;
plot(acc(:,1), 'r');
plot(acc(:,2), 'g');
plot(acc(:,3), 'b');
xlabel('sample');
ylabel('g');
title('Accelerometer');
legend('X', 'Y', 'Z');

%% Process data through AHRS algorithm (calcualte orientation)
% See: http://www.x-io.co.uk/open-source-imu-and-ahrs-algorithms/

R = zeros(3,3,length(gyr));     % rotation matrix describing sensor relative to Earth

ahrs = MahonyAHRS('SamplePeriod', samplePeriod, 'Kp', 1);

for i = 1:length(gyr)
    ahrs.UpdateIMU(gyr(i,:) * (pi/180), acc(i,:));	% gyroscope units must be radians
    R(:,:,i) = quatern2rotMat(ahrs.Quaternion)';    % transpose because ahrs provides Earth relative to sensor
end

%% Calculate 'tilt-compensated' accelerometer

tcAcc = zeros(size(acc));  % accelerometer in Earth frame

for i = 1:length(acc)
    tcAcc(i,:) = R(:,:,i) * acc(i,:)';
end

% Plot
figure;
hold on;
plot(tcAcc(:,1), 'r');
plot(tcAcc(:,2), 'g');
plot(tcAcc(:,3), 'b');
xlabel('sample');
ylabel('g');
title('''Tilt-compensated'' accelerometer');
legend('X', 'Y', 'Z');

%% Calculate linear acceleration in Earth frame (subtracting gravity)

%acc = quaternRotate(acc, quaternConj(quat));


linAcc = tcAcc - [zeros(length(tcAcc), 1), zeros(length(tcAcc), 1), ones(length(tcAcc), 1)];
linAcc = linAcc * 9.81;     % convert from 'g' to m/s/s

% Plot
figure;
hold on;
plot(linAcc(:,1), 'r');
plot(linAcc(:,2), 'g');
plot(linAcc(:,3), 'b');
xlabel('sample');
ylabel('g');
title('Linear acceleration');
legend('X', 'Y', 'Z');

%% Calculate linear velocity (integrate acceleartion)

linVel = zeros(size(linAcc));

for i = 2:length(linAcc)
    linVel(i,:) = linVel(i-1,:) + linAcc(i,:) * samplePeriod;
end

% Plot
figure;
hold on;
plot(linVel(:,1), 'r');
plot(linVel(:,2), 'g');
plot(linVel(:,3), 'b');
xlabel('sample');
ylabel('g');
title('Linear velocity');
legend('X', 'Y', 'Z');

%% High-pass filter linear velocity to remove drift

order = 1;
filtCutOff = 0.1;
[b, a] = butter(order, (2*filtCutOff)/(1/samplePeriod), 'high');
linVelHP = filtfilt(b, a, linVel);

% Plot
figure;
hold on;
plot(linVelHP(:,1), 'r');
plot(linVelHP(:,2), 'g');
plot(linVelHP(:,3), 'b');
xlabel('sample');
ylabel('g');
title('High-pass filtered linear velocity');
legend('X', 'Y', 'Z');

%% Calculate linear position (integrate velocity)

linPos = zeros(size(linVelHP));

for i = 2:length(linVelHP)
    linPos(i,:) = linPos(i-1,:) + linVelHP(i,:) * samplePeriod;
end

% Plot
figure;
hold on;
plot(linPos(:,1), 'r');
plot(linPos(:,2), 'g');
plot(linPos(:,3), 'b');
xlabel('sample');
ylabel('g');
title('Linear position');
legend('X', 'Y', 'Z');

%% High-pass filter linear position to remove drift

order = 1;
filtCutOff = 0.1;
[b, a] = butter(order, (2*filtCutOff)/(1/samplePeriod), 'high');
linPosHP = filtfilt(b, a, linPos);

% Plot
figure;
hold on;
plot(linPosHP(:,1), 'r');
plot(linPosHP(:,2), 'g');
plot(linPosHP(:,3), 'b');
xlabel('sample');
ylabel('g');
title('High-pass filtered linear position');
legend('X', 'Y', 'Z');

%% Play animation

SamplePlotFreq = 8;

SixDOFanimation(linPosHP, R, ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'Off', ...
                'Position', [9 39 1280 720], ...
                'AxisLength', 0.1, 'ShowArrowHead', false, ...
                'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, 'Title', 'Unfiltered',...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));            
 
%% End of script



angles = rotMat2euler(R); % phi, theta and psi
origin = [0,0,0]; % X, Y and Z

figure;
for i = 1:length(gyr)
        ux = R(1,1,i);
        vx = R(2,1,i);
        wx = R(3,1,i);
        uy = R(1,2,i);
        vy = R(2,2,i);
        wy = R(3,2,i);
        uz = R(1,3,i);
        vz = R(2,3,i);
        wz = R(3,3,i);
%     X_rot_y = [0,cos(angles(i,1)),sin(angles(i,1))];
%     X_rot_z = [0,cos(angles(i,1)+pi/2),sin(angles(i,1)+pi/2)];
%     X_line_y = [origin; [X_rot_y(1,1),X_rot_y(1,2),X_rot_y(1,3)]];
%     X_line_z = [origin; [X_rot_z(1,1),X_rot_z(1,2),X_rot_z(1,3)]];
%     
%     Y_rot_x = [cos(angles(i,2)),0,sin(angles(i,2))];
%     Y_rot_z = [cos(angles(i,2)+pi/2),0,sin(angles(i,2)+pi/2)];
%     Y_line_x = [origin; [Y_rot_x(1,1),Y_rot_x(1,2),Y_rot_x(1,3)]];
%     Y_line_z = [origin; [Y_rot_z(1,1),Y_rot_z(1,2),Y_rot_z(1,3)]];
%     
%     Z_rot_y = [sin(angles(i,3)),cos(angles(i,3)),0];
%     Z_rot_x = [sin(angles(i,3)+pi/2),cos(angles(i,3)+pi/2), 0];
%     Z_line_y = [origin; [Z_rot_y(1,1),Z_rot_y(1,2),Z_rot_y(1,3)]];
%     Z_line_x = [origin; [Z_rot_x(1,1),Z_rot_x(1,2),Z_rot_x(1,3)]];
%     
%     X = Z_line_x + Y_line_x;
%     Y = X_line_y + Z_line_y;
%     Z = X_line_z + Y_line_z;
    
    X = [origin; [ux,vx,wx]];
    Y = [origin; [uy,vy,wy]];
    Z = [origin; [uz,vz,wz]];
%     Z = [origin; [sin(angles(i,2)),(angles(i,1)),cos(angles(i,2))]];
    xxx(i) = dot(Z(2,:),X(2,:)) + dot(Y(2,:),X(2,:));
    yyy(i) = dot(Z(2,:),Y(2,:)) + dot(Y(2,:),X(2,:));
    zzz(i) = dot(Z(2,:),X(2,:)) + dot(Y(2,:),Z(2,:));

    view(3);
    %hold on;
    plot3(X(:,1),X(:,2),X(:,3),Y(:,1),Y(:,2),Y(:,3),Z(:,1),Z(:,2),Z(:,3));
    %plot3(X_line_z(:,1),X_line_z(:,2),X_line_z(:,3));
    %hold off;
    grid on;
    axis([-1,1,-1,1,-1,1]);
    pause(0.0001);
end
