

global intangibleswitch select_params choice_moments moments_values all_results Weighting
global exactident targetnetgrossreturn adjustleveleffects yini numyears identbetastar forcegngp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibration on a rolling sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% let's do 1984+5 = 1989 to 2016-5=2011
samplerolling = find(year>=yearstart&year<=yearend) ;


targets_TS = targetmom_timeseries_smoothed(samplerolling,:) ;
% targets_TS = targetmom_timeseries_smoothed(samplerolling,:) ;
% targets_TS = targetmom_timeseries_smoothed(samplerolling,:) ;
% for t=Ts+1:T-Ts
%     for i=1:size(targetmom_timeseries,2)
%         targetmom_timeseries_smoothed(t,i) = nanmean(targetmom_timeseries(t-Ts:t+Ts,i));
%     end
% end

TT = size(targets_TS,1) ;
year2 = year(samplerolling) ;

store_param = NaN*ones(TT,length(all_params)) ;
store_check = NaN*ones(TT,1) ;
store_implied_moments = NaN*ones(TT,length(all_results)) ;

store_param_macro = NaN*ones(TT,length(all_params)) ;
store_check_macro = NaN*ones(TT,1) ;
store_implied_moments_macro = NaN*ones(TT,length(all_results)) ;

for t=1:TT
    
    disp(floor(100*t/TT))
    
    setparamV2 ;
    
    moments_values = targets_TS(t,:) ;
    
    % choose starting point iteratively
    if t==1
        x0 = all_params(select_params_baseline) ;
        %         x0(indexP_p) = 0.02 ;
        x0macro = all_params(select_params_macro) ;
    else
        x0 = store_param(t-1,select_params_baseline) ;
        x0macro = store_param_macro(t-1,select_params_macro) ;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Fit baseline model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    select_params = select_params_baseline ;
    choice_moments = choice_moments_baseline ;
    %     Weighting = eye(length(choice_moments)) ;
    
    if exactident==1
        options = optimoptions('fsolve','MaxFunEvals',2000,'MaxIter',1000);
        [x1x,check1x] = fsolve(@solvecalibrationV2,x0,options) ;
    else
        optimset.MaxFunEvals = 2000 ;
        optimset.MaxIter = 1000 ;
        [x1x,check1x] = fminsearch(@solvecalibrationV2,x0,optimset) ;
    end
    
    store_param(t,:) = all_params ;
    store_param(t,select_params) = x1x ;
    store_check(t,:) = max(abs(check1x)) ;
    store_implied_moments(t,:) = all_results ;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % for comparison -- macro exercise: do not target PD, assume p =0 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    select_params = select_params_macro ;
    choice_moments = choice_moments_macro ;
    %     Weighting = eye(length(choice_moments)) ;
    
    if exactident==1
        options = optimoptions('fsolve','MaxFunEvals',2000,'MaxIter',1000);
        [x1x,check1x] = fsolve(@solvecalibrationV2,x0macro,options) ;
    else
        optimset.MaxFunEvals = 2000 ;
        optimset.MaxIter = 1000 ;
        [x1x,check1x] = fminsearch(@solvecalibrationV2,x0macro,optimset) ;
    end
    
    store_param_macro(t,:) = all_params ;
    store_param_macro(t,select_params) = x1x ;
    store_check_macro(t,:) = max(abs(check1x)) ;
    store_implied_moments_macro(t,:) = all_results ;
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%
% add graphs
%%%%%%%%%%%%%%%%%%%%%%%%%

rollinggraphs ;
