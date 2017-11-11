clear;
maindir = pwd;
subnums = dir(fullfile(maindir,'data'));
subnums = struct2cell(subnums);
subnums = subnums(1,4:end);

nets = [4 8 9 10];
resultsmat = zeros(length(subnums),12); % punishment, reward, neutral. -- for each net

for s = 1:length(subnums)
    for n = 1:length(nets)
                
        featdir = fullfile(maindir,'data',subnums{s},'tfMRI_GAMBLING_LR','lev1.feat');
        design = load(fullfile(featdir,'design.mtx'));
        data = load(fullfile(featdir,sprintf('net%02d.txt',nets(n))));
        sLR = regstats(zscore(data),zscore(design),'linear',{'all'});
        
        featdir = fullfile(maindir,'data',subnums{s},'tfMRI_GAMBLING_RL','lev1.feat');
        design = load(fullfile(featdir,'design.mtx'));
        data = load(fullfile(featdir,sprintf('net%02d.txt',nets(n))));
        sRL = regstats(zscore(data),zscore(design),'linear',{'all'});
        
        tmpB = mean([sRL.beta sLR.beta],2);
        resultsmat(s,(n*3)-2) = tmpB(2);
        resultsmat(s,(n*3)-1) = tmpB(3);
        resultsmat(s,n*3) = tmpB(4);
        
 
    end
end

DMN = resultsmat(:,1:3);
ECN = resultsmat(:,4:6);
LFPN = resultsmat(:,7:9);
RFPN = resultsmat(:,10:12);

DMN = DMN(:,[1 3 2]);
ECN = ECN(:,[1 3 2]);
LFPN = LFPN(:,[1 3 2]);
RFPN = RFPN(:,[1 3 2]);

myN = length(DMN);
figure,barweb_dvs2([mean(DMN); mean(ECN); mean(LFPN); mean(RFPN)], [std(DMN)/sqrt(myN); std(ECN)/sqrt(myN); std(LFPN)/sqrt(myN); std(RFPN)/sqrt(myN)])


