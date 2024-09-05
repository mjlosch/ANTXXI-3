function data = loadctd(fname);
%function data = loadctd(fname);
  
  fid=fopen(fname,'r');
  stid = fscanf(fid,'%u',1);
  a = fscanf(fid,'%f',4);
  lon = a(3) + a(4)./60;
  lat = a(1) + a(2)./60;

  time = fscanf(fid,'%f',8); % [day month year ?? ?? ?? ?? hour]
  depth = fscanf(fid,'%f',1);
  depthctd = fscanf(fid,'%f',1);
  
  % advance 4 lines
  for k = 1:5; fgetl(fid); end
  
  a=fscanf(fid,'%f');
  
  fclose(fid);
  
  n = 15;
  m = length(a)/n;
  
  b = reshape(a,n,m)';
  nr = b(:,1);
  pres = b(:,2);
  salt = b(:,5);
  ptemp = b(:,6);

  data = struct('stid',stid,'lon',lon,'lat',lat,'time',time,'depth',depth, ...
		'depthctd',depthctd,'nr',nr,'pres',pres,'salt',salt, ...
		'theta',ptemp); 
  return
