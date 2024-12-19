clc;clearvars;close all;
warning('off','arrow:limits')
syms z L p;
pi = L;
pf = 3*L;
eb = 4*L;
v = 3*p;
vc = v*L;
m = vc*L;
yl = 1.5*double(v./p);
if yl<0
    yl = -yl;
end
xl = double(eb./L);
plane = 1;
beam_domain = 0:0.1:double(eb./L);
f1 =  figure(1);
hold on;
axes(f1.CurrentAxes)
plot(2.*beam_domain,zeros(length(beam_domain)),'LineWidth',2)
axis equal
f2 = figure(2);
hold on;
plot(2.*beam_domain,zeros(length(beam_domain)),'LineWidth',2)

% test5 = rec(pi,pf,v,eb,plane,f1.CurrentAxes,f2.CurrentAxes);
% test5 = con_f(pi,2*vc,'down',1,f1.CurrentAxes);
% test5 = con_m(pi,m,'ccw',1,f1.CurrentAxes);
% test5 = n_tri(pi,pf,v,eb,1,f1.CurrentAxes,f2.CurrentAxes);
% test5 = rev_tri(pi,pf,v,eb,plane,f1.CurrentAxes,f2.CurrentAxes);
% test5 = trap(pi,pf,v,v/2,eb,plane,f1.CurrentAxes,f2.CurrentAxes);
% test5= roller(pi,1,1,f1.CurrentAxes);
% test5 = simple(pi,1,1,f1.CurrentAxes);
mm = fixed(0,1,1, f1.CurrentAxes);

% moment = test5.final_moment;
% zi = linspace(0,4,100).*L;
% assume(L>0)
% moment_plot = subs(moment,z,zi);
% final = double(moment_plot./p./L^2);
% fff = double(zi./L);
% plot(double(zi./L),final)


% x = [0 -0.125 -0.125 0];
% y = [1 1 -1 -1];
% fill(x,y,'r')

set(f1.CurrentAxes,'YLim',1.5.*[-yl yl])
set(f2.CurrentAxes,'YLim',1.5.*[-yl yl])
set(f1.CurrentAxes,'XLim',2.*[-0.75 1.1*xl])
set(f2.CurrentAxes,'XLim',2.*[-0.75 1.1*xl])
% axes(f1.CurrentAxes)
% delete(test5.pl)
% axis equal
% str2
% annotation(f1,"arrow",2,2)