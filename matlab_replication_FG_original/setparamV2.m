
global all_params intangibleswitch
global list_params_nonest values_params_nonest

beta = .96 ; % preference parameter
gn = 1.0 ; % growth rate of employment
gp = 1.0 ; % growth rate of population
gz = 1.0 ; % growth rate of TFP
theta = 12 ; % risk aversion
alphaIES = 0.5 ; % inverse of IES
mu = 1.00 ; % markup (gross, so 1.1 is 10%)
b = -log(1-0.15) ; % disaster size
p = 0 ; % probability of disaster
Nbar = 1 ; % labor (normalization)
ksi = 0.0 ; % wedge - NOT USED for now

if intangibleswitch==0
    qstar = 1 ; % inverse of price of investment goods. normalization.
    delta = 4.0 ;% depreciation
    alphaCD = 0.3 ; % cobb-douglas
    gq = 1.0 ; % inverse of growth rate of relative price of investment
    lambda_mismeas = 1.0 ; % mismeasurement
else
    qTstar = 1 ; % inverse of price of investment goods. normalization.
    deltaT = 4.0 ; % depreciation
    alphaCDT = 0.2 ; % cobb-douglas
    qUstar = 1 ; % inverse of price of investment goods. normalization.
    deltaU = 18.0 ; % depreciation
    alphaCDU = 0.05 ; % cobb-douglas
    gqT = 1.0 ; % inverse of growth rate of relative price of investment
    gqU = 1.0 ; % inverse of growth rate of relative price of investment
    lambda_mismeas = 1.0 ; % mismeasurement
end

if intangibleswitch==0
    all_params = [beta,mu,p,delta,ksi,alphaCD,theta,alphaIES,gn,gp,gz,gq,qstar,b,lambda_mismeas,Nbar] ;
else
    all_params = [beta,mu,p,deltaT,ksi,alphaCDT,theta,alphaIES,gn,gp,gz,gqT,qTstar,b,deltaU,alphaCDU,gqU,qUstar,lambda_mismeas,Nbar] ;
end

% overwrite with the parameters that we fix (possibly time-varying across samples)
for is=1:length(list_params_nonest)
    all_params(list_params_nonest(is)) = values_params_nonest(is) ;
end