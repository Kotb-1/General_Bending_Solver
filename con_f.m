% Class for Concenterated Forces
% syntax:
% con_f(Position,Magnitude,direction,plane,axes)
% - Position:   is a symbolic input ; Example: (2*L)
% - Magnitude:  is a symbolic input ; Example: (2*p*L)
% - direction:  is "down" for downward force or "up" for upward force
% - plane:      input (1) for yz plane ; input (2) for xz plane
% - axes:       input the axes on which the load will be plotted
classdef con_f
    properties
        p; % Position
        R; % Magnitude
        final_moment; % Final moment due to concentrated force
        pl; % All plots of the object
        fy; % Resultant force in the upward direction 
        m0; % Moment about z=0
        plane; % Index of the plane
    end
    methods
        function obj = con_f(pos,R,dir,plane,axes1)
            axes1.NextPlot = "add";
            obj.plane = plane;
            if strcmp(dir,"up")
                si = 1;
                obj.fy = R;
                R = -R;
            elseif strcmp(dir,"down")
                si = -1;
                obj.fy = -R;
            end
            syms p L;
            assume(L>0)
            assume(p>0)
            obj.p = pos;
            obj.R = R;
            x1 =  concentrated_force(pos,obj.R);
            obj.final_moment = x1;
            obj.m0 = obj.fy*pos;
            % plotting
            position = double(pos./L);
            magnitude = double(R./p./L);
            x_v = position.*ones([10 1]);
            y_v = linspace(0,magnitude,10);
            x_arr = linspace(0,0.1,10);
            y_arr = 3.*x_arr;
            axes(axes1)
            obj.pl = plot(2.*x_v,y_v,'-k',2.*(-si.*x_arr+position),-si.*y_arr,'-k',2.*(si.*x_arr+position),-si.*y_arr,'-k');
            
            % arrow([position magnitude],[position 0])
        end
    end
end