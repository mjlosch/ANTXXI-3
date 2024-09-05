% t0 is defined as 00:00 UTC of the 13th of February, 2004, per email by
% Volker Strass of Oct26, 2006
t0 = datenum('13-Feb-2004')-datenum('01-Jan-2004');

load eifex_DONDOC_for_plotting
time_doc = doc_numeric(:,8);
doc100 = doc_numeric(:,2);
doc150 = doc_numeric(:,3);
doc200 = doc_numeric(:,4);

doc_inpatch = [1 zeros(1,8) NaN ones(1,25) NaN zeros(1,4) NaN NaN NaN];
doc_outpatch = [0 ones(1,8) NaN zeros(1,25) NaN ones(1,4) NaN NaN NaN];
doc_inpatch = find(doc_inpatch==1);
doc_outpatch = find(doc_outpatch==1);

sh = subplot(621);
ph1 = plot(time_doc(doc_inpatch),doc100(doc_inpatch),'d', ...
	  time_doc(doc_outpatch),doc100(doc_outpatch),'o');
ylabel('\int DOC dz [mmol m^{-2}]')
title('0 - 100 m')
sh(2) = subplot(623);
ph2 = plot(time_doc(doc_inpatch),doc150(doc_inpatch),'d', ...
	  time_doc(doc_outpatch),doc150(doc_outpatch),'o');
ylabel('\int DOC dz [mmol m^{-2}]')
title('0 - 150 m')
sh(3) = subplot(625);
ph3 = plot(time_doc(doc_inpatch),doc200(doc_inpatch),'d', ...
	  time_doc(doc_outpatch),doc200(doc_outpatch),'o');
ylabel('\int DOC dz [mmol m^{-2}]')
title('150 - 200 m')

% $$$ set(sh,'xlim',[-2 37],'xMinorTick','on','yMinorTick','on')
% $$$ set(sh,'ylim',[1500 9000])
% $$$ 
% $$$ ph = [ph1 ph2 ph3];
% $$$ set(ph,'Color','k')
% $$$ set(ph(1,:),'markerfacecolor','k')
% $$$ return
% $$$ 
% $$$ print -dpng doc.png
% $$$ print -deps doc.eps

boris = load('Boris_Stationstabelle.txt');

inpatch = find(boris(:,end));
outpatch = find(boris(:,end)==0);
statidboris = boris(:,1)*100+boris(:,2);
t0 = datenum('13-Feb-2004')-datenum('01-Jan-2004');
timeboris = datenum(boris(:,[7 6 5 8:10]))-datenum('13-Feb-2004');

don_inpatch = [];
dep_inpatch = [];
tim_inpatch = [];
don_outpatch = [];
dep_outpatch = [];
tim_outpatch = [];
for k = 1:317
  statstr = don_raw{k,1};
  if ~isnan(statstr)
    statid = statstr(1:min(3,length(statstr)));
    statnr = str2num(statid);
    if ~isempty(statnr)
      castnr = statstr(4:end);
      ik = findstr(castnr,'_');
      castnr = str2num(castnr(2:ik-1));
      statid = statnr*100 + castnr;
      ip = find(statidboris(inpatch)==statid);
      op = find(statidboris(outpatch)==statid);
      if ~isempty(ip)
	dep_inpatch = [dep_inpatch; don_raw{k,2}];
	don_inpatch = [don_inpatch; don_raw{k,4}];
	tim_inpatch = [tim_inpatch; timeboris(inpatch(ip))];
      end
      if ~isempty(op)
	dep_outpatch = [dep_outpatch; don_raw{k,2}];
	don_outpatch = [don_outpatch; don_raw{k,4}];
	tim_outpatch = [tim_outpatch; timeboris(outpatch(op))];
      end
    end
  end
end

% No dow the integral
[tip,iti,jti] = unique(tim_inpatch);
[top,ito,jto] = unique(tim_outpatch);

for k=1:length(tip)
  it = find(tim_inpatch==tip(k));
  dep = dep_inpatch(it);
  don = don_inpatch(it);
  i = find(dep<=100);
  in = find(~isnan(don(i)));
  don100_ip(k) = trapz(dep(i(in)),don(i(in)));
  i = find(dep<=150);
  in = find(~isnan(don(i)));
  don150_ip(k) = trapz(dep(i(in)),don(i(in)));
  i = find(dep>=150&dep<=200);
  in = find(~isnan(don(i)));
  if length(in)<2
    don200_ip(k) = NaN;
  else
    don200_ip(k) = trapz(dep(i(in)),don(i(in)));
  end
end
for k=1:length(top)
  it = find(tim_outpatch==top(k));
  dep = dep_outpatch(it);
  don = don_outpatch(it);
  i = find(dep<=100);
  in = find(~isnan(don(i)));
  don100_op(k) = trapz(dep(i(in)),don(i(in)));
  i = find(dep<=150);
  in = find(~isnan(don(i)));
  don150_op(k) = trapz(dep(i(in)),don(i(in)));
  i = find(dep>=150&dep<=200);
  in = find(~isnan(don(i)));
  if length(in)<2
    don200_op(k) = NaN;
  else
    don200_op(k) = trapz(dep(i(in)),don(i(in)));
  end
end
  
sh(4) = subplot(627);
ph4 = plot(tip,don100_ip,'d', ...
	  top,don100_op,'o');
ylabel('\int DON dz [mmol m^{-2}]')
title('0 - 100 m')
sh(5) = subplot(629);
ph5 = plot(tip,don150_ip,'d', ...
	  top,don150_op,'o');
ylabel('\int DON dz [mmol m^{-2}]')
title('100 - 150 m')
sh(6) = subplot(6,2,11);
ph6 = plot(tip,don200_ip,'d', ...
	  top,don200_op,'o');
ylabel('\int DON dz [mmol m^{-2}]')
xlabel('days of experiment')
title('150 - 200 m')

set(sh,'xlim',[-2 37],'xMinorTick','on','yMinorTick','on')
set(sh(1:3),'ylim',[1500 9000])
set(sh(4:6),'ylim',[0 600])

ph = [ph1 ph2 ph3 ph4 ph5 ph6];
set(ph,'Color','k')
set(ph(1,:),'markerfacecolor','k')

set(gcf,'paperPosition',[0.25 0.8436 7.7677 10.0056]);

print -dpng dom.png
print -deps dom.eps
%print -dpng don.png
%print -deps don.eps
