
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load file data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

namesvar = names(2:end);
year = data(:,1) ;
time = year ;
targetmom_timeseries = data(:,2:end) ;
T = length(year) ;
targetmom_timeseries_smoothed = NaN*ones(size(targetmom_timeseries)) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% targets in each sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NN = size(targetmom_timeseries,2) ;

sample1 = find(year>=yearstart1&year<=yearend1) ;
sample2 = find(year>=yearstart2&year<=yearend2) ;

moments_values_V1 = nanmean(targetmom_timeseries(sample1,:)) ;
moments_values_V2 = nanmean(targetmom_timeseries(sample2,:)) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do some smoothing, over Ts periods on each side
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for t=Ts+1:T-Ts
    for i=1:size(targetmom_timeseries,2)
        targetmom_timeseries_smoothed(t,i) = nanmean(targetmom_timeseries(t-Ts:t+Ts,i));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the target moments and the smoothed versions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plotmoments==1
    F = find(year>=1950) ;
    for i=1:NN
        figure ;
        plot(time(F),targetmom_timeseries(F,i),'b-') ;
        hold on ;
        plot(time(F),targetmom_timeseries_smoothed(F,i),'r-','LineWidth',1.5) ;
        title(namesvar{i}) ;
        axis tight ;
        eval(strcat('print -dpdf   output\figuretargets\',namesvar{i}))
        eval(strcat('print -depsc2 output\figuretargets\',namesvar{i}))
        eval(strcat('print -dpng   output\figuretargets\',namesvar{i}))
    end
    
    % figure for paper
    if printtopaperfolder==1
        figure ;
        for i=1:length(choice_moments_baseline)
            subplot(5,2,i) ;
            plot(time(F(Ts+1:end-Ts)),targetmom_timeseries(F(Ts+1:end-Ts),choice_moments_baseline(i)),'b-','LineWidth',1.5) ;
            hold on ;
            plot(time(F(Ts+1:end-Ts)),targetmom_timeseries_smoothed(F(Ts+1:end-Ts),choice_moments_baseline(i)),'r-','LineWidth',1.5) ;
            title(names_moments_nice{choice_moments_baseline(i)}) ;
            axis tight ;
            set(gca,'Fontsize',8)
            
        end
        print -dpdf output\paperfigs\data_over_time
        print -depsc2 output\paperfigs\data_over_time
        print -dpng output\paperfigs\data_over_time
        
        figure ;
        for i=1:length(choice_moments_baseline)
            subplot(3,3,i) ;
            plot(time(F(Ts+1:end-Ts)),targetmom_timeseries(F(Ts+1:end-Ts),choice_moments_baseline(i)),'b-','LineWidth',1.5) ;
            hold on ;
            plot(time(F(Ts+1:end-Ts)),targetmom_timeseries_smoothed(F(Ts+1:end-Ts),choice_moments_baseline(i)),'r-','LineWidth',1.5) ;
            title(names_moments_nice{choice_moments_baseline(i)}) ;
            axis tight ;
            set(gca,'Fontsize',5)            
        end
        print -dpdf output\paperfigs\data_over_time
        print -depsc2 output\paperfigs\data_over_time
        print -dpng output\paperfigs\data_over_time
    end
end

