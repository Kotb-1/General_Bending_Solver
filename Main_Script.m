%% Main Script
clc;clearvars;close all
syms L Z c1 c2 c3 c4 p E d t;
eb = 4*L;    % Beam Length
n_plane = 2; % Number of Planes
Is = []; % Initialization of Is 
Is = [2/3,5/12,1/4];
%% Figures Intiation
[yz_axes,xz_axes,Mx_axes,My_axes,Sx_axes,Sy_axes,v_axes,u_axes] = initial_plot(n_plane,eb);
if ~isempty(Mx_axes)
Mx_axes.NextPlot = "add";
Sy_axes.NextPlot = "add";
end
if ~isempty(My_axes)
My_axes.NextPlot = "add";
Sx_axes.NextPlot = "add";
end
v_axes.NextPlot = "add";
u_axes.NextPlot = "add";
 
%% Constraints
o = 1;  % Index of supports
fix1 = fixed(0,o,1,yz_axes);
o = o+1; % must increase after each support declaration
fix2 = fixed(eb,o,1,yz_axes);
o = o+1;
s1 = simple(2*L,1,o,yz_axes);
o = o+1;
fix3 = fixed(0,o,2,xz_axes);
o = o+1; % must increase after each support declaration
fix4 = fixed(eb,o,2,xz_axes);




%% Loads
org = true;  % to not draw any corrections

rev1 = rev_tri(0,L,p,eb,1,yz_axes,xz_axes,org);
tri1 = n_tri(3*L,eb,p,eb,1,yz_axes,xz_axes,org);
cf1 = con_f(2*L,4*p*L,"down",1,yz_axes);

rec1 = rec(L,3*L,p/2,eb,2,xz_axes,xz_axes,org);
cm1 = con_m(L,p*L^2,'ccw',2,xz_axes);
cm2 = con_m(3*L,p*L^2,'cw',2,xz_axes);

%% Moment creation
consteraints = {fix1 fix2 fix3 fix4 s1};
loads = {rev1 rec1 cf1 cm1 cm2 tri1};
fixed_index=[];
for i = 1:length(consteraints)
    c_i = consteraints{i};
    if isa(c_i,'fixed')
        fixed_index = [fixed_index c_i.n];%#ok<AGROW>
    end
end

[Mx,My,Sx,Sy,v,v_dash,u,u_dash,solutions] = Structure_Project(consteraints,loads,n_plane,fixed_index,eb,Is);
final_plots(eb,Mx,My,Sx,Sy,v,u,yz_axes,xz_axes,Mx_axes,My_axes,Sx_axes,Sy_axes,v_axes,u_axes)

    if n_plane == 2 && isempty(Is)
        warning("Deflection plots won't be correct unless you INPUT Is");
    end
