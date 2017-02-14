figure
while(1)
    data = csvread('dump2.csv',1);
    [timestamp,accel_x,accel_y,accel_z,mag_x,mag_y,mag_z,gyro_x,gyro_y,gyro_z]=splitData(data);
    clear data

    subplot(3,1,1)
    hold on
    plot(accel_x,'Color',[0    0.4470    0.7410])
    pause(.0001)
    plot(accel_y,'Color',[0.8500    0.3250    0.0980])
    pause(.0001)
    plot(accel_z,'Color',[0.9290    0.6940    0.1250])
    pause(.0001)
    hold off
    grid on
    xlabel('Time (CHECK UNIT)')
    ylabel('Acceleration (g)')
    title('TI SensorTag 2 acceleration')
    legend('X', 'Y', 'Z', 'Location', 'best')

    subplot(3,1,2)
    hold on
    plot(gyro_x,'Color',[0    0.4470    0.7410])
    plot(gyro_y,'Color',[0.8500    0.3250    0.0980])
    plot(gyro_z,'Color',[0.9290    0.6940    0.1250])
    % hold off
    grid on
    xlabel('Time (CHECK UNIT)')
    ylabel('Rotation (CHECK UNIT)')
    title('TI SensorTag 2 Gyroscope reading')
    legend('X', 'Y', 'Z', 'Location', 'best')

    subplot(3,1,3)
    hold on
    plot(mag_x,'Color',[0    0.4470    0.7410])
    plot(mag_y,'Color',[0.8500    0.3250    0.0980])
    plot(mag_z,'Color',[0.9290    0.6940    0.1250])
    % hold off
    grid on
    xlabel('Time (CHECK UNIT)')
    ylabel('Magnetometer reading (CHECK UNIT)')
    title('TI SensorTag 2 Magnetometer reading')
    legend('X', 'Y', 'Z', 'Location', 'best')
end
