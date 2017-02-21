function fig = ModSixDOFanimation(varargin)

    %% Create local variables

    % Required arguments
    p = varargin{1};                % position of body
    R = varargin{2};                % rotation matrix of body
    [numSamples dummy] = size(p);

    % Default values of optional arguments
    SamplePlotFreq = 1;
    Trail = 'Off';
    LimitRatio = 1;
    Position = [];
    FullScreen = false;
    View = [30 20];
    AxisLength = 1;
    ShowArrowHead = 'on';
    Xlabel = 'X';
    Ylabel = 'Y';
    Zlabel = 'Z';
    Title = '6DOF Animation';
    ShowLegend = true;
    CreateAVI = false;
    AVIfileName = '6DOF Animation';
    AVIfileNameEnum = true;
    AVIfps = 30;

    for i = 3:2:nargin
        if  strcmp(varargin{i}, 'SamplePlotFreq'), SamplePlotFreq = varargin{i+1};
        elseif  strcmp(varargin{i}, 'Trail')
            Trail = varargin{i+1};
            if(~strcmp(Trail, 'Off') && ~strcmp(Trail, 'DotsOnly') && ~strcmp(Trail, 'All'))
                error('Invalid argument.  Trail must be ''Off'', ''DotsOnly'' or ''All''.');
            end
        elseif  strcmp(varargin{i}, 'LimitRatio'), LimitRatio = varargin{i+1};
        elseif  strcmp(varargin{i}, 'Position'), Position = varargin{i+1};
        elseif  strcmp(varargin{i}, 'FullScreen'), FullScreen = varargin{i+1};
        elseif  strcmp(varargin{i}, 'View'), View = varargin{i+1};
        elseif  strcmp(varargin{i}, 'AxisLength'), AxisLength = varargin{i+1};
        elseif  strcmp(varargin{i}, 'ShowArrowHead'), ShowArrowHead = varargin{i+1};
        elseif  strcmp(varargin{i}, 'Xlabel'), Xlabel = varargin{i+1};
        elseif  strcmp(varargin{i}, 'Ylabel'), Ylabel = varargin{i+1};
        elseif  strcmp(varargin{i}, 'Zlabel'), Zlabel = varargin{i+1};
        elseif  strcmp(varargin{i}, 'Title'), Title = varargin{i+1};
        elseif  strcmp(varargin{i}, 'ShowLegend'), ShowLegend = varargin{i+1};
        elseif  strcmp(varargin{i}, 'CreateAVI'), CreateAVI = varargin{i+1};
        elseif  strcmp(varargin{i}, 'AVIfileName'), AVIfileName = varargin{i+1};
        elseif  strcmp(varargin{i}, 'AVIfileNameEnum'), AVIfileNameEnum = varargin{i+1};
        elseif  strcmp(varargin{i}, 'AVIfps'), AVIfps = varargin{i+1};
        elseif  strcmp(varargin{i}, 'Figure'), fig = varargin{i+1};
        else error('Invalid argument.');
        end
    end;

    %% Reduce data to samples to plot only

%      p = p(1:SamplePlotFreq:numSamples, :);
%      R = R(:, :, 1:SamplePlotFreq:numSamples) * AxisLength;
%      if(numel(View) > 2)
%         View = View(1:SamplePlotFreq:numSamples, :);
%      end
     [numPlotSamples dummy] = size(p);

    %% Setup AVI file

    aviobj = [];                                                            	% create null object
    if(CreateAVI)
        fileName = strcat(AVIfileName, '.avi');
        if(exist(fileName, 'file'))
            if(AVIfileNameEnum)                                              	% if file name exists and enum enabled
                i = 0;
                while(exist(fileName, 'file'))                                  % find un-used file name by appending enum
                    fileName = strcat(AVIfileName, sprintf('%i', i), '.avi');
                    i = i + 1;
                end
            else                                                                % else file name exists and enum disabled
                fileName = [];                                                  % file will not be created
            end
        end
        if(isempty(fileName))
            sprintf('AVI file not created as file already exists.')
        else
            aviobj = avifile(fileName, 'fps', AVIfps, 'compression', 'Cinepak', 'quality', 100);
        end
    end

    %% Setup figure and plot

    % Create figure
%     fig = figure;
    if(FullScreen)
        screenSize = get(0, 'ScreenSize');
        set(fig, 'Position', [0 0 screenSize(3) screenSize(4)]);
    elseif(~isempty(Position))
        set(fig, 'Position', Position);
    end
    set(gca, 'drawmode', 'fast');
    lighting phong;
    set(gcf, 'Renderer', 'zbuffer');
    hold on;
    axis equal;
    grid on;
    view(View(1, 1), View(1, 2));
    title(i);
    xlabel(Xlabel);
    ylabel(Ylabel);
    zlabel(Zlabel);

    % Create plot data arrays
    if(strcmp(Trail, 'DotsOnly') || strcmp(Trail, 'All'))
        x = zeros(numPlotSamples, 1);
        y = zeros(numPlotSamples, 1);
        z = zeros(numPlotSamples, 1);
    end
    if(strcmp(Trail, 'All'))
        ox = zeros(numPlotSamples, 1);
        oy = zeros(numPlotSamples, 1);
        oz = zeros(numPlotSamples, 1);
        ux = zeros(numPlotSamples, 1);
        vx = zeros(numPlotSamples, 1);
        wx = zeros(numPlotSamples, 1);
        uy = zeros(numPlotSamples, 1);
        vy = zeros(numPlotSamples, 1);
        wy = zeros(numPlotSamples, 1);
        uz = zeros(numPlotSamples, 1);
        vz = zeros(numPlotSamples, 1);
        wz = zeros(numPlotSamples, 1);
    end
    x(1) = p(1,1);
    y(1) = p(1,2);
    z(1) = p(1,3);
    ox(1) = x(1);
    oy(1) = y(1);
    oz(1) = z(1);
    ux(1) = R(1,1,1:1);
    vx(1) = R(2,1,1:1);
    wx(1) = R(3,1,1:1);
    uy(1) = R(1,2,1:1);
    vy(1) = R(2,2,1:1);
    wy(1) = R(3,2,1:1);
    uz(1) = R(1,3,1:1);
    vz(1) = R(2,3,1:1);
    wz(1) = R(3,3,1:1);

    % Create graphics handles
    orgHandle = plot3(x, y, z, 'k.');
    if(ShowArrowHead)
        ShowArrowHeadStr = 'on';
    else
        ShowArrowHeadStr = 'off';
    end
    quivXhandle = quiver3(ox, oy, oz, ux, vx, wx,  'r', 'ShowArrowHead', ShowArrowHeadStr, 'MaxHeadSize', 0.999999, 'AutoScale', 'off');
    quivYhandle = quiver3(ox, oy, oz, uy, vy, wy,  'g', 'ShowArrowHead', ShowArrowHeadStr, 'MaxHeadSize', 0.999999, 'AutoScale', 'off');
    quivZhandle = quiver3(ox, ox, oz, uz, vz, wz,  'b', 'ShowArrowHead', ShowArrowHeadStr, 'MaxHeadSize', 0.999999, 'AutoScale', 'off');

    % Create legend
    if(ShowLegend)
        legend('Origin', 'X', 'Y', 'Z');
    end
    
    % Set initial limits
    Xlim = [x(1)-AxisLength x(1)+AxisLength] * LimitRatio;
    Ylim = [y(1)-AxisLength y(1)+AxisLength] * LimitRatio;
    Zlim = [z(1)-AxisLength z(1)+AxisLength] * LimitRatio;
    set(gca, 'Xlim', Xlim, 'Ylim', Ylim, 'Zlim', Zlim);
    
    % Set initial view
    view(View(1, :));

    %% Plot one sample at a time

%     for i = 1:numPlotSamples
%     for i = 1:numSamples
        % Update graph title
%         if(strcmp(Title, ''))
%             titleText = sprintf('Sample %i of %i', 1+((end-1)*SamplePlotFreq), numSamples);
%         else
%             titleText = strcat(Title, ' (', sprintf('Sample %i of %i', 1+((end-1)*SamplePlotFreq), numSamples), ')');
%         end
        titleText = 'RealTime Orientation of TI SensorTag';
        title(titleText);
        set(gcf,'color','w');
        % Plot body x y z axes
        if(strcmp(Trail, 'DotsOnly') || strcmp(Trail, 'All'))
            x(1:end) = p(1:end,1);
            y(1:end) = p(1:end,2);
            z(1:end) = p(1:end,3);
        else
            x = p(end,1);
            y = p(end,2);
            z = p(end,3);
        end
        if(strcmp(Trail, 'All'))
            ox(1:end) = p(1:end,1);
            oy(1:end) = p(1:end,2);
            oz(1:end) = p(1:end,3);
            ux(1:end) = R(1,1,1:end);
            vx(1:end) = R(2,1,1:end);
            wx(1:end) = R(3,1,1:end);
            uy(1:end) = R(1,2,1:end);
            vy(1:end) = R(2,2,1:end);
            wy(1:end) = R(3,2,1:end);
            uz(1:end) = R(1,3,1:end);
            vz(1:end) = R(2,3,1:end);
            wz(1:end) = R(3,3,1:end);
        else
            ox = p(end,1);
            oy = p(end,2);
            oz = p(end,3);
            ux = R(1,1,end);
            vx = R(2,1,end);
            wx = R(3,1,end);
            uy = R(1,2,end);
            vy = R(2,2,end);
            wy = R(3,2,end);
            uz = R(1,3,end);
            vz = R(2,3,end);
            wz = R(3,3,end);
        end
        set(orgHandle, 'xdata', x, 'ydata', y, 'zdata', z);
        set(quivXhandle, 'xdata', ox, 'ydata', oy, 'zdata', oz,'udata', ux, 'vdata', vx, 'wdata', wx);
        set(quivYhandle, 'xdata', ox, 'ydata', oy, 'zdata', oz,'udata', uy, 'vdata', vy, 'wdata', wy);
        set(quivZhandle, 'xdata', ox, 'ydata', oy, 'zdata', oz,'udata', uz, 'vdata', vz, 'wdata', wz);

        % Adjust axes for snug fit and draw
        axisLimChanged = false;
        if((p(end,1) - AxisLength) < Xlim(1)), Xlim(1) = p(end,1) - LimitRatio*AxisLength; axisLimChanged = true; end
        if((p(end,2) - AxisLength) < Ylim(1)), Ylim(1) = p(end,2) - LimitRatio*AxisLength; axisLimChanged = true; end
        if((p(end,3) - AxisLength) < Zlim(1)), Zlim(1) = p(end,3) - LimitRatio*AxisLength; axisLimChanged = true; end
        if((p(end,1) + AxisLength) > Xlim(2)), Xlim(2) = p(end,1) + LimitRatio*AxisLength; axisLimChanged = true; end
        if((p(end,2) + AxisLength) > Ylim(2)), Ylim(2) = p(end,2) + LimitRatio*AxisLength; axisLimChanged = true; end
        if((p(end,3) + AxisLength) > Zlim(2)), Zlim(2) = p(end,3) + LimitRatio*AxisLength; axisLimChanged = true; end
        if(axisLimChanged), set(gca, 'Xlim', Xlim, 'Ylim', Ylim, 'Zlim', Zlim); end
        drawnow;

        % Adjust view
        if(numel(View) > 2)
            view(View(end, :));
        end

        % Add frame to AVI object
        if(~isempty(aviobj))
            frame = getframe(fig);
            aviobj = addframe(aviobj, frame);
        end

    hold off;

    % Close AVI file
    if(~isempty(aviobj))
        aviobj = close(aviobj);
    end
