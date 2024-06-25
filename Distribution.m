% Number of users
m = 1000; % Number of users 

% Load user locations
USER_LOC = load('UserLocation1.txt');

% Clustering users into 'k' groups using k-means
k = 20; % number of clusters
[cluster_idx, cluster_center] = kmeans(USER_LOC, k);

% UAV counts to test
uav_counts = [10,20,30,40,50,60,70];
num_iterations = 1000;

% Initialize storage for results
results = zeros(length(uav_counts), num_iterations);

% Loop through different numbers of UAVs
for idx = 1:length(uav_counts)
    n = uav_counts(idx); % number of UAVs
    
    for iter = 1:num_iterations
        % Randomly initialize UAV positions
        x = rand(1, n) * max(USER_LOC(:, 1));
        y = rand(1, n) * max(USER_LOC(:, 2));
        
        % UAV Parameters
        UAV_HEIGHT = 350;
        THETA = 60 * pi / 180;

        % Coverage radius of the UAV
        Coverage_radius = UAV_HEIGHT * tan(THETA / 2);

        % Count the number of users within the coverage radius of each UAV
        user_covered = zeros(m, 1); % array to mark users that are covered
        total_users_covered = 0;

        for i = 1:n
            covered_count = 0;
            for j = 1:m
                if ~user_covered(j) % if user is not already covered
                    dist = norm([x(i) - USER_LOC(j, 1); y(i) - USER_LOC(j, 2)], 2);
                    if dist <= Coverage_radius
                        user_covered(j) = 1; % mark user as covered
                        total_users_covered = total_users_covered + 1;
                        covered_count = covered_count + 1;
                        if covered_count >= 20
                            break;
                        end
                    end
                end
            end
        end
        
        % Save the total number of unique users covered in this iteration
        results(idx, iter) = total_users_covered;
    end
end

% Calculate statistics for plotting
mean_covered = mean(results, 2);
std_covered = std(results, 0, 2);

% Plot the results
figure;
hold on;

% Plot mean and standard deviation as error bars
errorbar(uav_counts, mean_covered, std_covered, '-o', 'LineWidth', 2);

xlabel('Number of UAVs');
ylabel('Number of Users Covered');
title('Number of Users Covered vs. Number of UAVs');
legend('Random');
grid on;
hold off;

% Save results to a file in a specific directory
uav_range = uav_counts;
optimal_values = mean_covered;
save('C:\Users\gowth\OneDrive\Desktop\uav_distribution_results_1000.mat', 'uav_range', 'optimal_values', 'std_covered');


