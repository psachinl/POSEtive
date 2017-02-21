function [timestamp,accel,mag,gyro] = splitData(data)

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

accel=[accel_x,accel_y,accel_z];
gyro=[gyro_x,gyro_y,gyro_z];
mag=[mag_x,mag_y,mag_z];
