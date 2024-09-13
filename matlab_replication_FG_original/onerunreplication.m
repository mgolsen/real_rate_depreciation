
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simple program to just do basic exercise
% (i.e. no transitional dynamics)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
global select_params choice_moments Weighting exactident pop_eq_work_force identbetastar
global identbetastar leverageadj leverageadjfactor riskapproach forcegngp
global intangibleswitch
global all_params all_results moments_values


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pick dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% baseline:
if pop_eq_work_force == 0
    [data,names] = xlsread('data\V3_timeseries__postrev_I1Y_19-Oct-2018_orig.csv') ;
end 
if pop_eq_work_force == 1 
    [data,names] = xlsread('data\V3_timeseries__postrev_I1Y_19-Oct-2018_altered.csv') ;
end

% using longer sample:
% [data,names] = xlsread('data\V3old_timeseries__postrev_I1Y_19-Oct-2018.csv') ;

% using different interest rates:
% [data,names] = xlsread('data\V3_timeseries__postrev_IAA_19-Oct-2018.csv') ;
% [data,names] = xlsread('data\V3_timeseries__postrev_I10YLESSREP_22-Oct-2018.csv') ;

% for intangible exercise:
% [data,names] = xlsread('data\V3INT_timeseries__postrev_I1Y_19-Oct-2018.csv') ;

%%%%%%%%%%%%%%%%%%%%%%%%
% switches
%%%%%%%%%%%%%%%%%%%%%%%%

printexcel = 1 ; % set to 1 to print an excel sheet
plotmoments = 0 ;  % set to 1 to print figures of data moments (figure 4 in the paper)
showdetails = 0 ; % display some additional results
showcompstatics = 0  ; % set to 1 to print figures of comparative statics
exactident = 1 ; % technical: better solution if exactly identified (if 1, use fsolve, exactly identified case, if 0, use fminsearch)
rollingcalibrun = 0 ; % if 1, do rolling calibration
Ts = 5 ; % number of years for smoothing of moments (two-sided; (-Ts:Ts))
yearstart = 1989 ; % rolling sample start
yearend = 2011 ; % rolling sample end
yearstart1 = 1984 ; % first sample start
yearend1 = 2000 ; % second sample start
yearstart2 = 2001 ; % first sample end
yearend2 = 2016 ; % second sample end
ordering = 1 ; % if 1, calculate effect of each parameter taking into account the nonlinearities (i.e. ordering) - note the ordering is exponential in # of parameters
sensitivity = 1 ; % if 1 ,calculate the sensitivity of moments to parameters (the test of shapiro et al.)
%identbetastar = 0 ; % use betastar as target for identification instead of beta (i.e. replace beta with betastar)
printtopaperfolder = 0 ; % if 1, print to folder of paper
leverageadj = 0 ; % if 0, no leverage; if 1, do simple leverge adj; if 2, adjust PD ratio for elverage. note:could add wedge in cost of debt
riskapproach = 2  ; % if 0, this is the standard disaster, if 1, this is disaster adjusted to have a mean of 1 with positive drift,
                    % if 2 this is disaster adjusted with "windfall" to have mean 1, and if 3 this is lognormal risk
forcegngp = 1 ; % set gn = gp (note the level of n/p is estimated) not an option used anymore, has to stay to 1
intangibleswitch = 0 ; % if 1, use the appendix model with intangibles
adjustexogparamsecond = 0 ; % set to 1 if you want to change exogenously some parameters between the samples (and not estimate them)
% (This is used when we change the share of measured intangibles)
list_params_nonest = [] ; % this is the list of parameters not estimated
values_params_nonest = [] ; % values of parameters not estimated
values_params_nonest2 = [] ; % values of parameters not estimated in 2nd sample (if values of parameters not estimated==1)
     
% set names etc.: needed to get the choice of moments and parameters 
preparation ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some simple examples:
% see file preparation.m for list of moments and parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% baseline:
namecalib = 'baseline' ;
choice_moments = choice_moments_baseline ;
select_params = select_params_baseline ;

% macro w markups:
% namecalib = 'baselinemacro' ;
% choice_moments = choice_moments_macro ;
% select_params = select_params_macro ;

% macro wo markups: use these lines
% namecalib = 'baselinemacrowomarkups' ;
% choice_moments = choice_moments_macro_womarkups ;
% select_params = select_params_macro_womarkups ;

% intangibles: need to switch dataset above:  use these lines
% intangibleswitch = 1 ;
% preparation ;
% namecalib = 'intang_nomismeas' ;
% choice_moments = choice_moments_baseline ;
% select_params = select_params_baseline ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run optimization and produce tables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

calibrationV8 ;





