function val = solve_beta(beta,beta_star,alpha,mu,delta,gQ,parameters)
% Solve for beta
gT      = parameters(5);       % Growth of income 

val = ((1/beta_star-(1-delta)/(1+gQ))*mu/alpha - (1+gT)*(cap_lambda(beta,beta_star,parameters,0)*(1-alpha)/mu-(1+gT)*beta_star*(mu-1)*(mu-mu*(1+gT)*beta_star)^(-1))^(-1));


end