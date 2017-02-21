function plotST(input_file)

%-------------------------------------------------------------------------%
% Housekeeping

addpath('ximu_matlab_library');	% include x-IMU MATLAB library
addpath('quaternion_library');	% include quatenrion library
% close all;                     	% close all figures
% clear;                         	% clear all variables
% clc;                          	% clear the command terminal
    
%-------------------------------------------------------------------------%
% Key Initializations

t = 1;
samplePeriod = 1/256;

%origin = [0 0 0];
%ref_vector_x = [1,0,0];
%ref_vector_y = [0,1,0];
%ref_vector_z = [0,0,1];

quaternion = zeros(1,4);
AHRS = MadgwickAHRS('SamplePeriod', samplePeriod, 'Beta', 0.1);
% AHRS = MahonyAHRS('SamplePeriod', samplePeriod, 'Kp', 0.5);

figure

while(1)
        data = csvread(input_file,1);
        [timestamp,accel,gyro,mag]=splitData(data);
        clear data

        AHRS.Update(gyro(end,:)* (pi/180), accel(end,:), mag(end,:));	
        quaternion = AHRS.Quaternion;

        [yaw,pitch,roll] = quat2angle(quaternion);
        x = cos(yaw).*cos(pitch);
        y = sin(yaw).*cos(pitch);
        z = sin(pitch);
        
        
        euler =quatern2euler(quaternConj(quaternion)) * (180/pi);	% use conjugate for sensor frame relative to Earth and convert to degrees.

%-------------------------------------------------------------------------%        
%Accel and Gyro Work straight from sensor      
        
subplot(2,3,1)
hold on;
plot(gyro(:,1), 'r');
pause(.0001)
plot(gyro(:,2), 'g');
pause(.0001)
plot(gyro(:,3), 'b');
pause(.0001)
xlabel('sample');
ylabel('dps');
title('Gyroscope');
legend('X', 'Y', 'Z');
hold off;
grid on;

subplot(2,3,2)
hold on;
plot(accel(:,1), 'r');
pause(.0001)
plot(accel(:,2), 'g');
pause(.0001)
plot(accel(:,3), 'b');
pause(.0001)
xlabel('sample');
ylabel('g');
title('Accelerometer');
legend('X', 'Y', 'Z');
hold off
grid on;

subplot(1,3,3)
hold on;
plot(t, euler(:,1), 'r*');
plot(t, euler(:,2), 'g*');
plot(t, euler(:,3), 'b*');
title('Euler angles');
xlabel('Time (s)');
ylabel('Angle (deg)');
legend('\phi', '\theta', '\psi');
hold off;

t=t+1;
%-------------------------------------------------------------------------%
end


