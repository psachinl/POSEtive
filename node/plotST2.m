function plotST2(input_file)
    addpath('quaternion_library');
    figure
    while(1)
        data = csvread(input_file,1);
        [timestamp,accel,gyro,mag]=splitData(data);
        clear data

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
        
        AHRS = MadgwickAHRS('SamplePeriod', 1/256, 'Beta', 0.1);
        % AHRS = MahonyAHRS('SamplePeriod', 1/256, 'Kp', 0.5);
%         tic

        quaternion = zeros(1,4);
        
        AHRS.Update(gyro(end,:) * (pi/180), accel(end,:), mag(end,:)./1000);	% gyroscope units must be radians
        quaternion(end, :) = AHRS.Quaternion;
%         toc

        [yaw,pitch,roll] = quat2angle(quaternion);
        x = cos(yaw).*cos(pitch);
        y = sin(yaw).*cos(pitch);
        z = sin(pitch);
        vect=[x,y,z];
        origin = [0 0 0];
        line = [origin;vect(end,:)];
        plot3(line(:,1),line(:,2),line(:,3))
%         axis([-1 1 -1 1 -1 1])
        grid on
        pause(.0001)
        
        % TODO: Plot line
    
    iter = iter + 1;
    end
toc
