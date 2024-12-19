% Final Function
% Syntax:
%       [Mx,My,v,v_dash,u,u_dash,solutions] = Structure_Project(consteraints,loads,n_plane,b_l,Is)
% Where:
%   Outputs:
%       Mx:         Moment in Y-Z plane
%       My:         Moment in X-Z plane
%       v:          Deflection in Y direction
%       v_dash:     Slope of deflection in Y
%       u:          Deflection in X direction
%       u_dash:     Slope of deflection in X
%       solutions:  Struct for Values of Unknowns
%
%   Inputs:
%       constraints:    A cell array containing all Supports
%       loads:          A cell array containing all Loads
%       n_plane:        Number of planes
%       fixed_support:  Array for numbered Indices "o" of fixed supports
%                       (fixed.n)
%       b_l:            Beam length
%       Is:         --> Optional: Only in case given Inertias
%                   --> Required for correct deflection plots in case of 2
%                       planes problem.
%                    -> ONLY the Coeffiecients of Inertias
%                       Where [Ixx,Iyy,Ixy] = Is.*d^3.*t
%                       and Ixx = Is(1)*t*d^3   ; t & d are symbolic
%                       dimensions of the Cross-Section.
%                   --> If not passed as an Input, The solution will be in
%                       terms of kx,ky,kxy instead of t,d


function [Mx,My,Sx,Sy,v,v_dash,u,u_dash,solutions] = Structure_Project(consteraints,loads,n_plane,fixed_index,eb,Is)
    %% Variables Declaration
    syms L Z c1 c2 c3 c4 p E d t;
    syms R1 R2 R3 R4 R5 R6 R7 R8 R9 R10 R11 R12 R14 R15 R16 R17 R19 R20...
        M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20;
    reactions = [R1 R2 R3 R4 R5 R6 R7 R8 R9 R10 R11 R12 R14 R15 R16 R17 R19 R20];
    moments = [M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20];
    assume(L>0)
    assume(p>0)
    assume(Z>0)
    if nargin == 6
        Ix = Is(1)*t*d^3;
        Iy = Is(2)*t*d^3;
        Ixy = Is(3)*t*d^3;
        K_bar = Ix*Iy-Ixy^2;
        kx = Ix/K_bar;
        ky = Iy/K_bar;
        kxy = Ixy/K_bar;
    else
        syms kx ky kxy
    end
    
    
    %%supports declaration
    
    
    %% Moment creation
    all = {consteraints{1:end} loads{1:end}};
    z_u = [];
    z_v = [];
    z_ud = [];
    z_vd = [];
    u_value = [];
    v_value = [];
    ud_value = [];
    vd_value = [];
    fi = length(consteraints); % number of unknown reactions
    Mx = 0;
    My = 0;
    Fy = 0;
    Fx = 0;
    m01 = 0;
    m02 = 0;
    % supports_y = [];
    % supports_x = [];
    for i = 1:length(consteraints)
        c_conc = consteraints{i};
        if c_conc.plane == 1
            if c_conc.p~=eb
                Mx = Mx+ c_conc.final_moment;
            end
            Fy = Fy + c_conc.fy;
            m01 = m01+c_conc.m0;
            % supports_y = [supports_y c_conc.n];
        end
        if c_conc.plane == 2
            if c_conc.p~=eb
                My = My+ c_conc.final_moment;
            end
            Fx = Fx + c_conc.fy;
            m02 = m02+c_conc.m0;
            % supports_x = [supports_x c_conc.n];
        end
        if ~isnan(c_conc.u)
            z_u = [z_u;c_conc.p];%#ok<AGROW>
            u_value = [u_value;c_conc.u];%#ok<AGROW>
        end
        if ~isnan(c_conc.v)
            z_v = [z_v;c_conc.p];%#ok<AGROW>
            v_value = [v_value;c_conc.v];%#ok<AGROW>
        end
        if ~isnan(c_conc.u_dash)
            z_ud = [z_ud;c_conc.p];%#ok<AGROW>
            ud_value = [ud_value;c_conc.u_dash];%#ok<AGROW>
        end
        if ~isnan(c_conc.v_dash)
            z_vd = [z_vd;c_conc.p];%#ok<AGROW>
            vd_value = [vd_value;c_conc.v_dash];%#ok<AGROW>
        end
    end
    for i = 1:length(loads)
        c_load = loads{i};
        if c_load.plane == 1
            Mx = Mx+ c_load.final_moment;
            Fy = Fy + c_load.fy;
            m01 = m01+c_load.m0;
        end
        if c_load.plane == 2
            My = My+ c_load.final_moment;
            Fx = Fx + c_load.fy;
            m02 = m02+ c_load.m0;
        end
    end
    unknowns = [c1 c2 c3 c4 reactions(1:fi) moments(fixed_index)];
    trans = -1./E.*[-kxy,kx;ky,-kxy]*[Mx;My];
    Mx_ph = Mx;
    My_ph = My;
    if Mx~=0
        Mx = children(Mx);
    end
    if My~=0
        My = children(My);
    end
    Mx1i = int(Mx,Z);
    Mx2i = int(Mx1i,Z);
    My1i = int(My,Z);
    My2i = int(My1i,Z);
    Mx1 = sum([Mx1i(:)]);
    Mx2 = sum([Mx2i(:)]);
    My1 = sum([My1i(:)]);
    My2 = sum([My2i(:)]);
    
    trans1 = -1./E.*[-kxy,kx;ky,-kxy]*[Mx1;My1];
    trans2 = -1./E.*[-kxy,kx;ky,-kxy]*[Mx2;My2];
    u2_dash = trans(1);
    v2_dash = trans(2);
    u_dash = trans1(1) + c1;
    v_dash = trans1(2) + c3;
    u = trans2(1) + c2;
    v = trans2(2) + c4;
    if n_plane ==1
        eqns = [subs(v_dash,Z,z_vd)==vd_value ; subs(v,Z,z_v)==v_value ; Fy == 0; m01 == 0];
    else
        eqns = [subs(v_dash,Z,z_vd)==vd_value ; subs(v,Z,z_v)==v_value ; Fy == 0; m01 == 0 ;subs(u_dash,Z,z_ud)==ud_value ; subs(u,Z,z_u)==u_value ;Fx == 0; m02 == 0];
    end
    solutions = solve(eqns,unknowns);
    % sol_cell = struct2cell(solutions);
    % Names = fieldnames(solutions);
    Mx = Mx_ph;
    My = My_ph;
    D = digits(6);
    for i = 1:length(unknowns)
        unknown.var = char(unknowns(i));
        current = vpa(solutions.(unknown.var));
        Mx = subs(Mx,unknowns(i),current);
        My = subs(My,unknowns(i),current);
        v = subs(v,unknowns(i),current);
        u = subs(u,unknowns(i),current);
        u_dash = subs(u_dash,unknowns(i),current);
        v_dash = subs(v_dash,unknowns(i),current);
    end
    Sx = diff(My,Z);
    Sy = diff(Mx,Z);
    digits(D);
end