
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create tables for the paper/slides
% note: table 1, 14-15 and figures 1-3 are not 
% produced here (stata descriptive work)
% also, transit dynamics not reproduced here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table 2 (first model tables)
% parameter estimate for baseline versiosn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
load output\matfiles\results_baseline

disp('======================================================')
disp('Table 2: parameter estimates baseline')
texprint([x1;x2;x2-x1]','%6.3f',{'first sample','second sample','change'},names_params(select_params2))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table 3: target moment decompositions for baseline model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
load output\matfiles\results_baseline

choice_moments_to_show = choice_moments ;
XXX = [all_results1(choice_moments_to_show)',...
    all_results2(choice_moments_to_show)',...
    all_results2(choice_moments_to_show)'-all_results1(choice_moments_to_show)',...
    ASorderXXX(:,choice_moments_to_show)'] ;

clear XXXn
XXXn{1} = 'data1' ;
XXXn{2} = 'data2' ;
XXXn{3} = 'diff' ;
for i=1:length(select_params2)
    XXXn{3+i} = names_params{select_params2(i)} ;
end

disp('======================================================')
disp('Table 3: moment decomposition')
texprint(XXX,'%6.2f',XXXn,names_moments(choice_moments_to_show))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table 4: additional moments for baseline model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
load output\matfiles\results_baseline

choice_moments_to_show = [
    indexM_SpreadRKRF,indexM_SpreadRKRFgqdelta,indexM_SpreadRKRFprof,indexM_SpreadRKRFrisk,...
    indexM_ER,indexM_ERP,indexM_RF,...
    indexM_PD,indexM_PE,indexM_TobinQ,...
    indexM_ShareLab,indexM_ShareCap,indexM_ShareProf,...
    indexM_KY,indexM_invtY,indexM_logtrueystar,indexM_logtruexstar];

clear XXXn
XXXn{1} = 'data1' ;
XXXn{2} = 'data2' ;
XXXn{3} = 'diff' ;
for i=1:length(select_params2)
    XXXn{3+i} = names_params{select_params2(i)} ;
end

XXX = [all_results1(choice_moments_to_show)',...
    all_results2(choice_moments_to_show)',...
    all_results2(choice_moments_to_show)'-all_results1(choice_moments_to_show)',...
    ASorderXXX(:,choice_moments_to_show)'] ;

% with spacing:
nnn = names_moments(choice_moments_to_show) ;
clear namessp
namessp(1:4) = nnn(1:4) ;
namessp(5) = {''} ;
namessp(6) = {''} ;
namessp(7:9) = nnn(5:7) ;
namessp(10) = {''} ;
namessp(11) = {''} ;
namessp(12:14) = nnn(8:10) ;
namessp(15) = {''} ;
namessp(16) = {''} ;
namessp(17:19) = nnn(11:13) ;
namessp(20) = {''} ;
namessp(21) = {''} ;
namessp(22:25) = nnn(14:17) ;

% with spacing
clear XXXsp
XXXsp(1:4,:) = XXX(1:4,:) ;
XXXsp(5:6,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(7:9,:) = XXX(5:7,:) ;
XXXsp(10:11,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(12:14,:) = XXX(8:10,:) ;
XXXsp(15:16,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(17:19,:) = XXX(11:13,:) ;
XXXsp(20:21,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(22:25,:) = XXX(14:17,:) ;

disp('======================================================')
disp('Table 4: additional moments')
texprint(XXXsp,'%6.2f',XXXn,namessp)

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version for the slides: group parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % simple table for spread:
% XXXspSL1 = XXXsp(1:4,1:3) ;
% texprint(XXXspSL1,'%6.2f',XXXn(1:3),namessp(1:4))
% 
% % simple table for other moments:
% JJ = ASorderXXX(:,choice_moments_baseline)' ;
% JJ2 = zeros(size(JJ,1),4) ;
% JJ2(:,1:3) = JJ(:,1:3) ;
% JJ2(:,4) = sum(JJ(:,4:end)')' ;
% texprint(JJ2,'%6.2f',{'beta','mu','p','others'},names_moments(choice_moments_baseline))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extensions-comparisons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table 5: baseline vs baseline macro: parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

variants_to_show = {'baseline','baselinemacro','baselinemacronomarkup'} ;
variants_to_showW = {'baseline','','','macro w markup','','','macro no markup','',''} ;

store_all_paramest_variants = zeros(length(all_params),3*length(variants_to_show)) ;

for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    store_all_paramest_variants(:,3*(iii-1)+1) = all_params1 ;
    store_all_paramest_variants(:,3*(iii-1)+2) = all_params2 ;
    store_all_paramest_variants(:,3*(iii-1)+3) = all_params2 - all_params1 ;
end

disp('======================================================')
disp('Table 5: comparison with baseline/macro models')
texprint(store_all_paramest_variants(select_params_baseline,:),'%6.3f',variants_to_showW,names_params(select_params_baseline))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table 6: baseline vs baseline macro: moments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

choice_impl = [indexM_SpreadRKRF,indexM_SpreadRKRFgqdelta,indexM_SpreadRKRFprof,indexM_SpreadRKRFrisk,...
    indexM_ER,indexM_ERP,indexM_RF,...
    indexM_PD,indexM_PE,indexM_TobinQ,...
    indexM_ShareLab,indexM_ShareCap,indexM_ShareProf,...
    indexM_KY,indexM_invtY,indexM_logtrueystar,indexM_logtruexstar];

store_all_impl_variants = zeros(length(choice_impl),3*length(variants_to_show)) ;

for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    store_all_impl_variants(:,3*(iii-1)+1) = all_results1(choice_impl) ;
    store_all_impl_variants(:,3*(iii-1)+2) = all_results2(choice_impl) ;
    store_all_impl_variants(:,3*(iii-1)+3) = all_results2(choice_impl) - all_results1(choice_impl) ;
end

XXX = store_all_impl_variants ;

% with spacing:
nnn = names_moments(choice_impl) ;
clear namessp
namessp(1:4) = nnn(1:4) ;
namessp(5) = {''} ;
namessp(6) = {''} ;
namessp(7:9) = nnn(5:7) ;
namessp(10) = {''} ;
namessp(11) = {''} ;
namessp(12:14) = nnn(8:10) ;
namessp(15) = {''} ;
namessp(16) = {''} ;
namessp(17:19) = nnn(11:13) ;
namessp(20) = {''} ;
namessp(21) = {''} ;
namessp(22:25) = nnn(14:17) ;

% with spacing
clear XXXsp
XXXsp(1:4,:) = XXX(1:4,:) ;
XXXsp(5:6,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(7:9,:) = XXX(5:7,:) ;
XXXsp(10:11,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(12:14,:) = XXX(8:10,:) ;
XXXsp(15:16,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(17:19,:) = XXX(11:13,:) ;
XXXsp(20:21,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(22:25,:) = XXX(14:17,:) ;

disp('======================================================')
disp('Table 6: macro moments')
texprint(XXXsp,'%6.2f',variants_to_showW,namessp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tables 7 and 8: risk extensions: parameters and moments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all ;
variants_to_show = {'baseline','baseline_smallupside','baseline_nooffset','baseline_lognormal','tvsize','tvriskaversion','IESunity','IESlow'} ;
variants_to_showW = {'baseline','','baseline_smallupside','','baseline_nooffset','','baseline_lognormal','',...
    'tvsize','','tvriskaversion','','IESunity','','IESlow',''} ;

for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    store_all_paramest_variants(iii,:) = all_params1 ;
    store_all_paramest_variants2(iii,:) = all_params2 ;
    
    JJ = ASorderXXX' ;
    JJ3 = zeros(size(JJ,1),3) ;
    j1 = JJ(:,indexP_beta) ;
    JJ3(:,indexP_beta) = j1 ;
    if ismember(indexP_p,select_params)==1
        j2 = JJ(:,3);%find(names_params(select_params2)==names_params(indexP_p))) ;
    elseif ismember(indexP_b,select_params)==1
        j2 = JJ(:,end);%find(names_params(select_params2)==names_params(indexP_b))) ;
    elseif ismember(indexP_theta,select_params)==1
        j2 = JJ(:,end);%find(names_params(select_params2)==names_params(indexP_theta))) ;
    end
    JJ3(:,2) = j2 ;
    JJ3(:,3) = sum(JJ')' - j1 - j2  ;
    store_all_decomp(iii,:,:) = JJ3 ; 
end

toshow1 = store_all_paramest_variants(:,[indexP_beta,indexP_p,indexP_b,indexP_theta,indexP_alphaIES]) ;
toshow2 = store_all_paramest_variants2(:,[indexP_beta,indexP_p,indexP_b,indexP_theta,indexP_alphaIES]) ;

toshow = []; 
for i=1:size(toshow1,1)
    toshow(2*(i-1)+1,:) = toshow1(i,:) ;
    toshow(2*(i-1)+2,:) = toshow2(i,:) ;
end
nnn = names_params([indexP_beta,indexP_p,indexP_b,indexP_theta,indexP_alphaIES]) ;
disp('======================================================')
disp('Table 7: risk modeling - estimates')
texprint(toshow,'%6.3f',nnn,variants_to_showW) ;

% show decomposition for RF, for PD, for Tobin's Q:
toshowdecomp = [] ;
for i=1:size(toshow1,1)
    toshowdecomp(i,:) = [ squeeze(store_all_decomp(i,indexM_RF,1:3))',squeeze(store_all_decomp(i,indexM_PD,1:3))',squeeze(store_all_decomp(i,indexM_TobinQ,1:3))'] ;
end
nnn2 = {'\beta','p','others','\beta','p','others','\beta','p','others'};

disp('======================================================')
disp('Table 8: risk modeling - effects')
texprint(toshowdecomp,'%6.2f',nnn2,variants_to_show) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table 9: basic extensions: parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all ;
variants_to_show = {'IESlow','leverage','AA','10YLESSREP'} ;
variants_to_showW = {'IESlow','','','leverage','','','AA','','','10YLESSREP','',''} ;

% store_all_paramest_variants = zeros(length(all_params),3*length(variants_to_show)) ;

for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    store_all_paramest_variants(:,3*(iii-1)+1) = all_params1 ;
    store_all_paramest_variants(:,3*(iii-1)+2) = all_params2 ;
    store_all_paramest_variants(:,3*(iii-1)+3) = all_params2 - all_params1 ;
end

disp('======================================================')
disp('Table 9: robustness - parameters')
texprint(store_all_paramest_variants(select_params_baseline,:),'%6.3f',variants_to_showW,names_params(select_params_baseline))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table 10: basic extensions: moments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

choice_impl = [indexM_SpreadRKRF,indexM_SpreadRKRFgqdelta,indexM_SpreadRKRFprof,indexM_SpreadRKRFrisk,...
    indexM_ER,indexM_ERP,indexM_RF,...
    indexM_PD,indexM_PE,indexM_TobinQ,...
    indexM_ShareLab,indexM_ShareCap,indexM_ShareProf,...
    indexM_KY,indexM_invtY,indexM_logtrueystar,indexM_logtruexstar];

store_all_impl_variants = zeros(length(choice_impl),3*length(variants_to_show)) ;

for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    store_all_impl_variants(:,3*(iii-1)+1) = all_results1(choice_impl) ;
    store_all_impl_variants(:,3*(iii-1)+2) = all_results2(choice_impl) ;
    store_all_impl_variants(:,3*(iii-1)+3) = all_results2(choice_impl) - all_results1(choice_impl) ;
end

XXX = store_all_impl_variants ;

% with spacing:
nnn = names_moments(choice_impl) ;
clear namessp
namessp(1:4) = nnn(1:4) ;
namessp(5) = {''} ;
namessp(6) = {''} ;
namessp(7:9) = nnn(5:7) ;
namessp(10) = {''} ;
namessp(11) = {''} ;
namessp(12:14) = nnn(8:10) ;
namessp(15) = {''} ;
namessp(16) = {''} ;
namessp(17:19) = nnn(11:13) ;
namessp(20) = {''} ;
namessp(21) = {''} ;
namessp(22:25) = nnn(14:17) ;

% with spacing
clear XXXsp
XXXsp(1:4,:) = XXX(1:4,:) ;
XXXsp(5:6,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(7:9,:) = XXX(5:7,:) ;
XXXsp(10:11,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(12:14,:) = XXX(8:10,:) ;
XXXsp(15:16,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(17:19,:) = XXX(11:13,:) ;
XXXsp(20:21,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(22:25,:) = XXX(14:17,:) ;

disp('======================================================')
disp('Table 10: robustness - moments')
texprint(XXXsp,'%6.2f',variants_to_showW,namessp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table 11: mismeasurement: parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all ;
variants_to_show = {'baseline','mismeasK1010','mismeasK1020','mismeasK1030'} ;
variants_to_showW = {'baseline','','','mismeasK1010','','','mismeasK1020','','','mismeasK1030','',''} ;

% store_all_paramest_variants = zeros(length(all_params),3*length(variants_to_show)) ;

for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    store_all_paramest_variants(:,3*(iii-1)+1) = all_params1 ;
    store_all_paramest_variants(:,3*(iii-1)+2) = all_params2 ;
    store_all_paramest_variants(:,3*(iii-1)+3) = all_params2 - all_params1 ;
end

disp('======================================================')
disp('Table 11: mismeasurement - parameters')
texprint(store_all_paramest_variants(select_params_baseline,:),'%6.3f',variants_to_showW,names_params(select_params_baseline))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table 12: mismeasurement: moments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

choice_impl = [indexM_SpreadRKRF,indexM_SpreadRKRFgqdelta,indexM_SpreadRKRFprof,indexM_SpreadRKRFrisk,...
    indexM_ER,indexM_ERP,indexM_RF,...
    indexM_PD,indexM_PE,indexM_TobinQ,...
   indexM_ShareLab,indexM_ShareCap,indexM_ShareProf,...
    indexM_KY,indexM_invtY,indexM_logmeasystar,indexM_logmeasxstar];

store_all_impl_variants = zeros(length(choice_impl),3*length(variants_to_show)) ;

for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    store_all_impl_variants(:,3*(iii-1)+1) = all_results1(choice_impl) ;
    store_all_impl_variants(:,3*(iii-1)+2) = all_results2(choice_impl) ;
    store_all_impl_variants(:,3*(iii-1)+3) = all_results2(choice_impl) - all_results1(choice_impl) ;
end

XXX = store_all_impl_variants ;

% with spacing:
nnn = names_moments(choice_impl) ;
clear namessp
namessp(1:4) = nnn(1:4) ;
namessp(5) = {''} ;
namessp(6) = {''} ;
namessp(7:9) = nnn(5:7) ;
namessp(10) = {''} ;
namessp(11) = {''} ;
namessp(12:14) = nnn(8:10) ;
namessp(15) = {''} ;
namessp(16) = {''} ;
namessp(17:19) = nnn(11:13) ;
namessp(20) = {''} ;
namessp(21) = {''} ;
namessp(22:25) = nnn(14:17) ;

% with spacing
clear XXXsp
XXXsp(1:4,:) = XXX(1:4,:) ;
XXXsp(5:6,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(7:9,:) = XXX(5:7,:) ;
XXXsp(10:11,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(12:14,:) = XXX(8:10,:) ;
XXXsp(15:16,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(17:19,:) = XXX(11:13,:) ;
XXXsp(20:21,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(22:25,:) = XXX(14:17,:) ;

disp('======================================================')
disp('Table 12: mismeasurement - moments')
texprint(XXXsp,'%6.2f',variants_to_showW,namessp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table A1 sensitivity matrix - baseline model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
load output\matfiles\results_baseline
disp('======================================================')
disp('Table A1: sensitivity matrix')
texprint(100*Lambda,'%6.2f',names_moments(choice_moments),names_params(select_params2))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table A2 - sensitivity matrix for betastar %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all ;
load output\matfiles\results_baselinebetastar
disp('======================================================')
disp('Table A2: sensitivity matrix betastar')
texprint(100*Lambda,'%6.2f',names_moments(choice_moments),names_params(select_params2))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table A3 - upper and lower bounds for decompositions  - baselien model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
load output\matfiles\results_baseline
disp('======================================================')
disp('Table A3: upper and lower bounds')
texprint(ASorderXXXbounds(:,choice_moments),'%6.2f',names_moments(choice_moments),names_params(sort([select_params2,select_params2])))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Table A4 - parameter estimates for the IES=1, IES=0.5 cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all ;
variants_to_show = {'baseline','IESunity','IESlow'} ;
variants_to_showW = {'baseline','','','IESunity','','','IESlow','',''} ;
% store_all_paramest_variants = zeros(length(all_params),3*length(variants_to_show)) ;

for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    store_all_paramest_variants(:,3*(iii-1)+1) = all_params1 ;
    store_all_paramest_variants(:,3*(iii-1)+2) = all_params2 ;
    store_all_paramest_variants(:,3*(iii-1)+3) = all_params2 - all_params1 ;
end

disp('======================================================')
disp('Table A4: robustness - parameters')
texprint(store_all_paramest_variants(select_params_baseline,:),'%6.3f',variants_to_showW,names_params(select_params_baseline))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Table A7 - model implications for the IES=1, IES=0.5 cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

choice_impl = [indexM_SpreadRKRF,indexM_SpreadRKRFgqdelta,indexM_SpreadRKRFprof,indexM_SpreadRKRFrisk,...
    indexM_ER,indexM_ERP,indexM_RF,...
    indexM_PD,indexM_PE,indexM_TobinQ,...
    indexM_ShareLab,indexM_ShareCap,indexM_ShareProf,...
    indexM_KY,indexM_invtY,indexM_logtrueystar,indexM_logtruexstar];

store_all_impl_variants = zeros(length(choice_impl),3*length(variants_to_show)) ;

for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    store_all_impl_variants(:,3*(iii-1)+1) = all_results1(choice_impl) ;
    store_all_impl_variants(:,3*(iii-1)+2) = all_results2(choice_impl) ;
    store_all_impl_variants(:,3*(iii-1)+3) = all_results2(choice_impl) - all_results1(choice_impl) ;
end

XXX = store_all_impl_variants ;

% with spacing:
nnn = names_moments(choice_impl) ;
clear namessp
namessp(1:4) = nnn(1:4) ;
namessp(5) = {''} ;
namessp(6) = {''} ;
namessp(7:9) = nnn(5:7) ;
namessp(10) = {''} ;
namessp(11) = {''} ;
namessp(12:14) = nnn(8:10) ;
namessp(15) = {''} ;
namessp(16) = {''} ;
namessp(17:19) = nnn(11:13) ;
namessp(20) = {''} ;
namessp(21) = {''} ;
namessp(22:25) = nnn(14:17) ;

% with spacing
clear XXXsp
XXXsp(1:4,:) = XXX(1:4,:) ;
XXXsp(5:6,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(7:9,:) = XXX(5:7,:) ;
XXXsp(10:11,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(12:14,:) = XXX(8:10,:) ;
XXXsp(15:16,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(17:19,:) = XXX(11:13,:) ;
XXXsp(20:21,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(22:25,:) = XXX(14:17,:) ;

disp('======================================================')
disp('Table A5 - model implications - different IES ')
texprint(XXXsp,'%6.2f',variants_to_showW,namessp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Table A5 - decompositions for the IES unity case
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('======================================================')
disp('Table A6 - IES unity decomposition')
variants_to_show = {'IESunity'}  ;
for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    choice_moments_to_show = choice_moments_baseline ;
    texprint(ASorderXXX(:,choice_moments_to_show)','%6.2f',names_params(select_params2),names_moments(choice_moments_to_show))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Table A6 - decompositions for the IES=0.5 case
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('======================================================')
disp('Table A7 - IES 0.5 decomposition')
variants_to_show = {'IESlow'}  ;
for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    choice_moments_to_show = choice_moments_baseline ;
    texprint(ASorderXXX(:,choice_moments_to_show)','%6.2f',names_params(select_params2),names_moments(choice_moments_to_show))
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table A8: explicit model of intangibles - parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
load output\matfiles\results_intang_nomis
variants_to_show = {'intang_nomis','intang_mis33','intang_mis50','intang_mis75'};
variants_to_showW = {'no mismeas','','','33pct','','','50pct','','','75pct','',''} ;
store_all_paramest_variants = zeros(length(all_params),3*length(variants_to_show)) ;

for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    store_all_paramest_variants(:,3*(iii-1)+1) = all_params1 ;
    store_all_paramest_variants(:,3*(iii-1)+2) = all_params2 ;
    store_all_paramest_variants(:,3*(iii-1)+3) = all_params2 - all_params1 ;
end
disp('======================================================')
disp('Table A8 - Intangibles - Parameters')
texprint(store_all_paramest_variants(select_params_baseline,:),'%6.3f',variants_to_showW,names_params(select_params_baseline))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table A9: intangibles - implications
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% choice_impl = [indexM_SpreadRKRF,indexM_SpreadRKRFgqdelta,indexM_SpreadRKRFprof,indexM_SpreadRKRFrisk,...
%     indexM_ER,indexM_ERP,indexM_RF,...
%     indexM_PD,indexM_PE,indexM_TobinQ,...
%     indexM_ShareLab,indexM_ShareCap,indexM_ShareProf,...
%     indexM_KY,indexM_invtY,indexM_logtrueystar,indexM_logtruexstar];

choice_impl = [indexM_SpreadRKRF,...
    indexM_ER,indexM_ERP,indexM_RF,...
    indexM_PD,indexM_PE,indexM_TobinQ,...
    indexM_ShareLab,indexM_ShareCapT,indexM_shareCapU,indexM_ShareProf,...
    indexM_KY,indexM_invtY,...
    indexM_logmeasystar,indexM_logmeasxstar];

store_all_impl_variants = zeros(length(choice_impl),3*length(variants_to_show)) ;

for iii=1:length(variants_to_show)
    eval(strcat('load output\matfiles\results_',variants_to_show{iii}))
    store_all_impl_variants(:,3*(iii-1)+1) = all_results1(choice_impl) ;
    store_all_impl_variants(:,3*(iii-1)+2) = all_results2(choice_impl) ;
    store_all_impl_variants(:,3*(iii-1)+3) = all_results2(choice_impl) - all_results1(choice_impl) ;
end

XXX = store_all_impl_variants ;

% with spacing:
nnn = names_moments(choice_impl) ;
clear namessp
namessp(1) = nnn(1) ;
namessp(2) = {''} ;
namessp(3) = {''} ;
namessp(4:6) = nnn(2:4) ;
namessp(7) = {''} ;
namessp(8) = {''} ;
namessp(9:11) = nnn(5:7) ;
namessp(12) = {''} ;
namessp(13) = {''} ;
namessp(14:17) = nnn(8:11) ;
namessp(18) = {''} ;
namessp(19) = {''} ;
namessp(20:23) = nnn(12:15) ;

% with spacing
clear XXXsp
XXXsp(1,:) = XXX(1,:) ;
XXXsp(2:3,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(4:6,:) = XXX(2:4,:) ;
XXXsp(7:8,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(9:11,:) = XXX(5:7,:) ;
XXXsp(12:13,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(14:17,:) = XXX(8:11,:) ;
XXXsp(18:19,:) = zeros(2,length(XXX(1,:))) ;
XXXsp(20:23,:) = XXX(12:15,:) ;

disp('======================================================')
disp('Table A9 - model implications - model w intangibles')
texprint(XXXsp,'%6.2f',variants_to_showW,namessp)


