function x_k1 = StateTransitionFcn(x_k, u)
    % x_k: 12-element state vector [px, py, pz, vx, vy, vz, phi, theta, psi, p, q, r]
    % u: 3-element input vector [ax, ay, az] from the accelerometer
    
    dt = 0.001; 
    g = 9.81;  % Gravity constant (assuming Z-up inertial frame)
    
    % Initialize next state vector
    x_k1 = zeros(12,1);
    
    % Extract current states for easier reading
    pos = x_k(1:3);
    vel = x_k(4:6);
    phi = x_k(7); theta = x_k(8); psi = x_k(9);
    p = x_k(10); q = x_k(11); r = x_k(12);
    
    % --- 1. Attitude Update (Euler Kinematics) ---
    % Convert body rates from the gyro into real Euler angle rates
    euler_rates = [1, sin(phi)*tan(theta), cos(phi)*tan(theta);
                   0, cos(phi),           -sin(phi);
                   0, sin(phi)/cos(theta), cos(phi)/cos(theta)] * [p; q; r];
                   
    x_k1(7:9) = [phi; theta; psi] + (euler_rates * dt);
    
    % --- 2. Velocity Update ---
    % Direction Cosine Matrix (Body to Inertial, Z-Y-X sequence)
    R_b_i = [cos(theta)*cos(psi), sin(phi)*sin(theta)*cos(psi) - cos(phi)*sin(psi), cos(phi)*sin(theta)*cos(psi) + sin(phi)*sin(psi);
             cos(theta)*sin(psi), sin(phi)*sin(theta)*sin(psi) + cos(phi)*cos(psi), cos(phi)*sin(theta)*sin(psi) - sin(phi)*cos(psi);
            -sin(theta),          sin(phi)*cos(theta),                              cos(phi)*cos(theta)];
             
    % Rotate specific force to inertial frame and subtract gravity
    a_i = (R_b_i * u) - [0; 0; g];
    
    x_k1(4:6) = vel + (a_i * dt);
    
    % --- 3. Position Update ---
    % Standard kinematic equation: pos = pos + v*t + 0.5*a*t^2
    x_k1(1:3) = pos + (vel * dt) + (0.5 * a_i * dt^2);
    
    % --- 4. Angular Rates Update ---
    x_k1(10:12) = [p; q; r];
end