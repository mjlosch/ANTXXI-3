clear

% interpolate different data to common time line, days after 2003-12-31, 00:00
deltaT = 1/24;
firstDay = 22;
lastDay = 85;
firstDay = 31+   11; % 2004-02-11
lastDay  = 31+29+21; % 2004-03-21

myTime = [firstDay:deltaT:lastDay]';
%
% coarse resolution 3-hour routine synoptic observations
%
load ../output_tmp/antxxi time lon lat cloudcover atemp

% parameterization of Koenig+Augstein, 1994, Meterologische Zeitschrift,
% N.F. 3.Jg. 1994, H.6
effEmissivity=0.765+.22*cloudcover.^3;
stefanBoltzmannConstant=5.6693e-8; % W/m^2/K^4
tk = atemp+273.15;
% Stefan-Boltzmann law
lwdown = stefanBoltzmannConstant*effEmissivity.*tk.^4;

tm = time;
% interpolate linearily over data gaps
in=find(~isnan(lwdown));   
lwdown = interp1(tm(in),lwdown(in),myTime,'linear','extrap');
lwdown(find(lwdown<0))=0;

%
% high resolution 10-minute Poldat data
%
load ../output_tmp/antxxi_poldat time lon lat vwind uwind atemp press swdown precip aqh

tm = time;
% interpolate linearily over data gaps
in=find(~isnan(lon)); lon=interp1(tm(in),lon(in),myTime,'linear','extrap');
in=find(~isnan(lat)); lat=interp1(tm(in),lat(in),myTime,'linear','extrap');
in=find(~isnan(uwind)); uwind=interp1(tm(in),uwind(in),myTime,'linear','extrap');
in=find(~isnan(vwind)); vwind=interp1(tm(in),vwind(in),myTime,'linear','extrap');
in=find(~isnan(atemp)); atemp=interp1(tm(in),atemp(in),myTime,'linear','extrap');
in=find(~isnan(press)); press=interp1(tm(in),press(in),myTime,'linear','extrap');
in=find(~isnan(swdown)); swdown=interp1(tm(in),swdown(in),myTime,'linear','extrap');
in=find(~isnan(precip)); precip=interp1(tm(in),precip(in),myTime,'linear','extrap');
in=find(~isnan(aqh)); aqh=interp1(tm(in),aqh(in),myTime,'linear','extrap');
