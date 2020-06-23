% written by Chunhung Lin
function plotTweakParameter(filename, theta, diff, computations)
% Observing two performance metrics: diff and computations by tweaking the parameters theta
x = categorical(theta);
x = reordercats(x, theta);

normalize_factor = computations(1)/diff(1);
computations = computations./normalize_factor;
y = [diff', computations'];

%
figure;
b = bar(x, y);  
% b(1)=diff, b(2)=computations
% Specify Labels at the Ends of Bars
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);  %diff
legend('PSNR', 'Computations (Normalized)');
title(filename);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
end