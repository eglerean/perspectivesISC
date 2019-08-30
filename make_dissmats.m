close all;
clear all

output_path = './output/'

% load behavioral scores
DATA = load('data/datatable_emo_plus_socnet.mat');
templabels=DATA.datatableemoplussocnet.Properties.VariableNames';
% get rid of first column
labels=templabels(2:end);
temptable = DATA.datatableemoplussocnet(:,2:end); 
data = table2array(temptable); % convert into matrix

N=size(data,1);
M= size(data,2);

% siz = size(data);
% triu_inds = find(triu(ones(N,N),1));
% dist_mats = nan(length(triu_inds),siz(2));

% compute distances for each variable
for col=1:M
    temp=data(:,col);
    % check if there are NaN
    med=nanmedian(temp);
    temp(find(isnan(temp)))=med;
    dist_mats(:,:,col)=squareform(pdist(temp));
    figure(1)
    subplot(2,4,col)
    imagesc(dist_mats(:,:,col))
end

% interpolate to ISC matrices size
dissimmatrices = zeros(120,120,7);
for i = 1:7
    dissimmatrices(:,:,i)=imresize(dist_mats(:,:,i),4,'nearest'); % the same matrix expanded by 4 so that values are kept in blocks
end


save([output_path 'dissimmatrices.mat'],'dissimmatrices','dist_mats')



