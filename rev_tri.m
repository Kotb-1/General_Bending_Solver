% Reverse triangle class
% syntax:
%rev_tri(p_i,p_f,v_i,beam_L,plane,axes1,axes2,org)
% - p_i:    initial position is a symbolic input ; Example: (2*L)
% - p_f:    final position is a symbolic input ; Example: (4*L)
% - v_i:    initial value is a symbolic input ; Example: (2*p)
% - beam_L: beam lenght is a symbolic input ; Example: (2*L)
% - plane:  input (1) for yz plane ; input (2) for xz plane
% - axes1:  axes for original load
% - axes2:  axes for correction load
% - org:    True (to plot original load only) or 
%           False (to plot original & correction load)
classdef rev_tri
    properties
        start; % strating position
        ending_tri; % ending position
        ending_beam; % beam length
        value_tri; % value of correction's large triangle
        value_rec; % correction rectangle value
        value_tri2; % value of correction's small triangle
        corr_start; % strating position of the small triangle correction
        plane;% Index of the plane
        final_moment;% Final moment due to concentrated moment
        pl;% All plots of the object
        fy;% Resultant force in the upward direction
        m0;% Moment about z=0
    end
    methods
        function obj = rev_tri(p_i,pf,vi,eb,plane,axes1,axes2,org,istrap,vf)
            axes1.NextPlot = "add";
            axes2.NextPlot = "add";
            if nargin<9
                istrap = false;
            end
            if nargin<10
                vf = 0;
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
            obj.value_tri = (vi./(-p_i+pf)).*(eb-p_i);
            obj.corr_start = p_i;
            obj.value_rec = vi;
            obj.value_tri2 = obj.value_tri-vi;
            x1 = s_tri(p_i,obj.value_tri,eb);
            x2 = s_tri(pf,obj.value_tri2,eb);
            x3 = s_rec(obj.corr_start,obj.value_rec);
            obj.final_moment = -x1+x2+x3;
            obj.fy = -0.5*(pf-p_i)*vi;
            obj.m0 = obj.fy*(p_i+(pf-p_i)/3);


            % plotting
            obj.pl =[];
            p_i = double(p_i./L);
            pf = double(pf./L);
            eb = double(eb./L);
            vi = double(vi./p);
            pol = polyfit([p_i pf],[vi 0],1);
            x = linspace(p_i,pf,10);
            y = polyval(pol,x);
            y_vf = linspace(0,vi,10);
            x_pi = p_i.*ones(length(y_vf));
            if ~istrap
               pl1= plot(axes1,2.*x,y,'-b',2.*x_pi,y_vf,'-b');
               obj.pl = [obj.pl pl1'];
               axes(axes1)
               c=1;
                for i = p_i+0.25:0.25:pf-0.25
                   % arrow([i polyval(pol,i)],[i 0])
                   x_v = i.*ones([10 1]);
                   y_v = linspace(0,polyval(pol,i),10);
                   pl2(c) = plot(2.*x_v,y_v,'-k');
                   c = c+1;
                end
                obj.pl = [obj.pl pl2];
            end
            if ~org
                axes(axes2)
                % correction plotting
                pol = polyfit([p_i pf],[0 vi],1);
                x_corr01 = linspace(p_i,pf,10);
                x_corr02 = linspace(pf,eb,10);
                y_corr1 = [-polyval(pol,x_corr01) -polyval(pol,x_corr02)-vf];
                y_vf_corr01 = linspace(0,y_corr1(end),10);
                y_vf_corr02 = linspace(0,y_corr1(11),10);
                x_pf_corr01 = eb.*ones(length(y_vf_corr01));
                x_pf_corr02 = pf.*ones(length(y_vf_corr02));
                pl3 = plot(axes2,2.*[x_corr01 x_corr02],y_corr1,'-k',2.*x_pf_corr01,y_vf_corr01,'-k',2.*x_pf_corr02,y_vf_corr02,'-k');
                c=1;
                for i = p_i+0.25:0.25:pf-0.25
                        %arrow([i -polyval(pol,i)],[i 0])
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,-polyval(pol,i),10);
                        pl4(c) = plot(2.*x_v,y_v,'-k');
                        c = c+1;
                end
                c=1;
                for i = pf:0.25:eb-0.25
                        %arrow([i -polyval(pol,i)-vf],[i 0])
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,-polyval(pol,i)-vf,10);
                        pl5(c) = plot(2.*x_v,y_v,'-k');
                        c = c+1;
                end
                
                x_corr2 = linspace(pf,eb,10);
                y_corr2 = polyval(pol,(x_corr2+p_i-pf))+vf+vi;
                % y_vi_corr2 = linspace(0,vf,10);
                y_vf_corr2 = linspace(vf+vi,y_corr2(end),10);
                % x_pi_corr2 = pf.*ones(length(y_vi_corr2));
                x_pf_corr2 = eb.*ones(length(y_vf_corr2));
                pl6=plot(axes2,2.*x_corr2,y_corr2,'-k',2.*x_pf_corr2,y_vf_corr2,'-k');
    
                % rec
                y_vf2 = linspace(vf,vi+vf,10);
                y_rec = x_corr01.^0.*vi+vf;
                x_eb = eb.*ones(length(y_vf2));
                pl7 = plot(axes2,2.*x_corr01,y_rec,'-k',2.*x_pi,y_vf2,'-k',2.*x_eb,y_vf2,'-k');
                c=1;
                for i = p_i+0.25:0.25:pf-0.25
                        %arrow([i vi+vf],[i 0])
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,vi+vf,10);
                        pl8(c) = plot(2.*x_v,y_v,'-k');
                        c = c+1;
                end
                c=1;
                for i = pf:0.25:eb-0.25
                        %arrow([i polyval(pol,(i+p_i-pf))+vf+vi],[i 0])
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,polyval(pol,(i+p_i-pf))+vf+vi,10);
                        pl9(c) = plot(2.*x_v,y_v,'-k');
                        c = c+1;
                end
                obj.pl = [obj.pl pl3' pl4 pl5 pl6' pl7' pl8 pl9];
            end
        end
    end
end