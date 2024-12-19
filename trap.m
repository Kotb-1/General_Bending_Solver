%Class for trapezoid distributed load
% syntax:
% trap(p_i,p_f,v_1,v_2,beam_L,plane,axes1,axes2,org)
% - p_i:    initial position is a symbolic input ; Example: (2*L)
% - p_f:    final position is a symbolic input ; Example: (4*L)
% - v_1:    initial value is a symbolic input ; Example: (2*p)
% - v_2:    final value is a symbolic input ; Example: (2*p)
% - beam_L: beam lenght is a symbolic input ; Example: (2*L)
% - plane:  input (1) for yz plane ; input (2) for xz plane
% - axes1:  axes for original load
% - axes2:  axes for correction load
% - org:    True (to plot original load only) or 
%           False (to plot original & correction load)
classdef trap
    properties
        start; %strating position for distributed load (pi)
        ending_beam; %beam length (eb)
        value1; %trapezoid value from left
        value2; %Trapezoid value from right
        corr_start; %Correction intatiating position
        plane; %Plane of action
        final_moment;% Final moment due to supports reaction
        pl;% All plots of the object
        fy;% Resultant force in the upward direction
        m0;% Moment about z=0
    end
    methods
        function obj = trap(p_i,pf,v1,v2,eb,plane,axes1,axes2,org)
            if nargin<9
                org = false;
            end
            axes1.NextPlot = "add";
            axes2.NextPlot = "add";
            syms p L;
            assume(L>0)
            assume(p>0)
            obj.start = p_i;
            obj.plane = plane;
            obj.ending_beam = eb;
            obj.corr_start = pf;
            obj.value1 = v1;
            obj.value2 = v2;
            obj.pl=[];
            vi = double(v1./p);
            vf = double(v2./p);
            obj.fy = -0.5*(pf-p_i)*(v1+v2);
            if abs(vf)>abs(vi)
                x1 = rec(p_i,pf,v1,eb,plane,axes1,axes2,true,false);
                x2 = n_tri(p_i,pf,v2-v1,eb,plane,axes1,axes2,org,true);
                obj.final_moment = x1.final_moment+x2.final_moment;
                obj.pl = [obj.pl x1.pl x2.pl];
                m1 = -(pf-p_i)*(v1)*(p_i+0.5*(pf-p_i));
                m2 = -0.5*(pf-p_i)*(v2-v1)*(p_i+2*(pf-p_i)/3);
                obj.m0 = m1+m2;
            else
                x1 = rec(p_i,pf,v2,eb,plane,axes1,axes2,false,true);
                x2 = rev_tri(p_i,pf,v1-v2,eb,plane,axes1,axes2,org,true,vf);
                obj.final_moment = x1.final_moment+x2.final_moment;
                obj.pl = [obj.pl x1.pl x2.pl];
                m1 = -(pf-p_i)*(v2)*(p_i+0.5*(pf-p_i));
                m2 = -0.5*(pf-p_i)*(v1-v2)*(p_i+(pf-p_i)/3);
                obj.m0 = m1+m2;
            end
            p_i = double(p_i./L);
            pf = double(pf./L);
            eb = double(eb./L);
            
            pol = polyfit([p_i pf],[vi vf],1);
            x = linspace(p_i,pf,10);
            y = polyval(pol,x);
            y_vi = linspace(0,vi,10);
            y_vf = linspace(0,vf,10);
            x_pi = p_i.*ones(length(y_vi));
            x_pf = pf.*ones(length(y_vf));
            pl1=plot(axes1,2.*x,y,'-c',2.*x_pi,y_vi,'-c',2.*x_pf,y_vf,'-c');
            axes(axes1)
            c=1;
            for i = p_i+0.25:0.25:pf-0.25
                    %arrow([i polyval(pol,i)],[i 0])
                    x_v = i.*ones([10 1]);
                    y_v = linspace(0,polyval(pol,i),10);
                    pl2(c) = plot(2.*x_v,y_v,'-k');
                    c = c+1;
            end
            obj.pl = [obj.pl pl1' pl2];
            % correction
            if ~org
                if abs(vf)>abs(vi)
                    axes(axes2)
                    % positive
                    x1 = linspace(p_i,eb,10);
                    y1 = polyval(pol,x1);
                    y_vi1 = linspace(0,vi,10);
                    y_vf1 = linspace(0,y1(end),10);
                    x_pi1 = p_i.*ones(length(y_vi1));
                    x_pf1 = eb.*ones(length(y_vf1));
                    pl3=plot(axes2,2.*x1,y1,'-c',2.*x_pi1,y_vi1,'-c',2.*x_pf1,y_vf1,'-c');
                    c=1;
                    for i = p_i+0.25:0.25:eb-0.25
                        %arrow([i polyval(pol,i)],[i 0])
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,polyval(pol,i),10);
                        pl4(c) = plot(2.*x_v,y_v,'-k');
                        c = c+1;
                    end
                    % negative
                    x2 = linspace(pf,eb,10);
                    y2 = -polyval(pol,x2);
                    y_vi2 = -linspace(0,vf,10);
                    y_vf2 = linspace(0,y2(end),10);
                    x_pi2 = pf.*ones(length(y_vi2));
                    x_pf2 = eb.*ones(length(y_vf2));
                    pl5 = plot(axes2,2.*x2,y2,'-c',2.*x_pi2,y_vi2,'-c',2.*x_pf2,y_vf2,'-c');
                    c=1;
                    for i = pf+0.25:0.25:eb-0.25
                        %arrow([i -polyval(pol,i)],[i 0])
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,-polyval(pol,i),10);
                        pl6(c) = plot(2.*x_v,y_v,'-k');
                        c = c+1;
                    end
                    obj.pl = [obj.pl pl3' pl4 pl5' pl6];
                end
            end
        end
    end
end