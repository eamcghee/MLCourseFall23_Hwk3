% remove aliasing, any value less than or equal to 2100 becomes empty

load("filteredcoordinates.mat")
filtcoord = filteredcoordinates;
filtcoord_col2 = filtcoord(:,2);
filtcoord_col1 = filtcoord(:,1);

if any(filtcoord_col2 <= 2110)
    % Set values less than or equal to 2100 to an empty cell value
    filtcoord_col2(filtcoord_col2 <= 2110) = 555;
end

if any(filtcoord_col2 >= 2400)
    % Set values less than or equal to 2100 to an empty cell value
    filtcoord_col2(filtcoord_col2 >= 2400) = 555;
end

filtcoord_remz = horzcat(filtcoord_col1, filtcoord_col2);

% Copy/pasted filtcoord_remz into excel and used replace function to 
% replace all 555 values with Nan; coludn't figure otu how to do that in
% matlab! saved file as filtcoord.csv...

% Replace 'your_file.csv' with the actual path to your CSV file
filename = 'filtcoord.csv';

% Read the CSV file into a 2D array
filtcoordnan = readmatrix(filename);

save('filtcoordnan.mat', 'filtcoordnan');

% the rest of this file is attempts at linear regression (successful), and
% l1 and l2 attempts, unsucessful.

% Next...
% InvMethProject_StepCluster.m

%%

% %%
% 
% % Remove rows where the value in column 2 is equal to zero
% filtcoord_remz_z = filtcoord_remz(filtcoord_remz(:, 2) ~= 0, :);
% 
% figure(1)
% subplot(2,1,1:2)
% plot(filtcoord_remz_z(:,1), filtcoord_remz_z(:,2), '.');  % '.' specifies markers at the data points
% grid on;
% %ylim([2110 2400]);
% %xlim([0 2376]);
% %set(gca, 'YDir', 'reverse');
% %set(gca, 'XDir', 'reverse');
% %%
% % with coordinates of points, how to plot a linear regression
% 
% % start with slope 1 on far left (rows 1:14)
% slope1 = filtcoord_remz_z(1:14,:);
% 
% % Extract x and y coordinates
% x = slope1(:, 1);
% y = slope1(:, 2);
% 
% % Perform linear regression (fit a line)
% coefficients = polyfit(x, y, 1);
% 
% % Generate y values for the fitted line
% xFit = linspace(min(x), max(x), 100);
% yFit = polyval(coefficients, xFit);
% 
% % Plot the original points
% scatter(x, y, 'o', 'DisplayName', 'Data Points');
% hold on;
% 
% % Plot the fitted line
% plot(xFit, yFit, 'r-', 'DisplayName', 'Fitted Line');
% 
% %%
% % with coordinates of points, how to plot an l1
% % didn't figure this out
% % https://www.youtube.com/watch?v=AX_ZDX6aTT0
% % try that next
% 
% % Perform L1 (Lasso) regression
% [B, FitInfo] = lasso(x, y);
% lassoPlot(B, FitInfo, 'PlotType', 'Lambda', 'XScale', 'log');
% lam = FitInfo.Lambda(1,46);
% fitinfomse = FitInfo.MSE(1,46);
% B_ = B(1,46);
% 
% rhat = x\y;
% res = x*rhat - y;     % Calculate residuals
% MSEmin = res'*res/200; % b(:,lam) value is 2.294
% 
% %%
% % with coordinates of points, how to plot an l2
% 
% % how to plot residuals
% 
% rhat = x\y
% res = x*rhat - y;     % Calculate residuals
% MSEmin = res'*res/200 % b(:,lam) value is 2.294
% 
% % how to plot l-curve of l2 vs residuals
% 
% % how to plot l-curve of l1 vs residuals
