function [ init_energy, final_energy ] = satellite(start_altitude, start_velocity, timestep)

%{

    NAME
        satellite -- track the motion of a satellite (hopefully) in orbit
        around earth.

    PARAMETERS

        start_alititude : the distance above the surface of the earth that the satellite starts at.
		In this case, it starts in the positive x area.

	start_velocity : the starting velocity of the satellite, in the Y direction. Positive is "up."

	timestep : the fraction of time to use for numerical integration.
		The smaller it is, the more accurate, but the more number crunching that must be done.

    RETURNED VALUES

    	init_energy : the amount of energy in the system at the start of the simulation
	final_energy : the amount of energy in the system at the end of the simulation

	These values can both be used by an outside function to compute the error of the simulation.

    SIMULATION
    	The satellite starts at a given altitude away from the earth's surface.
	Speaking in polar coordinates, it starts at zero degrees with a radius of the given altitude plus the radius of the earth.
	It has an initial velocity in the Y direction, regarding positive as up.
	The reasoning behind this setup is that when given positive values,
	the satellite follows the path of an increasing degree value in polar coordinates (conter-clockwise).

    NUMERICAL INTEGRATION
        The method of numerical integration used is Euler's method, second order.
	This means that for each given interval of time (timestep), each time-dependant value is increased by it's higher-order derivatives
	multiplied by the timestep, up to the second degree.

    VARIABLE CONVENTIONS
	All "constants" are in UPPERCASE. These are safe to change before running the program.
	They are currently set to the given values for the assignment.

	position, velocity, and acceleration are all arrays. Position 1 is for the x value, position 2 is for the y value.

    DESIGN PATTERNS (attempted)
    	Compartmentalize as many functions as possible, so that code can easily be reused, refactored or extended.
	As such, do not use global variables. Instead, have sub-functions accept these variables passed as arguments.
	Let the "main" part of the program be easy on the surface in terms of arrays, let the sub-functions do the hard work
		(the user should not have to worry about wrapping variables in other functions to pass the proper format to a function,
		e.g. using acceleration instead of hypo(acceleration) )

    AUTHOR
        Kevin Granger -- kmg2728@rit.edu

%}

% Check initial values
if (start_altitude <= 0)
    error('Error: Your starting altitude must be above zero.');
elseif (timestep <= 0)
    error('Error: your timestep must be a positive number.');
end

% Set constants & initial values

BALL_MASS = 1; % kg
EARTH_RADIUS = 6.37e6; % m
time = 0;
RUN_FOR = 5600; % s, the time to run until. 5600 s = 90 minutes.

% the starting value is however many meters to the "right" of the earth, so set the x value as such.
position = [(start_altitude+EARTH_RADIUS) , 0];
% the starting velocity is in the Y direction, with "up" being positive.
velocity = [0, start_velocity];
% have the grav function find the acceleration due to gravity for both X and Y for us.
acceleration = grav(position);
% calculate the total energy in the system at the start. This is used for the RETURNED VALUES.
init_energy = total_energy(BALL_MASS, velocity, position);

% Set the file to write to
fid = fopen('satellite.txt', 'w');

% write to the screen
fprintf(1, 't  %5E  x  %5E  y %5E  vx  %5E  vy  %5E  a  %5E\n', time, position(1), position(2), velocity(1), velocity(2), hypo(acceleration));

% write to the file
fprintf(fid, '%012f\t%012f\t%012f\t%012f\t%012f\t%012f\n', time, position(1), position(2), velocity(1), velocity(2), hypo(acceleration));


% keep looping until we've reached the time specified earlier
while (time <  RUN_FOR)
	old_position = position;
	old_velocity = velocity;

	time = time + timestep;
	velocity = old_velocity + ( acceleration * timestep );
	position = old_position + ( old_velocity * timestep ) + (0.5 * acceleration * (timestep^2));
	acceleration = grav(old_position);

	    
	fprintf(1, 't  %5E  x  %5E  y %5E  vx  %5E  vy  %5E  a  %5E\n', time, position(1), position(2), velocity(1), velocity(2), hypo(acceleration));

	fprintf(fid, '%012f\t%012f\t%012f\t%012f\t%012f\t%012f\n', time, position(1), position(2), velocity(1), velocity(2), hypo(acceleration));
    
end

fclose(fid);

final_energy = total_energy(BALL_MASS, velocity, position);

end % end of the main function



% FUNCTION FOR GRAVITATIONAL COMPUTATION
% takes a position array, returns an acceleration due to gravity array.
function [ accel ] = grav(positions)

EARTH_MASS = 5.98e24; % kg
GRAVITATION = 6.67e-11; % N-m^2/kg^2

% overall gravity "vector"
overall_gravity = - (GRAVITATION * EARTH_MASS) / ( (hypo(positions))^3 );
% convert to array for X and Y values
accel = [ overall_gravity*positions(1) overall_gravity*positions(2) ];

end % end grav function



% FUNCTION FOR ENERGY CALCULATIONS
% takes mass, velocity array and position array for an object, and returns its total energy
function [ found_total_energy ] = total_energy(mass, velocity, position)

% Find gravitational potential energy
gpe = mass * hypo(position) * hypo(grav(position));
% Kinetic Energy
ke = 0.5 * mass * hypo(velocity)^2;
found_total_energy = ke + gpe;

end



% Solve the pythagorean triangle for the hypotenuse, given an array. This only works on the first two entries in the array.
% There is probably an existing matlab function for this, but this was rewritten for clarity.
% This is useful since we're dealing with X and Y coordinates in an array, but may want, say, the absolute distance from the object to the planet.
function [ hypotenuse ] = hypo(array)
hypotenuse = (array(1)^2 + array(2)^2)^(0.5);
end



% this makes the file look nice under vim, although folding seems to have stopped working somehow.
% If you don't use vim, ignore these lines. But if you're grading this, you know vim.
% vim:fdm=manual fmr={,}
