orData = readtable('openrocket_export.csv');

time_or = orData.Time;
mass_or = orData.Mass;
cg_or   = orData.CGLocation;
cp_or   = orData.CPLocation;
Iyy_or  = orData.LongitudinalMOI;
Ixx_or  = orData.RotationalMOI;

% Clean: remove NaNs, sort, remove duplicates -- same pattern as your density data
validRows = ~isnan(time_or) & ~isnan(mass_or) & ~isnan(cg_or) & ~isnan(cp_or);
time_or = time_or(validRows); mass_or = mass_or(validRows);
cg_or = cg_or(validRows); cp_or = cp_or(validRows);
Iyy_or = Iyy_or(validRows); Ixx_or = Ixx_or(validRows);

[time_or, sortIdx] = sort(time_or);
mass_or = mass_or(sortIdx); cg_or = cg_or(sortIdx); cp_or = cp_or(sortIdx);
Iyy_or = Iyy_or(sortIdx); Ixx_or = Ixx_or(sortIdx);

[time_or, uniqueIdx] = unique(time_or, 'stable');
mass_or = mass_or(uniqueIdx); cg_or = cg_or(uniqueIdx); cp_or = cp_or(uniqueIdx);
Iyy_or = Iyy_or(uniqueIdx); Ixx_or = Ixx_or(uniqueIdx);

% Find where CP drops to (near) zero - marks end of useful ascent data
apogee_idx = find(cp_or <= 0.01, 1, 'first');  

% Truncate everything to just before that point, with a small safety margin
cutoff_idx = apogee_idx - 5;  % a few samples before the drop, adjust as needed

time_or = time_or(1:cutoff_idx);
mass_or = mass_or(1:cutoff_idx);
cg_or   = cg_or(1:cutoff_idx);
cp_or   = cp_or(1:cutoff_idx);
Iyy_or  = Iyy_or(1:cutoff_idx);
Ixx_or  = Ixx_or(1:cutoff_idx);

save('rocketMassProps.mat', 'time_or', 'mass_or', 'cg_or', 'cp_or', 'Iyy_or', 'Ixx_or');