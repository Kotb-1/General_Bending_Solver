% Class for normal triangle
% syntax:
% n_tri(p_i,p_f,v_f,beam_L,plane,axes1,axes2,org)
% - p_i:    initial position is a symbolic input ; Example: (2*L)
% - p_f:    final position is a symbolic input ; Example: (4*L)
% - v_f:    final value is a symbolic input ; Example: (2*p)
% - beam_L: beam lenght is a symbolic input ; Example: (2*L)
% - plane:  input (1) for yz plane ; input (2) for xz plane
% - axes1:  axes for original load
% - axes2:  axes for correction load
% - org:    True (to plot original load only) or 
%           False (to plot original & correction load)
classdef n_tri
    properties
        start; % Starting Position
        ending_tri; % Ending Position of Original Load
        ending_beam; % Length of the beam
        value_tri; % Value of Correction's large triangle
        value_rec; % Value of Correction's rectangle
        value_tri2; % Value of Correction's small triangle
        corr_start; % Starting Position of Correction's small triangle
        plane;% Index of the plane
        final_moment;% Final moment due to concentrated moment
        pl;% All plots of the object
        fy;% Resultant force in the upward direction
        m0;% Moment about z=0
    end
    methods
        function obj = n_tri(p_i,pf,vf,eb,plane,axes1,axes2,org,istrap)
            axes1.NextPlot = "add";
            axes2.NextPlot = "add";
            if nargin<9
                istrap = false;
            end
            if nargin<8
                org = false;
            end
            syms p L;
            assume(L>0)
            assume(p>0)
            obj.start = p_i;
            obj.plane = plane;
            obj.ending_tri = pf;
            obj.ending_beam = eb;
            obj.value_tri = (vf./(pf-p_i)).*(eb-p_i);
            obj.corr_start = pf;
            obj.value_rec = -vf;
            obj.value_tri2 = -(obj.value_tri-vf);
            if pf~=eb
                x1 = s_tri(p_i,obj.value_tri,eb);
                x2 = s_tri(obj.corr_start,obj.value_tri2,eb);
                x3 = s_rec(obj.corr_start,obj.value_rec);
                obj.final_moment = x1-x2-x3;
            else 
                x1 = s_tri(p_i,vf,eb);
                obj.final_moment = x1;
            end
            obj.fy = -0.5*(pf-p_i)*vf;
            obj.m0 = obj.fy*(p_i+2*(pf-p_i)/3);
            % plotting
            p_i = double(p_i./L);
            pf = double(pf./L);
            eb = double(eb./L);
            vf = double(vf./p);
            pol = polyfit([p_i pf],[0 vf],1);
            x = linspace(p_i,pf,10);
            y = polyval(pol,x);
            y_vf = linspace(0,vf,10);
            x_pf = pf.*ones(length(y_vf));
            obj.pl = [];
            if ~istrap
                axes(axes1)
                pl1 = plot(axes1,2.*x,y,'-b',2.*x_pf,y_vf,'-b');
                c=1;
                for i = p_i+0.25:0.25:pf-0.25
                    % arrow([i polyval(pol,i)],[i 0])
                    x_v = i.*ones([10 1]);
                    y_v = linspace(0,polyval(pol,i),10);
                    pl2(c) = plot(2.*x_v,y_v,'-k');
                    c = c+1;
                end
                obj.pl = [pl1' pl2];
                if ~org
                    % correction plotting
                    axes(axes2)
                    % pol = polyfit([p_i pf],[0 vf],1);
                    x_corr1 = linspace(p_i,eb,10);
                    y_corr1 = polyval(pol,x_corr1);
                    y_vf_corr1 = linspace(0,y_corr1(end),10);
                    x_pf_corr1 = eb.*ones(length(y_vf_corr1));
                    pl3 = plot(axes2,2.*x_corr1,y_corr1,'-b',2.*x_pf_corr1,y_vf_corr1,'-b');
                    c = 1;
                    for i = p_i+0.25:0.25:eb-0.25
                        % arrow([i polyval(pol,i)],[i 0])
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,polyval(pol,i),10);
                        pl4(c) = plot(2.*x_v,y_v,'-k');
                        c = c+1;
                    end
        
                    x_corr2 = linspace(pf,eb,10);
                    y_corr2 = -polyval(pol,x_corr2);
                    y_vi_corr2 = linspace(0,-vf,10);
                    y_vf_corr2 = linspace(0,y_corr2(end),10);
                    x_pi_corr2 = pf.*ones(length(y_vi_corr2));
                    x_pf_corr2 = eb.*ones(length(y_vf_corr2));
                    pl5 = plot(axes2,2.*x_corr2,y_corr2,'-g',2.*x_pi_corr2,y_vi_corr2,'-g',2.*x_pf_corr2,y_vf_corr2,'-g');
                    c = 1;
                    for i = pf+0.25:0.25:eb-0.25
                        % arrow([i -polyval(pol,i)],[i 0])
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