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

DMN_results = nan(length(subnums),4); % coordinates = {'-44_-60_24', '02_-58_30', '02_56_-04', '54_-62_28'};

coordinates = {'-44_-60_24', '02_-58_30', '02_56_-04', '54_-62_28'};
ROIs = {'lTPJ', 'PCC', 'MPFC', 'rTPJ'};

for s = 1:length(subnums)
    corr_mat_dmn = nan(nruns,4); % ROIs = {'lTPJ', 'PCC', 'MPFC', 'rTPJ'};
    
    for r = 1:nruns
        
        if subnums(s) == 12 && r == 5
            continue
        end
        
        featdir = fullfile(maindir,'data',sprintf('sub%02d',subnums(s)));
        outfile = fullfile(featdir,sprintf('sub%02d_r%d_design.mtx',subnums(s),r));
        D = load(outfile);
        DMN = D(:,14);
        
        for c = 1:length(coordinates) % sub02_run2_DMNseed_02_-58_30.txt
            tsfile = fullfile(maindir,'data',sprintf('sub%02d_run%d_DMNseed_%s.txt', subnums(s), r, coordinates{c}));
            ts = load(tsfile);
            corr_mat_dmn(r,c) = corr(DMN,ts);
        end
    end
    DMN_results(s,:) = nanmean(corr_mat_dmn);
    
end


myN = length(subnums);
figure,
bar(mean(DMN_results))
hold on
errorbar(1:4,mean(DMN_results),std(DMN_results)/sqrt(myN),'LineStyle','none')
title('DMN results')
set(gca,'XTickLabel',{'lTPJ', 'PCC', 'MPFC', 'rTPJ'},'XTick',[1 2 3 4])
xlabel('Region');
ylabel('Correlation with DMN');

%
% fid = fopen('dmn_summary.csv','w');
% fprintf(fid,'Subject,Friend_R,Friend_D,Stranger_R,Stranger_D,Computer_R,Computer_D\n');
% for s = 1:length(subnums)
%     fprintf(fid,'sub%02d,%3.3f,%3.3f,%3.3f,%3.3f,%3.3f,%3.3f\n',subnums(s),rFPN_results(s,:));
% end
% fclose(fid);

