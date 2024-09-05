addpath ~/matlab/co2
load eifex_cdata
% t0 is define as 00:00 UTC of the 13th of February, 2004, per email by
% Volker Strass of Oct26, 2006
t0 = datenum('13-Feb-2004')-datenum('01-Jan-2004');

inpatchstations = [42402 46601 50802 51101 52201 54001 54310 54453 54501 ...
		   55303 57004 58002 59101 59303];
%outpatchstations= [46401 47001 50901 51402 51413 58701 ];
outpatchstations= [46401 47001 50901 51402       58701 ];
%outpatchstations= [46401 47001 50901 51402 54602 58701 ];

stations = outpatchstations;
%stations = inpatchstations;

% eliminate outlier
i = find(cData.station*100+cData.cast==52201);
ii = find(cData.tco2(i)<2000);
cData.tco2(i(ii)) = NaN;

ip = find(ismember(cData.station*100+cData.cast,stations));

sh = subplot(311);
h = scatter(cData.time(ip)-t0,-cData.depth(ip),20,cData.tco2(ip),'filled');
%set(sh(1),'ylim',[-500 0],'clim',[2115 2250])
colorbar('h')
title('observed TCO2 [mmol m^{-3}]')
ylabel('depth [m]')
set(sh(1),'ylim',[-300 0],'clim',[2115 2200]);

hmax = 150;
z = [0:1:hmax]';
clear totco2* time dicflux
for k=1:length(stations);
  ip = find(cData.station*100+cData.cast==stations(k));
  z = [0:1:100]';
  co2data = cData.tco2(ip);
  alkdata = cData.alk(ip);
  depth = cData.depth(ip);
  in = find(isnan(co2data));
  co2data(in) = [];
  alkdata(in) = [];
  depth(in)  = [];
  co2_100  = interp1(depth,co2data,z,'linear');
  co2n = interp1(depth,co2data,z,'nearest','extrap');
  in = find(isnan(co2_100));
  co2_100(in) = co2n(in);
  in = find(~isnan(co2_100));
  totco2_100(k) = trapz(z(in),co2_100(in));
  % 
  z = [0:1:150]';
  co2_150  = interp1(depth,co2data,z,'linear');
  co2n = interp1(depth,co2data,z,'nearest','extrap');
  in = find(isnan(co2_150));
  co2_150(in) = co2n(in);
  in = find(~isnan(co2_150));
  totco2_150(k) = trapz(z(in),co2_150(in));
  time(k) = mean(cData.time(ip));
end

clf
sh(2) = subplot(312);
plot(time-t0,(totco2_100-totco2_100(1))*12e-3,'x-', ...
     time-t0,(totco2_150-totco2_150(1))*12e-3,'o-');
legend('100m','150m',3);
title('change in vertically integrated TCO2 [gC m^{-2}]')
set(sh(2),'ylim',[-25 5])
%set(sh(2),'ylim',[-25 0])

set(sh,'box','on','layer','top')

% compute surface fluxes
u10 = 1*ones(length(stations),1);
%pco2air0 = 375; 380;
% per V.Strass email (Nov04,2006)
pco2air0= 374.4;
pco2air = pco2air0*ones(length(stations),1);
met = load('../metdata/antxxi_poldat.mat');
in=find(isnan(met.windspeed));
met.time(in) = [];
met.windspeed(in) = [];
for k=1:length(stations);
  ip = find(cData.station*100+cData.cast==stations(k));
  u10(k) =interp1(met.time,met.windspeed,cData.time(ip(1)),'linear');
  thetadata = cData.theta(ip);
  saldata = cData.sal(ip);
  co2data = cData.tco2(ip);
  alkdata = cData.alk(ip);
  depth = cData.depth(ip);
  ksurf = 1;
  while ksurf <= length(ip) & isnan(thetadata(ksurf)+saldata(ksurf) ...
	      +co2data(ksurf)+alkdata(ksurf)) 
    ksurf = ksurf+1;
  end
  if ksurf>length(ip)
    dicflux(k) = NaN;
  else
    dicflux(k) = co2flux(co2data(ksurf),alkdata(ksurf), ...
			 thetadata(ksurf),saldata(ksurf), ...
			 pco2air(k),u10(k));
  end
end

sh(3) = subplot(313);
mmol2g    = 12e-3;
secperday = 86400;
in = find(~isnan(dicflux));
plot(time(in)-t0,dicflux(in)*mmol2g*secperday,'o-')
title(sprintf('%s%s%5.1f%s', ...
	      'surface flux of CO_2 into the ocean [gC m^{-2} d^{-1}] ', ...
	      '(pCO2_{a} = ', pco2air0, ' ppm)'))
set(sh(3),'ylim',[0 .6])
text(time(1)-t0,0.5,sprintf('total flux = %10.4f gC m^{-2}', ...
			 trapz(time(in),dicflux(in))*mmol2g*secperday))
xlabel('days since T_0 (first iron fertilization)')
set(sh,'box','on','layer','top')

set(sh,'xlim',[-2 37])

return
print -painters -dpng inpatch.png
print -painters -depsc inpatch.eps
print -painters -dpng outpatch.png
print -painters -depsc outpatch.eps
