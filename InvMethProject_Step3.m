% use matrix from step 1 to ylimit the frequency range to 0.00 to 0.07 Hz
% by creating a matrix of zeros for values higher than 0.07 Hz
% Rows 0-1625 values will be zero and rows 1626-2376 are from the original
% matrix

th_matrix = Matrix_DR03_2016_0_LHZ_;
th_matrix = th_matrix(1:400,:);
zeroMatrix = zeros(1976, 2376);

FreqLimMatrix = vertcat(zeroMatrix, th_matrix);

% re-run Step 2 to obtain maximum  values for each column and plot

% Find the maximum value in each column
maxValues_fl = max(FreqLimMatrix);

% Iterate over each column and set values less than the maximum to 0
for col = 1:size(FreqLimMatrix, 2)
    columnValues_fl = FreqLimMatrix(:, col);
    FreqLimMatrix(:, col) = columnValues_fl .* (columnValues_fl == maxValues_fl(col));
end

% Initialize arrays to store coordinates of maximum values
maxX_fl = zeros(1, size(FreqLimMatrix, 2));
maxY_fl = zeros(1, size(FreqLimMatrix, 2));

% Iterate over each column
for col = 1:size(FreqLimMatrix, 2)
    % Find the maximum value and its row index in the current column
    [maxValue_fl, rowIndex_fl] = max(FreqLimMatrix(:, col));
    
    % Save the coordinates (x, y) of the maximum value
    maxX_fl(col) = rowIndex_fl;
    maxY_fl(col) = col; % Column index is the y-coordinate
    
end

maxX_fl = maxX_fl';
maxY_fl = maxY_fl';

% Extract x and y coordinates
y_fl = maxY_fl(:, 1);
x_fl = maxX_fl(:, 1);

%for 0.03 to 0.07 Hz...
% y coords 100 to 1000 approx

figure(1)
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
plot(y_fl, x_fl, '.');  % '.' specifies markers at the data points
title('Scatter Plot of Coordinates');
%set(gca, 'YDir', 'reverse');
%set(gca, 'XDir', 'reverse');
%xlabel('X-coordinate');
%ylabel('Y-coordinate');
grid on;
ylim([2100 2376]);
xlim([0 2376]);

% Add a horizontal line at y = 0.5 (replace with your desired y-coordinate)
% yLine = 2231;
% hold on;  % Use hold on to overlay the line on the existing plot
% line([min(x_fl), max(x_fl)], [yLine, yLine], 'Color', 'red', 'LineStyle', '--', 'LineWidth', 2);
% hold off;

%Obtain final bandpass array

% set up an array composed of y_fl and x_fl such that the xlim is
% 2100-2376 and xlim is 0 to 2376 to retain frequency limits and remove low
% frequency tsunami band from above. 

% Change all column 2 coordinates value equal to 1 to 0
x_fl(x_fl == 1) = 0;
x_fl(x_fl < 1) = 0;

%first, combine y_fl (index) and x_fl to create a coordinate array
coordinates = horzcat(y_fl, x_fl);

subplot(4,1,3:4)
plot(coordinates(:,1), coordinates(:,2), '.');  % '.' specifies markers at the data points
grid on;
ylim([2110 2400]);
xlim([0 2376]);
%set(gca, 'YDir', 'reverse');
%set(gca, 'XDir', 'reverse');

% save array
filteredcoordinates = coordinates;

% Specify the filename (e.g., 'my_matrix.mat')
filename = 'filteredcoordinates.mat';

% Save the matrix to the .mat file
save(filename, 'filteredcoordinates');

%Next...
%InvMethProject_StepBinarize




