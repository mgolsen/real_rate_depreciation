
preparation ;

leverageadjfactor = moments_values(29) ;

% out of precaution
clear beta mu p deltaT ksi alphaCDT theta alphaIES gn gp gz gqT gqU qUstar qTstar alphaCDU deltaU b Nbar lambda_mismeas

    
% make sure there's no typo here:
beta = all_params(1) ;
mu = all_params(2) ;
p = all_params(3) ;
deltaT = all_params(4) ;
ksi = all_params(5) ;
alphaCDT = all_params(6) ;
theta = all_params(7) ;
alphaIES = all_params(8) ;
gn = all_params(9) ;
gp = all_params(10) ;
gz = all_params(11) ;
gqT = all_params(12) ;
qTstar = all_params(13) ;
b = all_params(14) ;
deltaU = all_params(15) ;
alphaCDU = all_params(16) ;
gqU = all_params(17) ;
qUstar = all_params(18) ;
lambda_mismeas = all_params(19) ;
Nbar = all_params(20) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if force gn = gp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if forcegngp==1
    gn = gp ; 
    all_params(indexP_gn) = all_params(indexP_gp) ; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this file solves a simple RBC model
% with disaster risk and with monopolistic competition
% assuming we are on the 'risky balanced growth path'
% NOW WITH TWO TYPES OF CAPITAL
% AND MISMEASUREMENT OF INTANGIBLE CAPITAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% first, calculate some key moments
switch riskapproach
    case 0
        % w/prob p, decline of factor b, with prob 1-p, no change
        MOM =  ((1-p) + p*exp(-b*(1-theta)))^((1-alphaIES)/(1-theta)) ; % E exp((1-theta)*u)) ^ (1-alpha)/(1-theta)
        MOM2 = ((1-p) + p*exp(-b*(1-theta))) ; % E exp((1-theta)*u)
        MOM3 = ((1-p) + p*exp(-b*(-theta))) ; % E exp(-theta*u)
        MOM4 = ((1-p) + p*exp(-b)) ; % E exp(u)
    case 1
        % w/prob p, decline, and with prob 1-p, change of -bh:
        bh = - log( (1-p*exp(-b))/(1-p) ) ;
        MOM =  ((1-p)*exp(-bh*(1-theta)) + p*exp(-b*(1-theta)))^((1-alphaIES)/(1-theta)) ; % E exp((1-theta)*u)) ^ (1-alpha)/(1-theta)
        MOM2 = ((1-p)*exp(-bh*(1-theta)) + p*exp(-b*(1-theta))) ; % E exp((1-theta)*u)
        MOM3 = ((1-p)*exp(-bh*(-theta)) + p*exp(-b*(-theta))) ; % E exp(-theta*u)
        MOM4 = ((1-p)*exp(-bh) + p*exp(-b)) ; % E exp(u)
    case 2
        % w/prob p, decline, and with prob p, increase, so that mean = 1
        bh = - log( (2-exp(-b))) ;
        MOM =  ((1-2*p)+p*exp(-bh*(1-theta)) + p*exp(-b*(1-theta)))^((1-alphaIES)/(1-theta)) ; % E exp((1-theta)*u)) ^ (1-alpha)/(1-theta)
        MOM2 = ((1-2*p)+p*exp(-bh*(1-theta)) + p*exp(-b*(1-theta))) ; % E exp((1-theta)*u)
        MOM3 = ((1-2*p)+p*exp(-bh*(-theta)) + p*exp(-b*(-theta))) ; % E exp(-theta*u)
        MOM4 = ((1-2*p)+p*exp(-bh) + p*exp(-b)) ; % E exp(u)
    case 3
        % p is now the std dev of the shock: E(u) = -p^2/2, and Std(u) = p
        MOM =  exp( (1-theta)*(-p^2/2)+(1-theta)^2/2*p^2 )^((1-alphaIES)/(1-theta)) ; % E exp((1-theta)*u)) ^ (1-alpha)/(1-theta)
        MOM2 = exp((1-theta)*(-p^2/2)+(1-theta)^2/2*p^2) ; % E exp((1-theta)*u)
        MOM3 = exp(-theta*(-p^2/2)+.5*theta^2*p^2) ; % E exp(-theta*u)
        MOM4 = 1 ; % E exp(u)
end

% calculate the trend growth rate of GDP
gt = - 100 + 100*(1+.01*gqT)^(alphaCDT/(1-alphaCDT-alphaCDU))*(1+.01*gqU)^(alphaCDU/(1-alphaCDT-alphaCDU))*(1+.01*gn)*(1+.01*gz)^(1/(1-alphaCDT-alphaCDT)) ;

% per capita growth rate:
gpc = -100 + 100*(1+0.01*gt)/(1+0.01*gp) ;

% risk-adjusted discount factor:
if identbetastar~=1
    betastar = beta*(1+.01*gpc)^(-alphaIES)*MOM ;
else
    betastar = all_params(indexP_beta) ;
end


dzeta = alphaCDU/alphaCDT*( ((1+.01*gqT)/betastar - (1-.01*deltaT))/((1+.01*gqU)/betastar - (1-.01*deltaU) ) );

kToverN = (( (1+.01*gqT)/betastar - (1-.01*deltaT) )*mu/(alphaCDT*qTstar)/dzeta^alphaCDU)^(1/(alphaCDT+alphaCDU-1)) ;

kUoverN = dzeta*kToverN ;

kTstar = kToverN*Nbar ;
true_kUstar = kUoverN*Nbar ;
meas_kUstar = lambda_mismeas*true_kUstar ;


true_ystar = kTstar^alphaCDT*true_kUstar^alphaCDU*Nbar^(1-alphaCDT-alphaCDU) ;

iTstar = ((1+.01*gqT)*(1+.01*gt)-(1-.01*deltaT))*kTstar ;

true_iUstar = ((1+.01*gqU)*(1+.01*gt)-(1-.01*deltaU))*true_kUstar ;
meas_iUstar = lambda_mismeas*true_iUstar ;

cstar = true_ystar - iTstar - true_iUstar ;

meas_ystar = cstar + iTstar + lambda_mismeas*true_iUstar ;
% meas_ystar = true_ystar - (1-lambda_mismeas)*true_iUstar

% so:
% cstar = meas_ystar - iTstar - meas_iUstar

meas_pistar = (mu+alphaCDT+alphaCDU-1)/mu*true_ystar - (1-lambda_mismeas)*true_iUstar ;
% meas_pistar = meas_ystar - (1-alphaCDT-alphaCDU)/mu*true_ystar
true_pistar = true_ystar - (1-alphaCDT-alphaCDU)/mu*true_ystar ;

% calculation of vstar -- not used -- the formula here might be wrong
vstar = -99 ;
% if alphaIES~=1
%     vstar = (1-beta)*cstar^(1-alphaIES)/(1-beta*MOM*(1+0.01*gt)^(1-alphaIES)) ;
% else
%     switch riskapproach
%         case 0
%             vstar = cstar*((1-p) + p*exp(-b*(1-theta)))^(1/(1-theta))*(1+0.01*gt) ;
%         case 1
%             bh = - log( (1-p*exp(-b))/(1-p) ) ;
%             vstar = cstar* ((1-p)*exp(-bh*(1-theta)) + p*exp(-b*(1-theta)))^(1/(1-theta))*(1+0.01*gt) ;
%         case 2
%             bh = - log( (2-exp(-b))) ;
%             vstar = cstar*((1-2*p)+p*exp(-bh*(1-theta)) + p*exp(-b*(1-theta)))^(1/(1-theta))*(1+0.01*gt) ;
%         case 3
%             vstar = cstar* exp( (1-theta)*(-p^2/2)+(1-theta)^2/2*p^2 )^(1/(1-theta))*(1+0.01*gt) ;
%     end
% end

% big ratios:

pkT_over_y = 1/qTstar*kTstar/meas_ystar ;
pkU_over_y = 1/qUstar*meas_kUstar/meas_ystar ;
pkTOT_over_y = pkT_over_y + pkU_over_y ;

iT_over_y = iTstar/meas_ystar ;
iU_over_y = meas_iUstar/meas_ystar ;

pi_over_pkT = meas_pistar/(kTstar/qTstar) ;
pi_over_pkU = meas_pistar/(meas_kUstar/qUstar) ;

% if targetnetgrossreturn==1
%     pi_over_pkT = pi_over_pkT - .01*deltaT ; % !!! this is net of physical depreciation now
%     pi_over_pkU = pi_over_pkU - .01*deltaU ; % !!! this is net of physical depreciation now
% end

pi_over_y = meas_pistar/meas_ystar; 

RF = exp(ksi)*MOM2/(betastar*MOM3) ;
rf = RF - 1 ;



% PMON = (mu-1)/mu*ystar*betastar/(1-betastar) ; % this is the price of claim to future monopoly profits (divided by z)
% PCAP = kstar/qstar ; % this is the price of current capital (divided by z)
% PTOT = PMON + PCAP ; % price of all firms



% PEMON = PMON/((mu-1)/mu*ystar) ; % this is the PE ratio of the monopoly rents
% PDMON = PEMON ; % PD ratio of monopoly rents = same since no investment!

% PECAP = PCAP/(alphaCD/mu*ystar) ; % PE ratio of physical capital
% PDCAP = PCAP/(alphaCD/mu*ystar-istar) ; % PD ratio of capital

% PETOT = PTOT/pistar;  % PE ratio of total firm
% PDTOT = PTOT/(pistar-istar) ; % PD ratio of total firms

if leverageadj==0
    PDTOT = betastar*(1+.01*gt)/(1-betastar*(1+.01*gt)) ;
elseif leverageadj==1
    % adjust the equity return directly using the weighted cost of capital:
    rstar = 1/betastar - 1 ;
    % leverageadjfactor is the debt-equity ratio
    re = (1+leverageadjfactor)*rstar - leverageadjfactor*rf ;
    PDTOT = 1/(re - 0.01*gt)  ;
elseif leverageadj==2 
    % this is debt over total enterprise value:
    leverage2 = leverageadjfactor/(1+leverageadjfactor) ;
    PDTOT = betastar*(1+.01*gt)/(1-betastar*(1+.01*gt)) ;
    PDTOT = PDTOT*(1-leverage2)/(1+leverage2*PDTOT*(.01*gt-rf)/(1+.01*gt)) ;
end

    

meas_dstar = meas_pistar-iTstar-meas_iUstar ;
% true_dstar = true_pistar-iTstar-true_iUstar  l

PTOT = PDTOT*meas_dstar ;
PETOT = PTOT/meas_pistar ; % note that this might not be accurate with eleverage. but not a target.


ERTOT = (PDTOT+1)/PDTOT*MOM4*(1+.01*gt) ; % expected return on equity.
EPTOT = 100*(ERTOT - RF) ; % equity premium over RF 

% this assumes tangible K:
TobinQ = PTOT/(kTstar/qTstar+meas_kUstar/qUstar) ;

% ERMON = (PDMON+1)/PDMON*MOM4*(1+.01*gt) ; % need to add growth to this.
% EPMON = ERMON - RF ;
%
% ERCAP = (PDCAP+1)/PDCAP*MOM4*(1+.01*gt) ;
% EPCAP = ERCAP - RF ;

% PLEV = PTOT*(1-LEV) ; % equity price, with leverage ratio LEV
% ERLEV = 1/(1-LEV)*ERTOT + (-LEV/(1-LEV))*RF ;
% EPLEV = 100*(ERLEV - RF) ;
growth = gt ; % GDP growth

% alternative expression for unlevered equity premium
EPnonlev = MOM4*MOM3/MOM2*100-100 ;

% 
Dep = (deltaT*kTstar+deltaU*meas_kUstar)/(kTstar+meas_kUstar) ;
iTkT = iTstar/kTstar ;
iUkU = meas_iUstar/meas_kUstar ;

% if adjustleveleffects==1
%     actual_growth = gt + 100*(log(meas_ystar) - log(yini))/numyears ;
% else
    actual_growth = gt ;
% end


% fake solow accounting
% growth rate of GDP - lab share * growth rate of N - (1-labshare)*growth
% rate of K = fake TFP
labshare = 1 - pi_over_y ;
% labshare2 = (1-alphaCDT-alphaCDU)*true_ystar/mu/meas_ystar ;
% note - this is the normal solow residual - in my model z^(1-alpha) is the
% solow residual
growthmeasuredtfp = actual_growth - labshare*gn - (1-labshare)*(actual_growth+gqT);

sharelab = (1-alphaCDT-alphaCDU)/mu ;
sharecapT = (alphaCDT)/mu ;
sharecapU = (alphaCDU)/mu ; % this is the true one
shareprof = (mu-1)/mu ;

% pi/k net minus rf can be written as the sum of:


% aggregate capital ---
% this needs rethinking
apk = pi_over_pkT ;
% (mu+alphaCDT-1)/alphaCDT*(1/betastar-1+.01*deltaT+.01*gqT) ;
spread = apk - (RF-1) ; 
spreadgqdelta = -99.99;%.01*deltaT + .01*gqT ;
spreadmu = -99.99;%(mu-1)/alphaCDT*(1/betastar-1+.01*deltaT+.01*gqT) ;
spreadrp = -99.99; % 1/betastar - 1 - (RF-1) ;
% betastar = beta*(1+gp)*(1+gt)^(-alphaIES)*MOM ;
% RF = exp(ksi)*MOM2/(betastar*MOM3) ;

if leverageadj==1||leverageadj==2
    EPfinal = 100*( (1+leverageadjfactor)*(rf+.01*EPnonlev)-leverageadjfactor*rf - rf ) ;
else
    EPfinal  = EPnonlev ;
end

ER = 100*rf + EPfinal ;

Npop = Nbar ;

all_results = [100*pi_over_pkT,100*pi_over_y,100*iT_over_y,RF*100-100,PETOT,...
    gp,gn,actual_growth,-gqT,PDTOT,...
    PETOT,growthmeasuredtfp,growthmeasuredtfp,EPfinal,pkTOT_over_y,...
    meas_ystar,Dep,100*iTkT,100*sharelab,100*sharecapT,...
    100*shareprof,100*spread,EPnonlev,100*spreadmu,100*spreadrp,100*spreadgqdelta...
    growth-gn,ER,NaN,kTstar,vstar,cstar,iTstar,100*log(meas_ystar),100*log(iTstar+meas_iUstar),log(cstar),Npop,...
    100*iU_over_y,100*iUkU,100*pi_over_pkU,-gqU, 100*sharecapU,...
   100*log(true_ystar),100*log(true_iUstar),100*log(true_kUstar),TobinQ] ;
% add the ystar etc.
    