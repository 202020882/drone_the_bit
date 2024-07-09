% 메인 스크립트
count_go = 0;  % 전진한 횟수를 세주는 변수
area_circle = 0;  % 각 스테이지 별 원의 면적
center = [480, 200];  % 기준 중심 위치
centroid = zeros(size(center));  % 원의 중심 좌표를 저장할 변수
count = 0; % 상하좌우 전진 횟수
color_pixel = 0; % 색 감지 변수

drone = ryze();  % 드론 객체 선언
cam = camera(drone);  % 드론의 카메라 객체 선언
takeoff(drone);  % 드론 이륙
move(drone, [-0.3 0 -0.3],"Speed",0.2); % 드론 x방향 z방향으로 -만큼 이동
pause(1.0);

% 1stage
while 1
    frame = snapshot(cam);  % 카메라로부터 이미지 캡처
    img = double(frame);  % 이미지를 double 형으로 변환
    [R, C, X] = size(img);  % 이미지의 크기를 저장

    % 특정 색상 조건에 따라 이미지를 이진화
    img2 = zeros(R, C, X);
    for i = 1:R
        for j = 1:C
            if img(i, j, 1) - img(i, j, 2) > -5 || img(i, j, 1) - img(i, j, 3) > -5 || img(i, j, 2) - img(i, j, 3) > -40
                img2(i, j, :) = 255;
            else
                img2(i, j, :) = 0;
            end
        end
    end

    % 이진화된 이미지에서 원의 중심과 면적을 찾음
    circle_ring = img2 / 255;
    circle_ring_Gray = rgb2gray(circle_ring);
    circle_ring_bi = imbinarize(circle_ring_Gray);
    bi2 = imcomplement(circle_ring_bi);
    bw = bwareaopen(bi2, 8000);
    bw = imcomplement(bw);
    se = strel('disk', 10);
    bw2 = imclose(bw, se);
    bw3 = bwareaopen(bw2, 8000);
    [B, L] = bwboundaries(bw3, 'noholes');
    figure(1), imshow(bw3); % 원의 중심 좌표 찾는 과정 출력
    axis on
    hold on

    % 원의 경계를 하얀색 선으로 그림
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:, 2), boundary(:, 1), 'w', 'LineWidth', 2);
    end

    % 원의 면적과 중심 좌표를 계산
    stats = regionprops(L, 'Area', 'Centroid');
    threshold = 0.7;
    for k = 1:length(B)
        boundary = B{k};
        delta_sq = diff(boundary).^2;
        perimeter = sum(sqrt(sum(delta_sq, 2)));
        area = stats(k).Area;
        metric = 4 * pi * area / perimeter^2;
        metric_string = sprintf('%2.2f', metric);

        if metric > threshold
            area_circle = stats(k).Area;
            centroid = stats(k).Centroid;
            plot(centroid(1), centroid(2), 'r');
        end

        text(boundary(1, 2) - 35, boundary(1, 1) + 13, metric_string, 'Color', 'r', ...
            'FontSize', 10, 'FontWeight', 'bold');
    end

    % 드론의 이동 결정
    dis = centroid - center;
    if (abs(dis(1)) < 33 && abs(dis(2)) < 33) || count == 4

        frame = snapshot(cam); % 색상 감지
        color_pixel = processImage_R(frame);
        if color_pixel > 150
            disp('find_red')
        end

        % 드론을 앞으로 이동
        if 30000 <= area_circle && area_circle < 40000
            moveforward(drone, 'Distance', 3.8, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(-1);
        elseif 40000 <= area_circle && area_circle < 50000
            moveforward(drone, 'Distance', 3.75, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(0);
        elseif 50000 <= area_circle && area_circle < 60000
            moveforward(drone, 'Distance', 3.7, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(1);
        elseif 60000 <= area_circle && area_circle < 70000
            moveforward(drone, 'Distance', 3.65, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(2);
        elseif 70000 <= area_circle && area_circle < 85000
            moveforward(drone, 'Distance', 3.6, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(3);
        elseif 85000 <= area_circle && area_circle < 100000
            moveforward(drone, 'Distance', 3.5, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(4);
        elseif 100000 <= area_circle && area_circle < 130000
            moveforward(drone, 'Distance', 3.4, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(5);
        elseif 130000 <= area_circle && area_circle < 160000
            moveforward(drone, 'Distance', 3.3, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(6);
        elseif 160000 <= area_meas
            moveforward(drone, 'Distance', 3.1, 'Speed', 0.7);
            count_forward = 1;
            pause(1.0);
            disp(7);
        else
            moveforward(drone, 'Distance', 3.85, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(12);
        end

    else
        while 1
            if dis(1) > 0 && abs(dis(1)) > 33 && dis(2) < 33
                disp("Moving drone right");
                moveright(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) < 0 && abs(dis(1)) > 33 && dis(2) < 33
                disp("Moving drone left");
                moveleft(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif abs(dis(1)) < 33 && dis(2) > 0 && abs(dis(2)) > 33
                disp("Moving drone down");
                movedown(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif abs(dis(1)) < 33 && dis(2) < 0 && abs(dis(2)) > 33
                disp("Moving drone up");
                moveup(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) > 0 && abs(dis(1)) > 33
                disp("Moving right");
                moveright(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) < 0 && abs(dis(1)) > 33
                disp("Moving left");
                moveleft(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            else
                break;
            end
        end

    end
    if count_go == 1
        break;
    end
end


count_go = 0;
count = 0;
turn(drone, deg2rad(130));

% 2stage
moveforward(drone, 'Distance', 2.6, 'Speed', 0.7);
pause(1.0);

while 1
    frame = snapshot(cam);  % 카메라로부터 이미지 캡처
    img = double(frame);  % 이미지를 double 형으로 변환
    [R, C, X] = size(img);  % 이미지의 크기를 저장

    % 특정 색상 조건에 따라 이미지를 이진화
    img2 = zeros(R, C, X);
    for i = 1:R
        for j = 1:C
            if img(i, j, 1) - img(i, j, 2) > -5 || img(i, j, 1) - img(i, j, 3) > -5 || img(i, j, 2) - img(i, j, 3) > -40
                img2(i, j, :) = 255;
            else
                img2(i, j, :) = 0;
            end
        end
    end

    % 이진화된 이미지에서 원의 중심과 면적을 찾음
    circle_ring = img2 / 255;
    circle_ring_Gray = rgb2gray(circle_ring);
    circle_ring_bi = imbinarize(circle_ring_Gray);
    bi2 = imcomplement(circle_ring_bi);
    bw = bwareaopen(bi2, 8000);
    bw = imcomplement(bw);
    se = strel('disk', 10);
    bw2 = imclose(bw, se);
    bw3 = bwareaopen(bw2, 8000);
    [B, L] = bwboundaries(bw3, 'noholes');
    figure(1), imshow(bw3);
    axis on
    hold on

    % 원의 경계를 하얀색 선으로 그림
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:, 2), boundary(:, 1), 'w', 'LineWidth', 2);
    end

    % 원의 면적과 중심 좌표를 계산
    stats = regionprops(L, 'Area', 'Centroid');
    threshold = 0.7;
    for k = 1:length(B)
        boundary = B{k};
        delta_sq = diff(boundary).^2;
        perimeter = sum(sqrt(sum(delta_sq, 2)));
        area = stats(k).Area;
        metric = 4 * pi * area / perimeter^2;
        metric_string = sprintf('%2.2f', metric);

        if metric > threshold
            area_circle = stats(k).Area;
            centroid = stats(k).Centroid;
            plot(centroid(1), centroid(2), 'r');
        end

        text(boundary(1, 2) - 35, boundary(1, 1) + 13, metric_string, 'Color', 'r', ...
            'FontSize', 10, 'FontWeight', 'bold');
    end

    % 드론의 이동 결정
    dis = centroid - center;
    if (abs(dis(1)) < 40 && abs(dis(2)) < 40) || count == 4

        frame = snapshot(cam); % 색상 감지
        color_pixel = processImage_G(frame);
        if color_pixel > 200
            disp('find_green')
        end

        % 드론을 앞으로 이동
        if 30000 <= area_circle && area_circle < 40000
            moveforward(drone, 'Distance', 1.55, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(-1);
        elseif 40000 <= area_circle && area_circle < 50000
            moveforward(drone, 'Distance', 1.5, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(0);
        elseif 50000 <= area_circle && area_circle < 60000
            moveforward(drone, 'Distance', 1.45, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(1);
        elseif 60000 <= area_circle && area_circle < 70000
            moveforward(drone, 'Distance', 1.4, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(2);
        elseif 70000 <= area_circle && area_circle < 85000
            moveforward(drone, 'Distance', 1.3, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(3);
        elseif 85000 <= area_circle && area_circle < 100000
            moveforward(drone, 'Distance', 1.2, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(4);
        elseif 100000 <= area_circle
            moveforward(drone, 'Distance', 1.1, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
        else
            moveforward(drone, 'Distance', 1.6, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(12); % 두번찍힘
        end

        % 드론이 원의 중심과 가까울 경우
    elseif (abs(dis(1)) > 40 && abs(dis(1)) <= 200) || (abs(dis(2)) > 40 && abs(dis(2)) <=200)
        while 1
            if dis(1) > 0 && abs(dis(1)) > 40 && dis(2) < 40
                disp("Moving drone right");
                moveright(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) < 0 && abs(dis(1)) > 40 && dis(2) < 40
                disp("Moving drone left");
                moveleft(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif abs(dis(1)) < 40 && dis(2) > 0 && abs(dis(2)) > 40
                disp("Moving drone down");
                movedown(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif abs(dis(1)) < 40 && dis(2) < 0 && abs(dis(2)) > 40
                disp("Moving drone up");
                moveup(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) > 0 && abs(dis(1)) > 40
                disp("Moving right");
                moveright(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) < 0 && abs(dis(1)) > 40
                disp("Moving left");
                moveleft(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            end
        end


        % 드론이 원의 중심과 멀리 떨어져 있을 경우
    elseif dis(1) > 0 && abs(dis(1)) > 200 && dis(2) < 40
        disp("Moving drone more right");
        moveright(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif dis(1) < 0 && abs(dis(1)) > 200 && dis(2) < 40
        disp("Moving drone more left");
        moveleft(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif abs(dis(1)) < 40 && dis(2) > 0 && abs(dis(2)) > 200
        disp("Moving drone more down");
        movedown(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif abs(dis(1)) < 40 && dis(2) < 0 && abs(dis(2)) > 200
        disp("Moving drone more up");
        moveup(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif dis(1) > 0 && abs(dis(1)) > 200
        disp("Moving right");
        moveright(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif dis(1) < 0 && abs(dis(1)) > 200
        disp("Moving left");
        moveleft(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    end

    if count_go == 1
        break;
    end
end

turn(drone, deg2rad(-130));
count_go = 0;
count = 0;

% 3stage
moveforward(drone, 'Distance', 0.5, 'Speed', 0.3);
pause(1.0);

while 1
    frame = snapshot(cam);  % 카메라로부터 이미지 캡처
    img = double(frame);  % 이미지를 double 형으로 변환
    [R, C, X] = size(img);  % 이미지의 크기를 저장

    % 특정 색상 조건에 따라 이미지를 이진화
    img2 = zeros(R, C, X);
    for i = 1:R
        for j = 1:C
            if img(i, j, 1) - img(i, j, 2) > -5 || img(i, j, 1) - img(i, j, 3) > -5 || img(i, j, 2) - img(i, j, 3) > -40
                img2(i, j, :) = 255;
            else
                img2(i, j, :) = 0;
            end
        end
    end

    % 이진화된 이미지에서 원의 중심과 면적을 찾음
    circle_ring = img2 / 255;
    circle_ring_Gray = rgb2gray(circle_ring);
    circle_ring_bi = imbinarize(circle_ring_Gray);
    bi2 = imcomplement(circle_ring_bi);
    bw = bwareaopen(bi2, 8000);
    bw = imcomplement(bw);
    se = strel('disk', 10);
    bw2 = imclose(bw, se);
    bw3 = bwareaopen(bw2, 8000);
    [B, L] = bwboundaries(bw3, 'noholes');
    figure(1), imshow(bw3);
    axis on
    hold on

    % 원의 경계를 하얀색 선으로 그림
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:, 2), boundary(:, 1), 'w', 'LineWidth', 2);
    end

    % 원의 면적과 중심 좌표를 계산
    stats = regionprops(L, 'Area', 'Centroid');
    threshold = 0.7;
    for k = 1:length(B)
        boundary = B{k};
        delta_sq = diff(boundary).^2;
        perimeter = sum(sqrt(sum(delta_sq, 2)));
        area = stats(k).Area;
        metric = 4 * pi * area / perimeter^2;
        metric_string = sprintf('%2.2f', metric);

        if metric > threshold
            area_circle = stats(k).Area;
            centroid = stats(k).Centroid;
            plot(centroid(1), centroid(2), 'r');
        end

        text(boundary(1, 2) - 35, boundary(1, 1) + 13, metric_string, 'Color', 'r', ...
            'FontSize', 10, 'FontWeight', 'bold');
    end

    % 드론의 이동 결정
    dis = centroid - center;
    if (abs(dis(1)) < 40 && abs(dis(2)) < 40) || count == 4

        frame = snapshot(cam); % 색상 감지
        color_pixel = processImage_P(frame);
        if color_pixel > 200
            disp('find_purple')
        end

        % 드론을 앞으로 이동
        if 30000 <= area_circle && area_circle < 40000
            moveforward(drone, 'Distance', 1.8, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(-1);
        elseif 40000 <= area_circle && area_circle < 50000
            moveforward(drone, 'Distance', 1.7, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(0);
        elseif 50000 <= area_circle && area_circle < 60000
            moveforward(drone, 'Distance', 1.6, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(1);
        elseif 60000 <= area_circle && area_circle < 70000
            moveforward(drone, 'Distance', 1.5, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(2);
        elseif 70000 <= area_circle && area_circle < 85000
            moveforward(drone, 'Distance', 1.4, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(3);
        elseif 85000 <= area_circle && area_circle < 100000
            moveforward(drone, 'Distance', 1.2, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(4);
        elseif 100000 <= area_circle && area_circle < 130000
            moveforward(drone, 'Distance', 1.0, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(5);
        elseif 130000 <= area_circle
            moveforward(drone, 'Distance', 0.8, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(6);
        else
            moveforward(drone, 'Distance', 1.8, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(12);
        end

    elseif (abs(dis(1)) > 40 && abs(dis(1)) <= 200) || (abs(dis(2)) > 40 && abs(dis(2)) <=200)
        while 1
            if dis(1) > 0 && abs(dis(1)) > 40 && dis(2) < 40
                disp("Moving drone right");
                moveright(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) < 0 && abs(dis(1)) > 40 && dis(2) < 40
                disp("Moving drone left");
                moveleft(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif abs(dis(1)) < 40 && dis(2) > 0 && abs(dis(2)) > 40
                disp("Moving drone down");
                movedown(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif abs(dis(1)) < 40 && dis(2) < 0 && abs(dis(2)) > 40
                disp("Moving drone up");
                moveup(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) > 0 && abs(dis(1)) > 40
                disp("Moving right");
                moveright(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) < 0 && abs(dis(1)) > 40
                disp("Moving left");
                moveleft(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            end
        end


        % 드론이 원의 중심과 멀리 떨어져 있을 경우
    elseif dis(1) > 0 && abs(dis(1)) > 200 && dis(2) < 40
        disp("Moving drone more right");
        moveright(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif dis(1) < 0 && abs(dis(1)) > 200 && dis(2) < 40
        disp("Moving drone more left");
        moveleft(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif abs(dis(1)) < 40 && dis(2) > 0 && abs(dis(2)) > 200
        disp("Moving drone more down");
        movedown(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif abs(dis(1)) < 40 && dis(2) < 0 && abs(dis(2)) > 200
        disp("Moving drone more up");
        moveup(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif dis(1) > 0 && abs(dis(1)) > 200
        disp("Moving right");
        moveright(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif dis(1) < 0 && abs(dis(1)) > 200
        disp("Moving left");
        moveleft(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    end

    if count_go == 1
        break;
    end
end

turn(drone, deg2rad(215));
stage_pixel = 0;
count_go = 0;
count = 0;

% 4stage
moveforward(drone, 'Distance', 1.1, 'Speed', 0.7);

while 1
    frame = snapshot(cam);  % 카메라로부터 이미지 캡처
    img = double(frame);  % 이미지를 double 형으로 변환
    [R, C, X] = size(img);  % 이미지의 크기를 저장

    % 특정 색상 조건에 따라 이미지를 이진화
    img2 = zeros(R, C, X);
    for i = 1:R
        for j = 1:C
            if img(i, j, 1) - img(i, j, 2) > -5 || img(i, j, 1) - img(i, j, 3) > -5 || img(i, j, 2) - img(i, j, 3) > -40
                img2(i, j, :) = 255;
            else
                img2(i, j, :) = 0;
            end
        end
    end

    % 이진화된 이미지에서 원의 중심과 면적을 찾음
    circle_ring = img2 / 255;
    circle_ring_Gray = rgb2gray(circle_ring);
    circle_ring_bi = imbinarize(circle_ring_Gray);
    bi2 = imcomplement(circle_ring_bi);
    bw = bwareaopen(bi2, 8000);
    bw = imcomplement(bw);
    se = strel('disk', 10);
    bw2 = imclose(bw, se);
    bw3 = bwareaopen(bw2, 8000);
    [B, L] = bwboundaries(bw3, 'noholes');
    figure(1), imshow(bw3);
    axis on
    hold on

    % 원의 경계를 하얀색 선으로 그림
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:, 2), boundary(:, 1), 'w', 'LineWidth', 2);
    end

    % 원의 면적과 중심 좌표를 계산
    stats = regionprops(L, 'Area', 'Centroid');
    threshold = 0.7;
    for k = 1:length(B)
        boundary = B{k};
        delta_sq = diff(boundary).^2;
        perimeter = sum(sqrt(sum(delta_sq, 2)));
        area = stats(k).Area;
        metric = 4 * pi * area / perimeter^2;
        metric_string = sprintf('%2.2f', metric);

        if metric > threshold
            area_circle = stats(k).Area;
            centroid = stats(k).Centroid;
            plot(centroid(1), centroid(2), 'r');
        end

        text(boundary(1, 2) - 35, boundary(1, 1) + 13, metric_string, 'Color', 'r', ...
            'FontSize', 10, 'FontWeight', 'bold');
    end

    % 드론의 이동 결정
    dis = centroid - center;
    if (abs(dis(1)) < 33 && abs(dis(2)) < 33) || count == 4

        % 드론을 앞으로 이동
        if 30000 <= area_circle && area_circle < 40000
            moveforward(drone, 'Distance', 1.75, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(-1);
        elseif 40000 <= area_circle && area_circle < 50000
            moveforward(drone, 'Distance', 1.7, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(0);
        elseif 50000 <= area_circle && area_circle < 60000
            moveforward(drone, 'Distance', 1.65, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(1);
        elseif 60000 <= area_circle && area_circle < 70000
            moveforward(drone, 'Distance', 1.6, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(2);
        elseif 70000 <= area_circle && area_circle < 85000
            moveforward(drone, 'Distance', 1.55, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(3);
        elseif 85000 <= area_circle && area_circle < 100000
            moveforward(drone, 'Distance', 1.5, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(4);
        elseif 100000 <= area_circle && area_circle < 130000
            moveforward(drone, 'Distance', 1.4, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(5);
        elseif 130000 <= area_circle && area_circle < 160000
            moveforward(drone, 'Distance', 1.3, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(6);
        elseif 160000 <= area_circle && area_circle < 200000
            moveforward(drone, 'Distance', 1.2, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(7);
        elseif 200000 <= area_circle
            moveforward(drone, 'Distance', 1.1, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(8);
        else
            moveforward(drone, 'Distance', 1.8, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(12);
        end

    elseif (abs(dis(1)) > 33 && abs(dis(1)) <= 200) || (abs(dis(2)) > 33 && abs(dis(2)) <=200)
        while 1
            if dis(1) > 0 && abs(dis(1)) > 33 && dis(2) < 33
                disp("Moving drone right");
                moveright(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) < 0 && abs(dis(1)) > 33 && dis(2) < 33
                disp("Moving drone left");
                moveleft(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif abs(dis(1)) < 33 && dis(2) > 0 && abs(dis(2)) > 33
                disp("Moving drone down");
                movedown(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif abs(dis(1)) < 33 && dis(2) < 0 && abs(dis(2)) > 33
                disp("Moving drone up");
                moveup(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) > 0 && abs(dis(1)) > 33
                disp("Moving right");
                moveright(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            elseif dis(1) < 0 && abs(dis(1)) > 33
                disp("Moving left");
                moveleft(drone, 'Distance', 0.2, 'Speed', 0.2);
                count = count + 1;
                pause(1.0);
                break;
            end
        end


        % 드론이 원의 중심과 멀리 떨어져 있을 경우
    elseif dis(1) > 0 && abs(dis(1)) > 200 && dis(2) < 33
        disp("Moving drone more right");
        moveright(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif dis(1) < 0 && abs(dis(1)) > 200 && dis(2) < 33
        disp("Moving drone more left");
        moveleft(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif abs(dis(1)) < 33 && dis(2) > 0 && abs(dis(2)) > 200
        disp("Moving drone more down");
        movedown(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif abs(dis(1)) < 33 && dis(2) < 0 && abs(dis(2)) > 200
        disp("Moving drone more up");
        moveup(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif dis(1) > 0 && abs(dis(1)) > 200
        disp("Moving right");
        moveright(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    elseif dis(1) < 0 && abs(dis(1)) > 200
        disp("Moving left");
        moveleft(drone, 'Distance', 0.4, 'Speed', 0.3);
        pause(1.0);
    end

    if count_go == 1
        break;
    end
end
frame = snapshot(cam);
colorcenter = processImage_R_a(frame);
dis_c = colorcenter - center;
count_a = 0;
while abs(dis_c(1)) > 30
    frame = snapshot(cam);
    colorcenter = processImage_R_a(frame);
    dis_c = colorcenter - center;
    if dis_c(1)>0
        turn(drone, deg2rad(5));
        count_a = count_a + 1;
    else
        turn(drone, deg2rad(-5));
        count_a = count_a - 1;
    end
end
disp('find');
moveforward(drone, 'Distance', 1, 'Speed', 0.8);
pause(1.0);
count_go = 0;
land(drone);

% 4 stage 빨간색 이미지 처리 함수
function [centerX, centerY] = processImage_R_a(frame)

% 이미지 읽기
img = double(frame);
[R, C, X] = size(img);
img3 = zeros(R, C, X);  % img3 변수를 초기화

% 빨간색 픽셀의 개수를 초기화
redPixelCount = 0;

% 빨간색 픽셀의 좌표를 저장할 배열
redPixels = [];

for i = 1:R
    for j = 1:C
        % 빨간색이 아닌 색들을 제거하기 위한 조건
        if img(i,j,1) - img(i,j,2) >= 55 && img(i,j,1) - img(i,j,3) >= 10 && img(i,j,2) - img(i,j,3) <= 30
            % 빨간색으로 판단되는 경우
            img3(i, j, 1) = 255;
            img3(i, j, 2) = 0;
            img3(i, j, 3) = 0;
            redPixelCount = redPixelCount + 1;
            redPixels = [redPixels; [i, j]];
        else
            img3(i, j, 1) = 0;
            img3(i, j, 2) = 0;
            img3(i, j, 3) = 0;
        end
    end
end

% 빨간색 픽셀의 중심 좌표 계산
if redPixelCount > 0
    centerX = mean(redPixels(:, 2));
    centerY = mean(redPixels(:, 1));
else
    centerX = NaN;
    centerY = NaN;
    disp('빨간색 네모를 찾을 수 없습니다.');
end

% 결과 시각화
figure;
imshow(uint8(img3));
hold on;
if ~isnan(centerX) && ~isnan(centerY)
    plot(centerX, centerY, 'g+', 'MarkerSize', 30, 'LineWidth', 2);
    title('빨간색 네모의 중심 좌표');
end
hold off;

% 중심 좌표 출력
fprintf('빨간색 네모의 중심 좌표: (%.2f, %.2f)\n', centerX, centerY);

end

function color_pixel = processImage_R(frame)
img = double(frame);
[R, C, X] = size(img);
img3 = zeros(R, C, X);  % img3 변수를 초기화

color_pixel = 0;  % stage_pixel을 초기화

for i = 1:R
    for j = 1:C
        % 빨간색이 아닌 색들을 제거하기 위한 조건
        if img(i,j,1) - img(i,j,2) >= 55 && img(i,j,1) - img(i,j,3) >= 10 && img(i,j,2) - img(i,j,3) <= 30
            % 빨간색으로 판단되는 경우
            img3(i, j, 1) = 255;
            img3(i, j, 2) = 0;
            img3(i, j, 3) = 0;
            color_pixel = color_pixel + 1;  % 빨간색 픽셀의 개수를 증가
        else
            img3(i, j, 1) = 0;
            img3(i, j, 2) = 0;
            img3(i, j, 3) = 0;
        end
    end
end
end

function color_pixel = processImage_G(frame)
img = double(frame);
[R, C, X] = size(img);
img3 = zeros(R, C, X);  % img3 변수를 초기화

color_pixel = 0;  % stage_pixel을 초기화

for i = 1:R
    for j = 1:C
        % 초록색이 아닌 색들을 제거하기 위한 조건
        if img(i,j,1) - img(i,j,2) <= 25 && img(i,j,1) - img(i,j,3) <= 5 && img(i,j,2) - img(i,j,3) >= 17
            % 초록색으로 판단되는 경우
            img3(i, j, 1) = 0;
            img3(i, j, 2) = 255;
            img3(i, j, 3) = 0;
            color_pixel = color_pixel + 1;
        else
            img3(i, j, 1) = 0;
            img3(i, j, 2) = 0;
            img3(i, j, 3) = 0;
        end
    end
end
end

function color_pixel = processImage_P(frame)
img = double(frame);
[R, C, X] = size(img);
img3 = zeros(R, C, X);  % img3 변수를 초기화

color_pixel = 0;  % stage_pixel을 초기화

for i = 1:R
    for j = 1:C
        % 보라색이 아닌 색들을 제거하기 위한 조건
        if img(i,j,1) - img(i,j,2) < 11 && img(i,j,1) - img(i,j,3) > 0 && img(i,j,2) - img(i,j,3) > 20
            % 보라색으로 판단되는 경우
            img3(i, j, 1) = 255;
            img3(i, j, 2) = 0;
            img3(i, j, 3) = 255;
            color_pixel = color_pixel + 1;  % 보라색 픽셀의 개수를 증가
        else
            img3(i, j, 1) = 0;
            img3(i, j, 2) = 0;
            img3(i, j, 3) = 0;
        end
    end
end
end
