data = readtable('altitude_density.csv');
altitude_data = data.Altitude;   % column name as it appears in your sheet
density_data = data.density;

% Make sure altitude is strictly increasing (required for lookup tables)
[altitude_data, sortIdx] = sort(altitude_data);
density_data = density_data(sortIdx);

[altitude_data, uniqueIdx] = unique(altitude_data, 'stable');
density_data = density_data(uniqueIdx);
save('atmoData.mat', 'altitude_data', 'density_data');