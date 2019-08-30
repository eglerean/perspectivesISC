clc;
clearvars;
close all;
clear all

%output_path = '/m/nbe/scratch/braindata/bacham1/data_analysis/Articles_niis_and_figs/perspectives/';
output_path = './output/'

% load behavioral scores
DATA = load('datatable_emo_plus_socnet.mat');

mytable = DATA.datatableemoplussocnet(:,2:end); % only take background and IAT scores (first columns)
%subjects = mytable.Properties.RowNames(1:24); % subjects
%subjects = mytable.Properties.RowNames;
%variables = mytable.Properties.VariableNames; % subjects
data = table2array(mytable); % convert into matrix

N=size(data,1);
M = size(data,2);

siz = size(data);
triu_inds = find(triu(ones(N,N),1));
dist_mats = nan(length(triu_inds),siz(2));

% compute distances for each variable
for col=1:siz(2)
    for k=1:length(triu_inds)
        [sub1,sub2]=ind2sub([N,N],triu_inds(k));
        dist_mats(k,col) = data(sub1,col) - data(sub2,col);
    end
end
dist_mats = dist_mats.^2; % square

%create similartity matrices:
simmatrices =[];
dissimmatrices1 =[];
for col=1:siz(2)
    dissimmat = zeros(N);
    dissimmat(triu_inds) = dist_mats(:,col);
    dissimmat = dissimmat + dissimmat';
    dissimmatrices1(:,:,col) =  dissimmat;
    simmat = 1 - dissimmat;% + eye(size(dissimmat));
    simmatrices(:,:,col) =  simmat;
   
end

%a=reshape(1:900,30,[]); % a matrix 6 x 6 with values
dissimmatrices = zeros(120,120,7);
for i = 1:7
    dissimmatrices(:,:,i)=imresize(dissimmatrices1(:,:,i),4,'nearest'); % the same matrix expanded by 4 so that values are kept in blocks
end

save(sprintf('%ssimmatrices_socnet_120.mat',output_path),'simmatrices')
save(sprintf('%sdissimmatrices_socnet_120.mat',output_path),'dissimmatrices')



