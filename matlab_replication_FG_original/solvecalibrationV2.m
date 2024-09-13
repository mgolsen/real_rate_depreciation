    
function zzz = solvecalibrationV2(xxx)

global intangibleswitch riskapproach
global select_params choice_moments moments_values all_results Weighting exactident 
global identbetastar forcegngp leverageadj leverageadjfactor 

% set default parameters:
setparamV2 ;

% overwrite with the parameters that we estimate, select_params, using the
% values xxx
for i=1:length(select_params)
    all_params(select_params(i)) = xxx(i) ;
end

% calculate model implications:
solvestochsteadystateV2;

% create criterion:
if exactident==1
    % (1) just identifiedd case  - set all eqns to zero exactly
    zzz = all_results(choice_moments) - moments_values(choice_moments) ;
else
    % (2) potentially overidentified case - weigthed sum of squares:
    zzz1 = all_results(choice_moments)-moments_values(choice_moments) ;
    zzz = zzz1*Weighting*zzz1';
end