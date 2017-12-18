%{
Decision (agnostic to partner condition)
Friend Reciprocate (0.903)
Friend Defect (0.948)
Stranger Reciprocate (0.884)
Stranger Defect (0.903)
Computer Reciprocate (0.729)
Computer Defect (0.754)
Miss (Decision phase) (0.2)
Miss (Outcome phase) (0.2)
Subject Keep (outcome) (0.9226)
Net01 TS (visual)
Net02 TS (visual)
Net03 TS (visual)
Net04 TS (DMN)
Net05 TS (cerebellum)
Net06 TS (sensorimotor)
Net07 TS (auditory)
Net08 TS (ECN)
Net09 TS (frontoparietal)
Net10 TS (frontoparietal)
%}

clear;
maindir = pwd;
subnums = 2:32;
skips = [13 14 15 23 29];
[a,b] = ismember(skips,subnums);
subnums(b) = [];
nruns = 6;

DMN_results = nan(length(subnums),6); % Friend_R, Friend_D, Stranger_R, Stranger_D, Computer_R, Computer_D
ECN_results = nan(length(subnums),6); % Friend_R, Friend_D, Stranger_R, Stranger_D, Computer_R, Computer_D

for s = 1:length(subnums)
    beta_mat_dmn = nan(nruns,10);
    beta_mat_ecn = nan(nruns,10);
    
    for r = 1:nruns
        
        if subnums(s) == 12 && r == 5
            continue
        end
        
        featdir = fullfile(maindir,'data',sprintf('sub%02d',subnums(s)));
        outfile = fullfile(featdir,sprintf('sub%02d_r%d_design.mtx',subnums(s),r));
        D = load(outfile);
        
        baseModel = D(:,1:10);
        DMN = D(:,14);
        ECN = D(:,18);
        
        good_idx = find(any(baseModel)); %preserve indices
        baseModel(:,~any(baseModel)) = []; %strip 0 columns
        
        % run DMN
        stats = regstats(zscore(DMN),zscore(baseModel),'linear',{'all'});
        tmp_betas = stats.beta(2:end);
        beta_mat_dmn(r,good_idx) = tmp_betas; %put things in the right spot
        
        
        % run ECN
        stats = regstats(zscore(ECN),zscore(baseModel),'linear',{'all'});
        tmp_betas = stats.beta(2:end);
        beta_mat_ecn(r,good_idx) = tmp_betas; %put things in the right spot
    end
    
    % nan(length(subnums),6); % Friend_R, Friend_D, Stranger_R, Stranger_D, Computer_R, Computer_D
    DMN_results(s,:) = nanmean(beta_mat_dmn(:,2:7));
    ECN_results(s,:) = nanmean(beta_mat_ecn(:,2:7));
    
end


keyboard

%figure,barweb_dvs2([mean(DMN); mean(ECN); mean(LFPN); mean(RFPN)], [std(DMN)/sqrt(myN); std(ECN)/sqrt(myN); std(LFPN)/sqrt(myN); std(RFPN)/sqrt(myN)])


