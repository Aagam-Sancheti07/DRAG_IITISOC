deployPct_table = [0 25 50 75 100];
CP_shift_table = [0 0.02 0.05 0.09 0.14];   % example values, use your actual CFD numbers (meters, relative to 0% baseline)

save('cpShiftData.mat', 'deployPct_table', 'CP_shift_table');
