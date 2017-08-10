function skittlesMovie(sub,day,block)

% subnum: subject number, between (1,8)
% day: practice day, between (1,6)
% block: block number, between (1,4)


    [Angle,Sensor]=loaddata(sub,day,block);
    
    target = [-.6, .6];
    threshold = .011;
    graphicsScale = .25;
    
    close all;
    
    fig = createUI(target,graphicsScale);
    handles = guidata(fig);
    pause;

    setappdata(fig, 'simStep', 'waitToStart');
    i=1;
    while i<length(Angle)-1600
        
        angle_i = Angle(i);
        sensor_i = Sensor(i);
        set(handles.arm, 'XData', [0 .4*-cosd(angle_i)]*graphicsScale, 'YData', [-1.5 -1.5+.4*sind(angle_i)]*graphicsScale);
   
    switch(getappdata(fig, 'simStep'))
        case 'waitToStart'
            mm=tic;
            set(handles.ball, 'Visible', 'on');
            set(handles.trajectory,'Visible', 'on');
            set(handles.target, 'FaceColor', 'y');  
            if sensor_i > 2.0
                setappdata(fig,'simStep', 'waitToThrow');
                handles = guidata(fig);
                set(handles.ball, 'Visible', 'on');
            end
            pause(0.001-toc(mm));
            i=i+1;
        case 'waitToThrow'
            mm=tic;
            set(handles.trajectory,'Visible', 'off');
            set(handles.target, 'FaceColor', 'y');
            set(handles.ball, 'Position', [(.4*-cosd(angle_i))-.05,(-1.5+.4*sind(angle_i))-.05,.05*2,.05*2]*graphicsScale);
            if sensor_i < 0.5
               setappdata(fig,'simStep', 'ballReleased');
               releaseIndex =i;% find(aa(i) < .5, 1);
               releaseAngle =  Angle(releaseIndex);        
               releaseVelocity = getVelocity(Angle(releaseIndex-19:releaseIndex));
               setappdata(fig, 'drawTimeStart', tic);
               spring = getSpringParameters(releaseAngle, releaseVelocity);
               setappdata(fig, 'springParameters', spring);
            end  
            pause(0.001-toc(mm));
            i=i+1;  
        case 'ballReleased'
            minDistance = 100;
            postHit = false;
            targetHit = false;
            spring = getappdata(fig, 'springParameters');
            tStart = getappdata(fig, 'drawTimeStart');
            time = toc(tStart);
            %time=0;
            prevTime = time;
            j=1;
            while(time < 1.6 && postHit == false)
                time = toc(tStart);
               % time=0.001;
                for t=prevTime:.001:time
                    checkx=spring(1).*sin(spring(5).*t+spring(3)).*exp(-t/spring(6));
                    checky=spring(2).*sin(spring(5).*t+spring(4)).*exp(-t/spring(6));
                    if (sqrt((checkx-target(1))^2 + (checky-target(2))^2) < minDistance)
                        minDistance = sqrt((checkx-target(1))^2 + (checky-target(2))^2);
                        if minDistance < threshold
                            targetHit = true;
                            set(handles.target, 'FaceColor', 'g');
                        end
                    end
                    if(checkx^2+checky^2 < .25^2)
                        postHit = true;
                        minDistance = 1;
                    end
                end
                x(j)=spring(1).*sin(spring(5).*time+spring(3)).*exp(-time/spring(6));
                y(j)=spring(2).*sin(spring(5).*time+spring(4)).*exp(-time/spring(6));
                set(handles.trajectory, 'XData', x*graphicsScale, 'YData', y*graphicsScale, 'Visible', 'on'); 
                set(handles.ball, 'Position', [x(j)-.05,y(j)-.05,.05*2,.05*2]*graphicsScale);
                set(handles.arm, 'XData', [0 .4*-cosd(Angle(i+round(toc(tStart)/0.001)))]*graphicsScale, 'YData', [-1.5 -1.5+.4*sind(Angle(i+round(toc(tStart)/0.001)))]*graphicsScale);
              
                drawnow;
                prevTime = time;
                j=j+1;

            end 
                    setappdata(fig, 'simStep', 'waitToStart');
                    clear x y;
                    i=i+round(toc(tStart)/.001);
    end

    end
  
end

function [angle,sensor]=loaddata(sub,day,block)
    load(sprintf([sub,'/',sub,'_%d_%d','.mat'],day,block));    
end

function fig = createUI(target,graphicsScale)
    fig = figure('Tag','fig',...
                 'Units','normalized',...
                 'OuterPosition',[0, 0.3533, 0.3, 0.6533],...
                 'Color',[0 0 0],...
                 'Renderer', 'zbuffer', ...
                 'MenuBar', 'none', ...
                 'ToolBar', 'none', ...
                 'Resize', 'off');

    ax = axes('Parent',fig,...
              'Tag','ax', ...
              'Units','normalized',...
              'Position',[0 0 1 1],...
              'XLim',[-.3 .3],...
              'YLim',[-.51 .4],...
              'XLimMode', 'manual', ...
              'YLimMode', 'manual', ...
              'Color',[0 0 0]);
          
    daspect('manual');

    post = rectangle('Parent',ax,...
                       'Tag','post',....
                       'Position',[0-.25,0-.25,.25*2,.25*2]*graphicsScale,...
                       'LineStyle', 'none', ...
                       'Curvature',[1,1], ...
                       'FaceColor',[1 0 0]);
                   
    target = rectangle('Parent',ax,...
       'Tag','target',....
       'Position',[target(1)-.05,target(2)-.05,.05*2,.05*2]*graphicsScale,...
       'LineStyle', 'none', ...,
       'Curvature',[1,1], ...
       'FaceColor',[1 1 0]);   

    armJoint = rectangle('Parent',ax,...
                       'Tag','armJoint',....
                       'Position',[0-.02,-1.5-.02,.01*2,.02*2]*graphicsScale,...
                       'LineStyle', 'none', ...
                       'Curvature',[1,1], ...
                       'FaceColor',[1 1 1]);

    arm = line('Parent',ax, ...
               'Tag','arm', ...
               'LineStyle', '-',...
               'XData', [0.4 0]*graphicsScale,...
               'YData', [-1.5 -1.5]*graphicsScale,...
               'LineStyle', '-', ...
               'LineWidth', 3, ...
               'Color',[1 0 1]); 
           
   trajectory = line('Parent',ax, ...
               'Tag','trajectory', .....
               'XData', [-10 -10]*graphicsScale,...
               'YData', [-10 -10]*graphicsScale,...
               'LineStyle', '-', ...
               'LineWidth', 2, ...
               'Color','w', ...
               'Visible', 'off'); 

    ball = rectangle('Parent',ax,...
       'Tag','ball',....
       'LineStyle', 'none', ...
       'Position', [-10,-10,.05*2,.05*2]*graphicsScale, ...
       'Curvature',[1,1], ...
       'FaceColor',[1 1 1], ...
       'Visible', 'off');   
   

    % create handles structure
    ad = guihandles(fig);
    
    % save application data
    guidata(fig, ad);
end

function slope = getVelocity(data)
    angle = data;
    
    boundary = find(abs(diff(angle))>300);
    if ~isempty(boundary)
        if angle(boundary+1)-angle(boundary) > 0
            angle(boundary+1:end) = angle(boundary+1:end)-360;
        else
        	angle(1:boundary) = angle(1:boundary)-360;
        end
    end
    time = 0:.001:.019;
    slope = sum((time-mean(time)).*(angle-mean(angle)))/sum((time-mean(time)).*(time-mean(time))); 
end

function spring = getSpringParameters(releaseAngle, releaseVelocity)
    m = 0.1; %mass
    k = 1; %spring constant
    c = 0.01;   %viscous damping
    T = (2*m/c);    %relaxation time
    w = sqrt(abs((k/m)-((1/T)^2))); %frequency
    l = 0.4; %arm length
    
    x0=-l*cosd(releaseAngle);
    y0=-1.5+l*sind(releaseAngle);
    vx0=(releaseVelocity*pi/180*l)*sind(releaseAngle); 
    vy0=(releaseVelocity*pi/180*l)*cosd(releaseAngle);
    
    ax=sqrt((x0)^2+((vx0/w)+(x0/T)/w)^2);
    ay=sqrt((y0)^2+((vy0/w)+(y0/T)/w)^2);
    
    if ax~=0
        px=acos((1/ax)*((vx0/w)+((x0/T)/w)));
    else
        px=0;
    end
    if x0<0
        px=-px;
    end

    if ay~=0
        py=acos((1/ay)*((vy0/w)+((y0/T)/w)));
    else py=0;
    end
    if y0<0
        py=-py;
    end 
    spring = [ax,ay,px,py,w,T];
end



