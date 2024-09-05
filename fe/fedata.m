load('../timeline.mat');
k=1;
station(k)=42003;
lat(k) = -(49+44/60);
lon(k) = 18+20/60;
month(k)=2;
day(k)=2;
year(k)=2004;
hour(k)=9;
minute(k)=0;


%  Depth [DFe]   [TFe]   NOx     NO2     NO3     NH4     Si  
a=[   40     NaN     NaN   28.39    0.25   28.14    0.45   27.22    1.89; ...
      50     NaN     NaN   28.46    0.22   28.24    0.37   27.62    1.88; ...
      60     NaN     NaN   28.46    0.23   28.23    0.41   27.85    1.88; ...
      70     NaN     NaN   28.62    0.23   28.39    0.49   27.95    1.93; ...
      80     NaN     NaN   28.64    0.23   28.41    0.65   28.07    1.93; ...
      90     NaN     NaN   28.98    0.23   28.75    0.72   29.67    1.97; ...
     100     NaN     NaN   29.69    0.22   29.47    0.90   33.00    2.05; ...
     110     NaN     NaN   29.94    0.21   29.73    0.93   33.76    2.07]; 

depth{k} = a(:,1);
DFe{k} = a(:,2);      
TFe{k} = a(:,3);
SolFe{k} = NaN*ones(size(a(:,3)));
NOx{k} = a(:,4);      
NO2{k} = a(:,5);      
NO3{k} = a(:,6);      
NH4{k} = a(:,7);      
Si{k}  = a(:,8);

k=2;
station(k)=42701;
lat(k) = -(49+12.01/60);
lon(k) = 2+5.99/60;
month(k)=2;
day(k)=13;
year(k)=2004;
hour(k)=18;
minute(k)=0;

%Depth   [DFe]   [TFe]   NOx     NO2     NO3     NH4     Si      PO4     ID#     notes:
a = [ 30   NaN      NaN      0.22   24.39    0.61   18.10    1.69; ...
      40   NaN      NaN      0.22   24.37    0.57   17.98    1.69; ...
      50   NaN      NaN      0.22   24.41    0.56   18.03    1.68; ...
      60   0.023    NaN      0.22   24.37    0.57   18.02    1.69; ...
      75   0.039    NaN      0.21   24.40    0.74   18.39    1.66; ...
      85   0.031    NaN      0.21   24.47    0.79   18.61    1.69; ...
      95  -0.018    NaN      0.21   24.50    0.81   18.54    1.69; ...
     105   NaN      NaN      0.21   24.50    0.88   18.56    1.71]; 
depth{k} = a(:,1);
DFe{k} = a(:,2);      
TFe{k} = a(:,3);
SolFe{k} = NaN*ones(size(a(:,3)));
NOx{k} = a(:,4);      
NO2{k} = a(:,5);      
NO3{k} = a(:,6);      
NH4{k} = a(:,7);      
Si{k}  = a(:,8);

k=3;
station(k)=46602;
lat(k) = -(49+00.37/60);
lon(k) = 2+15.34/60;
month(k)=2;
day(k)=17;
year(k)=2004;
hour(k)=18;
minute(k)=0;
%Depth   [DFe]    [TFe]   NOx     NO2     NO3     NH4     Si      PO4     ID#     notes:
a=[   35  2.432   1.442; ...
      55  0.347   0.884; ...
      75  0.206   0.343; ...
      95  0.358   0.659]; ...
depth{k} = a(:,1);
DFe{k} = a(:,2);      
TFe{k} = a(:,3);
SolFe{k} = NaN*ones(size(a(:,3)));
NOx{k} = NaN*ones(size(a(:,3)));      
NO2{k} = NaN*ones(size(a(:,3)));      
NO3{k} = NaN*ones(size(a(:,3)));      
NH4{k} = NaN*ones(size(a(:,3)));      
Si{k}  = NaN*ones(size(a(:,3)));      

k=4;
station(k)=50802;
lat(k) = -(49+12.22/60);
lon(k) = 2+0.32/60;
month(k)=2;
day(k)=22;
year(k)=2004;
hour(k)=7;
minute(k)=20;
%Depth   [Sol-Fe] [DFe]   [TFe]   NO2     NO3     NH4     Si      PO4     ID#     notes:
a=[   40  0.210   0.720   0.903; ...
      50  0.117   0.206   0.478; ...
      60  0.063   0.159   0.418; ...
      70  0.049   0.126   0.456; ...
      80  0.086   0.088   0.157; ...
      90  0.070   0.093   0.108; ...
     100  0.051   0.134   0.106; ...
     110  0.056   0.049   0.090];
depth{k} = a(:,1);
SolFe{k} = a(:,2);
DFe{k} = a(:,3);      
TFe{k} = a(:,4);
NOx{k} = NaN*ones(size(a(:,3)));      
NO2{k} = NaN*ones(size(a(:,3)));      
NO3{k} = NaN*ones(size(a(:,3)));      
NH4{k} = NaN*ones(size(a(:,3)));      
Si{k}  = NaN*ones(size(a(:,3)));      

k=5;
station(k)=51303;
lat(k) = -(49+37.13/60);
lon(k) = 2+8.84/60;
month(k)=2;
day(k)=27;
year(k)=2004;
hour(k)=18;
minute(k)=00;
%Depth   [Sol-Fe] [DFe]   [TFe]   NO2     NO3     NH4     Si      PO4     ID#     notes:
a=[   25  7.993   6.913     9.128     0.2   23.12    0.53   13.55    1.54; ...
      35  0.491   0.247     0.638     0.2   23.17    0.23   13.54    1.54; ...
      45  0.829   0.168     0.256     0.2    23.5     0.4   13.61    1.57; ...
      55  1.128   0.365     0.231     0.2   23.87    0.72   13.94    1.64; ...
      60  0.142   0.159     0.172     0.2   23.82     0.5   13.97    1.64; ...
      80  0.106   0.078     0.025     0.2   23.92    0.52   14.24    1.67; ...
     100  0.198   0.058     0.056     0.2   24.02    0.67   14.71    1.68; ...
     120  0.097   0.025     0.127    0.21   24.64    1.08   17.34    1.76];
depth{k} = a(:,1);
SolFe{k} = a(:,2);
DFe{k} = a(:,3);      
TFe{k} = a(:,4);
NO2{k} = a(:,5);      
NO3{k} = a(:,6);      
NH4{k} = a(:,7);      
Si{k}  = a(:,8);
PO4{k} = a(:,9);

k=6;
station(k)=51406;
lat(k) = -(49+15.90/60);
lon(k) = 2+20.30/60;
month(k)=2;
day(k)=20;
year(k)=2004;
hour(k)=18;
minute(k)=00;
% Depth   [Sol-Fe] [DFe]   [TFe]   NO2     NO3     NH4     Si      PO4     ID#     notes:
a=[   25  0.482   0.062     0.073     0.2   23.03    0.54     9.1     1.7; ...
      35  0.559   0.068     0.087     0.2   23.03    0.58    9.14     1.7; ...
      45  0.935   0.050     0.052     0.2   23.03    0.72    9.18     1.7; ...
      55  0.380   0.052     0.274     0.2   23.03    0.54    9.09    1.69; ...
      60  0.166   0.047     0.180    0.19   23.04    0.57    9.06    1.69; ...
      80  0.132   0.068     0.072     0.2   23.29    0.75    10.7    1.72; ...
     100  0.161   0.048     0.054     0.2   23.72    0.95   12.73    1.77; ...
     120  0.101   0.050     0.086    0.21   24.46    1.13   16.14    1.87];
depth{k} = a(:,1);
SolFe{k} = a(:,2);
DFe{k} = a(:,3);      
TFe{k} = a(:,4);
NO2{k} = a(:,5);      
NO3{k} = a(:,6);      
NH4{k} = a(:,7);      
Si{k}  = a(:,8);
PO4{k} = a(:,9);

k=7;
station(k)=54310;
lat(k) = -(49+28.53/60);
lon(k) = 2+27.30/60;
month(k)=3;
day(k)=4;
year(k)=2004;
hour(k)=6;
minute(k)=10;
%Depth   [Sol-Fe]  [DFe]   [TFe]   NO2     NO3     NH4     Si      PO4     ID#     notes:
a=[   25  2.992    0.654     1.253     0.2   22.67     0.6   12.33    1.69; ...
      35  1.236    0.325     0.483     0.2   22.67    0.66   12.32    1.66; ...
      45  2.859    0.539     0.412     0.2    22.6    0.71   12.43    1.64; ...
      55  1.788    0.455     0.479    0.19   22.68    0.46   12.42    1.65; ...
      60  0.811    0.432     0.762     0.2   22.67    0.63    12.4    1.66; ...
      80  0.754    0.395     0.442     0.2   22.74    0.69   12.63    1.67; ...
     100  0.537    0.251     0.548     0.2   23.34    1.05   15.07    1.81; ...
     120  0.625    0.248     0.379    0.21   25.87     1.2   22.58     2.1];
depth{k} = a(:,1);
SolFe{k} = a(:,2);
DFe{k} = a(:,3);      
TFe{k} = a(:,4);
NO2{k} = a(:,5);      
NO3{k} = a(:,6);      
NH4{k} = a(:,7);      
Si{k}  = a(:,8);
PO4{k} = a(:,9);

k=8;
station(k)=54414;
lat(k) = -(49+30.75/60);
lon(k) = 2+3.29/60;
month(k)=3;
day(k)=6;
year(k)=2004;
hour(k)=5;
minute(k)=30;
%Depth   [DFe]     [TFe]   [SolFe]                                         ID#     notes:
a=[   20  0.836    1.353   0.501; ...
      40  0.746    1.460   0.477; ...
      60  0.708    1.164   0.349];
depth{k} = a(:,1);
DFe{k} = a(:,2);      
TFe{k} = a(:,3);
SolFe{k} = a(:,4);
NOx{k} = NaN*ones(size(a(:,3)));      
NO2{k} = NaN*ones(size(a(:,3)));      
NO3{k} = NaN*ones(size(a(:,3)));      
NH4{k} = NaN*ones(size(a(:,3)));      
Si{k}  = NaN*ones(size(a(:,3)));      
PO4{k} = NaN*ones(size(a(:,3)));      
      
k=9;
station(k)=54418;
lat(k) = -(49+30.75/60);
lon(k) = 2+3.29/60;
month(k)=3;
day(k)=6;
year(k)=2004;
hour(k)=9;
minute(k)=00;
%Depth   [DFe]     [TFe]   [SolFe]                                         ID#     notes:
a=[   20  0.358    1.080   0.287; ...
      40  0.548    4.548   0.912; ...
      60  0.399    0.876   0.345];
depth{k} = a(:,1);
DFe{k} = a(:,2);      
TFe{k} = a(:,3);
SolFe{k} = a(:,4);
NOx{k} = NaN*ones(size(a(:,3)));      
NO2{k} = NaN*ones(size(a(:,3)));      
NO3{k} = NaN*ones(size(a(:,3)));      
NH4{k} = NaN*ones(size(a(:,3)));      
Si{k}  = NaN*ones(size(a(:,3)));      
PO4{k} = NaN*ones(size(a(:,3)));      

k=10;
station(k)=54424;
lat(k) = -(49+30.75/60);
lon(k) = 2+3.29/60;
month(k)=3;
day(k)=6;
year(k)=2004;
hour(k)=14;
minute(k)=30;
%Depth   [DFe]     [TFe]   [SolFe]                                         ID#     notes:
a=[   20  0.534    1.120   0.339; ...
      40  1.173    0.858   0.276; ...
      60  0.636    0.753   3.053; ...
      20  0.461    0.832   0.636; ...
      40  0.485    0.547   1.190; ...
      60  0.684    0.601   4.482];
depth{k} = a(:,1);
DFe{k} = a(:,2);      
TFe{k} = a(:,3);
SolFe{k} = a(:,4);
NOx{k} = NaN*ones(size(a(:,3)));      
NO2{k} = NaN*ones(size(a(:,3)));      
NO3{k} = NaN*ones(size(a(:,3)));      
NH4{k} = NaN*ones(size(a(:,3)));      
Si{k}  = NaN*ones(size(a(:,3)));      
PO4{k} = NaN*ones(size(a(:,3)));      

k=11;
station(k)=54448;
lat(k) = -(49+26.82/60);
lon(k) = 1+55.57/60;
month(k)=3;
day(k)=7;
year(k)=2004;
hour(k)=5;
minute(k)=30;
%Depth   [DFe]     [TFe]   [SolFe]                                         ID#     notes:
a=[   20  0.512    0.376; ...
      40  4.526    10.571; ... 
      60  2.268    2.443];
depth{k} = a(:,1);
DFe{k} = a(:,2);      
TFe{k} = a(:,3);
SolFe{k} = NaN*ones(size(a(:,3)));
NOx{k} = NaN*ones(size(a(:,3)));      
NO2{k} = NaN*ones(size(a(:,3)));      
NO3{k} = NaN*ones(size(a(:,3)));      
NH4{k} = NaN*ones(size(a(:,3)));      
Si{k}  = NaN*ones(size(a(:,3)));      
PO4{k} = NaN*ones(size(a(:,3))); 

k=12;
station(k)=54453;
lat(k) = -(49+26.82/60);
lon(k) = 1+55.57/60;
month(k)=3;
day(k)=7;
year(k)=2004;
hour(k)=10;
minute(k)=00;
%Depth   [DFe]     [TFe]   [SolFe]                                         ID#     notes:
a=[   20  0.921    0.608; ...
      40  0.708    0.641; ...
      60  0.583    0.632];
depth{k} = a(:,1);
DFe{k} = a(:,2);      
TFe{k} = a(:,3);
SolFe{k} = NaN*ones(size(a(:,3)));
NOx{k} = NaN*ones(size(a(:,3)));      
NO2{k} = NaN*ones(size(a(:,3)));      
NO3{k} = NaN*ones(size(a(:,3)));      
NH4{k} = NaN*ones(size(a(:,3)));      
Si{k}  = NaN*ones(size(a(:,3)));      
PO4{k} = NaN*ones(size(a(:,3))); 

k=13;
station(k)=54458;
lat(k) = -(49+26.82/60);
lon(k) = 1+55.57/60;
month(k)=3;
day(k)=7;
year(k)=2004;
hour(k)=15;
minute(k)=00;
%Depth   [DFe]     [TFe]   [SolFe]                                         ID#     notes:
a=[   20  0.791    1.790; ...
      40  0.765    0.470; ...
      60  0.848    0.384];
depth{k} = a(:,1);
DFe{k} = a(:,2);      
TFe{k} = a(:,3);
SolFe{k} = NaN*ones(size(a(:,3)));
NOx{k} = NaN*ones(size(a(:,3)));      
NO2{k} = NaN*ones(size(a(:,3)));      
NO3{k} = NaN*ones(size(a(:,3)));      
NH4{k} = NaN*ones(size(a(:,3)));      
Si{k}  = NaN*ones(size(a(:,3)));      
PO4{k} = NaN*ones(size(a(:,3))); 

k=14;
station(k)=55303;
lat(k) = -(49+27.71/60);
lon(k) = 2+25.33/60;
month(k)=3;
day(k)=11;
year(k)=2004;
hour(k)=18;
minute(k)=50;
%Depth   [Sol-Fe]  [DFe]   [TFe]   NO2     NO3     NH4     Si      PO4     ID#     notes:
a=[   30           0.563   1.536; ...
      40           0.591   1.005; ...
      50           0.646   0.770; ...
      60           0.621   0.977; ...
      80           0.493   0.729; ...
     100           0.712   0.757; ...
     120           0.518   0.887; ...
     150           0.502   0.562];
depth{k} = a(:,1);
DFe{k} = a(:,2);      
TFe{k} = a(:,3);
SolFe{k} = NaN*ones(size(a(:,3)));
NOx{k} = NaN*ones(size(a(:,3)));      
NO2{k} = NaN*ones(size(a(:,3)));      
NO3{k} = NaN*ones(size(a(:,3)));      
NH4{k} = NaN*ones(size(a(:,3)));      
Si{k}  = NaN*ones(size(a(:,3)));      
PO4{k} = NaN*ones(size(a(:,3))); 

k=15;
station(k)=57002;
lat(k) = -(49+25.75/60);
lon(k) = 2+03.18/60;
month(k)=3;
day(k)=14;
year(k)=2004;
hour(k)=2;
minute(k)=0;
%Depth   [Sol-Fe]  [DFe]   [TFe]   NO2     NO3     NH4     Si      PO4     ID#     notes:
a=[   20           0.345   0.947   NaN; ...
      30           0.377   0.625   NaN; ...
      40           0.340   NaN     5.439; ...
      50           0.325   0.622   NaN; ...
      60           0.131   0.262   NaN; ...
      80           0.110   0.400   NaN; ...
     100           0.096   0.241   NaN; ...
     120           0.086   0.118   NaN; ...
     150           0.079   0.106   NaN; ...
     200           0.085   0.094   NaN; ...
     250           0.103   0.151   NaN; ...
     300           0.104   0.545   NaN];
depth{k} = a(:,1);
DFe{k} = a(:,2);      
TFe{k} = a(:,3);
SolFe{k} = NaN*ones(size(a(:,3)));
NOx{k} = NaN*ones(size(a(:,3)));      
NO2{k} = a(:,4);
NO3{k} = NaN*ones(size(a(:,3)));      
NH4{k} = NaN*ones(size(a(:,3)));      
Si{k}  = NaN*ones(size(a(:,3)));      
PO4{k} = NaN*ones(size(a(:,3))); 

k=16;
station(k)=58002;
lat(k) = -(49+07.92/60);
lon(k) = 2+15.21/60;
month(k)=3;
day(k)=16;
year(k)=2004;
hour(k)=2;
minute(k)=10;
%Depth   [10mFe]   [DFe]   [TFe]   NO2     NO3     NH4     Si      PO4     ID#     notes:
a=[   20  0.568    4.217   0.908; ...
      30  0.430    0.358   0.718; ...
      40  0.650    0.763   1.999; ...
      50  0.580    0.345   0.564; ...
      60  0.469    0.363   0.415; ...
      80  0.571    0.257   0.759; ...
     100  0.491    0.285   0.435; ...
     120  0.496    0.267   0.443; ...
     150  NaN      0.225   0.279; ...
     200  NaN      0.214   0.340; ...
     250  NaN      0.231   0.472; ...
     300  NaN      0.277   0.405];
depth{k} = a(:,1);
DFe{k} = a(:,3);      
TFe{k} = a(:,4);
SolFe{k} = NaN*ones(size(a(:,3)));
NOx{k} = NaN*ones(size(a(:,3)));      
NO2{k} = NaN*ones(size(a(:,3)));      
NO3{k} = NaN*ones(size(a(:,3)));      
NH4{k} = NaN*ones(size(a(:,3)));      
Si{k}  = NaN*ones(size(a(:,3)));      
PO4{k} = NaN*ones(size(a(:,3))); 

% end of data, now do something with it
for k=1:length(station)
  offset=0;
  if month(k) == 2
    offset=31;
  elseif month(k) == 3
    offset=31+29;
  else
    error('unknown month')
  end
  tim(k) = offset + day(k);
end

tlid=timeline.station*100 + timeline.cast;

stid=[];
la=[];
lo=[];
d=[];
time = [];
days_since_jan01=[];
hours_since_jan01=[];
dfe=[];
tfe=[];
solfe=[];
i0=find(lon<10);
for kk=1:length(i0)
  k=i0(kk);
  dum=ones(size(depth{k}(:)));
  stid=[stid; station(k)*dum];
  lo=[lo;lon(k)*dum];
  la=[la;lat(k)*dum];
  time=[time;tim(k)*dum];
  ik=find(station(k) == tlid);
  if isempty(ik)
    days_since_jan01  = [days_since_jan01; NaN*dum];
    hours_since_jan01 = [hours_since_jan01; NaN*dum];
  else
    if length(ik) > 1
      error('length(ik)>1')
    end
    days_since_jan01  = [days_since_jan01; ...
		    timeline.days_since_jan01(ik)*dum];
    hours_since_jan01 = [hours_since_jan01; ...
		    timeline.hours_since_jan01(ik)*dum];
  end
  d=[d;depth{k}(:)];
  dfe=[dfe;DFe{k}(:)];
  tfe=[tfe;TFe{k}(:)];
  solfe=[solfe; SolFe{k}(:)];
end



feData=struct('station',stid,'time',time, ...
	      'days_since_jan01',days_since_jan01, ...
	      'hours_since_jan01',hours_since_jan01, ...
	      'lon',lo,'lat',la,'depth',d, ...
	      'DFe',dfe,'TFe',tfe,'SolFe',solfe);

save feData feData
