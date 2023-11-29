%InvMethProject_StepCluster

%Isolate sections of D_double_inv matrix to mask and assign slopes
% Try k-means clustering with two columns, coordinates-
% filteredcoordinates.mat

% maybe plot a vertical line at each index you want to partition
% maybe also have to partition horizontally for some slopes that merge
% save each partitioned slope section as an individual matrix
% then use linear regression, l1 vs l2, svd...

%% using filtered coordinates from 2100-2376 on y-axis, 
% with Nan for cells less than 2100 or equal to aliasing

rng('default')  % For reproducibility
load('filtcoordnan.mat');
X = filtcoordnan;
size(X)

figure(1)
h=subplot(6,1,1:2);
    imagesc(Td,F,filteredImage);
    xlim(xl)
    axis xy
    ylabel('F (Hz)')
    colormap("jet")
    ax=get(h,'Position');
    s=mean(std(10*log10(PSDdiffsm)));
    m=median(median(10*log10(PSDdiffsm+eps)));
    caxis([-10 10])
    hc=colorbar;
    set(get(hc,'label'),'string','PSD (dB rel. median)');
    tick_locations=[datenum(year,1,1:365),datenum(year+1,1,1:365)];
    set(gca,'XTick',tick_locations)      %x-axis ticks normal, inside
    datetick('x',6,'keeplimits', 'keepticks')
    set(h,'Position',ax)
    set(gcf,'units','normalized','position',[0.1300 0.1100 0.8 0.7])
    ylim([.03 .09])
    title 'DR03 2016 LHZ, PSD rel. median';

subplot(6,1,3:4)
plot(X(:,1),X(:,2),'.');
ylim([2150 2376])
xlim([1 2376])
%title 'Data';
ax = gca;
ax.XTick = [];
ax.YTick = [];
legend('Maximum PSD Value Coordinate Point');


k = 60
opts = statset('Display','final');
% idx = index vector; C = centroid coordinate vectors (2-col)
[idx,C] = kmeans(X,k,'Distance','sqeuclidean','Replicates',5,'Options',opts);

% Plot the data points colored by cluster
subplot(6,1,5:6)
scatter(X(:, 1), X(:, 2), 50, idx, 'filled');
hold on;
% Plot the cluster centroids
scatter(C(:, 1), C(:, 2), 200, (1:k)', 'x', 'LineWidth', 2);
ylim([2150 2376])
xlim([1 2376])
title('');
xlabel('');
ylabel('');
ax = gca;  % Get the current axis handle
ax.XTick = [];
ax.YTick = [];
legend('Data Points', 'Cluster Centroids');

clustercat = horzcat(X, idx);

save('clustercat.mat', 'clustercat');
%cluster cat has 3 columns:
% 1: index, 
% 2: coordinates of max PSD pts,
% 3: cluster assignment number (out of 30).

% Plot linear regression for each cluster
for i = 1:k
    % Extract data points belonging to cluster i
    clusterData = X(idx == i, :);
    
    % Perform linear regression
    coeffs = polyfit(clusterData(:, 1), clusterData(:, 2), 1);
    
    % Plot the regression line
    xFit = linspace(min(clusterData(:, 1)), max(clusterData(:, 1)), 100);
    yFit = polyval(coeffs, xFit);
    plot(xFit, yFit, 'LineWidth', 2);
end

hold off;

% Add labels and legend
title('K-Means Clustering with Linear Regression for Each Cluster');
%xlabel('Feature 1');
%ylabel('Feature 2');
legend('Cluster', 'Centroid', 'LR Line Fit');

% idea: bandpass filter clustering. Mask to create y-limits and run
% clustering, then move up y-axis and continue.

% next: sort clustercat by cluster assignment(1:60), 
% create a matrix for each cluster
% set G = index
% set d = coordinates
% find m (is it an over or underdetermined matrix? 
% I think 1 col= G, 1 col=d, so m will also be 1 col?
% 
% apply ||Gm-d||2

% next: InvMethProject_StepClCat.m





