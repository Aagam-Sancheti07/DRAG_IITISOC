Motor = readtable("Cesaroni_6026M1670-P.csv");
% Extract relevant columns for analysis
time = Motor.Time; 
thrust = Motor.Thrust; 

save('thrustcurve.mat',"thrust","time");