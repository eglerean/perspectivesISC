clear all
close all
addpath '/m/nbe/scratch/braindata/shared/toolboxes/NIFTI/';
addpath(genpath('external'));
output_path = [pwd '/output/mantel/'];

threshold = 0.05;

cfg.infile = '/m/nbe/scratch/braindata/bacham1/data_analysis/Articles_niis_and_figs/perspectives/ISC271114_memMaps_matrices.nii';
cfg.mask = '//m/nbe/scratch/braindata/bacham1/data_analysis/Articles_niis_and_figs/perspectives/ISCmask.nii';
load('output/dissimmatrices.mat')
for v = 1:7
	cfg.model = dissimmatrices(:,:,v); 
	results=bramila_mantel_ISC(cfg);
    filename=['persfmri_vs_v' num2str(v)];
	save([output_path filename  '.mat'],'results')

	% Save thresholded T-maps:
	raw_correlation_map = results.raw_correlation_map;
	raw_correlation_map(~(results.stats.raw_pval_corrected<threshold))=0;
	save_nii(make_nii(raw_correlation_map),[output_path filename '.nii'])

	raw_correlation_map = results.raw_correlation_map;
	raw_correlation_map(~(results.stats.cluster_pval_corrected<threshold))=0;
	save_nii(make_nii(raw_correlation_map),[output_path filename '-cluster.nii'])

	raw_correlation_map = results.raw_correlation_map;
	raw_correlation_map(~(results.stats.tfce_pval_corrected<threshold))=0;
	save_nii(make_nii(raw_correlation_map),[output_path filename '-tfce.nii'])
end
