
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this file estimates all the different model variants 
% then prints out tables
% does not run transitional dynamics (for simplicity)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all ; close all ; clc ;

global select_params choice_moments Weighting exactident
global identbetastar leverageadj leverageadjfactor riskapproach forcegngp
global intangibleswitch
global all_params all_results moments_values

calc = 1 ;

if calc==1
    
    for numresults=1
        
        % dataset:
        [data,names] = xlsread('data\V3_timeseries__postrev_I1Y_19-Oct-2018.csv') ;
        
        % switches:
        printexcel = 1 ; % set to 1 to print an excel sheet
        showdetails = 0 ; % set to 1 to print out more stuff onscreen
        plotmoments = 0 ;  % set to 1 to print figures of moments
        showcompstatics = 0  ; % set to 1 to print figures of comparative statics
        exactident  = 1 ; % technical: better solution if exactly identified (if 1, use fsolve, exactly identified case, if 0, use fminsearch)
        rollingcalibrun = 0 ; % if 1, do rolling calibration
        ordering = 1 ; % if 1, calculate effect of each parameter taking into account the nonlinearities (i.e. ordering)
        sensitivity = 1 ; % if 1 ,calculate the sensitivity of moments to parameters (the test of shapiro et al.)
        Ts = 5 ; % number of years for smoothong of moments (two-sided: (-Ts:Ts))
        identbetastar = 1 ; % set to 1 to make betastar, rather than beta, the estimated parameter
        forcegngp = 1 ; % force equlity of growth pop and growth employment (
        printtopaperfolder = 0 ; % set to 1 to print eps and png in output\paperfigs
        leverageadj = 0 ; % if 0, no leverage; if 1, do simple leverge adj; if 2, adjust PD ratio for elverage. note:could add wedge in cost of debt
        riskapproach = 2 ; % if 0, this is the standard disaster (no offset) if 1, this is disaster adjusted to have a mean of 1 with positive drift,
        % if 2 this is disaster adjusted with "windfall" to have mean 1 (baseline) and if 3 this is lognormal risk
        yearstart = 1989 ; % rolling sample start (1984+5)
        yearend = 2011 ; % rolling sample end (2016-5)
        yearstart1 = 1984 ; % beginning of first half of sample
        yearstart2 = 2001 ; % beginning of second half of sample
        yearend1 = 2000 ; % end of first half of sample
        yearend2 = 2016 ; % end of second half of sample
        transitionaldynamics = 0 ; % calculation of transitional dynamics
        transitionalcalib = 0 ; % optimizatoin of transitional dynamics
        intangibleswitch = 0 ; % set to 1 to estimate full model with intangibles
        adjustexogparamsecond = 0 ; % if 1, some parameters are changed exogenously from 1st to 2nd subsample (and not estimated) 
        % (This is used when we change the share of measured intangibles)
        list_params_nonest = [] ; % this is the list of parameters not estimated
        values_params_nonest = [] ; % values of parameters not estimated
        values_params_nonest2 = [] ; % values of parameters not estimated in 2nd sample (if values of parameters not estimated==1)
        
        
        
        preparation ; % sets up the list of parameters and moments - NOTE this depends on the intangible switch
        
        % default moments:
        choice_moments = choice_moments_baseline ;
        select_params = select_params_baseline ;
 
        switch numresults
            case 1
                namecalib = 'baseline' ;
                printtopaperfolder = 1 ; % set to 1 to print eps and png in output\paperfigs
                plotmoments = 0 ;  % set to 1 to print figures of moments
                showcompstatics = 0  ; % set to 1 to print figures of comparative statics
            case 2
                % estimate with macro moments
                namecalib = 'baselinemacro' ;
                choice_moments = choice_moments_macro ;
                select_params = select_params_macro ;
            case 3
                % rolling estimation on longer sample
                namecalib = 'longrollback' ;
                [data,names] = xlsread('data\V3old_timeseries__postrev_I1Y_19-Oct-2018.csv') ;
                rollingcalibrun = 1 ;
                yearstart = 1951 ;
                yearend = 2011 ;
                yearstart1 = 1960 ;
                yearend1 = 1992 ;
                yearstart2 = 1993 ;
                yearend2 = 2016 ;
            case 5
                % IES = 1 estimation
                namecalib = 'IESunity' ;
                list_params_nonest = [indexP_alphaIES] ;
                values_params_nonest = [1] ;
            case 6
                % IES = .5 estimation
                namecalib = 'IESlow' ;
                list_params_nonest = [indexP_alphaIES] ;
                values_params_nonest = [2] ;
            case 7
                % model with time-varying risk aversion
                namecalib = 'tvriskaversion' ;
                list_params_nonest = [indexP_p] ;
                values_params_nonest = [0.02] ;
                select_params = [setdiff(select_params_baseline,indexP_p),indexP_theta] ;
            case 8
                % lognormal risk
                namecalib = 'baseline_lognormal' ;
                riskapproach = 3 ;
            case 9
                % time-varying disaster size
                namecalib = 'tvsize' ;
                list_params_nonest = [indexP_p] ;
                values_params_nonest = [0.02] ;
                select_params = [setdiff(select_params_baseline,indexP_p),indexP_b] ;
            case 10
                % other risk approach: small upside
                namecalib = 'baseline_smallupside' ;
                riskapproach = 1 ;
            case 11
                % other risk approach: no offset
                namecalib = 'baseline_nooffset' ;
                riskapproach = 0 ;
            case 12
                namecalib = 'leverage' ;
                leverageadj = 1 ;
            case 13
                % alternative target for risk free rate
                namecalib = 'AA' ;
                [data,names] = xlsread('data\V3_timeseries__postrev_IAA_19-Oct-2018.csv') ;
            case 14
                % alternative target for risk free rate
                namecalib = '10YLESSREP' ;
                [data,names] = xlsread('data\V3_timeseries__postrev_I10YLESSREP_22-Oct-2018.csv') ;
            case 15
                % mismeasurement of capital: miss 10% of capital in first
                % sample, and 10% in the second sample
                namecalib = 'mismeasK1010' ;
                list_params_nonest = [indexP_lambda] ;
                values_params_nonest = [0.9] ;
                adjustexogparamsecond = 1 ;
                values_params_nonest2 = [0.9] ;
            case 16
                % mismeasurement of capital: now miss 20% in the second
                % sample
                namecalib = 'mismeasK1020' ;
                list_params_nonest = [indexP_lambda] ;
                values_params_nonest = [0.9] ;
                adjustexogparamsecond = 1 ;
                values_params_nonest2 = [0.8] ;
            case 17
                % mismeasurement of capital: now miss 30% in the second
                % sample
                namecalib = 'mismeasK1030' ;
                list_params_nonest = [indexP_lambda] ;
                values_params_nonest = [0.9] ;
                adjustexogparamsecond = 1 ;
                values_params_nonest2 = [0.7] ;
            case 18
                % macro without markups
                list_params_nonest = [] ;
                adjustexogparamsecond = 0 ;
                namecalib = 'baselinemacronomarkup' ;
                choice_moments = choice_moments_macro_womarkups ; % defined in preparation.m
                select_params = select_params_macro_womarkups ;
            case 19
                % baseline model, but betastar is the estimated parameter
                % (instead of beta) - just for nicer sensitivity table in
                % appendix
                namecalib = 'baselinebetastar' ;
                identbetastar = 1 ;
            case 20
                intangibleswitch = 1 ;
                preparation ; % need to re-rerun for this case
                choice_moments = choice_moments_baseline ;
                select_params = select_params_baseline ;
                namecalib = 'intang_nomis' ;
                [data,names] = xlsread('data\V3INT_timeseries__postrev_I1Y_19-Oct-2018.csv') ;
            case 21
                intangibleswitch = 1 ;
                preparation ; % need to re-rerun for this case
                choice_moments = choice_moments_baseline ;
                select_params = select_params_baseline ;
                namecalib = 'intang_mis33' ;
                [data,names] = xlsread('data\V3INT_timeseries__postrev_I1Y_19-Oct-2018.csv') ;
                list_params_nonest = [indexP_lambda] ;
                values_params_nonest = [2/3] ;
            case 22
                intangibleswitch = 1 ;
                preparation ; % need to re-rerun for this case
                choice_moments = choice_moments_baseline ;
                select_params = select_params_baseline ;
                namecalib = 'intang_mis50' ;
                [data,names] = xlsread('data\V3INT_timeseries__postrev_I1Y_19-Oct-2018.csv') ;
                list_params_nonest = [indexP_lambda] ;
                values_params_nonest = [1/2] ;
            case 23
                intangibleswitch = 1 ;
                preparation ; % need to re-rerun for this case
                choice_moments = choice_moments_baseline ;
                select_params = select_params_baseline ;
                namecalib = 'intang_mis66' ;
                [data,names] = xlsread('data\V3INT_timeseries__postrev_I1Y_19-Oct-2018.csv') ;
                list_params_nonest = [indexP_lambda] ;
                values_params_nonest = [1/3] ;        
            case 24
                intangibleswitch = 1 ;
                preparation ; % need to re-rerun for this case
                choice_moments = choice_moments_baseline ;
                select_params = select_params_baseline ;
                namecalib = 'intang_mis75' ;
                [data,names] = xlsread('data\V3INT_timeseries__postrev_I1Y_19-Oct-2018.csv') ;
                list_params_nonest = [indexP_lambda] ;
                values_params_nonest = [1/4] ;        
        end
        
        calibrationV8 ;
        close all ;        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tables
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% replicationtables ;

