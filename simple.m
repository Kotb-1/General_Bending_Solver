% Class for Simple supports
% syntax:
%simple(position,support_index,plane,axes)
% - Position:       is a symbolic input ; Example: (2*L)
% - support_index:  index with respect to number of supports
% - plane:          input (1) for yz plane ; input (2) for xz plane
% - axes:           input the axes on which the load will be plotted
classdef simple
    properties
        p; % Position
        R; % Reaction Force
        u; % u condition
        v; % v condition
        n; % Load index
        u_dash; % u' condition
        v_dash; % v' condition
        plane;% Index of the plane
        final_moment;% Final moment due to supports reaction
        pl;% All plots of the object
        fy;% Resultant force in the upward direction
        m0;% Moment about z=0
    end
    methods
        function obj = simple(pos,plane,o,axes1)
            axes1.NextPlot = "add";
            axes(axes1)
            syms R1 R2 R3 R4 R5 R6 R7 R8 R9 R10 R11 R12 R14 R15 R16 R17 R19 R20 L p;
            reactions = [R1 R2 R3 R4 R5 R6 R7 R8 R9 R10 R11 R12 R14 R15 R16 R17 R19 R20];
            assume(L>0)
            assume(p>0)
            obj.plane = plane;
            obj.p = pos;
            obj.R = reactions(o);
            if plane == 1
               obj.v = 0;
               obj.u = nan;
            elseif plane == 2
               obj.u = 0;
               obj.v = nan;
            else
                error("wrong plane index")
            end
            obj.n = o;
            obj.u_dash = nan;
            obj.v_dash = nan;
            x1 =  concentrated_force(pos,-obj.R);
            obj.final_moment = x1;
            obj.fy = obj.R;
            obj.m0 = obj.fy*pos;
            pos = 2.*double(pos./L);
            x = [pos pos+0.25 pos-0.25];
            y = [0 -0.25 -0.25];
            obj.pl = fill(x,y,'r');
        end
    end
end