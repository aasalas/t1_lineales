% export_data.m
% Guarda datos (t, Y) como .mat y .csv en results/data
function export_data(t, Y, fname_base)
    if ~exist('results/data','dir'), mkdir('results/data'); end
    save(fullfile('results','data',[fname_base '.mat']), 't','Y');
    csvwrite(fullfile('results','data',[fname_base '.csv']), [t(:) Y]);
end
