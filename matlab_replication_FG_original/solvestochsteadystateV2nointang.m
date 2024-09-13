
% this sets up the indices for all variables
preparation ;

% adjustment for leverage, if used
leverageadjfactor = moments_values(29) ;

% out of precaution: clear all parameters then rewrite them:
clear beta mu p delta ksi alphaCD theta alphaIES gn gp gz gq qstar b lambda_mismeas Nbar

% make sure there's no typo here:
beta = all_params(1) ;
mu = all_params(2) ;
p = all_params(3) ;
delta = all_params(4) ;
ksi = all_params(5) ;
alphaCD = all_params(6) ;
theta = all_params(7) ;
alphaIES = all_params(8) ;
gn = all_params(9) ;
gp = all_params(10) ;
gz = all_params(11) ;
gq = all_params(12) ;
qstar = all_params(13) ;
b = all_params(14) ;
lambda_mismeas = all_params(15) ;
Nbar = all_params(16) ;

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
%theta 
%alphaIES
%bh



    case 3
        % p is now the std dev of the shock: E(u) = -p^2/2, and Std(u) = p
        MOM =  exp( (1-theta)*(-p^2/2)+(1-theta)^2/2*p^2 )^((1-alphaIES)/(1-theta)) ; % E exp((1-theta)*u)) ^ (1-alpha)/(1-theta)
        MOM2 = exp((1-theta)*(-p^2/2)+(1-theta)^2/2*p^2) ; % E exp((1-theta)*u)
        MOM3 = exp(-theta*(-p^2/2)+.5*theta^2*p^2) ; % E exp(-theta*u)
        MOM4 = 1 ; % E exp(u)
end

% trend growth rate of GDP:
gt = - 100 + 100*(1+.01*gq)^(alphaCD/(1-alphaCD))*(1+.01*gn)*(1+.01*gz)^(1/(1-alphaCD)) ;

% per capita growth rate:
gpc = -100 + 100*(1+0.01*gt)/(1+0.01*gp) ;

% risk-adjusted discount factor:
if identbetastar~=1
    betastar = beta*(1+.01*gpc)^(-alphaIES)*MOM ;
else
    betastar = all_params(indexP_beta) ;
end

% solve: note that we need to be careful about what is measured vs. true:

true_koverN = (( (1+.01*gq)/betastar - (1-.01*delta) )*mu/(alphaCD*qstar))^(1/(alphaCD-1)) ;
true_kstar = true_koverN*Nbar ;
meas_kstar = lambda_mismeas*true_kstar ;

true_ystar = true_kstar^alphaCD*Nbar^(1-alphaCD) ;
true_pistar = true_ystar*(1-(1-alphaCD)/mu) ;
true_istar = ((1+.01*gq)*(1+.01*gt)-(1-.01*delta))*true_kstar ;
meas_istar = lambda_mismeas*true_istar ;
meas_ystar = true_ystar - (1-lambda_mismeas)*true_istar ;
cstar = true_ystar - true_istar ;
% cstar = meas_ystar - meas_istar ; % this is the same

meas_pistar = (mu+alphaCD-1)/mu*true_ystar - (1-lambda_mismeas)*true_istar ;
% this also equals: meas_ystar - (1-alphaCD)/mu*true_ystar

% calculation of vstar -- not used -- the formula here might be wrong
% actually
% !!!!
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


pk_over_y = 1/qstar*meas_kstar/meas_ystar ;
i_over_y = meas_istar/meas_ystar ;
pi_over_pk = meas_pistar/(meas_kstar/qstar) ;
% pi_over_pk = (mu+alphaCD-1)/mu*ystar/(kstar/qstar) ;

pi_over_y = meas_pistar/meas_ystar ;
% another expression:
% pi_over_y = (mu+alphaCD-1)/mu*true_ystar/meas_ystar - (1-lambda_mismeas)*true_istar/meas_ystar;

RF = exp(ksi)*MOM2/(betastar*MOM3) ;
rf = RF - 1 ;

if leverageadj==0
    PDTOT = betastar*(1+.01*gt)/(1-betastar*(1+.01*gt)) ;
elseif leverageadj==1
    % adjust the equity return directly using the weighted cost of capital:
    rstar = 1/betastar - 1 ;
    % leverageadjfactor is the debt-equity ratio
    re = (1+leverageadjfactor)*rstar - leverageadjfactor*rf ;
    PDTOT = 1/(re - 0.01*gt)  ;
elseif leverageadj==2
    % alternative approach to adjustmetn:
    % this is debt over total enterprise value:
    leverage2 = leverageadjfactor/(1+leverageadjfactor) ;
    PDTOT = betastar*(1+.01*gt)/(1-betastar*(1+.01*gt)) ;
    PDTOT = PDTOT*(1-leverage2)/(1+leverage2*PDTOT*(.01*gt-rf)/(1+.01*gt)) ;
end


% prices:
PTOT = PDTOT*(meas_pistar-meas_istar) ;
ERTOT = (PDTOT+1)/PDTOT*MOM4*(1+.01*gt) ; % expected return on equity.
EPTOT = 100*(ERTOT - RF) ; % equity premium over RF
TobinQ = PTOT/(meas_kstar/qstar) ;
EPnonlev = MOM4*MOM3/MOM2*100-100 ; % alternative expression for (unlevered) equity premium

PETOT = PTOT/meas_pistar ; % note that this might not be accurate with leverage. but not a target.
growth = gt ; % GDP growth (not per capita)
Dep = delta ;
ik = meas_istar/meas_kstar ;
actual_growth = gt ;

sharelab = (1-alphaCD)/mu ;
sharecap = (alphaCD)/mu ;
shareprof = (mu-1)/mu ;

apk = pi_over_pk  ;
apk2 = (mu+alphaCD-1)/alphaCD*((1+0.01*gq)/betastar-1+.01*delta)   ;
spread = apk - (RF-1) ;
spreadgqdelta = .01*delta + .01*gq ;
spreadmu = (mu-1)/alphaCD*(1/betastar-1+.01*delta+.01*gq) ;
spreadrp = 1/betastar - 1 - (RF-1) ;

EMPPOP = Nbar ;


% fake solow accounting
% growth rate of GDP - lab share * growth rate of N - (1-labshare)*growth
% rate of K = fake TFP
labshare = 1 - pi_over_y ;
% labshare2 = (1-alphaCD)/mu*true_ystar/(meas_ystar) ;
% note - this is the normal solow residual - in my model z^(1-alpha) is the
% solow residual
growthmeasuredtfp = actual_growth - labshare*gn - (1-labshare)*(actual_growth+gq);
% growthmeasuredtfp = gz ;

if leverageadj==1||leverageadj==2
    EPfinal = 100*( (1+leverageadjfactor)*(rf+.01*EPnonlev)-leverageadjfactor*rf - rf ) ;
else
    EPfinal  = EPnonlev ;
end
ER = 100*rf + EPfinal ;
    

% print out all moments including model stuff.
% note this is printed out exactly in the same order as the data!s
all_results = [100*pi_over_pk,100*pi_over_y,100*i_over_y,RF*100-100,PETOT,...
    gp,gn,actual_growth,-gq,PDTOT,...
    PETOT,growthmeasuredtfp,growthmeasuredtfp,EPfinal,pk_over_y,...
    meas_ystar,Dep,100*ik,100*sharelab,100*sharecap,...
    100*shareprof,100*spread,EPnonlev,100*spreadmu,100*spreadrp,100*spreadgqdelta...
    growth-gn,ER,NaN,meas_kstar,vstar,cstar,meas_istar,100*log(meas_ystar),...
    100*log(meas_istar),100*log(meas_pistar),EMPPOP,100*log(true_ystar),100*log(true_istar),100*log(true_pistar),TobinQ] ;

