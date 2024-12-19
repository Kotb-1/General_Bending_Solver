% Class for Rectangle distriputed load
% syntax:
%rec(p_i,p_f,v,beam_L,plane,axes1,axes2,org)
% - p_i:    initial position is a symbolic input ; Example: (2*L)
% - p_f:    final position is a symbolic input ; Example: (4*L)
% - v:      value is a symbolic input ; Example: (2*p)
% - beam_L: beam lenght is a symbolic input ; Example: (2*L)
% - plane:  input (1) for yz plane ; input (2) for xz plane
% - axes1:  axes for original load
% - axes2:  axes for correction load
% - org:    True (to plot original load only) or 
%           False (to plot original & correction load)
classdef rec
    properties
        start; % Starting Position of Rectangle
        ending_beam; % Length of the beam
        value; % Value of the distributed load
        corr_start; % Starting position of the correction
        plane;% Index of the plane
        final_moment;% Final moment due to concentrated moment
        % plotting stuff
        y_value;%numerical value for load
        domain;% z domain for original load
        domain_corr1;% z domain for correction1 load
        domain_corr2;% z domain for correction2 load
        pl;% All plots of the object
        fy;% Resultant force in the upward direction
        m0;% Moment about z=0
    end
    methods
        function obj = rec(p_i,pf,v,eb,plane,axes1,axes2,org,istrap,isrev)
            if nargin<9
                istrap = false;
            end
            if nargin<10
                isrev = false;
            end
            if nargin<8
                org = false;
            end
            syms L p;
            assume(L>0)
            assume(p>0)
            obj.start = p_i;
            obj.plane = plane;
            obj.ending_beam = eb;
            obj.corr_start = pf;
            obj.value = v;
            x1 = s_rec(p_i,obj.value);
            x2 = s_rec(pf,obj.value);
            obj.final_moment = x1-x2;
            obj.fy = -(pf-p_i)*v;
            obj.m0 = obj.fy*(p_i+0.5*(pf-p_i));

            % plotting
            y_plot = linspace(0,double(obj.value./p),100);
            obj.domain = double(obj.start./L):0.1:double(pf/L);
            obj.domain_corr1 = double(obj.start./L):0.1:double(eb/L);
            obj.domain_corr2 = double(pf./L):0.1:double(eb/L);
            obj.y_value = double(obj.value./p.*ones(length(obj.domain)));
            y_value1 = double(obj.value./p.*ones(length(obj.domain_corr1)));
            y_value2 = double(obj.value./p.*ones(length(obj.domain_corr2)));
            x_f1 = p_i./L.*ones(length(y_plot));
            x_f2 = pf./L.*ones(length(y_plot));
            x_f3 = eb./L.*ones(length(y_plot));
            axes1.NextPlot = "add";
            axes2.NextPlot = "add";
            obj.pl = [];
            % plot original load
            if ~istrap
                if ~isrev
                    pl1 = plot(axes1,2.*obj.domain,obj.y_value,'-k', 2.*x_f1,y_plot,'-k',2.*x_f2,y_plot,'-k','LineWidth',1);
                    obj.pl = [obj.pl pl1'];
                end
            end
                % plot correction
                if ~org
                    pl2 = plot(axes2,2.*obj.domain_corr1,y_value1,'-b',2.*obj.domain_corr2,-y_value2,'-g',2.*x_f1,y_plot,'-b', 2.*x_f3,y_plot,'-b',2.*x_f2,-y_plot,'-g', 2.*x_f3,-y_plot,'-g','LineWidth',1);
                    obj.pl = [obj.pl pl2'];
                end
            
            
            % arrows for original
            if ~istrap
                if ~isrev
                    axes(axes1)
                    c=1;
                    for i = min(obj.domain)+0.25:0.25:max(obj.domain)-0.25
                        %arrow([i obj.y_value(1)],[i 0])
                        x_v = i.*ones([10 1]);
                        y_v = linspace(0,obj.y_value(1),10);
                        pl3(c) = plot(2.*x_v,y_v,'-k');
                        c = c+1;
                    end
                    obj.pl = [obj.pl pl3];
                end
            end
                % arrows for corrections
                if ~org
                    axes(axes2)
                    c = 1;
                    for i = min(obj.domain)+0.25:0.25:obj.domain_corr1(end)-0.25
                        %arrow([i obj.y_value(1)],[i 0])
                            x_v = i.*ones([10 1]);
                            y_v = linspace(0,obj.y_value(1),10);
                            pl4(c) = plot(2.*x_v,y_v,'-k');
                        if i > obj.domain_corr2(1)
                            pl5(c) = plot(2.*x_v,-y_v,'-k');
                            if i == obj.domain_corr1(end)-0.25
                                obj.pl = [obj.pl pl5];
                            end
                        end
                        c = c+1;
                    end
                    obj.pl = [obj.pl pl4];
                end
            
        end
    end
end