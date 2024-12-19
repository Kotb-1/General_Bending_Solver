% Function to intialize all needed figures
% Syntax:
%       [yz_axes,xz_axes,Mx_axes,My_axes,Sx_axes,Sy_axes,v_axes,u_axes] = initial_plot(n_plane,b_l,plane)
%   Where:
%       Inputs:
%           n_plane:    Number of planes for your problem
%           b_l:        Beam Length in terms of "L" -syms L-
%           plane:      ||only Input If n_plane == 1|| 
%                       else -> only input the first 2 arguments
%                       Input which plane you have; "yz" or "xz"
% 
%       Outputs:
%           yz_axes:    Axes for your problem's Y-Z plane
%           xz_axes:    Axes for your problem's X-Z plane
%           Mx_axes:    Axes for your Mx diagram 
%           My_axes:    Axes for your My diagram 
%           Sx_axes:    Axes for your Sx diagram 
%           Sy_axes:    Axes for your SY diagram 
%           v_axes:     Axes for your deflection in Y (v) 
%           u_axes:     Axes for your deflection in X (u) 
% 



function [yz_axes,xz_axes,Mx_axes,My_axes,Sx_axes,Sy_axes,v_axes,u_axes] = initial_plot(n_plane,eb,plane)
    if nargin<3 && n_plane==2
        plane = [];
    end
    
    syms L;
    beam_domain = 0:0.1:double(eb./L);
    if n_plane==2
        fig1 = figure();sgtitle("Y-Z plane");xlabel("Y");ylabel("Z");
        yz_axes = fig1.CurrentAxes;
        hold on;
        axes(fig1.CurrentAxes)
        axis equal
        plot(2*beam_domain,zeros(length(beam_domain)),'LineWidth',3)

        fig2 = figure();sgtitle("X-Z plane");xlabel("X");ylabel("Z");
        xz_axes = fig2.CurrentAxes;
        hold on;
        plot(2*beam_domain,zeros(length(beam_domain)),'LineWidth',3)
        axis equal
        
        fig3 = figure();
        t = tiledlayout("vertical","TileSpacing","tight"); t.Title.String = "Moment plots"; t.XLabel.String = "Z";
        Mx_axes = nexttile;  
        plot(beam_domain,zeros(length(beam_domain)),'LineWidth',3)
        My_axes = nexttile;  
        plot(beam_domain,zeros(length(beam_domain)),'LineWidth',3)
        Mx_axes.YLabel.String = "Mx";
        My_axes.YLabel.String = "My";

        fig4 = figure();
        t2 = tiledlayout("vertical","TileSpacing","tight"); t2.Title.String = "Shear plots"; t2.XLabel.String = "Z";
        Sy_axes = nexttile;  
        plot(beam_domain,zeros(length(beam_domain)),'LineWidth',3)
        Sx_axes = nexttile;  
        plot(beam_domain,zeros(length(beam_domain)),'LineWidth',3)
        Sx_axes.YLabel.String = "Sx";
        Sy_axes.YLabel.String = "Sy";
        
    elseif strcmp(plane,"yz")
        fig1 = figure();sgtitle("Y-Z plane");xlabel("Y");ylabel("Z");
        yz_axes = fig1.CurrentAxes;
        hold on;
        axes(fig1.CurrentAxes)
        axis equal
        plot(2*beam_domain,zeros(length(beam_domain)),'LineWidth',3)
        xz_axes = [];

        fig3 = figure();
        t = tiledlayout("vertical","TileSpacing","tight"); t.Title.String = "Moment plots"; t.XLabel.String = "Z";
        Mx_axes = nexttile; 
        plot(beam_domain,zeros(length(beam_domain)),'LineWidth',3)
        Mx_axes.YLabel.String = "Mx"; 
        My_axes = []; 

        fig4 = figure();
        t2 = tiledlayout("vertical","TileSpacing","tight"); t2.Title.String = "Shear plots"; t2.XLabel.String = "Z";
        Sy_axes = nexttile; 
        plot(beam_domain,zeros(length(beam_domain)),'LineWidth',3)
        Sy_axes.YLabel.String = "Sy"; 
        Sx_axes = [];

    elseif strcmp(plane,"xz")
        fig2 = figure();sgtitle("X-Z plane");xlabel("X");ylabel("Z");
        xz_axes = fig2.CurrentAxes;
        hold on;
        plot(2*beam_domain,zeros(length(beam_domain)),'LineWidth',3)
        axis equal
        yz_axes = [];

        fig3 = figure();
        t = tiledlayout("vertical","TileSpacing","tight"); t.Title.String = "Moment plots"; t.XLabel.String = "Z";
        Mx_axes = [];
        My_axes = nexttile; 
        plot(beam_domain,zeros(length(beam_domain)),'LineWidth',3)
        My_axes.YLabel.String = "My"; 

        fig4 = figure();
        t2 = tiledlayout("vertical","TileSpacing","tight"); t2.Title.String = "Shear plots"; t2.XLabel.String = "Z";
        Sy_axes = [];
        Sx_axes = nexttile; 
        plot(beam_domain,zeros(length(beam_domain)),'LineWidth',3)
        Sx_axes.YLabel.String = "Sx"; 

    end
    fig5 = figure();
    t = tiledlayout("vertical","TileSpacing","tight"); t.Title.String = "Deflection plots"; t.XLabel.String = "Z";
    v_axes = nexttile; 
    plot(beam_domain,zeros(length(beam_domain)),'LineWidth',3)
    u_axes = nexttile; 
    plot(beam_domain,zeros(length(beam_domain)),'LineWidth',3)
    u_axes.YLabel.String = "u"; 
    v_axes.YLabel.String = "v"; 
end