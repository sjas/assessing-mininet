% D-ITG reporting script: packets timeseries
%
% Thi script assumes that ITGDec generates its output in /tmp/test.dat

while true ;
        load /tmp/test.dat

        t_start = test(1,5)*3600+test(1,6)*60+test(1,7);
        t_conv = (test(:,5)*3600+test(:,6)*60+test(:,7)) - t_start;

        % Packets
        bar(t_conv, test(:,8));
        title("Packets");
        xlabel("time [s]");
        ylabel("Packet Size [bytes]");
        axis([0 max(t_conv)]);

	% Update interval
	pause(5);
endwhile

