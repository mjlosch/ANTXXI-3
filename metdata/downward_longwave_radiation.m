load antxxi
%load antxxi_poldat

% interpolate linearily over data gaps
in=find(~isnan(cloudcover));   
cc_interp = interp1(time(in),cloudcover(in),time,'linear','extrap');
cc_interp(find(cc_interp>1))=1;
cc_interp(find(cc_interp<0))=0;

% parameterization of Koenig+Augstein, 1994, Meterologische Zeitschrift,
% N.F. 3.Jg. 1994, H.6
effEmissivity=0.765+.22*cc_interp.^3;
stefanBoltzmannConstant=5.6693e-8; % W/m^2/K^4
tk = atemp+273.15;
% Stefan-Boltzmann law
lwdown = stefanBoltzmannConstant*effEmissivity.*tk.^4;


