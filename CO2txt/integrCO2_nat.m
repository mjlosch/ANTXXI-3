addpath /Users/mlosch/matlab/co2

load eifex_cdata
% t0 is define as 00:00 UTC of the 13th of February, 2004, per email by
% Volker Strass of Oct26, 2006
t0 = datenum('13-Feb-2004')-datenum('01-Jan-2004');

difflux = 6.22e-2; % gC/d

inpatchstations = [42402 46601 50802 51101 52201 54001 54310 54453 54501 ...
		   55303 57004 58002 59101 59303];
%outpatchstations= [46401 47001 50901 51402 51413 58701 ];
outpatchstations= [46401 47001 50901 51402 54602 58701 ];

outpatchstations;
inpatchstations;

% eliminate outlier
i = find(cData.station*100+cData.cast==52201);
ii = find(cData.tco2(i)<2000);
cData.tco2(i(ii)) = NaN;

hmax = 150;
z = [0:1:hmax]';
clear totco2* time dicflux
for k=1:length(inpatchstations);
  ipi = find(cData.station*100+cData.cast==inpatchstations(k));
  stationcasti(k) = cData.station(ipi(1))*100+cData.cast(ipi(1));
  % inpatch
  co2data = cData.tco2(ipi);
  alkdata = cData.alk(ipi);
  depth = cData.depth(ipi);
  in = find(isnan(co2data));
  co2data(in) = [];
  alkdata(in) = [];
  depth(in)  = [];
  %
  z = [0:1:100]';
  co2_100  = interp1(depth,co2data,z,'linear');
  co2n = interp1(depth,co2data,z,'nearest','extrap');
  in = find(isnan(co2_100));
  co2_100(in) = co2n(in);
  in = find(~isnan(co2_100));
  totco2_100i(k) = trapz(z(in),co2_100(in));
  % 
  z = [0:1:150]';
  co2_150  = interp1(depth,co2data,z,'linear');
  co2n = interp1(depth,co2data,z,'nearest','extrap');
  in = find(isnan(co2_150));
  co2_150(in) = co2n(in);
  in = find(~isnan(co2_150));
  totco2_150i(k) = trapz(z(in),co2_150(in));
  timei(k) = min(cData.hours_since_jan01(ipi)/24);
  if isnan(timei(k))
    timei(k) = mean(cData.time(ipi));
  end
end
for k=1:length(outpatchstations);
  ipo = find(cData.station*100+cData.cast==outpatchstations(k));
  if outpatchstations(k)==54602
    ipo = [ipo;find(cData.station*100+cData.cast==54614)];
  end
  stationcasto(k) = cData.station(ipo(1))*100+cData.cast(ipo(1));
  % outpatch
  co2data = cData.tco2(ipo);
  alkdata = cData.alk(ipo);
  depth = cData.depth(ipo);
  in = find(isnan(co2data));
  co2data(in) = [];
  alkdata(in) = [];
  depth(in)  = [];
  %
  z = [0:1:100]';
  co2_100  = interp1(depth,co2data,z,'linear');
  co2n = interp1(depth,co2data,z,'nearest','extrap');
  in = find(isnan(co2_100));
  co2_100(in) = co2n(in);
  in = find(~isnan(co2_100));
  totco2_100o(k) = trapz(z(in),co2_100(in));
  % 
  z = [0:1:150]';
  co2_150  = interp1(depth,co2data,z,'linear');
  co2n = interp1(depth,co2data,z,'nearest','extrap');
  in = find(isnan(co2_150));
  co2_150(in) = co2n(in);
  in = find(~isnan(co2_150));
  totco2_150o(k) = trapz(z(in),co2_150(in));
%  timeo(k) = mean(cData.time(ipo));
  timeo(k) = cData.hours_since_jan01(ipo(1))/24;
end

% compute surface fluxes
u10 = 1*ones(length(inpatchstations),1);
%pco2air0 = 375; 380;
% per V.Strass email (Nov04,2006)
pco2air0= 374.4;
pco2air = pco2air0*ones(length(inpatchstations),1);
met = load('../metdata/antxxi_poldat.mat');
in=find(isnan(met.windspeed));
met.time(in) = [];
met.windspeed(in) = [];
for k=1:length(inpatchstations);
  ipi = find(cData.station*100+cData.cast==inpatchstations(k));
  % inpatch
  u10(k) =interp1(met.time,met.windspeed,cData.time(ipi(1)),'linear');
  thetadata = cData.theta(ipi);
  saldata = cData.sal(ipi);
  co2data = cData.tco2(ipi);
  alkdata = cData.alk(ipi);
  depth = cData.depth(ipi);
  ksurf = 1;
  while ksurf <= length(ipi) & isnan(thetadata(ksurf)+saldata(ksurf) ...
	      +co2data(ksurf)+alkdata(ksurf)) 
    ksurf = ksurf+1;
  end
  if ksurf>length(ipi)
    dicfluxi(k) = NaN;
  else
    dicfluxi(k) = co2flux(co2data(ksurf),alkdata(ksurf), ...
			 thetadata(ksurf),saldata(ksurf), ...
			 pco2air(k),u10(k));
  end
end
u10 = 1*ones(length(outpatchstations),1);
pco2air = pco2air0*ones(length(outpatchstations),1);
for k=1:length(outpatchstations);
  ipo = find(cData.station*100+cData.cast==outpatchstations(k));
  % outpatch
  u10(k) =interp1(met.time,met.windspeed,cData.time(ipo(1)),'linear');
  thetadata = cData.theta(ipo);
  saldata = cData.sal(ipo);
  co2data = cData.tco2(ipo);
  alkdata = cData.alk(ipo);
  depth = cData.depth(ipo);
  ksurf = 1;
  while ksurf <= length(ipo) & isnan(thetadata(ksurf)+saldata(ksurf) ...
	      +co2data(ksurf)+alkdata(ksurf)) 
    ksurf = ksurf+1;
  end
  if ksurf>length(ipo)
    dicfluxo(k) = NaN;
  else
    dicfluxo(k) = co2flux(co2data(ksurf),alkdata(ksurf), ...
			 thetadata(ksurf),saldata(ksurf), ...
			 pco2air(k),u10(k));
  end
end

mmol2g    = 12e-3;
secperday = 86400;

% interpolate dicflux to budget computation times:
in = find(~isnan(dicfluxi));
% hack;
%timei(end) = timei(end)+.1;
dicfluxi = interp1(timei(in),dicfluxi(in),timei,'linear');
%timei(end) = timei(end)-.1;
in = find(~isnan(dicfluxo));
dicfluxo = interp1(timeo(in),dicfluxo(in),timeo,'linear');
% compute integrated flux between stations:
dicuptakei = cumtrapz(timei,dicfluxi*secperday); 
dicuptakeo = cumtrapz(timeo,dicfluxo*secperday); 

diffuptakei = cumsum([0:length(dicuptakei)-1])*difflux; % gC
diffuptakeo = cumsum([0:length(dicuptakeo)-1])*difflux; % gC

clf
sh = subplot(311);
plot(timei-t0,-(totco2_100i-totco2_100i(1)-dicuptakei)*mmol2g+diffuptakei,'x-', ...
     timeo-t0,-(totco2_100o-totco2_100o(1)-dicuptakeo)*mmol2g+diffuptakeo,'o-');
grid
legend('in patch','out patch',2);
title('uptake of TCO2 in upper 100m [gC m^{-2}]')
set(sh,'ylim',[-10 35],'xlim',[-2 37])
set(sh,'box','on','layer','top')

print -painters -dpng uptake100
print -painters -depsc uptake100

pause

clf
sh = subplot(311);
plot(timei-t0,-(totco2_150i-totco2_150i(1)-dicuptakei)*mmol2g+diffuptakei,'x-', ...
     timeo-t0,-(totco2_150o-totco2_150o(1)-dicuptakeo)*mmol2g+diffuptakeo,'o-');
grid
legend('in patch','out patch',2);
title('uptake of TCO2 in upper 150m [gC m^{-2}]')
set(sh,'ylim',[-10 35],'xlim',[-2 37])
set(sh,'box','on','layer','top')

print -painters -dpng uptake150
print -painters -depsc uptake150

% save numbers for volker
ti = timei-t0;
to = timeo-t0;
tco2_150i = -(totco2_150i-totco2_150i(1)-dicuptakei)*mmol2g+diffuptakei;
tco2_150o = -(totco2_150o-totco2_150o(1)-dicuptakeo)*mmol2g+diffuptakeo;
tco2_100i = -(totco2_100i-totco2_100i(1)-dicuptakei)*mmol2g+diffuptakei;
tco2_100o = -(totco2_100o-totco2_100o(1)-dicuptakeo)*mmol2g+diffuptakeo;
save for_volker t0 to ti stationcasto stationcasti tco2_150i tco2_150o ...
    tco2_100i tco2_100o cData 

return
