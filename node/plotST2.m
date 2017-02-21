function plotST2(input_file)
    
addpath('quaternion_library');

origin = [0 0 0];

ref_vector_x = [1,0,0];
ref_vector_y = [0,1,0];
ref_vector_z = [0,0,1];
 
quaternion = zeros(1,4);
AHRS = MadgwickAHRS('SamplePeriod', 1/256, 'Beta', 0.1);

    
figure
%axis([-1 1 -1 1 -1 1])
grid on
t=1;

while(1)
    
    data = csvread(input_file,1);
    [timestamp,accel,mag,gyro]=splitData(data);
    clear data
    
    % AHRS = MahonyAHRS('SamplePeriod', 1/256, 'Kp', 0.5);
    

    AHRS.Update(gyro(end,:) * (pi/180), accel(end,:), mag(end,:));	% gyroscope units must be radians
    quaternion = AHRS.Quaternion;

    [yaw, pitch, roll] = quat2angle(quaternion);

% Yaw = Z,
% Pitch = Y;
% Roll = X;

hold on
plot(t,yaw,'r*')
pause(.0001)
plot(t,pitch,'b*')
pause(.0001)
plot(t,roll,'g*')
pause(.0001)
hold off
pause(0.1)
%axis([-1 1 -1 1 -1 1])
grid on
    
%     x_r = quatrotate(quaternion, ref_vector_x);
%     y_r = quatrotate(quaternion, ref_vector_y);
%     z_r = quatrotate(quaternion, ref_vector_z);
% 
%     line_x = [origin;x_r(end,:)];
%     line_y = [origin;y_r(end,:)];
%     line_z = [origin;z_r(end,:)];

%     view(3)
%     hold on
%     plot3(line_x(:,1),line_x(:,2),line_x(:,3))
%     pause(.0001)
%     plot3(line_y(:,1),line_y(:,2),line_y(:,3))
%     pause(.0001)
%     plot3(line_z(:,1),line_z(:,2),line_z(:,3))
%     pause(.0001)
%     hold off
%     pause(1)
%     clf;
% 
%     axis([-1 1 -1 1 -1 1])
%     grid on
t=t+1;
    
end
