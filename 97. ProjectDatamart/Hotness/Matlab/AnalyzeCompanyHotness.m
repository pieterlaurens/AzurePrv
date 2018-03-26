% b = 'US043432319'; nm = 'Akamai'
b = 'US130871985'; nm = 'IBM'
% b = 'IL30041GE'; nm ='Checkpoint'

%%
conn = database('prv_prj_cybersecurity_hotness','','', 'Vendor','Microsoft SQL Server','Server','nlagpdatacore','AuthType','Windows');
setdbprefs('DataReturnFormat','cellarray')
curs = exec(conn,sprintf('exec GetCompanyHotness ''%s''',b));
zz = fetchmulti(curs);
Hotness = zz.Data{1}; % labels of technologies [id, label]c

curs = exec(conn,sprintf('exec GetCompanyFrontierTechnologies ''%s''',b));
zz = fetchmulti(curs);
Frontier = zz.Data{1}; % labels of technologies [id, label]c

curs = exec(conn,sprintf('exec GetCompanyCompetitivePosition ''%s''',b));
zz = fetchmulti(curs);
CompetitivePosition = zz.Data{1}; % labels of technologies [id, label]c

curs = exec(conn,sprintf('exec GetCompanyScore ''%s''',b));
zz = fetchmulti(curs);
CompanyScore = zz.Data{1}; % labels of technologies [id, label]c

close(conn); close(curs);
%% Company score

figure(1); clf;
ax = axes('Position',[.05 .05 .9 .9],'xlim',[-.9 .9],'ylim',[-.6 1.15]);
axis off

h_endpoint = [0 1];
f_endpoint = [cosd(30) -sind(30)];
c_endpoint = [-cosd(30) -sind(30)];
text(h_endpoint(1),h_endpoint(2),'Hotness','verticalalignment','bottom','horizontalalignment','center','fontsize',16)
text(.9,f_endpoint(2),'Frontier technologies','verticalalignment','top','horizontalalignment','right','fontsize',16)
text(-.9,c_endpoint(2),'Competitive position','verticalalignment','top','horizontalalignment','left','fontsize',16)

a = [240 0 120];
x = zeros(3,3);
y = zeros(3,3);
for i = 1:3 % the difference scores, iterating a
    for j = 1:3 % the different elements, rows in CompanyScore and x/y
        x(j,i) = CompanyScore{j,1+i} * sind(a(i));
        y(j,i) = CompanyScore{j,1+i} * cosd(a(i));        
    end
end

hold on

fill( x(1,:),y(1,:),[.7 .7 .7],'edgecolor','none' ) % outer bound
fill( x(2,:),y(2,:),[1 1 1],'edgecolor','none' ) % inner bound

plot([0 h_endpoint(1)],[0 h_endpoint(2)],'k-','linewidth',.5);
plot(linspace(0,h_endpoint(1),11),linspace(0,h_endpoint(2),11),'k.-','linewidth',.5,'markersize',10);
plot(linspace(0,f_endpoint(1),11),linspace(0,f_endpoint(2),11),'k.-','linewidth',.5,'markersize',10);
plot(linspace(0,c_endpoint(1),11),linspace(0,c_endpoint(2),11),'k.-','linewidth',.5,'markersize',10);

plot(x(3,[1 2 3 1]),y(3,[1 2 3 1]),'r-', 'Linewidth',2)

%% Company Hotness
figure(2); clf;
yy = cell2mat(Hotness(:,1));

axcoa = axes('Position',[.1 .52 .85 .45],'xlim',[yy(1) yy(end)],'ylim',[0 ceil(max(reshape(cell2mat(Hotness(:,2:4)),[],1)))],'xtick',yy(1):2:yy(end),'xticklabel',[],'xgrid','on','fontsize',11);
ylabel('Citations/age')
hold on
fill([yy;flipud(yy)],[cell2mat(Hotness(:,3));flipud(cell2mat(Hotness(:,4)))],[.7 .7 .7],'edgecolor','none')
plot(yy,cell2mat(Hotness(:,2)),'r-','linewidth',2)

rectangle('Position',[yy(2),.85*ceil(max(reshape(cell2mat(Hotness(:,2:4)),[],1))),1,.1*ceil(max(reshape(cell2mat(Hotness(:,2:4)),[],1)))],'facecolor',[.7 .7 .7],'edgecolor','none')
text(yy(2)+1,.9*ceil(max(reshape(cell2mat(Hotness(:,2:4)),[],1))),' 25-75% benchmark','verticalalignment','middle','horizontalalignment','left','fontsize',12)

axy3c = axes('Position',[.1 .05 .85 .45],'xlim',[yy(1) yy(end)],'ylim',[0 ceil(max(reshape(cell2mat(Hotness(:,5:7)),[],1)))],'xtick',yy(1):2:yy(end),'xgrid','on','fontsize',11);
ylabel('Y3 Citations')
hold on
fill([yy;flipud(yy)],[cell2mat(Hotness(:,6));flipud(cell2mat(Hotness(:,7)))],[.7 .7 .7],'edgecolor','none')
plot(yy,cell2mat(Hotness(:,5)),'r-','linewidth',2)

%% Competitive Position
figure(3); clf;
power = cell2mat(CompetitivePosition(:,5));
dependence = cell2mat(CompetitivePosition(:,7));
name = CompetitivePosition(:,2);
nn = size(CompetitivePosition,1);

ss = max([power;dependence]);

ax = axes('Position',[.05 .1 .9 .85],'xlim',[-1 1],'xtick',-1:.25:1,'xticklabel',-100:25:100,'ylim',[0 nn+2],'xgrid','on','ytick',[], 'fontsize',11);
hold on
text(-1,nn+1,sprintf(' %s citing others',nm),'horizontalalignment','left','verticalalignment','bottom','color','red','fontsize',12)
text(1,nn+1,sprintf('%s cited by others ',nm),'horizontalalignment','right','verticalalignment','bottom','color','green','fontsize',12)

for i = 1:nn
    rectangle('Position',[-dependence(i)/ss i-.25 dependence(i)/ss .5],'facecolor',[1 .5 .5],'edgecolor','none')
    rectangle('Position',[0 i-.25 power(i)/ss .5],'facecolor',[.5 1 .5],'edgecolor','none')
    text(-1,i,[' ' name{i}],'verticalalignment','middle','horizontalalignment','left','fontsize',10)
end
xlabel('% of maximum citations')
%% Frontier technologies
figure(4); clf;
npatents = cell2mat(Frontier(:,4));
ntoppatents = cell2mat(Frontier(:,5));
name = Frontier(:,2);
nn = min(10,size(Frontier,1));

ss = max(npatents);

ax = axes('Position',[.3 .13 .65 .85],'xlim',[0 ss],'ylim',[.5 nn+.5],'xgrid','on','ytick',1:nn,'yticklabel',name,'fontsize',11);
hold on

for i = 1:nn
    rectangle('Position',[0 i-.25 npatents(i) .25],'facecolor',[0 0 0],'edgecolor','none')
    rectangle('Position',[0 i ntoppatents(i) .25],'facecolor',[.5 .5 .5],'edgecolor','none')
%     text(0,i,[' ' name{i}],'verticalalignment','middle','horizontalalignment','left','fontsize',7)
end

rectangle('Position',[ss*.85 nn-.3 ss*.1 .2],'facecolor',[0 0 0],'edgecolor','none')
rectangle('Position',[ss*.85 nn ss*.1 .2],'facecolor',[.5 .5 .5],'edgecolor','none')
text(ss*.85, nn-.2,'# patents in technology ','verticalalignment','middle','horizontalalignment','right','fontsize',12)
text(ss*.85, nn+.1,'# patents among top-cited 10% ','verticalalignment','middle','horizontalalignment','right','fontsize',12)
xlabel('Number of patents')
