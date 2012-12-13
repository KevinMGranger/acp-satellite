function = energyhalver

START_ALTITUDE = 250000
START_VELOCITY = 7762
init_timestep = timestep = 10;

[init_energy final_energy] = satellite(START_ALTITUDE, START_VELOCITY, timestep);

init_frac_error = ( final_energy - init_energy ) / init_energy;

fprintf('Fractional error = ${0}', frac_error);

while ( (tries < 10) && (init_frac_error / new_frac_error) > 0.5) )
	timestep = timestep / 2;
	[init_energy final_energy] = satellite(START_ALTITUDE, START_VELOCITY, timestep);
	new_frac_error = ( final_energy - init_energy ) / init_energy;
	tries = tries + 1;
end

if (tries == 10)
	fprintf('NOTE: Tries exceeded. Something is wonky.');
end

fprintf('Starting timestep: ${0} \nFinal Timestep: ${0} \n\nTimestep Change Factor: ${0} \n\n\n', init_timestep, timestep, (init_timestep / timestep) );
fprintf('Starting Fractional Error: ${0} \nFinal Fractional Error: ${0} \n\nFractional Error Change Factor: ${0}', init_frac_error, new_frac_error, (init_frac_error / new_frac_error) );
