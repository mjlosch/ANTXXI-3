% 1) read arrays of 3-hourly data of
% uwind,vwind,atemp,dewpoint,dampfdruck,press,aqh,cloudcover
load('../output_tmp/antxxi.mat')

% meteological data starts from Jan 21 at 6pm!
% not just die duration of fertilisation!

%---------------------------------------
% interpolate linearly over data gaps
%---------------------------------------
in=find(~isnan(uwind)); uwind=interp1(time(in),uwind(in),time,'linear','extrap');
in=find(~isnan(vwind)); vwind=interp1(time(in),vwind(in),time,'linear','extrap');
in=find(~isnan(atemp)); atemp=interp1(time(in),atemp(in),time,'linear','extrap');
in=find(~isnan(dewpoint)); dewpoint=interp1(time(in),dewpoint(in),time,'linear','extrap');
in=find(~isnan(dampfdruck)); dampfdruck=interp1(time(in),dampfdruck(in),time,'linear','extrap');
in=find(~isnan(press)); press=interp1(time(in),press(in),time,'linear','extrap');
in=find(~isnan(aqh)); aqh=interp1(time(in),aqh(in),time,'linear','extrap');
in=find(~isnan(cloudcover));   
cloudcover = interp1(time(in),cloudcover(in),time,'linear','extrap');
cloudcover(find(cloudcover>1))=1;
cloudcover(find(cloudcover<0))=0;

%---------------------------------------
% calculate downward longwave radiation
%---------------------------------------
% parameterization of Koenig+Augstein, 1994, Meterologische Zeitschrift,
% N.F. 3.Jg. 1994, H.6
effEmissivity=0.765+.22*cloudcover.^3;
stefanBoltzmannConstant=5.6693e-8; % W/m^2/K^4
tk = atemp+273.15;
% Stefan-Boltzmann law
lwdown = stefanBoltzmannConstant*effEmissivity.*tk.^4;

%---------------------------------------
% extrapolate over the entire mesh 
nx = 42;
ny = 54;
lonb = [1.35, 3.445]; 
lon_dc = diff(lonb)/(nx-1);
lonc = ((lonb(1)+lon_dc):lon_dc:(lonb(end)+lon_dc))';
latb = [-50.55, -48.80]; 
lat_dc = diff(latb)/(ny-1);
latc = ((latb(1)+lat_dc):lat_dc:(latb(end)+lat_dc))';

nt = length(time);
u_wind=ones(nx,ny,nt)*NaN;
v_wind=ones(nx,ny,nt)*NaN;
a_temp=ones(nx,ny,nt)*NaN;
dew_point=ones(nx,ny,nt)*NaN;
vap_pres=ones(nx,ny,nt)*NaN;
pres=ones(nx,ny,nt)*NaN;
a_qh=ones(nx,ny,nt)*NaN;
lw_down=ones(nx,ny,nt)*NaN;

for i=1:nt
    u_wind(:,:,i)=repmat(uwind(i),[nx,ny]);
    v_wind(:,:,i)=repmat(vwind(i),[nx,ny]);
    a_temp(:,:,i)=repmat(atemp(i),[nx,ny]);
    dew_point(:,:,i)=repmat(dewpoint(i),[nx,ny]);
    vap_pres(:,:,i)=repmat(dampfdruck(i),[nx,ny]);
    pres(:,:,i)=repmat(press(i),[nx,ny]);
    a_qh(:,:,i)=repmat(aqh(i),[nx,ny]);
    lw_down(:,:,i)=repmat(lwdown(i),[nx,ny]);    
end

% 2) read data of precipitation and shortwave radiation from poldat
% measured every 10 minutes, starting from Jan 21 18:00
load('../output_tmp/antxxi_poldat.mat')
% average to 3-hourly, same as 508 points in antxxi.mat
time2=time(1):0.0069:(time(1)+9126*0.0069);
in=find(~isnan(swdown)); swdown2=interp1(time(in),swdown(in),time2,'linear','extrap');

dt = 1;
for i = 1:508
    if dt+17>length(time2) break
    else
        swdown_3h(i) = mean(swdown2(dt:dt+17));
        dt = dt+18;
    end
end

prec='real*8';
ieee='ieee-be';
fid=fopen('../output_tmp/uwind.42x54.3hourly','w',ieee);fwrite(fid,u_wind,prec);fclose(fid);
fid=fopen('../output_tmp/vwind.42x54.3hourly','w',ieee);fwrite(fid,v_wind,prec);fclose(fid);
fid=fopen('../output_tmp/atemp.42x54.3hourly','w',ieee);fwrite(fid,a_temp,prec);fclose(fid);
fid=fopen('../output_tmp/dewpoint.42x54.3hourly','w',ieee);fwrite(fid,dew_point,prec);fclose(fid);
fid=fopen('../output_tmp/vappres.42x54.3hourly','w',ieee);fwrite(fid,vap_pres,prec);fclose(fid);
fid=fopen('../output_tmp/press.42x54.3hourly','w',ieee);fwrite(fid,pres,prec);fclose(fid);
fid=fopen('../output_tmp/aqh.42x54.3hourly','w',ieee);fwrite(fid,a_qh,prec);fclose(fid);
fid=fopen('../output_tmp/lwdown.42x54.3hourly','w',ieee);fwrite(fid,lw_down,prec);fclose(fid);
fid=fopen('../output_tmp/swdown_new.42x54.3hourly','w',ieee);fwrite(fid,swdown_3h,prec);fclose(fid);

