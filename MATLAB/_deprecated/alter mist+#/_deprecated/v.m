function [ x ] = v( test )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

	t_start = test(1,5)*3600+test(1,6)*60+test(1,7);
	t_conv = (test(:,5)*3600+test(:,6)*60+test(:,7)) - t_start;
	t_start_s = test(1,2)*3600+test(1,3)*60+test(1,4);
	t_conv_s = (test(:,2)*3600+test(:,3)*60+test(:,4)) - t_start_s;

	% compute intervals
	j = 1;
	t_int = 0;
	rate(j) = 0;
	delay(j) = 0;
	jitter(j) = 0;
	pktloss(j) = 0;
    
	for i = 1:length(test)
		if (t_conv(i) - t_int >= 1)
            j=j+1;
			t_int = t_conv(i);
			rate(j) = test(i,8);
			delay(j) = t_conv(i) - t_conv_s(i);
            if (i > 1)
				pktloss(j) = test(i,1) - test(i-1,1) - 1;
				jitter(j) = t_conv(i) - t_conv(i-1);
            end
		else
			rate(j) = rate(j) + test(i,8);
			delay(j) = mean([delay(j) (t_conv(i) - t_conv_s(i))]);
			
            if (i > 1)
				pktloss(j) = pktloss(j) + test(i,1) - test(i-1,1) - 1;
				jitter(j) = mean([jitter(j) (t_conv(i) - t_conv(i-1))]);
            end
        end
    end
    
    x=[rate' delay' jitter' pktloss'];
 
	% Throughput
	subplot (4, 2, 1);
	rate_u = rate ./ 125;
	plot(0:j-2, rate_u(1:j-1),'-');
	title('Throughput');
	xlabel('time [s]');
	ylabel('[Kbps]');
	axis([0 max(t_conv) 0 round(max(rate_u))+1]);
    %hold on;

	% Delay
	subplot (4, 2, 2);
	plot(0:length(delay)-1, delay,'-');
	title('Delay');
	xlabel('time [s]');
	ylabel('[ms]');
	axis([0 max(t_conv) min(delay)-0.00001 max(delay)]);
    %hold on;
    
	% Jitter
	subplot (4, 2, 3);
	plot(0:length(jitter)-1, jitter,'-');
	title('Jitter');
	xlabel('time [s]');
	ylabel('[ms]');
	axis([0 max(t_conv) min(jitter)-0.00001 max(jitter)+0.00001]);
    
	% Packet loss
	subplot (4, 2, 4);
	plot(0:length(pktloss)-1, pktloss,'-');
	title('Packet loss');
	xlabel('time [s]');
	ylabel('[pps]');
	axis([0 max(t_conv) 0 round(max(pktloss))+1]);
    
	% IDT distribution
	subplot (4, 2, 5);
	d = diff(t_conv);
	m = max(d);
	hist(d);
	title('Inter-departure time Distribution');
	xlabel('time [s]');
	ylabel('Empirical PDF');
	%axis([0 max([1 m]) 0 1]);
    
	% PS distribution
	subplot (4, 2, 6);
	hist(test(:,8));
	title('Packet size Distribution');
	xlabel('[bytes]');
	ylabel('Empirical PDF');
    
    %errorbar
    subplot (4, 2, 7);
    %errorbar();
	title('errorbar');
	xlabel('xlabel');
	ylabel('ylabel');vnc
    
    %dummy
    subplot (4, 2, 8);
    
end

