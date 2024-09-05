% ADCP measurements averaged to station coorindates
load ant21_3_grid5_adcp_xy xyt year_base z
load ant21_3_grid5_adcp_uv uv

uadcp = uv(:,1:2:end);
vadcp = uv(:,2:2:end);

lonadcp = xyt(1,:)';
latadcp = xyt(2,:)';
timadcp = xyt(3,:)';

zadcp = -abs(z);
refdate = datenum(sprintf('01/01/%i',year_base));
clear z uv xyt 

% 2004/02/14 05:45:00 to 2004/02/14 06:03:00 /* Station 428 */
tmp = textread('ant21_3_grid5_time.txt','%s','headerlines',1);
tmp(strcmp(tmp,'to'))=[];
tmp(strcmp(tmp,'/*'))=[];
tmp(strcmp(tmp,'Station'))=[];
tmp(strcmp(tmp,'deep'))=[];
tmp(strcmp(tmp,'CTD'))=[];
tmp(strcmp(tmp,'*/'))=[];
tmp = reshape(tmp,5,80)';

station = zeros(size(tmp,1),1);
starttime = station;
endtime   = starttime;
for k=1:size(tmp,1)
  starttime(k) = datenum(sprintf('%s %s',tmp{k,1},tmp{k,2}),'yyyy/mm/dd HH:MM:SS');
  endtime(k)   = datenum(sprintf('%s %s',tmp{k,3},tmp{k,4}),'yyyy/mm/dd HH:MM:SS');
  station(k)   = str2num(tmp{k,5});
end
