conn = database('company_hotness','','', 'Vendor','Microsoft SQL Server','Server','nlams10859','AuthType','Windows');
curs = exec(conn,'exec GetTechnologyTopicsQuality');
d = fetchmulti(curs);
close(conn); close(curs);
clear conn curs;

aggregations = {'Families','Classes','Companies'};

technologies = d.Data{1};
%%
for i = 2:length(d.Data)
    plotTopicQuality(i-1,cell2mat(d.Data{i}(:,3:5)),aggregations{i-1},technologies(:,[1 2]),cell2mat(technologies(:,[1 3])))
end 