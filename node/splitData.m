function [timestamp,accel_x,accel_y,accel_z,mag_x,mag_y,mag_z,gyro_x,gyro_y,gyro_z] = splitData(data)

timestamp = data(:,1);
accel_x = data(:,2);
accel_y = data(:,3);
accel_z = data(:,4);
mag_x = data(:,5);
mag_y = data(:,6);
mag_z = data(:,7);
gyro_x = data(:,8);
gyro_y = data(:,9);
gyro_z = data(:,10);
