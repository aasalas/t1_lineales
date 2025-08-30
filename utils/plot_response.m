% plot_response.m
% Función auxiliar para graficar una matriz de respuestas (t, Y, labels)
function plot_response(t, Y, labels, fname)
    figure; hold on;
    colors = {'r','g','b','k','m','c'};
    for k=1:size(Y,2)
        plot(t, Y(:,k), 'Color', colors{mod(k-1,length(colors))+1}, 'LineWidth',1.5);
    end
    legend(labels,'Location','best');
    xlabel('Time [s]'); ylabel('Output');
    grid on; hold off;
    if nargin>=4 && ~isempty(fname)
        saveas(gcf, fname);
    end
end
