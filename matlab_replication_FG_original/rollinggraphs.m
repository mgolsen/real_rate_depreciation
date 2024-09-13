%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot fit of moments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

choice_moments_show = choice_moments_baseline ;

figure ;
for i=1:length(choice_moments_show)
    if intangibleswitch==0
        subplot(3,3,i) ;
    else
        subplot(4,4,i) ;
    end
    plot(year2,store_implied_moments(:,choice_moments_show(i)),'bo-') ;
    hold on ;
    plot(year2,targets_TS(:,choice_moments_show(i)),'r+-') ;
    if i==1; legend('model','data') ; end
    title(names_moments(choice_moments_show(i))) ;
end

eval(strcat('print -dpdf output\figurerolling\',namecalib,'\fit_over_time'))
eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\fit_over_time'))
eval(strcat('print -dpng output\figurerolling\',namecalib,'\fit_over_time'))
%
% print -depsc2 output\figurerolling\fit_over_time
% print -dpng output\figurerolling\fit_over_time

if printtopaperfolder==1
    if strcmp(namecalib,'longrollback')==1
        namecalibS = '' ;
    else
        namecalibS = strcat('_',namecalib) ;
    end
    eval(strcat('print -dpdf output\paperfigs\fit_over_time',namecalibS))
    eval(strcat('print -depsc2 output\paperfigs\fit_over_time',namecalibS))
    eval(strcat('print -dpng output\paperfigs\fit_over_time',namecalibS))
end

figure ;
for i=1:length(choice_moments_show)
    if intangibleswitch==0
        subplot(3,3,i) ;
    else
        subplot(4,4,i);
    end
    plot(year2,store_implied_moments(:,choice_moments_show(i)),'bo-') ;
    hold on ;
    plot(year2,targets_TS(:,choice_moments_show(i)),'r+-') ;
    hold on ;
    plot(year2,store_implied_moments_macro(:,choice_moments_show(i)),'gx-') ;
    if i==1; legend('model','data','model macro') ; end
    title(names_moments(choice_moments_show(i))) ;
end

eval(strcat('print -dpdf output\figurerolling\',namecalib,'\fit_over_time_wmacro'))
eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\fit_over_time_wmacro'))
eval(strcat('print -dpng output\figurerolling\',namecalib,'\fit_over_time_wmacro'))

if printtopaperfolder==1
    
    eval(strcat('print -dpdf output\paperfigs\fit_over_time_wmacro',namecalibS))
    eval(strcat('print -depsc2 output\paperfigs\fit_over_time_wmacro',namecalibS))
    eval(strcat('print -dpng output\paperfigs\fit_over_time_wmacro',namecalibS))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

select_params_show = select_params_baseline ;

figure ;
for i=1:length(select_params_show)
    if intangibleswitch==0
        subplot(3,3,i) ;
    else
        subplot(4,4,i) ;
    end
    plot(year2,store_param(:,select_params_show(i)),'b-') ;
    title(names_params(select_params_show(i))) ;
    axis tight 
end

Aexcelparams = num2cell(zeros(size(store_param,1)+1,size(store_param,2)+1)) ;
Aexcelparams(1,2:end) = names_params ;
Aexcelparams(2:end,1) = num2cell(year2) ;
Aexcelparams(2:end,2:end) = num2cell(store_param) ;
xlswrite(strcat('output\figurerolling\',namecalib,'.xls'),Aexcelparams)

eval(strcat('print -dpdf output\figurerolling\',namecalib,'\parameters_over_time'))
eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\parameters_over_time'))
eval(strcat('print -dpng output\figurerolling\',namecalib,'\parameters_over_time'))
if printtopaperfolder==1
    eval(strcat('print -dpdf output\paperfigs\parameters_over_time',namecalibS))
    eval(strcat('print -depsc2 output\paperfigs\parameters_over_time',namecalibS))
    eval(strcat('print -dpng output\paperfigs\parameters_over_time',namecalibS))
end

% comparison w macro parameters
figure ;
for i=1:length(select_params_show)
    if intangibleswitch==0
        subplot(3,3,i) ;
    else
        subplot(4,4,i);
    end
    plot(year2,store_param(:,select_params_show(i)),'bx-') ;
    hold on ;
    plot(year2,store_param_macro(:,select_params_show(i)),'ro-') ;
    title(names_params(select_params_show(i))) ;
end


eval(strcat('print -dpdf output\figurerolling\',namecalib,'\parameters_over_time_wmacro'))
eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\parameters_over_time_wmacro'))
eval(strcat('print -dpng output\figurerolling\',namecalib,'\parameters_over_time_wmacro'))
if printtopaperfolder==1
    eval(strcat('print -dpdf output\paperfigs\parameters_over_time_wmacro',namecalibS))
    eval(strcat('print -depsc2 output\paperfigs\parameters_over_time_wmacro',namecalibS))
    eval(strcat('print -dpng output\paperfigs\parameters_over_time_wmacro',namecalibS))
end

% plot a few parameters side by side
select_params_show_pa = [indexP_beta,indexP_mu] ;

figure ;
for i=1:length(select_params_show_pa)
    subplot(2,1,i) ;
    plot(year2,store_param(:,select_params_show_pa(i)),'kx-','LineWidth',2) ;
    hold on ;
    plot(year2,store_param_macro(:,select_params_show_pa(i)),'k-','LineWidth',2) ;
    title(names_params(select_params_show_pa(i))) ;
end


eval(strcat('print -dpdf output\figurerolling\',namecalib,'\parameters_over_time_wmacroB'))
eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\parameters_over_time_wmacroB'))
eval(strcat('print -dpng output\figurerolling\',namecalib,'\parameters_over_time_wmacroB'))
if printtopaperfolder==1
    eval(strcat('print -dpdf output\paperfigs\parameters_over_time_wmacroB',namecalibS))
    eval(strcat('print -depsc2 output\paperfigs\parameters_over_time_wmacroB',namecalibS))
    eval(strcat('print -dpng output\paperfigs\parameters_over_time_wmacroB',namecalibS))
end


% plot a few parameters side by side - changes

figure ;
for i=1:length(select_params_show_pa)
    subplot(2,1,i) ;
    plot(year2,store_param(:,select_params_show_pa(i))-store_param(1,select_params_show_pa(i)),'kx-','LineWidth',2) ;
    hold on ;
    plot(year2,store_param_macro(:,select_params_show_pa(i))-store_param_macro(1,select_params_show_pa(i)),'k-','LineWidth',2) ;
    title(names_params(select_params_show_pa(i))) ;
end


eval(strcat('print -dpdf output\figurerolling\',namecalib,'\parameters_over_time_wmacroC'))
eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\parameters_over_time_wmacroC'))
eval(strcat('print -dpng output\figurerolling\',namecalib,'\parameters_over_time_wmacroC'))
if printtopaperfolder==1
    eval(strcat('print -dpdf output\paperfigs\parameters_over_time_wmacroC',namecalibS))
    eval(strcat('print -depsc2 output\paperfigs\parameters_over_time_wmacroC',namecalibS))
    eval(strcat('print -dpng output\paperfigs\parameters_over_time_wmacroC',namecalibS))
end


% plot tail risk in particular

figure ;
XXX = 100*store_param(:,select_params_baseline(indexP_p)) ;
plot(year2,XXX,'b-','LineWidth',1.5) ;
axis([min(year2) max(year2) 0 max(XXX)])
title('Probability of crisis')
ylabel('% per year')
set(gca,'Fontsize',12)


eval(strcat('print -dpdf output\figurerolling\',namecalib,'\tailrisk'))
eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\tailrisk'))
eval(strcat('print -dpng output\figurerolling\',namecalib,'\tailrisk'))
if printtopaperfolder==1
    eval(strcat('print -dpdf output\paperfigs\tailrisk',namecalibS))
    eval(strcat('print -depsc2 output\paperfigs\tailrisk',namecalibS))
    eval(strcat('print -dpng output\paperfigs\tailrisk',namecalibS))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% numerical check: how well did we fit ?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure ; plot(year2,store_check);title('model error')
eval(strcat('print -dpdf output\figurerolling\',namecalib,'\model_error'))
eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\model_error'))
eval(strcat('print -dpng output\figurerolling\',namecalib,'\model_error'))
% print -dpdf output\figurerolling\model_error
% print -depsc2 output\figurerolling\model_error
% print -dpng output\figurerolling\model_error


figure ; plot(year2,store_check_macro);title('macro model error')
eval(strcat('print -dpdf output\figurerolling\',namecalib,'\model_error_macro'))
eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\model_error_macro'))
eval(strcat('print -dpng output\figurerolling\',namecalib,'\model_error_macro'))
% print -dpdf output\figurerolling\model_error_macro
% print -depsc2 output\figurerolling\model_error_macro
% print -dpng output\figurerolling\model_error_macro

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot other implications: returns, K/Y, ystar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure ;
if leverageadj>0
    plot(year2,store_implied_moments(:,indexM_ERP),'m-','LineWidth',2);
    hold on ;
end
plot(year2,store_implied_moments(:,indexM_ERPnonlev),'b-','LineWidth',2);
hold on ;
plot(year2,store_implied_moments(:,indexM_RF),'g-','LineWidth',2);
hold on ;
plot(year2,store_implied_moments(:,indexM_ER),'r-','LineWidth',2);

ZZ = [store_implied_moments(:,indexM_ER),store_implied_moments(:,indexM_ERPnonlev),store_implied_moments(:,indexM_ERP),store_implied_moments(:,indexM_RF)];
mm = min(ZZ(ZZ>-99));
mm2 = max(ZZ(ZZ<99)) ;
axis([year2(1) year2(end) mm mm2])
if leverageadj>0
    legend('ERP lev','ERP unlev','RF','ER lev','Location','SouthWest')
else
    legend('ERP','RF','ER','Location','SouthWest')
end
title('Returns')


eval(strcat('print -dpdf output\figurerolling\',namecalib,'\model_impl1'))
eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\model_impl1'))
eval(strcat('print -dpng output\figurerolling\',namecalib,'\model_impl1'))
if printtopaperfolder==1
    eval(strcat('print -dpdf output\paperfigs\model_impl1',namecalibS))
    eval(strcat('print -depsc2 output\paperfigs\model_impl1',namecalibS))
    eval(strcat('print -dpng output\paperfigs\model_impl1',namecalibS))
end




% figure ; plot(year2,store_implied_moments(:,indexM_KY),'b-','LineWidth',2);
% hold on; plot(year2,store_implied_moments_macro(:,indexM_KY),'g-','LineWidth',2);
% title(names_moments(indexM_KY))
% legend('model','model macro','Location','Best')
% print -dpdf output\figurerolling\model_impl2
% print -depsc2 output\figurerolling\model_impl2
% print -dpng output\figurerolling\model_impl2
%
% if printtopaperfolder==1
%     print -dpdf output\paperfigs\model_impl2
%     print -depsc2 output\paperfigs\model_impl2
%     print -dpng output\paperfigs\model_impl2
% end
%
%
% figure ; plot(year2,store_implied_moments(:,indexM_ystar),'b-','LineWidth',2);
% hold on; plot(year2,store_implied_moments_macro(:,indexM_ystar),'g-','LineWidth',2);
% title(names_moments(16))
% legend('model','model macro','Location','Best')
% print -dpdf output\figurerolling\model_impl3
% print -depsc2 output\figurerolling\model_impl3
% print -dpng output\figurerolling\model_impl3
%
% if printtopaperfolder==1
%     print -dpdf output\paperfigs\model_impl3
%     print -depsc2 output\paperfigs\model_impl3
%     print -dpng output\paperfigs\model_impl3
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% income distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if intangibleswitch==0
    figure ; plot(year2,store_implied_moments(:,indexM_ShareCap)+store_implied_moments(:,indexM_ShareProf),'b-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments(:,indexM_ShareCap),'r-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments(:,indexM_ShareProf),'g-','LineWidth',2);
    ZZ = store_implied_moments(:,indexM_ShareCap)+store_implied_moments(:,indexM_ShareProf) ;
    title('Decomposition of income')
    axis([year2(1) year2(end) 0 max(ZZ)])
    legend('capital+rents','capital','rents','Location','SouthEast')
    
    
    eval(strcat('print -dpdf output\figurerolling\',namecalib,'\model_impl4'))
    eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\model_impl4'))
    eval(strcat('print -dpng output\figurerolling\',namecalib,'\model_impl4'))
    if printtopaperfolder==1
        eval(strcat('print -dpdf output\paperfigs\model_impl4',namecalibS))
        eval(strcat('print -depsc2 output\paperfigs\model_impl4',namecalibS))
        eval(strcat('print -dpng output\paperfigs\model_impl4',namecalibS))
    end
    
    
    figure ; plot(year2,store_implied_moments(:,indexM_ShareCap),'r-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments_macro(:,indexM_ShareCap),'r-p','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments(:,indexM_ShareProf),'g-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments_macro(:,indexM_ShareProf),'g-p','LineWidth',2);
    
    ZZ = [store_implied_moments(:,indexM_ShareCap)',store_implied_moments_macro(:,indexM_ShareCap)',...
        store_implied_moments(:,indexM_ShareProf)',store_implied_moments_macro(:,indexM_ShareProf)'] ;
    title('Decomposition of income')
    axis([year2(1) year2(end) min(ZZ) max(ZZ)])
    legend('capital','capital-macro','rents','rents-macro','Location','Best')
    
    
    eval(strcat('print -dpdf output\figurerolling\',namecalib,'\model_impl4b'))
    eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\model_impl4b'))
    eval(strcat('print -dpng output\figurerolling\',namecalib,'\model_impl4b'))
    if printtopaperfolder==1
        eval(strcat('print -dpdf output\paperfigs\model_impl4b',namecalibS))
        eval(strcat('print -depsc2 output\paperfigs\model_impl4b',namecalibS))
        eval(strcat('print -dpng output\paperfigs\model_impl4b',namecalibS))
    end
    
    
    figure ;
    subplot(2,1,1);
    plot(year2,store_implied_moments(:,indexM_ShareCap),'k-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments_macro(:,indexM_ShareCap),'k-p','LineWidth',2);
    title('True capital share')
    axis tight
    legend('model','model-macro','Location','Best')
    subplot(2,1,2) ;
    plot(year2,store_implied_moments(:,indexM_ShareProf),'k-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments_macro(:,indexM_ShareProf),'k-p','LineWidth',2);
    title('Profit share')
    axis tight
    
    
    eval(strcat('print -dpdf output\figurerolling\',namecalib,'\model_impl4c'))
    eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\model_impl4c'))
    eval(strcat('print -dpng output\figurerolling\',namecalib,'\model_impl4c'))
    
    if printtopaperfolder==1
        eval(strcat('print -dpdf output\paperfigs\model_impl4c',namecalibS))
        eval(strcat('print -depsc2 output\paperfigs\model_impl4c',namecalibS))
        eval(strcat('print -dpng output\paperfigs\model_impl4c',namecalibS))
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % spread
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure ;
    plot(year2,store_implied_moments(:,indexM_SpreadRKRF),'b-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments(:,indexM_SpreadRKRFgqdelta),'k-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments(:,indexM_SpreadRKRFrisk),'r-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments(:,indexM_SpreadRKRFprof),'g-','LineWidth',2);
    axis tight ;
    %     axis([year2(1) year2(end) 0 16])
    title('Decomposition of Spread MPK-RF')
    legend('Total','Depreciation','Risk','Rents','Location','NW')
    
    
    eval(strcat('print -dpdf output\figurerolling\',namecalib,'\model_impl5'))
    eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\model_impl5'))
    eval(strcat('print -dpng output\figurerolling\',namecalib,'\model_impl5'))
    if printtopaperfolder==1
        eval(strcat('print -dpdf output\paperfigs\model_impl5',namecalibS))
        eval(strcat('print -depsc2 output\paperfigs\model_impl5',namecalibS))
        eval(strcat('print -dpng output\paperfigs\model_impl5',namecalibS))
    end
    
    
    figure ;
    subplot(1,3,1) ;
    plot(year2,store_implied_moments(:,indexM_SpreadRKRFprof),'b-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments_macro(:,indexM_SpreadRKRFprof),'bp-','LineWidth',2);
    title('Rent component');
    % plot(year2,store_implied_moments(:,indexM_SpreadRKRF),'b-','LineWidth',2);
    % hold on ;
    % plot(year2,store_implied_moments_macro(:,indexM_SpreadRKRF),'b--','LineWidth',2);
    % title('MPK-RF'); legend('model','model macro')
    subplot(1,3,2) ;
    plot(year2,store_implied_moments(:,indexM_SpreadRKRFrisk),'r-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments_macro(:,indexM_SpreadRKRFrisk),'rp-','LineWidth',2);
    title('Risk component');
    legend('model','model macro','Location','Best')
    % legend('model','model macro')
    
    subplot(1,3,3) ;
    plot(year2,store_implied_moments(:,indexM_SpreadRKRFgqdelta),'g-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments_macro(:,indexM_SpreadRKRFgqdelta),'gp-','LineWidth',2);
    title('Depreciation component');
    % legend('model','model macro')
    
    
    eval(strcat('print -dpdf output\figurerolling\',namecalib,'\model_impl5b'))
    eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\model_impl5b'))
    eval(strcat('print -dpng output\figurerolling\',namecalib,'\model_impl5b'))
    if printtopaperfolder==1
        eval(strcat('print -dpdf output\paperfigs\model_impl5b',namecalibS))
        eval(strcat('print -depsc2 output\paperfigs\model_impl5b',namecalibS))
        eval(strcat('print -dpng output\paperfigs\model_impl5b',namecalibS))
    end
    
    
    
    
    figure ;
    subplot(1,2,1) ;
    plot(year2,store_implied_moments(:,indexM_SpreadRKRFprof),'k-','LineWidth',2);
    hold on ;
    plot(year2,store_implied_moments_macro(:,indexM_SpreadRKRFprof),'kp-','LineWidth',2);
    title('Rent component');
    legend('model','model macro','Location','Best')
    ZZ = [store_implied_moments(:,indexM_SpreadRKRFprof)',store_implied_moments_macro(:,indexM_SpreadRKRFprof)',...
        store_implied_moments(:,indexM_SpreadRKRFrisk)'] ;
    mm1 = min(ZZ) ;
    mm2 = max(ZZ) ;
    axis tight ;
    axis([year2(1) year2(end) mm1 mm2])
    subplot(1,2,2) ;
    plot(year2,store_implied_moments(:,indexM_SpreadRKRFrisk),'k-','LineWidth',2);
    hold on ;
    % plot(year2,store_implied_moments_macro(:,indexM_SpreadRKRFrisk),'kp-','LineWidth',2);
    title('Risk component');
    axis([year2(1) year2(end) mm1 mm2])
    
    
    eval(strcat('print -dpdf output\figurerolling\',namecalib,'\model_impl5b'))
    eval(strcat('print -depsc2 output\figurerolling\',namecalib,'\model_impl5b'))
    eval(strcat('print -dpng output\figurerolling\',namecalib,'\model_impl5b'))
    if printtopaperfolder==1
        eval(strcat('print -dpdf output\paperfigs\model_impl5b',namecalibS))
        eval(strcat('print -depsc2 output\paperfigs\model_impl5b',namecalibS))
        eval(strcat('print -dpng output\paperfigs\model_impl5b',namecalibS))
    end
    
    
    
end

