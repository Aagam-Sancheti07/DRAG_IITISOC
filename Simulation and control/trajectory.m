% Set the figure background color to white
figure('Color', 'w'); 

% Plot the braked trajectory
plot3(pos_braked(:,1), pos_braked(:,2), pos_braked(:,3), ...
    'b', 'LineWidth', 2.0); 
hold on;

% Plot the unbraked trajectory
plot3(pos_unbraked(:,1), pos_unbraked(:,2), pos_unbraked(:,3), ...
    'r--', 'LineWidth', 2.0);

% --- NEW: Semi-Transparent Target Altitude Plane at 3048m ---
% Define the four corners of a flat plane spanning our X and Y limits (-500 to 500)
x_plane = [-500, 500, 500, -500];
y_plane = [-500, -500, 500, 500];
z_plane = [3048, 3048, 3048, 3048];

% Draw the plane. 'c' is cyan. 'FaceAlpha', 0.2 makes it 80% transparent glass!
patch(x_plane, y_plane, z_plane, 'c', 'FaceAlpha', 0.2, 'EdgeColor', 'c', 'LineWidth', 1.5);

% Optional: Keep the star marker right in the center for a "bullseye" effect
plot3(0, 0, 3048, 'k*', 'MarkerSize', 10, 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Keep the gridlines on
grid on;

% Ensure the axis background itself is also white
set(gca, 'Color', 'w');

% Lock the X and Y limits so the plane fits perfectly edge-to-edge
xlim([-500 500]);
ylim([-500 500]);

xlabel('X (m)'); 
ylabel('Y (m)'); 
zlabel('Altitude (m)');

% Update legend to include the sweet new plane
legend('Braked (airbrake active)', 'Unbraked (clean)', 'Target Plane (3048 m)', 'Location', 'best');
title('3D Trajectory: Braked vs. Unbraked Flight Path');
 
% Note: I changed your pbaspect back to [1 1 3] so it stretches into a tall tower! 
% If you want a perfectly square cube, change this back to [1 1 1].
pbaspect([1 1 1]); 

% Angle the camera slightly lower so the vertical height looks massive
view(45, 10);