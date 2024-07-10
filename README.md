1차 워크샵 과제
1. 사용자로부터 현재 날짜와 시간을 입력 받습니다.
2. 시간 단위의 숫자를 입력 받습니다.
3. 입력된 현재 시각과 숫자의 시간을 이용하여 날짜와 시간을 계산한 값 반환.
ex) 현재 시간이 '2024년 4월 19일 15시'이고 사용자가 50시간 후의 시간을 알고 싶어한다면
프로그램은 '2024년 4월 21일 17시'를 출력(24시간 형식, 윤달 무시)

2차 워크샵 과제

1. 주어진 사다리꼴 경로로 드론제어
2. 1.roll제어, 2.yaw제어, 3.pitch제어, 4.yaw제어, 5.pitch제어, 6.사진촬영, 7.yaw제어, 8.roll제어 위 순으로 경로에 따라 드론제어
3. 드론 제어 모습 촬영한 동영상, 드론이 촬용한 사진, 드론제어코드 제출

3차 워크샵 과제

1. 과제 이미지에서 사각형의 중점 좌표 찾기
2. 5의 오차는 정답으로 인정, 부분 점수 있음
3. 3차과제.m의 코드를 돌렸을 때 나오는 좌표값과 팀명 등을 README.md에 작성



목차
===

이번 2024 미니 드론 대회에 대한 설명의 순서는 다음과 같다.

1. 대회 사전 규격 및 조건
2. 대회 진행 전략
3. 알고리즘 설명
4. 소스 코드 설명


대회 사전 규격 및 조건
===========
## 대회에 사용한 Toolbox
이번 대회에서 사용한 toolbox는 아래와 같고 대회에서 사용한 matlab 버전은 2023b로 사전 연습하였다. 

```
        (사용한 tool box)
```

## 대회에서 주어진 조건
먼저 대회에서 공지된 대회장의 규격은 아래 사진과 같다.   
![image](https://github.com/kjsik/example/assets/127501452/19491a7a-fdfa-45b1-accb-1faa6ad641eb)


또한 가림막의 링 크기는 각각   
1차 링 크기 : 57cm,   
2차 링 크기 : 46cm,    
3차 링 크기 : 46cm,   
4차 링 크기 : 52cm 이다.    
또한 가림막 링의 중심점의 높이는 80~100cm이다. 

아래 사진은 위의 사진과 유사한 규격의 연습장을 실제로 구성하여 진행한 사진이다.

<img src="https://github.com/kjsik/example/assets/127501452/7d5ce1ac-8648-4be4-96f9-0b12d2f79f32" alt="image" width="300"/>
     
    
    
    
stage 별로 구성을 설명하면 다음과 같다. 
+ 1st stage
	+ START 지점에서 이륙 후 1.6m 거리의 1차 가림막과 링, 그리고 붉은 색을 확인하고 링을 통과하여 이동 후, 우측 방향으로 120~140도 회전
+ 2nd stage
	+ 5.1m 거리의 2차 가림막과 링, 그리고 녹색을 확인하고 이동 후, 링을 통과하지 않고 좌측 방향으로 120~140도 회전
+ 3rd stage
	+ 2.7m 거리의 3차 가림막과 링, 그리고 보락색을 확인하고 이동 후, 링을 통과하지 않고 우측 방향으로 200~230도 회전
+ 4th stage
	+ 3.85m 거리의 4차 가림막과 링, 그리고 붉은 색을 확인하고 링을 통과하여 이동 후, 지름 20cm의 FINISH 지점에 착륙하도록 구성



대회 진행 전략
===========
위에서 설명한 대회 조건 및 규격에 따라 각 stage마다 전략을 달리하여 코드를 수정하였다. 

먼저 stage에서 공통적인 전략을 살펴보면 다음과 같다.

## 최적화된 원의 면적 계산 및 중심 인식
### 원의 면적

<img src="https://github.com/kjsik/example/assets/127501452/3e47641b-0252-410d-ad02-16c0b8498c2f" alt="image" width="300"/>      

[1번 case가 실행된 경우의 사진]   

<img src="https://github.com/kjsik/example/assets/127501452/a1ffe840-41a8-4039-8328-1befb30d0a20" alt="image" width="300"/>     

[4번 case가 실행된 경우의 사진] 

   
반복적인 주행 연습 결과, 드론이 원의 이미지를 찍었을 때, 적절한 가림막의 원이 존재하는 적정 거리가 존재한다. 이는 드론이 측정한 원의 면적이 작을 수록, 드론은 원으로부터 멀리 떨어져 있고 반대로 원의 면적이 클수록, 드론이 원으로부터 가까이 존재하는 것을 의미한다.   
즉, 측정된 원의 면적에 따라 드론이 원에 가까이 가기 위해서는 앞으로 이동하는 거리가 달라져야한다. 이를 반복적인 과정을 통해 10개의 case로 구분하였다.


### 원의 중심

<img src="https://github.com/kjsik/example/assets/127501452/3e47641b-0252-410d-ad02-16c0b8498c2f" alt="image" width="400"/>    

[(480,200)에 중점이 존재하는 경우]   


위의 면적 사진을 통해 드론이 찍은 이미지를 hold on axis를 통해 확인하면 가로축은 0 부터 960, 세로축은 0부터 720 인것 을 확인할 수 있다. 드론이 찍은 이미지대로라면 원의 중심은 480, 360 일 것이다.    
그러나 실제로는 그렇지 않다. 드론이 바라보는 방향이 정중앙이 아니기 때문에, 반복적인 주행을 통해 200으로 조정하였다.


### 최적화된 색깔 인식
   
(붉은 색 사진), (초록색 사진)   

코드의 가독성을 높이기 위해 붉은색, 녹색, 보라색을 인식하는 사용자 정의 함수를 정의하였다. ```processImage_R```, ```processImage_G```,```processImeage_P``` 함수를 설정하는 과정에서 가장 중요한 것은 색상의 RGB의 조건을 정확하게 하는 것이었다.    
우리가 선택한 RGB 구별 방식은 이미지의 R과 G, R과 B, G와 B의 값을 비교하여 어떤 값이 더 큰지, 즉 어느 값이 이미지에서 더 강하게 나타나는지를 비교하는 방식이었다. 이미지를 찍고 RGB를 비교하는 반복적인 과정을 통해 조건의 임계값을 찾았고 이를 토대로 조건을 선택하였다.

### 드론 객체의 안정성 유지
   
아래의 코드 설명에서 확인할 수 있겠지만 드론이 움직인 다음에 ```puase(1.0)```이 포함되어있는 것을 확인할 수 있을 것이다. 이는 드론이 움직인 후에, 관성과 가속력으로 인해 더 나아가는 것을 방지하기 위해 작성하였다.   
    
이와 마찬가지 이유로 속도값도 조정하였다. 반복적인 과정을 통해 확인한 결과, 0.8을 넘어가면 확률적으로 예상한 결과와의 오차가 더 자주, 크게 발생하였다.


### 수학적인 각도 분석


   
위에서 언급한 것과 같이 stage마다 진행 방식이 다르기 때문에, stage별로 다른 전략도 존재한다.   
   
+ 1 stage
  - 원의 중심을 올바르게 인식하기 위하여 첫 이륙 후, 드론을 대각선(x축, z축)으로 이동   
  - 중점을 찾고 상하좌우 조정 후에 색 인식   
  - 원을 통과하여 색 앞으로 이동 후 회전   

+ 2 stage
  - 주어진 각도만큼 회전 후, 원의 중심과 색을 인식하기 위해 적절한 거리만큼 앞으로 이동   
  - 중점을 찾고 상하좌우 조정 후에 색 인식   
  - 가림막 앞으로 이동 후 회전


+ 3 stage
  - 원의 중심과 색을 인식하기 위해 적절한 거리만큼 앞으로 이동   
  - 중점을 찾고 상하좌우 조정 후에 색 인식   
  - 가림막 앞으로 이동 후에 회전

+ 4 stage
  - 원의 중심과 색을 인식하기 위해 적절한 거리만큼 앞으로 이동
  - 원의 중심을 인식하고 가림막의 앞까지 이동
  - 색을 인식하고 색의 중심으로 각도를 회전
  - 적절한 거리 이동 후 착륙



알고리즘 설명
==========
(전체 순서도)


## 1st stage   
(1st stage 순서도)


## 2nd stage
(2nd stage 순서도)


## 3rd stage
(3rd stage 순서도)


## 4th stage
(4th stage 순서도)



소스 코드 설명
===========
```
%메인문 

count_go = 0;  % 전진한 횟수를 세주는 변수
area_circle = 0;  % 각 스테이지 별 원의 면적
center = [480, 200];  % 기준 중심 위치
centroid = zeros(size(center));  % 원의 중심 좌표를 저장할 변수
count = 0; % 상하좌우 전진 횟수
color_pixel = 0; % 색 감지 변수

drone = ryze();  % 드론 객체 선언
cam = camera(drone);  % 드론의 카메라 객체 선언
takeoff(drone);  % 드론 이륙
```   
변수를 초기화하고 드론 객체와 카메라 객체를 선언하였고, 위에서 언급한 것처럼 기준 중심의 위치를 480,200으로 선언하였다.   

```
move(drone, [-0.3 0 -0.3],"Speed",0.2); % 드론 x방향 z방향으로 -만큼 이동
pause(1.0);
```   
드론이 이륙한 자리에서 이미지를 인식하고 원을 정확하게 인식허기 어렵다. 따라서 위로 올라가는 과정과 뒤로 가는 과정을 조금 더 시간적으로 줄이기 위해 대각선으로 움직이도록 하였다.   

#### 가림막 인식
```
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
```
  
드론이 이미지를 찍고 이중 반복 과정을 통해 RGB 조건에 해당하는 픽셀은 흰색으로, 해당하지 않으면 흰색으로 바꾸는 과정이다.    
이는 푸른색 가림막을 인식하고 푸른색 부분은 흰색으로 나머지 부분은 검정색으로 변환하여 저장한다.
   
#### 원의 중심과 면적
```
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
    % 원의 중심 좌표 찾는 과정 출력
    axis on
    hold on

    % 원의 경계를 하얀색 선으로 그림
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:, 2), boundary(:, 1), 'w', 'LineWidth', 2);
    end
```

먼저 이미지를 0과 255 사이의 값을 0과 1로 정규화하고, 그레이 스케일로 바꾼다. 이를 다시 이진화하여 보수하는 과정을 거쳐서 픽셀이 8000이하의 작은 객체는 제거하고 남은 객체의 경계선을 찾는다.
   

```
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
```

원의 둘레와 면적을 계산하고 이를 바탕으로 원형 지표를 구하여 임계값보다 큰 경우, 이를 붉은 색 텍스트로 중심 좌표로 표시한다. 


   
(이를 바탕으로 나오는 이미지)   


#### 드론 이동
```

    % 드론의 이동 결정
    dis = centroid - center;
    if (abs(dis(1)) < 33 && abs(dis(2)) < 33) || count == 4

        frame = snapshot(cam); % 색상 감지
        color_pixel = processImage_R(frame);
        if color_pixel > 150
            disp('find_red')
        end

```

코드 초반에 선언한 전역 변수 값과 위에서 구한 구한 중심과의 차이가 33보다 작은 경우, 붉은 색의 픽셀을 반환하는 사용자 정의 함수를 실행시키고 반환 받은 값이 150보다 크다면 색을 인식하였다고 판단한다.    


```

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
            count_go = 1;
            pause(1.0);
            disp(7);
        else
            moveforward(drone, 'Distance', 3.85, 'Speed', 0.7);
            count_go = 1;
            pause(1.0);
            disp(12);
        end

```
   
   
위에서 언급한 것처럼 드론이 인식한 원의 면적에 따라 가림막과 드론 사이의 거리가 다르기 때문에, 조건문을 통해 드론이 가야하는 거리를 다르게 설정하였다. 드론이 앞으로 이동한 경우, ```count_go```변수를 1로 초기화하였고 이는 앞으로 간 것을 판단하는 변수이다.
   
   
   
```
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

```   






```

% 2stage


    % 드론의 이동 결정
    dis = centroid - center;
    if (abs(dis(1)) < 40 && abs(dis(2)) < 40) || count == 4

        frame = snapshot(cam); % 색상 감지
        color_pixel = processImage_G(frame);
        if color_pixel > 200
            disp('find_green')
        end

```

```

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

```

```

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
```

```

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

```

```

% 3stage
moveforward(drone, 'Distance', 0.5, 'Speed', 0.3);
pause(1.0);

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
figure(2);
imshow(img3);
disp(color_pixel);
end

function color_pixel = processImage_G(frame)
img = double(frame);
[R, C, X] = size(img);
img3 = zeros(R, C, X);  % img3 변수를 초기화

color_pixel = 0;  % stage_pixel을 초기화

for i = 1:R
    for j = 1:C
        % 초록색이 아닌 색들을 제거하기 위한 조건
        if img(i,j,1) - img(i,j,2) <= 25 && img(i,j,1) - img(i,j,3) <= 5 && img(i,j,2) - img(i,j,3) >= 17 %조건이 애매하다
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
figure(3);
imshow(img3);
disp(color_pixel);
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
figure(4);
imshow(img3);
disp(color_pixel);
end
```