function fh = sinking;
% stokes law
eta = 0.008904; % km/(m s)
g   = 9.81;
rsw = 1000;
rhoRef = rsw;
v0 = 700/86400;
v1 = 300/86400;
v2 = 100/86400;
v3 =  10/86400;

rtest = sqrt([0.1 .2 .6]*1e-6/4*pi);

r = 10.^(-linspace(0,10,100));

fh = gcf;
clf
hold on
h0=plot(r,density(rsw,rhoRef,eta,v0,g,r),'m:');
h1=plot(r,density(rsw,rhoRef,eta,v1,g,r),'r-');
h2=plot(r,density(rsw,rhoRef,eta,v2,g,r),'b--');
h3=plot(r,density(rsw,rhoRef,eta,v3,g,r),'g-.');

hh=plot([rtest;rtest],[1e-10*ones(size(rtest)); 1e10*ones(size(rtest))],'k-');
set(hh,'linewidth',2)

legend('v = 700m/day','v = 300m/day','v = 100m/day','v =  10m/day')

set(gca,'xscale','log','yscale','log')

xlabel('radius r [m]')
ylabel(sprintf('density difference %s-%u [kg/m^3]','\rho',rhoRef))
grid on

set([h0;h1;h2;h3],'linewidth',2);

set(gca,'xlim',[1.e-7 1e-2],'ylim',[1e2 1e5],'box','on')
hold off

return

function dens = density(rho0,rhoref,eta,v,g,r)
  dens = .5*(rho0+sqrt(rho0.^2+(18.*eta.*v.*rho0./g)./r.^2))-rhoref;
  return
