function plotTopicQuality(kk,nn,thisType,technology_label,technology_size)
    h = figure(kk); clf;

    %%
    % load nn to be the matrix with three columns: tech ID1, techid2 and #overlap
    % load technology_size from query
    nnn = zeros(0,3); %ones( length(technology_size) * (length(technology_size)-1) / 2,3 );
    nns = zeros(0,3); %ones( length(technology_size) * (length(technology_size)-1) / 2,3 );
    for i = 1:max(technology_size(:,1))
        ni = technology_size( technology_size(:,1)==i,2);
        for j = i+1:max(technology_size(:,1))
            nj = technology_size( technology_size(:,1)==j,2);
            ii = find( (nn(:,1)==i & nn(:,2)==j) | (nn(:,2)==i & nn(:,1)==j) );
            if(isempty(ii))
                nnn(end+1,:) = [i j 1];
            elseif(length(ii)==1)
                nnn(end+1,:) = [i j 1 - (nn(ii,3) / min([ni nj]))];
                nns(end+1,:) = [i j (nn(ii,3) / min([ni nj]))];
            else
                fprintf('multiple found for %d and %d.\n',i,j);
            end
        end
    end
    z = linkage(nnn(:,3)');

    nnn = [nnn;[nnn(:,2) nnn(:,1) nnn(:,3)]];
    nns = [nns;[nns(:,2) nns(:,1) nns(:,3)]];
    
    subplot(1,3,1); [~,~,r] = dendrogram(z,0,'Orientation','left');
    ylim([.5 length(r)+.5]);
    r_ = zeros(length(r),1);
    r_(r) = 1:length(r);
%     nnnf = full(sparse(nnn(:,1),nnn(:,2),nnn(:,3),size(technology_size,1),size(technology_size,1)));
%     nnsf = full(sparse(nns(:,1),nns(:,2),nns(:,3),size(technology_size,1),size(technology_size,1)));
    nnnf = full(sparse(r_(nnn(:,1)),r_(nnn(:,2)),nnn(:,3),size(technology_size,1),size(technology_size,1)));
    nnsf = full(sparse(r_(nns(:,1)),r_(nns(:,2)),nns(:,3),size(technology_size,1),size(technology_size,1)));    
    
    subplot(1,3,2); imagesc(flipud(nnnf))
%     subplot(1,3,2); imagesc(nnnf(r,r))
    set(gca,'xtick',1:size(nnnf,1),'ytick',1:size(nnnf,1),'xticklabel',r,'yticklabel',technology_label(fliplr(r),2))
    subplot(1,3,3); imagesc(flipud(log(1+nnsf)))
%     subplot(1,3,3); imagesc(log(1+nnsf(r,r)))
    set(gca,'xtick',1:size(nnsf,1),'ytick',1:size(nnsf,1),'xticklabel',r,'yticklabel',fliplr(r))

    title(strrep(thisType,'_',' '));
    set(h,'position',[kk*50 kk*50 1470 420]);
end

