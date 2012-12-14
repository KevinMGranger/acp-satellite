function = energyhalver

%{
    NAME
        energyhalver -- re-run the satellite simulation until the fractional error has been halved

    DESCRIPTION
        This function takes starting values, finds the fractional error in the satellite simulation,
	adjusts the values, and re-runs the simulation until the values are halved.

    AUTHOR
        Kevin Granger -- kmg2728@rit.edu
%}


% initial values & constants, echoed when running so the user knows
% (since normally the user would pass arguments, and could see their values, but in this case the program does not accept arguments.)
START_ALTITUDE = 250000 % m
START_VELOCITY = 7762 % m/s
% use a nice high number when just trying to halve the error. It makes the simulation go much faster, albeit less accurate.
init_timestep = timestep = 10;

% do the first run, then compute the fractional error
[init_energy, final_energy] = satellite(START_ALTITUDE, START_VELOCITY, timestep);
init_frac_error = abs( final_energy - init_energy ) / init_energy;
fprintf('Fractional error = %f\n', init_frac_error);

% keep retrying until the fractional error is halved, or until we've tried too many times.
tries = 0;
frac_error_change = 1;
while (tries < 10) && ( frac_error_change > 0.5)
	% try half the timestep! Why half? Because some computer scientist said so.
	timestep = timestep / 2;

	% do the same thing as before, but compute the change this time.
	[init_energy, final_energy] = satellite(START_ALTITUDE, START_VELOCITY, timestep);
	new_frac_error = abs( final_energy - init_energy ) / init_energy;
	fprintf('Fractional error = %f\n', new_frac_error);
	frac_error_change = (new_frac_error / init_frac_error);
	fprintf('Change in Frac Error = %f\n', frac_error_change);
	% let us know if we're now below 1% error.
	% This is useful for the other question, although there's another program for that.
	if (new_frac_error <= 0.01)
		good_timestep = timestep;
		fprintf('1%% error! Attained with a timestep of %f\n', timestep);
	end
	tries = tries + 1;
end

if (tries == 10)
	fprintf('NOTE: Tries exceeded. Something is wonky.\n');
end

% output our results.
fprintf('Starting timestep: %f \nFinal Timestep: %f \n\nTimestep Change Factor: %f \n\n\n', init_timestep, timestep, (init_timestep / timestep) );
fprintf('1%% error obtained with %f\n', good_timestep);
fprintf('Starting Fractional Error: %f \nFinal Fractional Error: %f \n\nFractional Error Change Factor: %f', init_frac_error, new_frac_error, frac_error_change );
