function = energyhalver

START_ALTITUDE = 250000 % m
START_VELOCITY = 7762 % m/s
init_timestep = timestep = 10;

[init_energy, final_energy] = satellite(START_ALTITUDE, START_VELOCITY, timestep);

init_frac_error = abs( final_energy - init_energy ) / init_energy;

fprintf('Fractional error = %f\n', init_frac_error);

tries = 0;
frac_error_change = 1;
while (tries < 10) && ( frac_error_change > 0.5)
	timestep = timestep / 2;
	[init_energy, final_energy] = satellite(START_ALTITUDE, START_VELOCITY, timestep);
	new_frac_error = abs( final_energy - init_energy ) / init_energy;
	fprintf('Fractional error = %f\n', new_frac_error);
	frac_error_change = (new_frac_error / init_frac_error);
	fprintf('Change in Frac Error = %f\n', frac_error_change);
	if (new_frac_error <= 0.01)
		good_timestep = timestep;
		fprintf('1%% error! Attained with a timestep of %f\n', timestep);
	end
	tries = tries + 1;
end

if (tries == 10)
	fprintf('NOTE: Tries exceeded. Something is wonky.\n');
end

fprintf('Starting timestep: %f \nFinal Timestep: %f \n\nTimestep Change Factor: %f \n\n\n', init_timestep, timestep, (init_timestep / timestep) );
fprintf('1%% error obtained with %f\n', good_timestep);
fprintf('Starting Fractional Error: %f \nFinal Fractional Error: %f \n\nFractional Error Change Factor: %f', init_frac_error, new_frac_error, frac_error_change );
