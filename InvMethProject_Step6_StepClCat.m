%InvMethProject_StepClCat

%CatSort = sort(clustercat(:,3));

CatSort = sortrows(clustercat, 3);

% Initialize an empty array to store the selected rows
Cat1 = [];

% Loop through each row of the original array
for i = 1:size(CatSort, 1)
    % Check if the value in column 3 is equal to 59
    if CatSort(i, 3) == 15

        % If true, append the first two columns to the selectedRows array
        Cat1 = [Cat1; CatSort(i, 1:2)];
    end
end

% this worked! but i have to do it for all 60...can i put another loop in
% it, maybe where k = 1:60?

Cat1G = Cat1(:,1);
Cat1d = Cat1(:,2);
size(Cat1d)
size(Cat1G)

Cat1m = Cat1G\Cat1d;

scatter(Cat1(:, 1), Cat1(:, 2))

% Extract x and y coordinates
x = Cat1G;
y = Cat1d;

% Perform linear regression (fit a line)
coefficients = polyfit(x, y, 1);

% Generate y values for the fitted line
xFit = linspace(min(x), max(x), 100);
yFit = polyval(coefficients, xFit);

% Plot the original points
scatter(x, y, 'o', 'DisplayName', 'Data Points');
hold on;

% Plot the fitted line
plot(xFit, yFit, 'r-', 'DisplayName', 'Fitted Line');

%%
%Create sample data with predictor variable X and response variable .
rng('default') % For reproducibility

% Extract x and y coordinates
Z = Cat1G;
W = Cat1d;

%Specify a regularization value, and find the coefficient of the regression model without an intercept term.
lambda = 1e-03;
B = lasso(Z,W,'Lambda',lambda,'Intercept',false)

%Plot the real values (points) against the predicted values (line).
scatter(x,W)
hold on
x = 0:0.1:1;
plot(x,x*B)
hold off

