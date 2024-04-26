% 현재 날짜와 시간 입력 받기
currentYear = input('현재 연도를 입력하세요: ');
currentMonth = input('현재 월을 입력하세요: ');
currentDay = input('현재 일을 입력하세요: ');
currentHour = input('현재 시간을 입력하세요: ');

% 시간 단위의 숫자 입력 받기
hoursToAdd = input('추가할 시간을 입력하세요: ');

current = datetime(currentYear, currentMonth, currentDay, currentHour, 0, 0);
% 입력된 현재 날짜와 시각
newDateTime = datetime(currentYear, currentMonth, currentDay, currentHour, 0, 0) + hours(hoursToAdd);
% 입력된 현재 시각과 숫자의 시간을 이용하여 날짜와 시간 계산
