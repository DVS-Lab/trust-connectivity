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
rFPN_results = nan(length(subnums),6); % Friend_R, Friend_D, Stranger_R, Stranger_D, Computer_R, Computer_D
lFPN_results = nan(length(subnums),6); % Friend_R, Friend_D, Stranger_R, Stranger_D, Computer_R, Computer_D

for s = 1:length(subnums)
    beta_mat_dmn = nan(nruns,10);
    beta_mat_ecn = nan(nruns,10);
    beta_mat_rfpn = nan(nruns,10);
    beta_mat_lfpn = nan(nruns,10);
    
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
        rFPN = D(:,19);
        lFPN = D(:,20);
        
        
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
        
        
        stats = regstats(zscore(lFPN),zscore(baseModel),'linear',{'all'});
        tmp_betas = stats.beta(2:end);
        beta_mat_rfpn(r,good_idx) = tmp_betas; %put things in the right spot
        
        stats = regstats(zscore(rFPN),zscore(baseModel),'linear',{'all'});
        tmp_betas = stats.beta(2:end);
        beta_mat_lfpn(r,good_idx) = tmp_betas; %put things in the right spot
        
    end
    
    % nan(length(subnums),6); % Friend_R, Friend_D, Stranger_R, Stranger_D, Computer_R, Computer_D
    DMN_results(s,:) = nanmean(beta_mat_dmn(:,2:7));
    ECN_results(s,:) = nanmean(beta_mat_ecn(:,2:7));
    
    rFPN_results(s,:) = nanmean(beta_mat_rfpn(:,2:7));
    lFPN_results(s,:) = nanmean(beta_mat_lfpn(:,2:7));
    
    
end


myN = length(subnums);

figure,barweb_dvs2([mean(DMN_results(:,1:2)); mean(DMN_results(:,3:4)); mean(DMN_results(:,5:6))], [std(DMN_results(:,1:2))/sqrt(myN); std(DMN_results(:,3:4))/sqrt(myN); std(DMN_results(:,5:6))/sqrt(myN)])
title('DMN results')
set(gca,'XTickLabel',{'Friend','Stranger','Computer'},'XTick',[1 2 3])
xlabel('Partner');
ylabel('Response (beta)');
legend('reciprocate','defect','Location','Northeast')

figure,barweb_dvs2([mean(ECN_results(:,1:2)); mean(ECN_results(:,3:4)); mean(ECN_results(:,5:6))], [std(ECN_results(:,1:2))/sqrt(myN); std(ECN_results(:,3:4))/sqrt(myN); std(ECN_results(:,5:6))/sqrt(myN)])
title('ECN results')
set(gca,'XTickLabel',{'Friend','Stranger','Computer'},'XTick',[1 2 3])
xlabel('Partner');
ylabel('Response (beta)');
legend('reciprocate','defect','Location','Southeast')


% figure,barweb_dvs2([mean(lFPN_results(:,1:2)); mean(lFPN_results(:,3:4)); mean(lFPN_results(:,5:6))], [std(lFPN_results(:,1:2))/sqrt(myN); std(lFPN_results(:,3:4))/sqrt(myN); std(lFPN_results(:,5:6))/sqrt(myN)])
% title('lFPN results')
% set(gca,'XTickLabel',{'Friend','Stranger','Computer'},'XTick',[1 2 3])
% xlabel('Partner');
% ylabel('Response (beta)');
% legend('reciprocate','defect','Location','Southeast')
% 
% figure,barweb_dvs2([mean(rFPN_results(:,1:2)); mean(rFPN_results(:,3:4)); mean(rFPN_results(:,5:6))], [std(rFPN_results(:,1:2))/sqrt(myN); std(rFPN_results(:,3:4))/sqrt(myN); std(rFPN_results(:,5:6))/sqrt(myN)])
% title('rFPN results')
% set(gca,'XTickLabel',{'Friend','Stranger','Computer'},'XTick',[1 2 3])
% xlabel('Partner');
% ylabel('Response (beta)');
% legend('reciprocate','defect','Location','Southeast')

fid = fopen('dmn_summary.csv','w');
fprintf(fid,'Subject,Friend_R,Friend_D,Stranger_R,Stranger_D,Computer_R,Computer_D\n');
for s = 1:length(subnums)
    fprintf(fid,'sub%02d,%3.3f,%3.3f,%3.3f,%3.3f,%3.3f,%3.3f\n',subnums(s),DMN_results(s,:));
end
fclose(fid);

fid = fopen('ecn_summary.csv','w');
fprintf(fid,'Subject,Friend_R,Friend_D,Stranger_R,Stranger_D,Computer_R,Computer_D\n');
for s = 1:length(subnums)
    fprintf(fid,'sub%02d,%3.3f,%3.3f,%3.3f,%3.3f,%3.3f,%3.3f\n',subnums(s),ECN_results(s,:));
end
fclose(fid);

