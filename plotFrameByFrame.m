function plotFrameByFrame(in_title, in_y_label, theta, plotData)
figure;
x = 1:size(plotData,1);
hold on;
for i =1:size(plotData,2)
plot(x, plotData(:,i), 'DisplayName', theta(i));
end
hold off;
xlabel('frame by frame');
ylabel(in_y_label);
legend;
title(in_title);
end