current_date = input('현재 날짜 및 시간을 입력하세요 :');
current_time = input('현재 시간을 입력하세요 :');
plustime = input ('추가 시간을 입력하세요 :');
t = datetime([current_date, current_time, 00, 00]);
ptime = hours(plustime);
A = t + ptime;
disp(['현재시간은 ',datestr(t), '입니다.'])
disp(['나중시간은 ', datestr(A), '입니다.'])