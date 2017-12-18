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
Decision X DMN
Friend Reciprocate X DMN
Friend Defect X DMN
Stranger Reciprocate X DMN
Stranger Defect X DMN
Computer Reciprocate X DMN
Computer Defect X DMN
Miss (Decision phase) X DMN
Miss (Outcome phase) X DMN
Subject Keep (outcome) x DMN
%}

clear;
maindir = pwd;
subnums = 2:32;
skips = [13 14 15 23 29];
[a,b] = ismember(skips,subnums);
subnums(b) = [];
nruns = 6;

matcheck = zeros(nruns*length(subnums),30); %will delete empty rows later

idx = 0;
for s = 1:length(subnums)
    for r = 1:nruns
        idx = idx + 1;
        
        if subnums(s) == 12 && r == 5
            continue
        end
        
        featdir = fullfile(maindir,'data',sprintf('sub%02d',subnums(s)));
        outfile = fullfile(featdir,sprintf('sub%02d_r%d_design.mtx',subnums(s),r));
        D = load(outfile);
        
        matcheck(idx,:) = any(D);
        
        DD = D(:,1:10);
        E = ~any(DD);
        if sum(E(2:7)) > 2
            msg = sprintf('missing > 2: subject %d run %d', subnums(s), r);
            disp(msg);
        end

%         check = combnk(2:7,5); %check 5
%         for i = 1:size(check,1)
%             if E(check(i,1)) && E(check(i,2)) && E(check(i,3)) && E(check(i,4)) && E(check(i,5))
%                 disp(E)
%                 break;
%             end
%         end
%         
%         check = combnk(2:7,4); %check 4
%         for i = 1:size(check,1)
%             if E(check(i,1)) && E(check(i,2)) && E(check(i,3)) && E(check(i,4))
%                 disp(E)
%                 break;
%             end
%         end
%         
%         check = combnk(2:7,3); %check 3
%         for i = 1:size(check,1)
%             if E(check(i,1)) && E(check(i,2)) && E(check(i,3))
%                 disp(E)
%                 break;
%             end
%         end
%         
%         check = combnk(2:7,2); %check 2
%         for i = 1:size(check,1)
%             if E(check(i,1)) && E(check(i,2))
%                 disp(E)
%                 break;
%             end
%         end
        
        
        
    end
end

matcheck(matcheck(:,1) == 0,:) = [];
