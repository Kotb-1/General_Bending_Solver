% Class for concentrated Moment
% syntax:
% con_m(Position,Magnitude,direction,plane,axes)
% - Position:   is a symbolic input ; Example: (2*L)
% - Magnitude:  is a symbolic input ; Example: (2*p*L^2)
% - direction:  is 'cw' for Clockwise Moment or 'ccw' for
%               Counterclockwise Moment
% - plane:      input (1) for yz plane ; input (2) for xz plane
% - axes:       input the axes on which the load will be plotted
classdef con_m
    properties
        p; % Position
        M; % Magnitude
        final_moment; % Final moment due to concentrated moment
        pl; % All plots of the object
        plane; % Index of the plane
        fy; % Resultant force in the upward direction (always = 0) 
        m0; % Moment about z=0
    end
    methods
        function obj = con_m(pos,m,dir,plane,axes1)
            axes(axes1)
            axes1.NextPlot = "add";
            obj.plane = plane;
            syms p L;
            assume(L>0)
            assume(p>0)
            obj.p = pos;
            if dir == "ccw"
                obj.M = m;
                mark = '+';
                angle = 180;
                lw =  2;
                s = 50;
            elseif dir == "cw"
                obj.M = -m;
                mark = '.';
                angle = 0;
                lw = 3;
                s = 100;
            end
            
            x1 =  concentrated_moment(pos,obj.M);
            obj.final_moment = x1;
            obj.fy = 0;
            obj.m0 = obj.M;
            % plotting
            position = double(pos./L);
            magnitude = double(obj.M./p./L^2);
            obj.pl = circular_arrow(axes1, 0.25 , [2.*position 0], angle , 180 , -sign(magnitude));
            pl2 = scatter(2.*position,0,s,'r',mark,'LineWidth',lw);
            obj.pl = [obj.pl pl2];
        end
    end
end