function [ init_energy final_energy ] = satellite(start_altitude, start_velocity, timestep)


%{
    TODOS:
        make main program
        make energy checking sub-function or separate one
        make script to run both, checking values in a loop for question 2
        make script for question 3
        read up on gnuplot agin for q 4 and 5

    BELLS:
        test on computers: (1)
            maclab
            obx
            e3x
        EXTRA CRED: tiny_earth
        rewrite for MOON
        rewrite with different integration methods (3)
            make script to compare nrg change with same timstep
            make script for timestep goals
        look into elliptical functions?
        
%}

%{

    NAME
        satellite -- track the motion of a satellite (hopefully) in orbit
        around earth.

    PARAMETERS

        start_alititude : 

    SIMULATION
        starts at degrees=0 BUT IN CARTESIAN, OH MAN

    NUMERICAL INTEGRATION
        

    VARIABLE CONVENTIONS
        arrays n stuff

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
RUN_FOR = 5600 % s, the time to run until. 5600 s = 90 minutes.
position = [(start_altitude+EARTH_RADIUS) , 0];
velocity = [0, start_velocity];
acceleration = grav(position);
init_energy = total_energy(mass, velocity, position);

% Set the file to print to
fid = fopen(satellite.data, 'w');

fprintf(1, 't  %5E  x  %5E  y %5E  vx  %5E  vy  %5E  a  %5E', time, position(1), position(2), velocity(1), velocity(2), hypo(acceleration));

fprintf(fid, '%012f\t%012f\t%012f\t%012f\t%012f\t%012f\t', time, position(1), position(2), velocity(1), velocity(2), hypo(acceleration));


while (time <  RUN_FOR)
	old_position = position;
	old_velocity = velocity;

	time = time + timestep;
	velocity = old_velocity + ( acceleration * timestep );
	position = old_position + ( old_velocity * timestep );
	acceleration = grav(old_position);

	    
	% only print to the screen every 1 simulation-second
	if (rem(time,1) == 0)
		fprintf(1, 't  %5E  x  %5E  y %5E  vx  %5E  vy  %5E  a  %5E', time, position(1), position(2), velocity(1), velocity(2), hypo(acceleration));
	end

	fprintf(fid, '%012f\t%012f\t%012f\t%012f\t%012f\t%012f\t', time, position(1), position(2), velocity(1), velocity(2), hypo(acceleration));
    
end

fclose(fid);

final_energy = total_energy(mass, velocity, position);

end

% FUNCTION FOR GRAVITATIONAL COMPUTATION
function [ accel ] = grav(positions)

EARTH_MASS = 5.98e24; % kg
GRAVITATION = 6.67e-11; % N-m^2/kg^2

% overall gravity

overall_gravity = - (GRAVITATION * EARTH_MASS) / ( (hypo(position))^3 );

accel = [ overall_gravity*position(1) overall_gravity*position(2) ];

end

% FUNCTION FOR ENERGY CALCULATIONS
function [ found_total_energy ] = total_energy(mass, velocity, position)

% Find gravitational potential energy
gpe = mass * hypo(position) * hypo(grav(position));
% Kinetic Energy
ke = 0.5 * mass * hypo(velocity)^2;
found_total_energy = ke + gpe;

end

% Solve the pythagorean triangle for the hypotenuse, given an array. This only works on the first two entries in the array.
function [ hypotenuse ] = hypo(array)
hypotenuse = (array(1)^2 + array(2)^2)^(0.5);
end


