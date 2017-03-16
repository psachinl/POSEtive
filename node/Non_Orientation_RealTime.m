function Orientation_RealTime(input_file)
%-------------------------------------------------------------------------%
addpath('ximu_matlab_library');	    % include x-IMU MATLAB library
addpath('quaternion_library');	    % include quatenrion library
%-------------------------------------------------------------------------%
% Variable Initializations
samplePeriod = 1/256;               %Sample Period
origin = [0,0,0];                   % Origin
R = zeros(3,3); E = zeros(3,3,1);   % Rotation and Angles Matrix 
%-------------------------------------------------------------------------%
% Real Time Implementation
fig1 = figure
while(1)
    data = csvread(input_file,1); % File Reading   
    [~,idx]=unique(data,'rows','first');out=data(idx,:); % Filter Duplicates
    [time,acc,mag,gyr]=splitData(data);     % Split Data 
    clear csv_data
    %---------------------------------------------------------------------%
    % Process Data through AHRS Algorithm (Calculate Orientation)
    ahrs = MahonyAHRS('SamplePeriod', samplePeriod, 'Kp', 1);
%   ahrs = MadgwickAHRS('SamplePeriod', samplePeriod, 'Beta', 0.1);
    %Update AHRS and ensure Gyroscope Units are in Radians
    ahrs.UpdateIMU(gyr(end,:) * (pi/180), acc(end,:));	
    % Transpose because AHRS provides Earth relative to sensor
    R(:,:) = quatern2rotMat(ahrs.Quaternion)';
    E = rotm2eul(R);
    dlmwrite ('outputData.csv', E, '-append');
    %---------------------------------------------------------------------%
    % Figure for Visualizing Orientation
    ux = R(1,1,end); vx = R(2,1,end); wx = R(3,1,end);
    uy = R(1,2,end); vy = R(2,2,end); wy = R(3,2,end);
    uz = R(1,3,end); vz = R(2,3,end); wz = R(3,3,end);    
    X = [origin; [ux,vx,wx]]; 
    Y = [origin; [uy,vy,wy]]; 
    Z = [origin; [uz,vz,wz]];        
    view(3); grid on; axis([-1,1,-1,1,-1,1]); pause(0.0001);
    plot3(X(:,1),X(:,2),X(:,3),Y(:,1),Y(:,2),Y(:,3),Z(:,1),Z(:,2),Z(:,3));
end
%% End of script

