function data = loadco2(fname)
  
  % load entire file into cell of string
  str=textread(fname,'%s','delimiter','\t','emptyvalue',NaN);

  % rearrange into a cell-"table" 
  k = 0;
  while 1>0
  % find the first occurence of ANTXXI/3 (marks the new line)
    k=k+1;
    if strcmp(str{k},'ANTXXI/3'); break; end
  end
  nx = k-1;
  ny = length(str)/nx-1;
  if round(ny) ~= ny;
  keyboard
    error('something wrong with the number of fields')
  end
  str=reshape(str(:),nx,ny+1)';
  
  % rearrange into structure
  for k = 1:nx;
    s0=str{1,k};
    if strcmpi(s0,'Cruise')
      data.cruise = str{2,k};
    elseif strcmpi(s0,'Station')
      data.station = str2num(fname(4:6));
      data.cast    = str2num(fname(7:8));
% $$$       s1=str{2,k};
% $$$       data.station = str2num(s1(1:3));
% $$$       if length(s1) == 4
% $$$ 	alphabet = ['abcdefghijklmnopqrstuvwxyz'];
% $$$ 	data.station = data.station  ...
% $$$ 	    + (findstr(s1(4),alphabet)-1)/length(alphabet);
% $$$       end
    elseif strcmpi(s0,'type')
      data.type = str{2,k};
    elseif strcmpi(s0,'mon/day/yr')
      s1=str{2,k};
      islash=findstr('/',s1);
      yr=str2num(s1(islash(2)+1:end));
      day=str2num(s1(islash(1)+1:islash(2)-1));
      mon=str2num(s1(1:islash(1)-1));
      data.date = yr*1e4+mon*1e2+day;
    elseif strcmpi(s0(1:2),'Lo')
      data.lon = str2num(str{2,k});
    elseif strcmpi(s0(1:2),'La')
      data.lat = str2num(str{2,k});
    elseif strcmpi(s0(1:2),'Bo')
      for kk = 1:ny
	val(kk) = str2num(str{kk+1,k});
      end
      data.depth = val(:);
    elseif ~strcmpi(s0,'QF')
      for kk = 1:ny
	tmp = str2num(str{kk+1,k});
	if isempty(tmp); 
	  val(kk) = NaN;
	else
	  val(kk) = tmp;
	end
      end
%      s0
%      keyboard
      eval(['data.' s0 ' = val(:);'])
    end
  end     
  
  return
