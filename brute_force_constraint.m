function [c,ceq] = brute_force_constraint(c_vector,r,G,g)

% Intertemporal budget constraint 

T = length(c_vector);

R_vector = ((1/(1+r)).^(0:1:T-1))';

w_vector = ((1+g).^(0:1:T-1))';
w_vector(G+1:end) = 0;

% g is growth rate of wages 

c = [];

%size(c_vector)
%size(R_vector)
%size(w_vector)


%w_vector(1:10)

ceq = c_vector'*R_vector - w_vector'*R_vector;


end