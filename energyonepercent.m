function energyonepercent
% #occupymatlab

START_ALTITUDE = 250000 % m
START_VELOCITY = 7762 % m/s
upper_timestep = timestep = 0.95;
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

