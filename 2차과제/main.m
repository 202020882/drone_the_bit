dronethebit = ryze();
cameraObj = camera(dronethebit);

takeoff(dronethebit);
pause(0.5);
moveleft(dronethebit,5);
pause(0.5);
turn(dronethebit,deg2rad(30));
pause(0.5);
moveforward(dronethebit,3);
pause(0.5);
turn(dronethebit,deg2rad(60));
pause(0.5);
moveforward(dronethebit,2);
pause(0.5);

frame = snapshot(cameraObj);
pause(0.5);
imshow(frame);
pause(0.5);

turn(dronethebit,deg2rad(150));
pause(0.5);
moveleft(dronethebit,3);
pause(0.5);
turn(dronethebit,deg2rad(120));
pause(0.5);

land(dronethebit);