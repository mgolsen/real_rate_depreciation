
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create folders to store results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mkdir output
cd output
try
    mkdir paperfigs
    mkdir results
    mkdir figuretargets
    mkdir figurerolling
    mkdir compstatics
    %     mkdir figuretransition
    mkdir matfiles
catch
end

cd figurerolling
try
    instructiontomkdir = strcat({'mkdir'},{' '},namecalib) ;
    eval(instructiontomkdir{1})
catch
end
cd ..

% cd figuretransition
% try
%     instructiontomkdir = strcat({'mkdir'},{' '},namecalib) ;
%     eval(instructiontomkdir{1})
% catch
% end
% cd ..

cd compstatics
try
    instructiontomkdir = strcat({'mkdir'},{' '},namecalib) ;
    eval(instructiontomkdir{1})
catch
end
cd ..\..

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% delete existing files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if printexcel==1
    namecalibX = strcat('output\results\',namecalib) ;
    namecalibX = strcat(namecalibX,'.xls') ;
    
    try
        instructiontodlete = strcat({'delete'},{'  '},namecalibX) ;
        eval(instructiontodlete{1})
    catch
    end
    
    try
        clear instructiontodlete
    catch
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data handling
% could accelerate by doing this once and for all...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataload ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first subsample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

setparamV2 ;
num_parameters = length(select_params) ;
moments_values = moments_values_V1 ;

if exactident==1
    options = optimoptions('fsolve','MaxFunEvals',2000,'MaxIter',1000);
    [x1,check1] = fsolve(@solvecalibrationV2,all_params(select_params),options) ;
else
    % Weigthing matrix - to define in non-exactly identified case: (NOT USED)
    Weighting = eye(length(moments_values(choice_moments))) ;
    set weighting matrix to moment value
    Weighting = zeros(length(choice_moments)) ;
    for i=1:length(choice_moments)
        Weighting(i,i) = 1/moments_values(choice_moments(i))^2 ;
    end
    optimset.MaxFunEvals = 2000 ;
    optimset.MaxIter = 1000 ;
    [x1,check1] = fminsearch(@solvecalibrationV2,all_params(select_params),optimset) ;
end

for i=1:length(x1)
    A(1,i) = names_params(select_params(i)) ;
    A(2,i) = num2cell(x1(i)) ;
end

for i=1:length(moments_values)
    C(1,1+i) = names_moments(i) ;
    C(2,1+i) = num2cell(moments_values(i)) ;
    C(3,1+i) = num2cell(all_results(i)) ;
    C(4,1+i) = num2cell(ismember(i,choice_moments)) ;
end
C(2,1) = {'Data'} ; C(3,1) = {'Model'} ; C(4,1) = {'Target?'} ;

select_params1 = select_params ;
all_results1 = all_results ;
all_params1 = all_params ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% second subsample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if adjustexogparamsecond==1
    values_params_nonest = values_params_nonest2 ;
end

setparamV2 ;
moments_values = moments_values_V2 ;

if exactident==1
    options = optimoptions('fsolve','MaxFunEvals',2000,'MaxIter',1000);
    [x2,check2] = fsolve(@solvecalibrationV2,all_params(select_params),options) ;
else
    optimset.MaxFunEvals = 2000 ;
    optimset.MaxIter = 1000 ;
    [x2,check2] = fminsearch(@solvecalibrationV2,all_params(select_params),optimset) ;
end

for i=1:length(x2)
    B(1,i) = names_params(select_params(i)) ;
    B(2,i) = num2cell(x2(i)) ;
end
for i=1:length(moments_values)
    D(1,1+i) = names_moments(i) ;
    D(2,1+i) = num2cell(moments_values(i)) ;
    D(3,1+i) = num2cell(all_results(i)) ;
    D(4,1+i) = num2cell(ismember(i,choice_moments)) ;
end
D(2,1) = {'Data'} ; D(3,1) = {'Model'} ; D(4,1) = {'Target?'} ;

select_params2 = select_params ;
all_results2 = all_results ;
all_params2 = all_params ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table for paper/slides ni Tex format:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('==================================================================')
disp('Estimated Parameters and Changes between the sample:')
texprint([x1;x2;x2-x1]','%6.3f',{'first sample','second sample','change'},names_params(select_params2))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table with both sets of parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if printexcel==1
    Text1{1} = 'Parameters that are calibrated in first subsample:' ;
    xlswrite(namecalibX,Text1,'est_params','A1')
    Text1{1} = 'Parameters that are calibrated in second subsample:' ;
    xlswrite(namecalibX,A,'est_params','A2') ;
    xlswrite(namecalibX,Text1,'est_params','A5')
    xlswrite(namecalibX,B,'est_params','A6') ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% non-calibrated parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nonselect_params = setdiff((1:length(all_params)),select_params) ;
x3 = all_params(nonselect_params) ;

for i=1:length(x3)
    Anotcalib(1,i) = names_params(nonselect_params(i)) ;
    Anotcalib(2,i) = num2cell(x3(i)) ;
end

if printexcel==1
    Text1{1} = 'Parameters that are not calibrated' ;
    xlswrite(namecalibX,Text1,'nonest_params','A1')
    xlswrite(namecalibX,Anotcalib,'nonest_params','A2') ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add switches to spreadsheet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

names_switches{1} = 'exactly identified' ;
names_switches{2} = 'gn=gp (emp growth=pop growth)' ;
names_switches{3} = 'leverage (0=no, 1=yes)' ;
names_switches{4} = 'risk approach' ;

switchval(1) = exactident ;
switchval(2) = forcegngp ;
switchval(3) = leverageadj ;
switchval(4) = riskapproach ;


for i=1:length(switchval)
    Aswitches(1,i) = names_switches(i) ;
    Aswitches(2,i) = num2cell(switchval(i)) ;
end

if printexcel==1
    Text1{1} = 'Switches and Options' ;
    xlswrite(namecalibX,Text1,'switches','A1') ;
    xlswrite(namecalibX,Aswitches','switches','B1') ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table with fit of moments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('==================================================================')
disp('Fit: moments first sample: Data vs Model (1 means targeted)')
disp(C(:,choice_moments+1)')

disp('==================================================================')
disp('Fit: moments second sample: Data vs Model (1 means targeted)')
disp(D(:,choice_moments+1)')

if printexcel==1
    Text1{1} = 'Fit of the moments in the first subsample:' ;
    xlswrite(namecalibX,Text1,'fit','A1')
    xlswrite(namecalibX,C,'fit','A2') ;
    Text1{1} = 'Fit of the moments in the second subsample:' ;
    xlswrite(namecalibX,Text1,'fit','A7')
    xlswrite(namecalibX,D,'fit','A8') ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table with fit of change in moments
% first line is data, second line is model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(moments_values)
    E(1,i) = names_moments(i) ;
    E(2,i) = num2cell(D{2,1+i}-C{2,1+i}) ;
    E(3,i) = num2cell(D{3,1+i}-C{3,1+i}) ;
end

if showdetails==1
    disp('==================================================================')
    disp('Fit: changes in moments')
    disp(E(:,1:end-1))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% numerical check: how well did we fit ?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('==================================================================')
disp('Fit in each subsample:')
disp(sum(abs(check1)))
disp(sum(abs(check2)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% decompose, for each data moment,
% the change due to each parameter change
% (this calculation fixes the parameters at the initival value)
% (not reported in the paper)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

setparamV2 ;
all_params(select_params1) = x1 ; % initial value
solvestochsteadystateV2 ;
store_baseline = all_results ;

storeres = zeros(length(x2),length(all_results)) ;
storechange = zeros(length(x2),length(all_results)) ;

for i=1:length(x2)
    setparamV2 ;
    all_params(select_params1) = x1 ; % initial value
    all_params(select_params2(i)) = x2(i)  ; % change to final value, one at a time
    solvestochsteadystateV2 ;
    storeres(i,:) = all_results ;
    storechange(i,:) = all_results -  store_baseline ;
end

% which moments to put in table? for now all the moments
show_moments = (1:length(names_moments)) ;

M1 = length(x2) ;
M2 = length(show_moments);

% table presentation:
AS(1,2) = {'Data 1st sample'} ; AS(1,3) = {'Data 2nd sample'} ; AS(1,4) = {'Data Change'} ; AS(1,5) = {'Model Chg'} ;
for i=1:M1; AS(1,i+5) = names_params(select_params2(i)) ; end
for i=1:M2; AS(i+1,1) = names_moments(show_moments(i))  ; end

% change implied by each parameter:
AS(2:M2+1,6:M1+5) = num2cell(storechange(:,show_moments)');

% data:
AS(2:M2+1,2) = num2cell(moments_values_V1(show_moments) );
AS(2:M2+1,3) = num2cell(moments_values_V2(show_moments) ) ;
AS(2:M2+1,4) = num2cell(moments_values_V2(show_moments) - moments_values_V1(show_moments) ) ;

% changing all parameters at once:
AS(2:M2+1,5) = num2cell(all_results2(show_moments) - all_results1(show_moments) ) ;

if printexcel==1
    xlswrite(namecalibX,AS,'decomposition')
end

if showdetails==1
    disp('==================================================================')
    disp('Decomposition - Simple (not used in paper')
    disp(AS)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% show effect of each parameter graphically
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if showcompstatics==1
    
    % list of moments to show in pictures of comparative statics
    
    show_mom = [indexM_profitK,indexM_profitY,indexM_invtY,...
        indexM_RF,indexM_PE,indexM_PD,indexM_growthTFP,indexM_ERP,indexM_logtrueystar] ;
    
    for j=1:length(all_params)
        
        setparamV2 ;
        gridparam = linspace(all_params(j)-0.02,all_params(j)+0.02,40) ;
        
        storeresults = zeros(length(gridparam),length(all_results)) ;
        for k=1:length(gridparam)
            setparamV2 ;
            all_params(j) = gridparam(k)  ;
            solvestochsteadystateV2 ;
            storeresults(k,:) = all_results ;
        end
        
        figure ;
        for i=1:length(show_mom)
            subplot(3,3,i) ;
            XXX = storeresults(:,show_mom(i)) ;
            plot(gridparam,XXX,'b-') ;
            title(names_moments(show_mom(i)))
            axis([min(gridparam) max(gridparam) min(XXX)-1e-4 max(XXX)+1e-4])
            if i==7||i==8||i==9
                xlabel(names_params{j})
            end
        end
        eval(strcat('print -dpdf output\compstatics\',namecalib,'\P',num2str(j)))
        eval(strcat('print -dpng output\compstatics\',namecalib,'\',num2str(j)))
        eval(strcat('print -depsc2 output\compstatics\',namecalib,'\',num2str(j)))
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alternative calculation for decompositions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_moments = length(all_results) ;

if ordering==1
    
    Ntot = 2^num_parameters ;
    % list of 0/1 for switch from initial (0) to final(1) value
    store_params_switch = zeros(Ntot,num_parameters);
    for i=1:2^num_parameters
        store_params_switch(i,:)=bitget(i,1:num_parameters) ;
    end
    
    
    % select_params1==select_params2 is assumed
    select_paramsX = select_params1 ;
    if select_params2~=select_paramsX
        disp('issue with decomposition')
        pause
    end
    
    % keep actually all combinations - no need to store all results first,
    store_combination = zeros(num_parameters,Ntot/2,num_moments);
    store_combinationUW = zeros(num_parameters,Ntot/2,num_moments);
    weight = zeros(num_parameters,Ntot/2) ;
    
    for i=1:num_parameters
        
        % find all combinations that have i at 0
        UUU = find(store_params_switch(:,i)==0) ;
        
        for isx=1:length(UUU)
            
            % calculate value initially
            FF  = store_params_switch(UUU(isx),:) ;
            
            F1 = find(FF==0) ;
            F2 = find(FF==1) ;
            if ~isempty(F1)
                all_params(select_paramsX(F1)) = x1(F1) ; % set initial value for 0's
            end
            if ~isempty(F2)
                all_params(select_paramsX(F2)) = x2(F2) ; % set final value for 1's
            end
            
            solvestochsteadystateV2 ;
            initval = all_results ;
            
            % now edit parameter i:
            newp = store_params_switch(UUU(isx),:) ;
            newp(i) = 1 ;
            
            F1 = find(newp==0) ;
            F2 = find(newp==1) ;
            if ~isempty(F1)
                all_params(select_paramsX(F1)) = x1(F1) ; % set initial value for 0's
            end
            if ~isempty(F2)
                all_params(select_paramsX(F2)) = x2(F2) ; % set final value for 1's
            end
            
            solvestochsteadystateV2 ;
            finalval = all_results ;
            
            weight(i,isx)  = factorial(length(find(FF==1)))*factorial(num_parameters-length(find(newp==1)))/factorial(num_parameters) ;
            
            % find index representing this calculation (to avoid having to
            % compute again the equilibrium...)
            %             [~,index_A,~] = intersect(store_params_switch,ones(size(store_params_switch,1),1)*newp,'rows');
            store_combination(i,isx,:) = weight(i,isx)*(finalval - initval) ;
            store_combinationUW(i,isx,:) = (finalval - initval) ;
            
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % now print out the min/max/median/mean/SD of the effects
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % table presentation:
    ASorder(1,2) = {'Data 1st sample'} ;
    ASorder(1,3) = {'Data 2nd sample'} ;
    ASorder(1,4) = {'Data Change'} ;
    ASorder(1,5) = {'Model Chg'} ;
    
    for i=1:M1; ASorder(1,5*(i-1)+5+1) = names_params(select_params2(i)) ; end
    for i=1:M1
        ASorder(2,5*(i-1)+5+1) = {'Mean'} ;
        ASorder(2,5*(i-1)+5+2) = {'Median'} ;
        ASorder(2,5*(i-1)+5+3) = {'SD'} ;
        ASorder(2,5*(i-1)+5+4) = {'Min'} ;
        ASorder(2,5*(i-1)+5+5) = {'Max'} ;
    end
    for i=1:M2; ASorder(i+2,1) = names_moments(show_moments(i))  ; end
    
    % stats of changes implied by each parameter:
    % mean median SD min max
    
    for i=1:M1
        for j=1:M2
            % sum across all combinations of the weighted contrib
            ASorder(2+j,5*(i-1)+5+1) = num2cell(sum(squeeze(store_combination(i,:,show_moments(j))))) ;
            % weighted median
            ASorder(2+j,5*(i-1)+5+2) = num2cell(weightedMedian(squeeze(store_combinationUW(i,:,show_moments(j))),weight(i,:))) ;
            % weighted SD
            ASorder(2+j,5*(i-1)+5+3) = num2cell(sqrt(var(squeeze(store_combinationUW(i,:,show_moments(j))),weight(i,:)))) ;
            % simple mean of unweighted:
            ASorder(2+j,5*(i-1)+5+4) = num2cell(min(squeeze(store_combinationUW(i,:,show_moments(j))))) ;
            ASorder(2+j,5*(i-1)+5+5) = num2cell(max(squeeze(store_combinationUW(i,:,show_moments(j))))) ;
        end
    end
    
    % data:
    ASorder(3:M2+2,2) = num2cell(moments_values_V1(show_moments) );
    ASorder(3:M2+2,3) = num2cell(moments_values_V2(show_moments) ) ;
    ASorder(3:M2+2,4) = num2cell(moments_values_V2(show_moments) - moments_values_V1(show_moments) ) ;
    
    % changing all parameters at once:
    ASorder(3:M2+2,5) = num2cell(all_results2(show_moments) - all_results1(show_moments) ) ;
    if printexcel==1
        xlswrite(namecalibX,ASorder,'decomposition_orders','A1')
    end
    
    % this seems the right thing to add to the paper
    ASorderXXX = zeros(M1,M2) ;
    for i=1:M1
        for j=1:M2
            ASorderXXX(i,j) = sum(squeeze(store_combination(i,:,show_moments(j)))) ;
        end
    end
    
    disp('==================================================================')
    disp('Decomposition: Mean - Selected Moments')
    texprint(ASorderXXX(:,choice_moments)','%6.2f',names_params(select_params2),names_moments(choice_moments))
    
    if showdetails==1
        disp('==================================================================')
        disp('Decomposition: Mean - All Moments')
        texprint(ASorderXXX','%6.2f',names_params(select_params2),names_moments)
    end
    
    % bounds---
    ASorderXXXbounds = zeros(2*M1,M2) ;
    for i=1:M1
        for j=1:M2
            ASorderXXXbounds(2*(i-1)+1,j) = min(squeeze(store_combinationUW(i,:,show_moments(j)))) ;
            ASorderXXXbounds(2*(i-1)+2,j) = max(squeeze(store_combinationUW(i,:,show_moments(j)))) ;
        end
    end
    
    if showdetails==1
        disp('==================================================================')
        disp('Decomposition: Bounds')
        texprint(ASorderXXXbounds(:,choice_moments),'%6.2f',names_moments(choice_moments),names_params(sort([select_params2,select_params2])))
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate sensitivity of estimates to moments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if sensitivity==1
    
    setparamV2 ;
    all_params(select_params1) = x1 ; % value at which to evaluate derivative; here, the estiamte of the first subsample!
    solvestochsteadystateV2 ;
    store_baseline = all_results ;
    shock = 1e-6 ;
    Jacobian = zeros(num_parameters,length(choice_moments)) ;
    for i=1:num_parameters
        setparamV2 ;
        all_params(select_params1) = x1 ; % value at which to evaluate derivative; here, the estiamte of the first subsample
        all_params(select_params1(i)) = x1(i) + shock ; % change in parameter
        solvestochsteadystateV2 ;
        store_variant = all_results ;
        Jacobian(:,i) = ((store_variant(choice_moments)-store_baseline(choice_moments))/shock)' ;
    end
    
    if exist(Weighting)==1
        Lambda = inv(Jacobian'*Weighting*Jacobian)*(Jacobian'*Weighting) ;
    else
        Lambda = inv(Jacobian'*Jacobian)*(Jacobian') ;
    end
    LL = length(choice_moments) ;
    ShowLambda = num2cell(zeros(M1+1,LL+1)) ;
    for i=1:M1; ShowLambda(i+1,1) = names_params(select_params2(i)) ; end
    for i=1:LL; ShowLambda(1,i+1) = names_moments(choice_moments(i)) ; end
    ShowLambda(2:M1+1,2:LL+1) = num2cell(Lambda) ;
    if printexcel==1
        xlswrite(namecalibX,ShowLambda,'identification','A1')
    end
    if showdetails==1
        disp('==================================================================')
        disp('Sensitivity Matrix')
        texprint(100*Lambda,'%6.2f',names_moments(choice_moments),names_params(select_params1))
        disp('==================================================================')
    end
end

%%%%%%%%%%%%%%%%%%
% save results
%%%%%%%%%%%%%%%%%%

eval(strcat('save output\matfiles\results_',namecalib))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calibration over rolling sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if rollingcalibrun==1
    rollingcalib ;
    eval(strcat('save output\matfiles\resultsrolling_',namecalib))
end
