clear;
maindir = pwd;
subnums = dir(fullfile(maindir,'data'));
subnums = struct2cell(subnums);
subnums = subnums(1,4:end);

ped = {'LR', 'RL'};

for s = 1:length(subnums)
    for p = 1:2
        % mycmd = ['grep -v [A-Za-df-z] design.mat | grep [0-9] > design.mtx'];
        
        featdir = fullfile(maindir,'data',subnums{s},['tfMRI_GAMBLING_' ped{p}],'lev1.feat');
        infile = fullfile(featdir,'design.mat');
        outfile = fullfile(featdir,'design.mtx');
        mycmd = ['grep -v [A-Za-df-z] ' infile ' | grep [0-9] > ' outfile];
        system(mycmd);
        
    end
end