function plotST2(input_file)
    
addpath('quaternion_library');
 
%[yaw,pitch,roll] = quat2angle(quaternion);
        origin = [0 0 0];
        ref_vector_x = [1,0,0];
        ref_vector_y = [0,1,0];
        ref_vector_z = [0,0,1];
        
        %quaternion1 = [1,0,0,0]    

figure
    while(1)
        data = csvread(input_file,1);
        [timestamp,accel,gyro,mag]=splitData(data);
        mag = mag.*1000;
        clear data

        % TODO: Calculate quat
        
        AHRS = MadgwickAHRS('SamplePeriod', 1/256, 'Beta', 0.1);
        % AHRS = MahonyAHRS('SamplePeriod', 1/256, 'Kp', 0.5);
%         tic

        quaternion = zeros(1,4);
        
        AHRS.Update(gyro(end,:) * (pi/180), accel(end,:), mag(end,:));	% gyroscope units must be radians
        quaternion(end, :) = AHRS.Quaternion;
%         toc

       
        
        x_r = quatrotate(quaternion, ref_vector_x);
        y_r = quatrotate(quaternion, ref_vector_y);
        z_r = quatrotate(quaternion, ref_vector_z);
        
        %final_vector = x_r + y_r + z_r;
        
        %x = cos(yaw).*cos(pitch);
        %y = sin(yaw).*cos(pitch);
        %z = sin(pitch);
        %vect=[x_r,y_r,z_r];
        
        
        line_x = [origin;x_r(end,:)];
        line_y = [origin;y_r(end,:)];
        line_z = [origin;z_r(end,:)];
        
        view(3)
        
        hold on
        plot3(line_x(:,1),line_x(:,2),line_x(:,3))
        pause(.0001)
        plot3(line_y(:,1),line_y(:,2),line_y(:,3))
        pause(.0001)
        plot3(line_z(:,1),line_z(:,2),line_z(:,3))
        pause(.0001)
        hold off
        pause(1)
        clf;
        
        
      axis([-1 1 -1 1 -1 1])
        grid on
        
        
 
end
