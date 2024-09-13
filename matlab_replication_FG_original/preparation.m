

if intangibleswitch==0
    
    names_params = {'\beta','\mu','p','\delta','\xi',...
        '\alpha','\theta','\sigma','g_N','g_P',...
        'g_Z','g_Q','qstar','shock size','lambda_mismeas','Nbar'};
    
    names_moments = {'Pi/K','Pi/Y','I/Y','RF','PE',...
        'growth pop.','growth emp.','growth gdp','growth price invt','PD',...
        'PE op.','growth TFP','growth TFP adj','ERP w leverage','K/Y',...
        'meas_ystar','Depr','I/K','Share Lab','Share Cap','Share Prof','Spread RKRF','EP unlevered','Spread MU','Spread RP',...
        'Spread gqdelta','growth Y/N','EQ RET','Leverage','meas_kstar','vstar','cstar','meas_xstar','log_meas_ystar','log_meas_xstar',...
        'log_meas_pistar','Emp/Pop','log_true_ystar','log_true_xstar','log_true_pistar','Tobin Q'};
    
    names_moments_nice = {'\Pi/K','\Pi/Y','I/Y','Risk-free rate','Price-Earnings',...
        'Pop. Growth','Employment Growth','GDP Growth','Invt Price Growth','Price-Dividend',...
        'Price-Operating Earnings','TFP growth','TFP adj growth','ERP w leverage','Capital-Output',...
        'meas_ystar','Depreciation','I/K','Share Lab','Share Cap','Share Prof','Spread RKRF','EP unlevered','Spread MU',...
        'Spread RP','Spread gqdelta','Labor Productivity Growth','EQ RET','Leverage','meas_kstar','vstar','cstar',...
        'meas_xstar','log_meas_ystar','log_meas_xstar','log_meas_pistar','Emp./Pop.','log_true_ystar','log_true_xstar','log_true_pistar','Tobin Q'};
    
    
    
    indexP_beta = 1 ;
    indexP_mu = 2 ;
    indexP_p = 3 ;
    indexP_delta = 4 ;
    indexP_ksi = 5 ;
    indexP_alphaCD = 6 ;
    indexP_theta = 7 ;
    indexP_alphaIES = 8 ;
    indexP_gn = 9 ;
    indexP_gp = 10 ;
    indexP_gz = 11 ;
    indexP_gq = 12 ;
    indexP_qstar = 13 ;
    indexP_b = 14 ;
    indexP_lambda = 15 ;
    indexP_nbar = 16 ;
    
    indexM_profitK = 1 ;
    indexM_profitY = 2 ;
    indexM_invtY = 3 ;
    indexM_RF = 4 ;
    indexM_PE = 5 ;
    indexM_growthPOP = 6 ;
    indexM_growthEMP = 7 ;
    indexM_growthGDP = 8 ;
    indexM_growthPI  = 9 ;
    indexM_PD = 10 ;
    indexM_PEop = 11 ;
    indexM_growthTFP = 12 ;
    indexM_growthTFPADJ = 13 ;
    indexM_ERP = 14 ;
    indexM_KY = 15 ;
    indexM_meas_ystar = 16 ;
    indexM_DepRate = 17 ;
    indexM_invtK = 18 ;
    indexM_ShareLab = 19 ;
    indexM_ShareCap = 20 ;
    indexM_ShareProf = 21 ;
    indexM_ERPnonlev = 23 ;
    indexM_SpreadRKRF = 22 ;
    indexM_SpreadRKRFprof = 24 ;
    indexM_SpreadRKRFrisk = 25 ;
    indexM_SpreadRKRFgqdelta = 26 ;
    indexM_growthYN = 27 ;
    indexM_ER = 28 ;
    indexM_LEV = 29 ;
    indexM_meas_kstar = 30 ;
    indexM_vstar = 31 ;
    indexM_cstar = 32 ;
    indexM_meas_xstar = 33 ;
    indexM_logmeasystar = 34 ;
    indexM_logmeasxstar = 35 ;
    indexM_logmeaspistar = 36 ;
    indexM_emppop = 37 ;
    indexM_logtrueystar = 38 ;
    indexM_logtruexstar = 39 ;
    indexM_logtruepistar = 40 ;
    indexM_TobinQ = 41 ;
    
    choice_moments_baseline = [indexM_profitK,indexM_profitY,indexM_RF,indexM_PD,indexM_invtK,indexM_growthTFP,indexM_growthPI,indexM_growthPOP,indexM_emppop] ;
    choice_moments_macro    = setdiff(choice_moments_baseline,indexM_PD);
    choice_moments_macro_womarkups = choice_moments_macro ;
    
    select_params_baseline = [indexP_beta,indexP_mu,indexP_p,indexP_delta,indexP_alphaCD,indexP_gp,indexP_gz,indexP_gq,indexP_nbar] ;
    select_params_macro    = setdiff(select_params_baseline,indexP_p ) ;
    select_params_macro_womarkups = [setdiff(select_params_macro,indexP_mu ) , indexP_ksi] ;
    
else
    
    names_params = {'\beta','\mu','p','\delta_T','\xi',...
        '\alpha_T','\theta','\sigma','g_N','g_P',...
        'g_Z','g_QT','qTstar','shock size','\delta_U','\alpha_U','g_QU','qUstar','\lambda_meas','Nbar'};
    
    names_moments = {'Pi/K','Pi/Y','I/Y','RF','PE',...
        'growth pop.','growth emp.','growth gdp','growth price invt','PD',...
        'PE op.','growth TFP','growth TFP adj','ERP w leverage','K/Y',...
        'ystar','Depr','I/K','Share Lab','Share Cap T ','Share Prof','Spread RKRF',...
        'EP unlevered','Spread MU','Spread RP','Spread gqdelta','growth Y/N','EQ RET',...
        'Leverage','kstar','vstar','cstar','xstar','log(meas_ystar)','log(iTstar)','logcstar','Emp/Pop','IUY','IUKU','ProfitKU','priceinvtU','share Cap U','log(true_ystar)','log(true_iUstar)','log(true_kUstar)','Tobin Q'};
    
    names_moments_nice = {'\Pi/K','\Pi/Y','I/Y','Risk-free rate','Price-Earnings','Population Growth','Employment Growth','GDP Growth','Investment Price Growth','Price-Dividend',...
        'Price-Operating Earnings','TFP growth','TFP adj growth','ERP w leverage','Capital-Output',...
        'ystar','Depreciation','I/K','Share Lab','Share Cap T','Share Prof','Spread RKRF','EP unlevered''Spread MU',...
        'Spread RP','Spread gqdelta','Labor Productivity Growth','EQ RET','Leverage','kstar','vstar','cstar',...
        'xstar','log(meas_ystar)','log(iTstar)','logcstar','Emp/Pop','IUY','IUKU','ProfitKU','priceinvtU','share Cap U','log(true_ystar)','log(true_iUstar)','log(true_kUstar)','Tobin Q'};
    
    indexP_beta = 1 ;
    indexP_mu = 2 ;
    indexP_p = 3 ;
    indexP_deltaT = 4 ;
    indexP_ksi = 5 ;
    indexP_alphaCDT = 6 ;
    indexP_theta = 7 ;
    indexP_alphaIES = 8 ;
    indexP_gn = 9 ;
    indexP_gp = 10 ;
    indexP_gz = 11 ;
    indexP_gqT = 12 ;
    indexP_qTstar = 13 ;
    indexP_b = 14 ;
    indexP_deltaU = 15 ;
    indexP_alphaCDU = 16 ;
    indexP_gqU = 17 ;
    indexP_qUstar = 18 ;
    indexP_lambda = 19 ;
    indexP_nbar = 20 ;
    
    indexM_profitK = 1 ;
    indexM_profitY = 2 ;
    indexM_invtY = 3 ;
    indexM_RF = 4 ;
    indexM_PE = 5 ;
    indexM_growthPOP = 6 ;
    indexM_growthEMP = 7 ;
    indexM_growthGDP = 8 ;
    indexM_growthPI  = 9 ;
    indexM_PD = 10 ;
    indexM_PEop = 11 ;
    indexM_growthTFP = 12 ;
    indexM_growthTFPADJ = 13 ;
    indexM_ERP = 14 ;
    indexM_KY = 15 ;
    indexM_ystar = 16 ;
    indexM_DepRate = 17 ;
    indexM_invtK = 18 ;
    indexM_ShareLab = 19 ;
    indexM_ShareCapT = 20 ;
    indexM_ShareProf = 21 ;
    indexM_ERPnonlev = 23 ;
    indexM_SpreadRKRF = 22 ;
    indexM_SpreadRKRFprof = 24 ;
    indexM_SpreadRKRFrisk = 25 ;
    indexM_SpreadRKRFgqdelta = 26 ;
    indexM_growthYN = 27 ;
    indexM_ER = 28 ;
    indexM_LEV = 29 ;
    indexM_kstar = 30 ;
    indexM_vstar = 31 ;
    indexM_cstar = 32 ;
    indexM_xstar = 33 ;
    indexM_logmeasystar = 34 ;
    indexM_logmeasxtstar = 35 ;
    indexM_logcstar = 36 ;
    indexM_emppop = 37 ;
    indexM_iuy = 38 ;
    indexM_iuku= 39 ;
    indexM_piku = 40 ;
    indexM_priceu = 41 ;
    indexM_shareCapU = 42 ;
    indexM_logtrueystar= 43 ;
    indexM_logtruexustar = 44 ;
    indexM_logtruekustar = 45 ;
    indexM_TobinQ = 46 ;
    
    % 3 more parsms: alphaU, deltaU, gqU
    % 3 more moments: prices, iu/ku, and pi/ku (i.e. ku/kt)
    
    choice_moments_baseline = [indexM_profitK,indexM_profitY,indexM_RF,indexM_PD,indexM_invtK,indexM_growthTFP,indexM_growthPI,indexM_growthPOP,indexM_iuku,indexM_piku,indexM_priceu,indexM_emppop] ;
    choice_moments_macro    = setdiff(choice_moments_baseline,indexM_PD) ; 
    choice_moments_macro_womarkups = choice_moments_macro ;
    select_params_baseline = [indexP_beta,indexP_mu,indexP_p,indexP_deltaT,indexP_alphaCDT,indexP_gp,indexP_gz,indexP_gqT,indexP_alphaCDU,indexP_deltaU,indexP_gqU,indexP_nbar] ;
    select_params_macro    = setdiff(select_params_baseline,indexP_p) ;
    select_params_macro_womarkups = [setdiff(select_params_macro,indexP_mu),indexP_ksi] ;
end


