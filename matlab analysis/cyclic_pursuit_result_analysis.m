%% Plotting the yaw of one of the crazyflies
clear; close all;
bag = ros2bagreader("rosbag2_2025_04_02-16_50_31_0.db3");

% plot the yaw of cf232
message = select(bag, 'Topic', '/cf232/pose');
all_msg = readMessages(message);
orientation_232 = zeros(1, length(all_msg));

for i = 1:length(all_msg)
    orientation = all_msg{i}.pose.orientation;
    w_orient(i) = orientation.w;
    z_orient(i) = orientation.z;
end

yaw = atan2d(z_orient, w_orient);
plot(yaw)

%% Create an animation of the all the crazyflie trajectories
clear; close all;
bag = ros2bagreader("rosbag2_2025_02_25-16_14_06_0.db3");

% Read messages for Crazyflie 231
messages_cf1 = select(bag, 'Topic', '/cf231/pose');
all_msgs_cf1 = readMessages(messages_cf1);

% Read messages for Crazyflie 123
messages_cf2 = select(bag, 'Topic', '/cf123/pose');
all_msgs_cf2 = readMessages(messages_cf2);

% Initialize arrays to store positions
x_positions_231 = zeros(1, length(all_msgs_cf1));
y_positions_231 = zeros(1, length(all_msgs_cf1));

x_positions_3 = zeros(1, length(all_msgs_cf2));
y_positions_3 = zeros(1, length(all_msgs_cf2));

% Extract positions for Crazyflie 231
for i = 1:length(all_msgs_cf1)
    pose = all_msgs_cf1{i}.pose.position;
    x_positions_231(i) = pose.x;
    y_positions_231(i) = pose.y;
end

% Extract positions for Crazyflie 123
for i = 1:length(all_msgs_cf2)
    pose = all_msgs_cf2{i}.pose.position;
    x_positions_3(i) = pose.x;
    y_positions_3(i) = pose.y;
end

% Create figure
figure;
hold on;
grid on;
xlim([-3 3]);
ylim([-2 2]);
xlabel('X Position');
ylabel('Y Position');
title('Fast Trajectory Animation of 2 Crazyflies');

% Create animated lines
traj_cf1 = animatedline('Color', 'b', 'LineWidth', 2);
traj_cf2 = animatedline('Color', 'k', 'LineWidth', 2);

% Create markers for current position
marker_cf1 = plot(NaN, NaN, 'bo', 'MarkerSize', 10, 'DisplayName', 'CF1');
marker_cf2 = plot(NaN, NaN, 'kx', 'MarkerSize', 10, 'DisplayName', 'CF2');

legend([marker_cf1, marker_cf2], {'CF1', 'CF2'});

% Initialize video writer
video_filename = 'crazyflies_trajectory.mp4';
video_fps = 30;  % Frames per second
v = VideoWriter(video_filename, 'MPEG-4');
v.FrameRate = video_fps;
open(v);

% Animate the trajectories quickly and record video
num_frames = max(length(x_positions_231), length(x_positions_3));

for i = 1:num_frames
    % Update Crazyflie 231 trajectory
    if i <= length(x_positions_231)
        addpoints(traj_cf1, x_positions_231(i), y_positions_231(i));
        set(marker_cf1, 'XData', x_positions_231(i), 'YData', y_positions_231(i));
    end

    % Update Crazyflie 123 trajectory
    if i <= length(x_positions_3)
        addpoints(traj_cf2, x_positions_3(i), y_positions_3(i));
        set(marker_cf2, 'XData', x_positions_3(i), 'YData', y_positions_3(i));
    end

    % Capture frame and write to video
    frame = getframe(gcf);
    writeVideo(v, frame);

    % Faster animation speed (adjust or remove this line)
    %pause(0.1);
end

% Close the video file
close(v);
hold off;

disp(['Video saved as: ', video_filename]);


%% Create a plot of the absolute distance between two crazyflies to evaulate safety
clear; close all;
bag = ros2bagreader("rosbag2_2025_02_25-16_14_06_0.db3");

% Read messages for Crazyflie 231
messages_cf1 = select(bag, 'Topic', '/cf231/pose');
all_msgs_cf1 = readMessages(messages_cf1);

% Read messages for Crazyflie 123
messages_cf2 = select(bag, 'Topic', '/cf123/pose');
all_msgs_cf2 = readMessages(messages_cf2);

% Get the number of messages
num_cf1 = length(all_msgs_cf1);
num_cf2 = length(all_msgs_cf2);
num_frames = min(num_cf1, num_cf2);  % Use the minimum to prevent indexing errors

% Initialize arrays for positions
x_positions_231 = zeros(1, num_cf1);
y_positions_231 = zeros(1, num_cf1);
x_positions_3 = zeros(1, num_cf2);
y_positions_3 = zeros(1, num_cf2);

% Extract positions for Crazyflie 231
for i = 1:num_cf1
    pose = all_msgs_cf1{i}.pose.position;
    x_positions_231(i) = pose.x;
    y_positions_231(i) = pose.y;
end

% Extract positions for Crazyflie 123
for i = 1:num_cf2
    pose = all_msgs_cf2{i}.pose.position;
    x_positions_3(i) = pose.x;
    y_positions_3(i) = pose.y;
end

% Compute Distance Between the Two Crazyflies
distances = zeros(1, num_frames);

% Compute Euclidean distance at each time step
for i = 1:num_frames
    distances(i) = sqrt((x_positions_231(i) - x_positions_3(i))^2 + ...
                        (y_positions_231(i) - y_positions_3(i))^2);
end

% Plot Distance Over Time
figure;
plot(1:num_frames, distances, 'r-', 'LineWidth', 2);
xlabel('Time Step');
ylabel('Distance (m)');
title('Distance Between Two Crazyflies Over Time');
grid on;
ylim([0, max(distances) * 1.2]); % Adjust Y-axis for better visibility


%%  Create a plot of the crazyflie trajectories at the horizon
clear; close all;
bag = ros2bagreader("rosbag2_2025_02_25-16_14_06_0.db3");



% Select messages from cf231
messages = select(bag, 'Topic', '/cf231/pose');

% Read all messages in one go
all_msgs = readMessages(messages);

% Initialize arrays to store x and y positions
x_positions_231 = [];
y_positions_231 = [];

% Loop through each message and extract positions
for i = 1:length(all_msgs)
    % Access the Pose message
    pose = all_msgs{i}.pose.position;
    orientation = all_msgs{i}.pose.orientation;
    
    % Extract x and y positions
    x_positions_231(i) = pose.x;
    y_positions_231(i) = pose.y;
end




% Select messages from cf232
messages = select(bag, 'Topic', '/cf232/pose');

% Read all messages in one go
all_msgs = readMessages(messages);

% Initialize arrays to store x and y positions
x_positions_232 = [];
y_positions_232 = [];

% Loop through each message and extract positions
for i = 1:length(all_msgs)
    % Access the Pose message
    pose = all_msgs{i}.pose.position;
    orientation = all_msgs{i}.pose.orientation;

    % Extract x and y positions
    x_positions_232(i) = pose.x;
    y_positions_232(i) = pose.y;
end




% Select messages from cf233
messages = select(bag, 'Topic', '/cf233/pose');

% Read all messages in one go
all_msgs = readMessages(messages);

% Initialize arrays to store x and y positions
x_positions_233 = [];
y_positions_233 = [];

% Loop through each message and extract positions
for i = 1:length(all_msgs)
    % Access the Pose message
    pose = all_msgs{i}.pose.position;
    orientation = all_msgs{i}.pose.orientation;
    
    % Extract x and y positions
    x_positions_233(i) = pose.x;
    y_positions_233(i) = pose.y;
end




% Select messages from cf123
messages = select(bag, 'Topic', '/cf123/pose');

all_msgs = readMessages(messages);

% Initialize arrays to store x and y positions
x_positions_123 = [];
y_positions_123 = [];

% Loop through each message and extract positions
for i = 1:length(all_msgs)
    % Access the Pose message
    pose = all_msgs{i}.pose.position;
    orientation = all_msgs{i}.pose.orientation;
    
    % Extract x and y positions
    x_positions_123(i) = pose.x;
    y_positions_123(i) = pose.y;
end

% Precompute gradient colors for each trajectory
colormap_full = parula(256); % Full colormap
colormap_cf1 = colormap_full(1:64, :); % Lighter gradient for Crazyfly 1
colormap_cf2 = colormap_full(64:128, :); % Darker gradient for Crazyfly 2
colormap_cf3 = colormap_full(128:192, :);
colormap_cf4 = colormap_full(192:256, :);

% Generate gradient colors for each trajectory
colormap1 = colormap_cf1(round(linspace(1, size(colormap_cf1, 1), length(x_positions_231) - 1)), :);
colormap2 = colormap_cf2(round(linspace(1, size(colormap_cf2, 1), length(x_positions_232) - 1)), :);
colormap3 = colormap_cf3(round(linspace(1, size(colormap_cf3, 1), length(x_positions_233) - 1)), :);
colormap4 = colormap_cf4(round(linspace(1, size(colormap_cf4, 1), length(x_positions_123) - 1)), :);
figure;
hold on;

% Plot Crazyfly 231 with gradient
for i = 1:(length(x_positions_231) - 1)
    plot(x_positions_231(i:i+1), y_positions_231(i:i+1), ...
         'Color', colormap1(i, :), 'LineWidth', 2);
end

% Plot Crazyfly 232 with gradient
for i = 1:(length(x_positions_232) - 1)
    plot(x_positions_232(i:i+1), y_positions_232(i:i+1), ...
         'Color', colormap2(i, :), 'LineWidth', 2);
end

% Plot Crazyfly 233 with gradient
for i = 1:(length(x_positions_233) - 1)
    plot(x_positions_233(i:i+1), y_positions_233(i:i+1), ...
         'Color', colormap3(i, :), 'LineWidth', 2);
end

% Plot Crazyfly 123 with gradient
for i = 1:(length(x_positions_123) - 1)
    plot(x_positions_123(i:i+1), y_positions_123(i:i+1), ...
         'Color', colormap4(i, :), 'LineWidth', 2);
end

% plot the end points of the trajectories
h1=plot(x_positions_231(end), y_positions_231(end), 'bo', 'MarkerSize', 10, 'DisplayName', 'CF1 Endpoint');
h2=plot(x_positions_232(end), y_positions_232(end), 'kx', 'MarkerSize', 10, 'DisplayName', 'CF2 Endpoint');
h3=plot(x_positions_233(end), y_positions_233(end), 'gsquare', 'MarkerSize', 10, 'DisplayName', 'CF3 Endpoint');
h4=plot(x_positions_123(end), y_positions_123(end), 'r*', 'MarkerSize', 10, 'DisplayName', 'CF4 Endpoint');

xlabel('X Position');
ylabel('Y Position');
legend([h1;h2;h3;h4],['CF1 Endpoint';'CF2 Endpoint';"CF3 Endpoint";"CF4 Endpoint"])
title('Trajectory of 3 crazyflies');
grid on;
xlim([-3 3])
ylim([-3 3])



