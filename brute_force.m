function V_1= brute_force(c_vector,beta,parameters)

% Calculate value function (doesn't work for sigma = 1)

% Parameters 

sigma   = parameters(3);       % elasticity of substituion (CHECK NOT THE INVERSE)


V_vector = 0*c_vector;

V_vector(end) = (1-beta)^(1/(1-sigma))*c_vector(end);

for t=length(V_vector)-1:-1:1
    
    V_vector(t) = ((1-beta)*c_vector(t)^(1-sigma)+beta*V_vector(t+1)^(1-sigma))^(1/(1-sigma));


end

% We minimize the negative of utility 

V_1 = - V_vector(1);








end