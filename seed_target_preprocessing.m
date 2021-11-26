clearvars all;clc

% set paths
addpath ("/home/proactionlab/MATLAB/R2021b/packages/TRENTOOL3-3.4.2")
addpath ("/home/proactionlab/MATLAB/R2021b/packages/fieldtrip-master");
ft_defaults ;

% define data paths
outputpath = "/home/proactionlab/Documents/projects/connectivity/testResults/";
parTCDir = ['/home/proactionlab/Documents/projects/connectivity/THBFP_CVS/' ...
    'ResidualTimeCourse_THBFP_FIR/%s/'];
parSeedDir = '/home/proactionlab/Documents/projects/connectivity/THBFP_CVS/ROIs/SubjReg_SearchSpaces_GM_ASMasked/';
subjRange = [3:30];
seedStr = '%s_%s_10mm_Sphere.nii';
regions = {'lPMTG','lMFus','lIPL'};
TCDataLength = 1100;


% prepare the proposed path
for sbj = subjRange
    cSubj = sprintf('sub-%1.2d',sbj);    
    cSubjTC = sprintf(parTCDir,cSubj);
    files = dir(cSubjTC);
    flag = [files.isdir];
    if isempty(flag),continue,end
    fileName = files(~flag).name;
    cSubjTC = append(cSubjTC, fileName);
    if ~exist(cSubjTC),continue,end

    allSeedTCMat = nan(TCDataLength,size(regions,2));
    for sd =1:size(regions,2)
        cSubjSeed = fullfile(parSeedDir,cSubj, sprintf(seedStr,cSubj,regions{sd}));
        if ~exist(cSubjSeed),continue,end

        % use cosmo to load data
        ds_seed = cosmo_fmri_dataset(cSubjTC,'mask',cSubjSeed);
        ds_seed = cosmo_remove_useless_data(ds_seed);
        allSeedTCMat(:,sd) = mean(ds_seed.samples,2);
    end
    % save data     
    writematrix(allSeedTCMat,append(append(outputpath, cSubj), '.csv')) 
end