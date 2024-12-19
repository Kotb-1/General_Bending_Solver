% Class for Fixed supports
% syntax:
%fixed(position,support_index,plane,axes)
% - Position:       is a symbolic input ; Example: (2*L)
% - support_index:  index with respect to number of supports
% - plane:          input (1) for yz plane ; input (2) for xz plane
% - axes:           input the axes on which the load will be plotted
classdef fixed
    properties
        p; % Position
        R; % Reaction Force
        M; % Reaction Moment
        n; % Load index
        u; % u condition
        v; % v condition
        u_dash; % u' condition
        v_dash; % v' condition
        plane;% Index of the plane
        final_moment;% Final moment due to supports reaction
        pl;% All plots of the object
        fy;% Resultant force in the upward direction
        m0;% Moment about z=0
    end
    methods
        function obj = fixed(pos,o,plane,axes1)
            axes1.NextPlot = "add";
            syms R1 R2 R3 R4 R5 R6 R7 R8 R9 R10 R11 R12 R14 R15 R16 R17 R19 R20 M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 L p;
            reactions = [R1 R2 R3 R4 R5 R6 R7 R8 R9 R10 R11 R12 R14 R15 R16 R17 R19 R20];
            moments = [M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20];
            assume(L>0)
            assume(p>0)
            obj.plane = plane; % It acts in both planes but each has its own unknowns
            obj.p = pos;
            obj.R = reactions(o);
            obj.M = moments(o);
            obj.n = o;
            if plane == 1
               obj.v = 0;
               obj.v_dash = 0;
               obj.u = nan;
               obj.u_dash = nan;
            elseif plane == 2
               obj.u = 0;
               obj.u_dash = 0;
               obj.v = nan;
               obj.v_dash = nan;
            else
                error("wrong plane index")
            end
            
            
            x1 =  concentrated_force(pos,-obj.R);
            x2 = concentrated_moment(pos,obj.M);
            obj.final_moment = x1+x2;
            obj.fy = obj.R;
            obj.m0 = obj.fy*pos+obj.M;

            % plotting
            pos = double(pos./L);
            axes(axes1)
            if pos == 0
                x = [0 -0.125 -0.125 0];
                y = [1 1 -1 -1].*0.5;
                pl1 = fill(x,y,'r');
                pl2 = circular_arrow(axes1, 1 , [1-0.5 0], 180 , 90 , -1 , 'r');
            else
                x = 2.*[pos pos+0.125/2 pos+0.125/2 pos];
                y = [1 1 -1 -1].*0.5;
                pl1 = fill(x,y,'r');
                pl2 = circular_arrow(axes1, 1 , [2.*pos-0.5 0], 0 , 90 , -1 , 'r');
            end
            % arrow([pos -1.5],[pos -0.5])
            x_v = pos.*ones([10 1]);
            y_v = linspace(0,-1,10);
            x_arr = linspace(0,0.1,10);
            y_arr = 3.*x_arr;
            axes(axes1)
            pl3 = plot(2.*x_v,y_v,'-k',2.*(-x_arr+pos),-y_arr,'-k',2.*(x_arr+pos),-y_arr,'-k');
            obj.pl = [pl1 pl2 pl3'];
            
        end
    end
end