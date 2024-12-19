% a function that plots Moment, Shear, and Deflection
function final_plots(b_l,Mx,My,Sx,Sy,v,u,yz_axes,xz_axes,Mx_axes,My_axes,Sx_axes,Sy_axes,v_axes,u_axes)
syms L Z p;
    Z_plot = (0:0.01:double(b_l./L))';
    if ~isempty(My_axes)
        My_disc = feval(symengine,'discont',My,Z);
        Sx_disc = feval(symengine,'discont',Sx,Z);
        My_plot = sub_plot(My,Z_plot);
        Sx_plot = sub_plot(Sx,Z_plot);
        plot(My_axes,Z_plot,My_plot,'-b','LineWidth',1.5);
        plot(Sx_axes,Z_plot,Sx_plot,'-b','LineWidth',1.5);
        disc_fix(My,My_disc,My_axes)
        disc_fix(Sx,Sx_disc,Sx_axes)
        tick_change(xz_axes)
    end
    
    if ~isempty(Mx_axes)
        Mx_disc = feval(symengine,'discont',Mx,Z);
        Sy_disc = feval(symengine,'discont',Sy,Z);
        Mx_plot = sub_plot(Mx,Z_plot);
        Sy_plot = sub_plot(Sy,Z_plot);
        plot(Mx_axes,Z_plot,Mx_plot,'-b','LineWidth',1.5);
        plot(Sy_axes,Z_plot,Sy_plot,'-b','LineWidth',1.5);
        disc_fix(Sy,Sy_disc,Sy_axes)
        disc_fix(Mx,Mx_disc,Mx_axes)
        tick_change(yz_axes)
    end
    
    
    
    v_plot = sub_plot(v,Z_plot);
    plot(v_axes,Z_plot,v_plot,'-b','LineWidth',1.5);
    u_plot = sub_plot(u,Z_plot);
    plot(u_axes,Z_plot,u_plot,'-b','LineWidth',1.5);
end