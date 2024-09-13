% ########################################################################## %
%     MAIN FILE FOR THE SIMULATION PART OF HAS THE REAL RATE DEPRECIATED     %
% ########################################################################## %
clear all ; close all ; clc ;

% Set global variables 

global pop_eq_work_force identbetastar T G sigma

% This code code should be run in the main folder. 


% Description: This code runs all the code for the project. 
% A) It first runs the code from Farhi and Gourio (2019) to get 
% the estimated coefficients. Note that there are two differences
% from their preferred specication
% - i) We estimate beta_star instead of beta 
% - ii) We do not allow the labor force participation to vary 

% B) It then runs our code which creates the figures associated with the paper. 
%    These figures are placed in the folder ¨figures for paper¨. There is also a folder for additional figures. These are 
%    not shown in the paper but are used for background or checks.
%    Numbers used in the paper are placed in the excel spreadsheet ¨numbers for paper¨.  
%    The code further creates figures used for background or checks. These are placed in ¨additional figures¨

% -----------------------------------------% 
% ------ Settings and Parameters ----------%
% -----------------------------------------% 

% Two possible differences from FG (paper sets both equal to 1):
identbetastar = 1 ;         % use betastar as target for identification instead of beta (i.e. replace beta with betastar)
pop_eq_work_force = 1;      % 1 if we set workforce growth to equal population growth

% Parameters of this project 
T       = 65;       % Length of life
G       = 40;       % Length of working life
sigma   = 5;        % Prefered sigma 

% All other parameters are set or estimated as in FG. 



% Execute FG files. Further settings can be set in this file. See FG for details
% All results from FG are included and this does not need to be run.
%run('Matlab_replication_FG_original/onerunreplication.m')

% Execute files of this project 
run('Main_file_OLG.m')