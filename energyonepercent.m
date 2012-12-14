function energyonepercent

%{
    NAME
    	energyonepercent -- find the highest possible timestep that still results in a ~1% fractional error

    DESCRIPTION
        Find the fractional error for a simulation given certain starting values,
	then use the bisection algorithim to get as close as possible.
	
	We are the 1%. #occupymatlab

    AUTHOR
        Kevin Granger -- kmg2728@rit.edu
%}

START_ALTITUDE = 250000 % m
START_VELOCITY = 7762 % m/s
% this value was found to be a good starting point when running the other energy wrapper.
upper_timestep = timestep = 0.95;
% 0 is a good lower bound for bisection. essentially just halving it, but only for the first run.
lower_timestep = 0;

tries = 0;
frac_error_change = 1;
while (tries < 10)
	[init_energy, final_energy] = satellite(START_ALTITUDE, START_VELOCITY, timestep);
	frac_error = abs( final_energy - init_energy ) / init_energy;
	fprintf('With timestep %f, fractional error = %f\n', timestep, frac_error);
	if (frac_error > 0.01)
		upper_timestep = timestep;
		timestep = (upper_timestep + lower_timestep) / 2;
	elseif (frac_error < 0.01)
		lower_timestep = timestep;
		timestep = (upper_timestep + lower_timestep) / 2;
	end
	tries = tries + 1;
end

if (tries == 10)
	fprintf('NOTE: Tries exceeded.\n');
end
