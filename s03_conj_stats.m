
clear all
close all

addpath(genpath('/Users/enrico/code/bramila/'))


mantel_files={
    'output/mantel//persfmri_vs_v1-tfce.nii'
'output/mantel//persfmri_vs_v2-tfce.nii'
'output/mantel//persfmri_vs_v3-tfce.nii'
'output/mantel//persfmri_vs_v4-tfce.nii'
'output/mantel//persfmri_vs_v5-tfce.nii'
'output/mantel//persfmri_vs_v6-tfce.nii'
'output/mantel//persfmri_vs_v7-tfce.nii'
};

mantel_filesC={
    'output/mantel//persfmri_vs_v1-cluster.nii'
'output/mantel//persfmri_vs_v2-cluster.nii'
'output/mantel//persfmri_vs_v3-cluster.nii'
'output/mantel//persfmri_vs_v4-cluster.nii'
'output/mantel//persfmri_vs_v5-cluster.nii'
'output/mantel//persfmri_vs_v6-cluster.nii'
'output/mantel//persfmri_vs_v7-cluster.nii'
};

pov_file='output/other_maps/pov_1minus3_TH.nii'
niipov=load_nii(pov_file);
TH=0;
posNum_pov=length(find(niipov.img>TH));
negNum_pov=length(find(niipov.img<-TH));

disp(['POV voxels with condition 1 > 3: ' num2str(posNum_pov)])
disp(['POV voxels with condition 1 < 3: ' num2str(negNum_pov)])

for posneg=1:2
    if(posneg ==1)
            disp(['Overlap between POV 1>3 and other factors'])
            povmask=niipov.img>TH;
        else
            disp(['Overlap between POV 1<3 and other factors'])
            povmask=niipov.img<-TH;
    end
        
    for r=1:length(mantel_files);
        nii=load_nii(mantel_files{r});
        overlapVOL=nii.img.*double(povmask);
        overlap=length(find(nii.img.*povmask~=0));
        disp([num2str(r) '; ' num2str(overlap)])
        filename=['output/overlap/' num2str(r) '_' num2str(posneg) '.nii'];
        disp(filename)
        save_nii(make_nii(overlapVOL),filename);
        niiout=bramila_fixOriginator(filename);
        save_nii(niiout,filename);
    end
end


%% actual conjunction


load output/pov_1minus3_pvals.mat % var op
for posneg=1:2
    if(posneg ==1)
            disp(['Overlap between POV 1>3 and other factors'])
            povmask=niipov.img>TH;
        else
            disp(['Overlap between POV 1<3 and other factors'])
            povmask=niipov.img<-TH;
    end

for r=1:length(mantel_files)
    load(['output/mantel/persfmri_vs_v' num2str(r) '.mat']); % variable results
    for x=1:91
        for y=1:109
            for z=1:91
                if(povmask(x,y,z)==1)
                    conj(x,y,z)=max(results.stats.tfce_pval_corrected(x,y,z),op(x,y,z));
                else
                    conj(x,y,z)=max(results.stats.tfce_pval_corrected(x,y,z),1-op(x,y,z));
                end
            end
        end
    end
    q=mafdr(conj(results.mask_ind),'BHFDR','true');
    overlap=length(find(q<0.05));
    %overlap=length(find(conj<0.05/7));
    disp([num2str(r) '; ' num2str(overlap)])
end
end
    
    