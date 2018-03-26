conn = database('company_hotness','','', 'Vendor','Microsoft SQL Server','Server','nlams10859','AuthType','Windows');
setdbprefs('DataReturnFormat','cellarray')
curs = exec(conn,'exec GetTechnologyHotnessTablesForMatlab');
zz = fetchmulti(curs);
close(conn); close(curs);
tm = zz.Data{1}; % labels of technologies [id, label]c
tfc = cell2mat(zz.Data{2}); 
bm = cell2mat(zz.Data{3});
%% distribution of Y3 citations per technology
start_year = 1990; end_year = 2013;


n = size(tm,1);
nn = size(tfc,1);
h = figure(1); clf


plot(tfc(:,4)+.03*randn(nn,1),tfc(:,1)+.03*randn(nn,1),'k.'); hold on
for i = 1:n
    m = quantile(tfc(tfc(:,1)==i,4),[.75 .95 .99]);
    plot(m,[i i i]+.1,'r-+','markersize',10)
end
set(gca,'xlim',[0 50],'ytick',1:n,'yticklabel',tm(:,2))
title('Distribution of Y3 citations over Technologies')
legend('y3 citations, indiv. patents','75, 95 and 99th percentile')

figure(2); clf
for i=1:n
    subplot(3,2,i);
    ii = find(tfc(:,1)==i & tfc(:,3)>=start_year);
    plot(tfc(ii,3)+.03*randn(length(ii),1),tfc(ii,4)+.03*randn(length(ii),1),'k.'); hold on
    axis([start_year-.3 end_year+.3 0 50])
    set(gca,'ytick',0:10:50,'ygrid','on')
    for j = start_year:end_year
        m = quantile(tfc(ii(tfc(ii,3)==j),4),[.75 .95 .99]);
        plot([j j j]+.1,m,'r-+','markersize',5)
    end
    title( sprintf('%s [n=%d, q75,95=%2.0f,%2.0f]',tm{i,2},length(ii),quantile(tfc(ii,4),.75),quantile(tfc(ii,4),.95)) )
    if(i==1)
        legend('y3 citations, indiv. patents','75, 95 and 99th percentile')
    end
end


figure(3); clf
for i=1:n
    subplot(3,2,i);
    ii = find(tfc(:,1)==i & tfc(:,3)>=start_year);
    
    jj = start_year:end_year;
    m = zeros(length(jj),1);
    for j = 1:length(jj)
        m(j) = sum(tfc(ii,3)==jj(j));
    end
    
    plot(jj,m,'k.-'); hold on
    xlim([start_year-.3 end_year+.3])
%     set(gca,'ytick',0:10:50,'ygrid','on')
    title( sprintf('%s [n=%d]',tm{i,2},length(ii) ) )
    if(i==1)
        legend('# filings on topic')
    end
end


figure(4); clf
for i=1:n
    subplot(3,2,i);
    ii = find(tfc(:,1)==i & tfc(:,3)>=start_year);
    idbm = find(bm(:,1)==i);

    jj = start_year:end_year;
    m = zeros(length(jj),1);
    for j = 1:length(jj)
        m(j) = sum(tfc(ii,3)==jj(j));
    end
    
    plot(jj,m./sum(m),'k.-'); hold on
    plot(bm(idbm,2),(bm(idbm,3)+bm(idbm,9)) ./ sum(bm(idbm,3)+bm(idbm,9)),'r.-'); hold on
    xlim([start_year-.3 end_year+.3])
%     set(gca,'ytick',0:10:50,'ygrid','on')
    title( sprintf('%s [n=%d, %%_{in}=%4.2f]',tm{i,2},length(ii),100*sum(bm(idbm,3))/sum(bm(idbm,9)) ) )
    if(i==1)
        legend('% filings on topic','%filings overall')
    end
end

