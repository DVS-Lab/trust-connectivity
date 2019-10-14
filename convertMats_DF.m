clear;
maindir = pwd;
subnums = 2:32;
skips = [13 14 15 23 29];
[a,b] = ismember(skips,subnums);
subnums(b) = [];


for s = 1:length(subnums)
    for r = 1:6
        % mycmd = ['grep -v [A-Za-df-z] design.mat | grep [0-9] > design.mtx'];
        
        if str2double(subnums(s)) == 12 && r == 5
            continue
        end
        featdir = fullfile(maindir,'FilesForDave_11_2017',sprintf('sub%02d',subnums(s)));
        infile = fullfile(featdir,sprintf('sub%02d_r%d_design.mat',subnums(s),r));
        outfile = fullfile(featdir,sprintf('sub%02d_r%d_design.mtx',subnums(s),r));
        mycmd = ['grep -v [A-Za-df-z] ' infile ' | grep [0-9] > ' outfile];
        system(mycmd);
        
    end
end