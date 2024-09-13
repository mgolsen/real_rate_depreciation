function [cap_lambda] = cap_lambda(beta,beta_star,parameters,indicator)
% We want to create a savings function which generally solves the problem 
% This function does two things 
% It calculates the capital_lambda: That is the savings out of total wage income on a risky balanced growth path. 
% It also creates a data.mat which stores the savings profile across generations. 


% Initalize parameters. Indicator = 0 means no savings function is plotted.

T       = parameters(1);       % Number of years  
G       = parameters(2);       % Number of years where we work. 
sigma   = parameters(3);       % elasticity of substituion (CHECK NOT THE INVERSE)
theta   = parameters(4);       % risk aversion 
r       = 1/beta_star - 1;     % The expected net return on the risky asset. 
gT      = parameters(5);       % Growth of economy 
p       = parameters(6);       % Shock to system
gL      = parameters(7);       % Growth of population 
g       = (1+gT)/(1+gL) -1;    % growth of individual income

% Measures of uncertainty: Based on FG. 
    b = 0.1625;
    bh = - log( (2-exp(-b))) ;
    MOM_value   =  ((1-2*p)+p*exp(-bh*(1-theta)) + p*exp(-b*(1-theta)))^((1-sigma)/(1-theta)) ; % E exp((1-theta)*u)) ^ (1-alpha)/(1-theta)
    MOM_savings = MOM_value^(-1/sigma);
 

% Following the appendix the code iterates over two vectors: nu: the value function to the power of (1-sigma) and s_hat_vector, the savings out of total wealth. 
% The code starts at the end of the life-cycle and works its way back.
% Initalize the two vectors and set the terminal value for both
nu_vector        = zeros(T,1);
nu_vector(end)   = (1-beta);    % Value function in the last period
s_hat_vector     = zeros(T,1);  % Savings rate
s_hat_vector(end)= 0;           % Consume everything in the last period 


% Then work backwards from the second-to-last period
for t=T-1:-1:1
    term = (beta)^(-1/sigma)*(1-beta)^(1/sigma)*nu_vector(t+1)^(-1/sigma)*(1+r)^((sigma-1)/sigma)*MOM_savings;
    s_hat_vector(t) = 1/(1+term);
    nu_vector(t) = (1-beta)*(1-s_hat_vector(t))^(1-sigma)+beta*nu_vector(t+1)*(1+r)^(1-sigma)*MOM_value*(s_hat_vector(t))^(1-sigma);
end


% With these in hand we can calculate the total savings of the economy as a
% share of total wages.  

% First create expected future wages for each individual 
% Needed vectors 
W_hat   = zeros(T,1);     % total wealth at the beginning of a period
W       = zeros(T,1);     % Only financial wealth 
wage_NPV= zeros(T,1);     % NPV of only wages 
lambda_vector = zeros(T,1);% savings as a share of present wages - intermediate variable

% future (expected) NPV of wages (including current period). 

dummy_wage = ((1+g)/(1+r)*ones(T,1)).^((0:T-1)');
dummy_wage(G+1:end) = 0;        % Stops working at G

for t=1:T
    wage_NPV(t)=sum(dummy_wage(t:T))*((1+g)/(1+r))^(1-t);
end



% And then create total financial savings of each generation iteratively 


lambda_vector(1) = 1 - (1 - s_hat_vector(1)) * wage_NPV(1);

for t = 2:T 
    lambda_vector(t) = (t<=G) + s_hat_vector(t)*lambda_vector(t-1)*(1+r)/(1+g)-(1-s_hat_vector(t))*wage_NPV(t);    
end


% And then we correct for the size of the population 

population_weight = (1+gL).^(-(0:T-1)');

savings = lambda_vector.*population_weight;

% And total income from those working 
population_weight_work = population_weight; 
population_weight_work(G+1:end) = 0;

cap_lambda = sum((savings))/sum(population_weight_work);

if indicator ~= 0

    save('data.mat','savings')

end



end