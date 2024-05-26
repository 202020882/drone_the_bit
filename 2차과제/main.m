dronethebit = ryze();
cameraObj = camera(dronethebit);

takeoff(dronethebit);
pause(0.5);
moveleft(dronethebit,5);
pause(0.5);
turn(dronethebit,deg2rad(30));
pause(0.5);
moveforward(dronethebit,3);
