% ################  MAIN_FILE_OLG ##############################
% Description: This file runs the main code for the OLG model. It executes the following
% i)   It loads the results from the FG model. 
% ii)  It solves for the beta that matches the data. It then 
% ii.a) Creates figure 5 for permutations to the return on the risky asset (beta_star)
% ii.b) Creates figure 6: the effect on r* of a change in delta. 
% iii) It creates some additional figures for checks and outputs the numbers needed for the text of the paper

% ------------------------------------------------------------------------- %
% Load estimates from the FG model, downloaded from their replication files
% ------------------------------------------------------------------------- %

par_est     = readmatrix('matlab_replication_FG_original\\output\\results\\baseline.xls','Sheet','est_params','Range','A3:H3');
par_non_est = readmatrix('matlab_replication_FG_original\\output\\results\\baseline.xls','Sheet','nonest_params','Range','B3:F3');

% Pull out parameters from the FG model

theta     = par_non_est(2);
sigma     = par_non_est(3);
b         = par_non_est(5);
beta_star = par_est(1);
mu        = par_est(2);
p         = par_est(3);
delta     = par_est(4)/100;
alpha     = par_est(5); 
gL        = par_est(6)/200;
gL        = par_non_est(3)/100;
gZ        = par_est(7)/100;
gQ        = par_est(8)/100;
gT        = (1+gL)*(1+gZ)^(1/(1-alpha))*(1+gQ)^(alpha/(1-alpha))-1;
% Figure 5 sigma values
sigma_list = [1/2, 3, 4];


% Code runs through two settings 
% i) Setting 1 with mu as estimated. 
%    a) Gives the estimated beta value for sigma=3 and sigma=5 
%    b) Figure 5: Savings effect of changes interest rate for low and high sigma 
%    c) Figure 6: Derivative of return on risky assets wrt delta as a function of sigma 
% ii) Setting 2 with mu=1.
%    a) Panel b of Figure 2. 

options4 = optimset('TolX', 1e-11, 'TolFun', 1e-11, 'Display','off');

% ------------------------------------ %
% Estimate model
% ------------------------------------ %

% For both settings run_through goes through different sigma values and saves needed figures and values. 

% Store values from the iterations below. 

% Outer loop runs over mu (markups). No markups and the estimated markup. 

for mu = [1,mu]


storage= [];
storage_other_beta_star = [];
storage_val = [];
storage_k_y = [];           % Store k/y ratio for each iteration. 
storage_savings = [];       
storage_sem_el = [];
storage_beta   = [];
storage_lambda =[];
storage_val2 = [];
storage_term_1 = [];
storage_term_2 = [];
storage_term_3 = [];
storage_savings_function = [];

run_through = (1/2:0.1:4);


for sigma = run_through     % Set to run through for the parameter of interest

    % Solve for beta (not beta_star)
    parameters = [T,G,sigma,theta,gT,p,gL];
    options = optimset('TolX', 1e-11, 'TolFun', 1e-11, 'Display','off','Algorithm','trust-region-reflective');
    options2 = optimset('TolX', 1e-11, 'TolFun', 1e-11, 'Display','off','Algorithm','active-set');

    [beta_sol,val1]=fminsearch(@(beta)(solve_beta(beta,beta_star,alpha,mu,delta,gQ,parameters))^2,0.98,options);

    % Sometimes codes needs a different starting point 
    if val1>10^(-8) | val1<0
        [beta_sol,val1]=fminsearch(@(beta)(solve_beta(beta,beta_star,alpha,mu,delta,gQ,parameters))^2,beta_star,options);
    end

    if val1<0 || val1>10^(-8)
        options3 = optimset('TolX', 1e-11, 'TolFun', 1e-11, 'Display','off','Algorithm','active-set');
        [beta_sol,val1]=fsolve(@(beta)(solve_beta(beta,beta_star,alpha,mu,delta,gQ,parameters)),.999,options4);
    end

    if val1>10^(-6)
        [beta_sol,val1]=fmincon(@(beta)(solve_beta(beta,beta_star,alpha,mu,delta,gQ,parameters))^2,.95,[],[],[],[],0.93,1.2,[],options2);
        sigma 
        Stop_here % Code stops if solution not found 
    end

    % For Figure 5
    % For given beta (beta_sol above) find the derivate wrt the real interest rate 

    % Set indicator to 1 to create a profile of financial savings across generations (saves data.mat with the savings function)
    % Capital lambda function saves data.mat within cap_lambda which we save as savings
    cap_lam1 = cap_lambda(beta_sol,beta_star,parameters,1);
    load('data.mat');
    savings1 = savings;
    cap_lam2 = cap_lambda(beta_sol,(1/beta_star + 0.01)^(-1),parameters,2);         % Change real rate by 1 percentage point
    load('data.mat');
    savings2 = savings;

    if ismember(sigma, sigma_list)
        % code to execute if sigma is 1/2, 3, or 5
        storage_savings_function = [storage_savings_function savings1 savings2];
    end

    % For Figure 5: Differentiate wrt delta (note not delta/(1+gQ). We account for that below)
    
 

    [beta_star_2,val2] = fsolve(@(beta_star_dummy)solve_beta(beta_sol,beta_star_dummy,alpha,mu,delta+0.001,gQ,parameters),beta_star,options4);

    if val2>10^(-6)

        disp('problem with bestar_2')
       % stop

    end

    sem_el_cap_lam = (cap_lam2-cap_lam1)/(cap_lam1*0.01);

    storage_sem_el = [storage_sem_el sem_el_cap_lam];
    storage_beta   = [storage_beta beta_sol];


% The derivative of r* 

storage = [storage (1/beta_star_2 - 1/beta_star)/0.001];
storage_val = [storage_val val1];
storage_val2 = [storage_val2 val2];

% Calculate the y/k ratio 

y_k = mu/alpha*(1/beta_star-(1-delta)/(1+gQ));

storage_k_y = [storage_k_y;1/y_k];
storage_lambda = [storage_lambda;cap_lam1];
%storage_savings = [storage_savings cap_lam*(1-alpha)/mu]

% Decompose the effect on beta_star 

term_1 = sem_el_cap_lam*cap_lam1*(1-alpha)/(alpha*(1+gT));
term_2 = (mu-1)/alpha*(1/beta_star-(1+gT))^(-2);
term_3 = (1/beta_star-(1-delta)/(1+gQ));

derivative = (1+term_3^2*(term_1+term_2))^(-1);

storage_other_beta_star = [storage_other_beta_star beta_star^(2)*derivative];


storage_term_1 = [storage_term_1;term_1];
storage_term_2 = [storage_term_2;term_2];
storage_term_3 = [storage_term_3;term_3];



end



figure(49)
subplot(4,3,1)
plot(run_through,storage_other_beta_star)
title('derivative')
subplot(4,3,2)
plot(run_through,storage_val)
title('value')
subplot(4,3,3)
plot(run_through,storage_k_y)
title('k_y')
subplot(4,3,4)
plot(run_through,storage_sem_el)
title('semi elasticity')
subplot(4,3,5)
plot(run_through,storage_beta)
title('beta')
subplot(4,3,6)
plot(run_through,storage_lambda)
title('cap_lambda')
subplot(4,3,7)
plot(run_through,storage_val2)
title('storage val2')
subplot(4,3,8)
plot(run_through,storage_term_1)
title('term_1')
subplot(4,3,9)
plot(run_through,storage_term_2)
title('term_2')
subplot(4,3,10)
plot(run_through,storage_term_3)
title('term_3')
subplot(4,3,11)
plot(run_through,(storage_term_3.^2).*(storage_term_1+storage_term_2))
title('combination of terms')
subplot(4,3,12)
plot(run_through,storage)
title('direct derivative')

% ---------------------------------------- %
% Create figure 1 
% ---------------------------------------- %

% Create the folders (will create a warning if they already exist)

mkdir('Paper_figures')
mkdir('Additional_figures')
mkdir('Paper_tables')

figure(82); set(gcf, 'Units', 'Inches', 'Position', [0, 0, 9, 3]);
subplot(1,3,1)
plot(storage_savings_function(:,1),'-r','DisplayName','r*=6.6%')
hold on;
plot(storage_savings_function(:,2),'--b','DisplayName','r*=7.6%')
xlabel('Generations (Panel a)')
ylabel('Savings / yearly wages')
hold off;
title('\sigma = 1/2 (high EIS)')
legend('show','Location','northwest')
subplot(1,3,2)
plot(storage_savings_function(:,3),'-r','DisplayName','r*=6.6%')
hold on;
plot(storage_savings_function(:,4),'--b','DisplayName','r*=7.6%')
xlabel('Generations (b)')
hold off;
title('\sigma = 3')
subplot(1,3,3)
plot(storage_savings_function(:,5),'-r','DisplayName','Low Return')
hold on;
plot(storage_savings_function(:,6),'--b','DisplayName','High Returns')
hold off;
xlabel('Generations (c)')
title('\sigma = 4')

% Save the figure as a PDF
%saveas(gcf, 'Paper_figures\Figure5.pdf')
% Figure 5 with monopoly power is used in the paper. With mu=1 is not used and is only for checks.

filename = ['Additional_figures/Figure5_',num2str(mu),'.pdf'];
saveas(gcf,filename,'pdf')
if mu > 1 
    filename = ['Paper_figures/Figure5.pdf'];
    saveas(gcf,filename,'pdf')
end


% ---------------------------------------- %
% Create figure 6 
% ---------------------------------------- %


figure(97); set(gcf, 'Units', 'Inches', 'Position', [0, 0, 6, 4]);

% Plotting
plot(run_through,(1+gQ)*storage)

% Setting title with font size, and include sigma value
%title(['Derivative of $1/beta^*$ \mu= ', num2str(mu)], 'FontSize', 16)

% Setting x and y labels with font size
xlabel('\sigma', 'FontSize', 14)
ylabel('Derivative','FontSize', 14)
%ylabel('\frac{dr^{*}}{d\left(\frac{\delta}{1+g_{Q}}\right)}', 'FontSize', 14)

% Setting the axis tick labels font size
set(gca, 'FontSize', 12)

% Adjust the position of the axes within the figure
set(gca, 'Position', [0.15, 0.15, 0.75, 0.75]);  % [left, bottom, width, height]

% Save as PDF with sigma value in filename
if mu>1
    filename = ['Paper_figures/Figure6a.pdf'];
else 
    filename = ['Paper_figures/Figure6b.pdf'];
end
saveas(gcf, filename, 'pdf');

% ---------------------------------------- %
%       CREATE TABLE                       %
% ---------------------------------------- %

par_output = [storage_beta(run_through==1/2) storage_beta(run_through==3) storage_beta(run_through==4) ... 
              beta_star mu p delta alpha gL gZ gQ]
            % Write par_output to an Excel file
            filename = ['Paper_tables/parameters',num2str(mu),'.xlsx'];
            sheet = 'Sheet1';
            xlRange = 'A1';
            writematrix(par_output, filename, 'Sheet', sheet, 'Range', xlRange);

% ---------------------------------------- %
% Create figure 3
% ---------------------------------------- %

% This figure is just to check. 
% We will do the following: 
% Ignore uncertainty and search the space of all c's to find the optimal.
% Check that that matches with the code above (which it obviously only
% should when uncertainty is turned off: p = 0). 

% We maximize utility as a function of the consumption vector 

% Growth rate of wages 
g      = (1+gZ)^(1/(1-alpha))*(1+gQ)^(alpha/(1-alpha))-1;

% Set up the non-linear constraint: The intertemporal budget constraint 
nlcon = @(c_vector)brute_force_constraint(c_vector,1/beta_star-1,G,g);
options2 = optimoptions('fmincon', 'Display', 'iter', 'MaxFunctionEvaluations', 10^5, 'OptimalityTolerance', 1e-10);

% Iterate over the vector of consumption 
% Set lower bound constraint to ensure all elements of c_vector_optimal are strictly positive
lb = zeros(T,1);

% Iterate over the vector of consumption 
[c_vector_optimal,V] = fmincon(@(c_vector)brute_force(c_vector,beta_sol,parameters),1*ones(T,1),[],[],[],[],lb,[],nlcon,options2);

% This results in consumption at each point. 
% Use this to calculate savings at eah point in time. Note; For a given person, not across generations. 

savings_bf = zeros(T,1);
savings_bf(1) = 1-c_vector_optimal(1);

% Savings at each point in time for a given person 
for t = 2:T 
    savings_bf(t) = savings_bf(t-1)/beta_star+(1+g)^(t-1)*(t<=G)-c_vector_optimal(t);
end

% Savings as a cross section across individuals. 

%[a,b]=brute_force_constraint(c_vector_optimal,1/beta_star-1,G,g)


% Correct for size and growth 

savings_bf_total = (((1/(1+gT)).^(0:1:T-1))').*savings_bf;

figure(92)
plot([savings_bf_total])
hold on 
plot(savings1,'-o')
hold off
title('Savings Comparison', 'FontSize', 16)
xlabel('Generation', 'FontSize', 14)
ylabel('Savings', 'FontSize', 14)
filename = ['Additional_figures/Savings_comp.pdf'];
saveas(gcf, filename, 'pdf');

end
