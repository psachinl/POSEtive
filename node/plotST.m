function plotST(input_file)
addpath('quaternion_library');
    

t = 1;
samplePeriod = 1/256;

%       origin = [0 0 0];
%       ref_vector_x = [1,0,0];
%      ref_vector_y = [0,1,0];
%     ref_vector_z = [0,0,1];

figure
    
while(1)
        data = csvread(input_file,1);
        [timestamp,accel,gyro,mag]=splitData(data);
        clear data

%-------------------------------------------------------------------------%        
%Accel and Gyro Work straight from sensor      
        
% subplot(1,2,1)
% hold on;
% plot(gyro(:,1), 'r');
% pause(.0001)
% plot(gyro(:,2), 'g');
% pause(.0001)
% plot(gyro(:,3), 'b');
% pause(.0001)
% xlabel('sample');
% ylabel('dps');
% title('Gyroscope');
% legend('X', 'Y', 'Z');
% grid on;
% 
% subplot(1,2,2)
% hold on;
% plot(accel(:,1), 'r');
% pause(.0001)
% plot(accel(:,2), 'g');
% pause(.0001)
% plot(accel(:,3), 'b');
% pause(.0001)
% xlabel('sample');
% ylabel('g');
% title('Accelerometer');
% legend('X', 'Y', 'Z');
% pause(0.5)

%-------------------------------------------------------------------------%
% Process data through AHRS algorithm (calculate orientation)
% See: http://www.x-io.co.uk/open-source-imu-and-ahrs-algorithms/

 R = zeros(3,3,1);     % rotation matrix describing sensor relative to Earth
%R = zeros(3,3,length(gyro)); 
 ahrs = MahonyAHRS('SamplePeriod', samplePeriod, 'Kp', 1);

%for i = 1:length(gyro)
    ahrs.UpdateIMU(gyro(end,:) * (pi/180), accel(end,:));	% gyroscope units must be radians
    R(:,:,end) = quatern2rotMat(ahrs.Quaternion)';    % transpose because ahrs provides Earth relative to sensor
%end

% Calculate 'tilt-compensated' accelerometer

tcAcc = zeros(size(accel));  % accelerometer in Earth frame
% tcAcc = zeros(size(accel));  % accelerometer in Earth frame

%for i = 1:length(accel)
    tcAcc(end,:) = R(:,:,end) * accel(end,:)';
%end

% Plot
hold on;
plot(tcAcc(:,1), 'r');
%pause(.0001)
plot(tcAcc(:,2), 'g');
%pause(.0001)
plot(tcAcc(:,3), 'b');
%pause(.0001)
xlabel('sample');
ylabel('g');
title('''Tilt-compensated'' accelerometer');
legend('X', 'Y', 'Z');
pause(0.5)

%-------------------------------------------------------------------------%
% Calculate linear acceleration in Earth frame (subtracting gravity)

linAcc = tcAcc - [zeros(length(tcAcc), 1), zeros(length(tcAcc), 1), ones(length(tcAcc), 1)];
linAcc = linAcc * 9.81;     % convert from 'g' to m/s/s

% Plot
% hold on;
% plot(linAcc(:,1), 'r');
% pause(.0001)
% plot(linAcc(:,2), 'g');
% pause(.0001)
% plot(linAcc(:,3), 'b');
% pause(.0001)
% xlabel('sample');
% ylabel('g');
% title('Linear acceleration');
% legend('X', 'Y', 'Z');
% pause(0.5)

%-------------------------------------------------------------------------%
% Calculate linear velocity (integrate acceleartion)

linVel = zeros(size(linAcc));

for i = 2:length(linAcc)
    linVel(i,:) = linVel(i-1,:) + linAcc(i,:) * samplePeriod;
end

% Plot
% hold on;
% plot(linVel(:,1), 'r');
% plot(linVel(:,2), 'g');
% plot(linVel(:,3), 'b');
% xlabel('sample');
% ylabel('g');
% title('Linear velocity');
% legend('X', 'Y', 'Z');
% pause(0.5)

%-------------------------------------------------------------------------%
% High-pass filter linear velocity to remove drift

order = 1;
filtCutOff = 0.1;
[b, a] = butter(order, (2*filtCutOff)/(1/samplePeriod), 'high');
linVelHP = filtfilt(b, a, linVel);

% Plot
% hold on;
% plot(linVelHP(:,1), 'r');
% plot(linVelHP(:,2), 'g');
% plot(linVelHP(:,3), 'b');
% xlabel('sample');
% ylabel('g');
% title('High-pass filtered linear velocity');
% legend('X', 'Y', 'Z');
% pause(0.5)

%-------------------------------------------------------------------------%
% Calculate linear position (integrate velocity)

linPos = zeros(size(linVelHP));

for i = 2:length(linVelHP)
    linPos(i,:) = linPos(i-1,:) + linVelHP(i,:) * samplePeriod;
end

% Plot
% hold on;
% plot(linPos(:,1), 'r');
% plot(linPos(:,2), 'g');
% plot(linPos(:,3), 'b');
% xlabel('sample');
% ylabel('g');
% title('Linear position');
% legend('X', 'Y', 'Z');
% pause(0.5)

%-------------------------------------------------------------------------%
% High-pass filter linear position to remove drift

order = 1;
filtCutOff = 0.1;
[b, a] = butter(order, (2*filtCutOff)/(1/samplePeriod), 'high');
linPosHP = filtfilt(b, a, linPos);

% Plot
% hold on;
% plot(linPosHP(:,1), 'r');
% plot(linPosHP(:,2), 'g');
% plot(linPosHP(:,3), 'b');
% xlabel('sample');
% ylabel('g');
% title('High-pass filtered linear position');
% legend('X', 'Y', 'Z');
% pause(0.5)

%-------------------------------------------------------------------------%
% Play animation

% SamplePlotFreq = 8;
% 
% SixDOFanimation(linPosHP, R, ...
%                 'SamplePlotFreq', SamplePlotFreq, 'Trail', 'Off', ...
%                 'Position', [9 39 1280 720], ...
%                 'AxisLength', 0.1, 'ShowArrowHead', false, ...
%                 'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, 'Title', 'Unfiltered',...
%                 'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));            
%  


%-------------------------------------------------------------------------%

%         subplot(3,1,1)
%         hold on
%         plot(accel(:,1),'Color',[0    0.4470    0.7410])
%         pause(.0001)
%         plot(accel(:,2),'Color',[0.8500    0.3250    0.0980])
%         pause(.0001)
%         plot(accel(:,3),'Color',[0.9290    0.6940    0.1250])
%         pause(.0001)
%         hold off
%         grid on
%         xlabel('Time (CHECK UNIT)')
%         ylabel('Acceleration (g)')
%         title('TI SensorTag 2 acceleration')
%         legend('X', 'Y', 'Z', 'Location', 'best')

%         subplot(3,1,2)
%         hold on
%         plot(gyro_x,'Color',[0    0.4470    0.7410])
%         plot(gyro_y,'Color',[0.8500    0.3250    0.0980])
%         plot(gyro_z,'Color',[0.9290    0.6940    0.1250])
%         % hold off
%         grid on
%         xlabel('Time (CHECK UNIT)')
%         ylabel('Rotation (CHECK UNIT)')
%         title('TI SensorTag 2 Gyroscope reading')
%         legend('X', 'Y', 'Z', 'Location', 'best')
% 
%         subplot(3,1,3)
%         hold on
%         plot(mag_x,'Color',[0    0.4470    0.7410])
%         plot(mag_y,'Color',[0.8500    0.3250    0.0980])
%         plot(mag_z,'Color',[0.9290    0.6940    0.1250])
%         % hold off
%         grid on
%         xlabel('Time (CHECK UNIT)')
%         ylabel('Magnetometer reading (CHECK UNIT)')
%         title('TI SensorTag 2 Magnetometer reading')
%         legend('X', 'Y', 'Z', 'Location', 'best')
        
        % TODO: Calculate quat
%         
%         AHRS = MadgwickAHRS('SamplePeriod', 1/256, 'Beta', 0.1);
%         % AHRS = MahonyAHRS('SamplePeriod', 1/256, 'Kp', 0.5);
% %         tic
% 
%         quaternion = zeros(1,4);
%         
%         AHRS.Update(gyro(end,:) * (pi/180), accel(end,:), mag(end,:));	% gyroscope units must be radians
%         quaternion(end, :) = AHRS.Quaternion;
% %         toc
% 
% 
% euler = quatern2euler(quaternConj(quaternion)) %* (180/pi);	% use conjugate for sensor frame relative to Earth and convert to degrees.

%     Point1 = [cos(euler(end,1)), sin(euler(end,1)),0];
% 
%     line_x = [origin;Point1];
% %     line_y = [origin;y_r(end,:)];
% %     line_z = [origin;z_r(end,:)];
% 
%     view(3)
%     hold on
%     plot3(line_x(:,1),line_x(:,2),line_x(:,3))
%     pause(.0001)
% %     plot3(line_y(:,1),line_y(:,2),line_y(:,3))
% %     pause(.0001)
% %     plot3(line_z(:,1),line_z(:,2),line_z(:,3))
% %     pause(.0001)
%     hold off
%     pause(1)
%     clf;


% hold on;
% plot(t, euler(:,1), 'r*');
% pause(.0001)
% plot(t, euler(:,2), 'g*');
% pause(.0001)
% plot(t, euler(:,3), 'b*');
% pause(.0001)
% title('Euler angles');
% xlabel('Time (s)');
% ylabel('Angle (deg)');
% legend('\phi', '\theta', '\psi');
% hold off;


%         x = cos(yaw).*cos(pitch);
%         y = sin(yaw).*cos(pitch);
%         z = sin(pitch);
%         vect=[x,y,z];
%         origin = [0 0 0];
%         line = [origin;vect(end,:)];
%         plot3(line(:,1),line(:,2),line(:,3))
% %         axis([-1 1 -1 1 -1 1])
%         grid on
%         pause(.0001)
        
        % TODO: Plot line
    
    %axis([-1 1 -1 1 -1 1])
    grid on;
    t = t+1;
end

