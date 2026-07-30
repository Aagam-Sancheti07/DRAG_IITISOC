cdrag = readtable("Cleandrag.csv");
% Extract relevant columns for analysis
time_c = cdrag.Time; 
Cd =cdrag.Dc; 

save('dragcurve.mat',"Cd","time_c");