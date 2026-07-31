function y_k = MeasurementFcn(x_k)
    % x_k: 12-element state vector
    % y_k: 4-element measurement vector [p; q; r; alt]
    
    y_k = zeros(4,1);
    
    % 1-3: Gyroscope directly measures angular rates
    y_k(1:3) = x_k(10:12);
    
    % 4: MS5611 Barometer directly measures Z-position (altitude)
    y_k(4) = x_k(3);
end