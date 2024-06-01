dronethebit = ryze();
% 드론 객체 선언
cameraObj = camera(dronethebit);
% 카메라 객체 선언
takeoff(dronethebit);
pause(0.5); % 이륙
moveleft(dronethebit,5);
pause(0.5); % roll 제어
turn(dronethebit,deg2rad(30));
pause(0.5); % yaw 제어
moveforward(dronethebit,3);
pause(0.5); % pitch 제어
turn(dronethebit,deg2rad(60));
pause(0.5); % yaw 제어
moveforward(dronethebit,2);
pause(0.5); % pitch 제어

frame = snapshot(cameraObj);
pause(0.5); % 사진 촬영
imshow(frame);
pause(0.5); % 촬영한 사진 출력

turn(dronethebit,deg2rad(150));
pause(0.5); % yaw 제어
moveleft(dronethebit,3);
pause(0.5); % roll 제어
turn(dronethebit,deg2rad(120));
pause(0.5); % 원상태 복귀

land(dronethebit); % 착륙