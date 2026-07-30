figure;
plot3(pos_braked(:,1), pos_braked(:,2), pos_braked(:,3), ...
      'b', 'LineWidth', 1.5);
hold on;
plot3(pos_unbraked(:,1), pos_unbraked(:,2), pos_unbraked(:,3), ...
      'r--', 'LineWidth', 1.5);
grid on;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Altitude (m)');
legend('Braked (airbrake active)', 'Unbraked (clean)', 'Location', 'best');
title('3D Trajectory: Braked vs. Unbraked Flight Path');
view(45, 20);   % angle the camera so both curves are visible S