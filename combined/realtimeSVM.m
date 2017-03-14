function realtimeSVM(input_file)

addpath('ximu_matlab_library');	
addpath('quaternion_library');	    
load neural_network.mat 
load svmStruct.mat

% Sample Period
samplePeriod = 1/53;                

% Origin
origin = [0,0,0];                   

% Rotation and Angles Matrix 
R = zeros(3,3);   
E = zeros(1,3);
% Gyroscope Threshold
thresh = 12.5;

% Process Data through AHRS Algorithm (Calculate Orientation)
ahrs = MahonyAHRS('SamplePeriod', samplePeriod, 'Kp', 1);
%   ahrs = MadgwickAHRS('SamplePeriod', samplePeriod, 'Beta', 0.1);

% Neural Net Threshold
net_threshold = 1.5;

%Other Variables
bad_count = 0;

%fig1 = figure

% Overwrite txt file
fid = fopen('outData.txt','w');
fprintf(fid,'Date, Time, Classification\n');
time = string(datestr(now,'dd mmm yyyy, HH:MM:SS'));
old_text_string = strcat(time,',','Initialising','\n');
fprintf(fid, old_text_string);
fclose(fid);

old_classif = 'Initialising';
bad_threshold = 10;
a = 'running'
while(1)
    % File Reading 
    data = csvread(input_file,1); 
    
    % Filter Duplicates
    [~,idx]=unique(data,'rows','first');
    out=data(idx,:);
    
    % Split Data
    [time,acc,mag,gyr]=splitData(out);      

    
    if abs(gyr(end,1)) < thresh
        gyr(end,1) = 0;
    end
    if abs(gyr(end,2)) < thresh
        gyr(end,2) = 0;
    end
    if abs(gyr(end,3)) < thresh
        gyr(end,3) = 0;
    end
    
    clear csv_data
    
    %---------------------------------------------------------------------%
    %Update AHRS and ensure Gyroscope Units are in Radians
    ahrs.UpdateIMU(gyr(end,:) * (pi/180), acc(end,:));	
    
    % Transpose because AHRS provides Earth relative to sensor
    R(:,:) = quatern2rotMat(ahrs.Quaternion)';
    E = rotm2eul(R);
%    dlmwrite ('Adam_back.csv', E, '-append');
    a = E(1,2:3);
    svm_output = svmclassify(svmStruct,a) %label = 'b' or 'g', for bad or good posture
   
    if svm_output == 0
       bad_count = 0;
    else
       bad_count = bad_count + 1;
    end

    if bad_count == bad_threshold
        classif_string = 'Bad';
        bad_count = bad_count - 1;
    elseif bad_count > 0
        classif_string = 'Pending';
    else
        classif_string = 'Good';
    end

%     str=sprintf('User Posture = %s', classif_string);
%     title(str);

    time = string(datestr(now,'dd mmm yyyy, HH:MM:SS'));
    text_string = strcat(time,',',classif_string,'\n');

    if ~strcmp(old_classif,classif_string)
        fid = fopen('outData.txt','a');
        fprintf(fid, text_string);
        fclose(fid);
        old_classif = classif_string;
    end  
     
    %---------------------------------------------------------------------%
    % Figure for Visualizing Orientation
%     ux = R(1,1,end); vx = R(2,1,end); wx = R(3,1,end);
%     uy = R(1,2,end); vy = R(2,2,end); wy = R(3,2,end);
%     uz = R(1,3,end); vz = R(2,3,end); wz = R(3,3,end);    
%    
%     X = [origin; [ux,vx,wx]]; 
%     Y = [origin; [uy,vy,wy]]; 
%     Z = [origin; [uz,vz,wz]];
    
%     view(3); grid on; axis([-1,1,-1,1,-1,1]); pause(0.0001);
%     plot3(X(:,1),X(:,2),X(:,3),Y(:,1),Y(:,2),Y(:,3),Z(:,1),Z(:,2),Z(:,3));
        
    %-------------------%
 end

