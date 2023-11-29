
% 1Jan to 8Apr = DR03_2016_0_LHZ, which is 99 days
% The matrix was resized to 2376 x 2376 so that each interval is 1 hr
% 99 days x 24 hours = 2376 hours
% the matrix was smoothed horizontally with medfilt2 [1, 5]

%save filteredImage as Matrix1k1k_DR03_2016_0_LHZ
Matrix_DR03_2016_0_LHZ_ = filteredImage;

% Specify the filename (e.g., 'my_matrix.mat')
filename = 'Matrix_DR03_2016_0_LHZ_.mat';

% Save the matrix to the .mat file
save(filename, 'Matrix_DR03_2016_0_LHZ_');

% Create a sample matrix (replace this with your actual matrix)
originalMatrix = Matrix_DR03_2016_0_LHZ_;

% Find the maximum value in each column
maxValues = max(originalMatrix);

% Iterate over each column and set values less than the maximum to 0
for col = 1:size(originalMatrix, 2)
    columnValues = originalMatrix(:, col);
    originalMatrix(:, col) = columnValues .* (columnValues == maxValues(col));
end

% Initialize arrays to store coordinates of maximum values
maxX = zeros(1, size(originalMatrix, 2));
maxY = zeros(1, size(originalMatrix, 2));

% Iterate over each column
for col = 1:size(originalMatrix, 2)
    % Find the maximum value and its row index in the current column
    [maxValue, rowIndex] = max(originalMatrix(:, col));
    
    % Save the coordinates (x, y) of the maximum value
    maxX(col) = rowIndex;
    maxY(col) = col; % Column index is the y-coordinate
    
end

maxX = maxX';
maxY = maxY';

% Extract x and y coordinates
y = maxY(:, 1);
x = maxX(:, 1);

figure(1)
    h=subplot(6,1,1:2);
    imagesc(Td,F,10*log10(PSDdiffsm));
    xlim(xl)
    axis xy
    ylabel('F (Hz)')
    colormap("jet")
    ax=get(h,'Position');
    s=mean(std(10*log10(PSDdiffsm)));
    m=median(median(10*log10(PSDdiffsm+eps)));
    caxis([m-3*s m+3*s])
    hc=colorbar;
    set(get(hc,'label'),'string','PSD (dB rel. median)');
    tick_locations=[datenum(year,1,1:365),datenum(year+1,1,1:365)];
    set(gca,'XTick',tick_locations)
    datetick('x',6,'keeplimits', 'keepticks')
    xtickangle(90)
    set(h,'Position',ax)
    set(gcf,'units','normalized','position',[0.1300 0.1100 0.8 0.7])

% Plot the coordinates
subplot(4,1,3:4)
plot(y, x, '.');  % '.' specifies markers at the data points
title('Scatter Plot of Coordinates');
xlabel('X-coordinate');
ylabel('Y-coordinate');
grid on;


%for 0.03 to 0.07 Hz...
% y coords 100 to 1000 approx

figure(2)
    h=subplot(4,1,1:2);
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

% Plot the coordinates
subplot(4,1,3:4)
plot(y, x, '.');  % '.' specifies markers at the data points
title('Scatter Plot of Coordinates');
ax = gca;  % Get the current axis handle
ax.TickLength = [0 0];  % Set TickLength to zero for both X and Y axes
%xlabel('X-coordinate');
%ylabel('Y-coordinate');
%grid on;
ylim([150 350]);
xlim([0 2376]);

