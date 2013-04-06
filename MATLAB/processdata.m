function [ x ] = processdata( matrix )

    t_start = matrix(1,5)*3600+matrix(1,6)*60+matrix(1,7);
    t_conv = (matrix(:,5)*3600+matrix(:,6)*60+matrix(:,7)) - t_start;
    t_start_s = matrix(1,2)*3600+matrix(1,3)*60+matrix(1,4);
    t_conv_s = (matrix(:,2)*3600+matrix(:,3)*60+matrix(:,4)) - t_start_s;

    % compute intervals
    j = 1;
    t_int = 0;
    rate(j) = 0;
    delay(j) = 0;
    jitter(j) = 0;
    pktloss(j) = 0;

    for i = 1:length(matrix)
        if (t_conv(i) - t_int >= 1)
            j=j+1;
            t_int = t_conv(i);
            rate(j) = matrix(i,8);
            delay(j) = t_conv(i) - t_conv_s(i);
            if (i > 1)
                pktloss(j) = matrix(i,1) - matrix(i-1,1) - 1;
                jitter(j) = t_conv(i) - t_conv(i-1);
            end
        else
            rate(j) = rate(j) + matrix(i,8);
            delay(j) = mean([delay(j) (t_conv(i) - t_conv_s(i))]);

            if (i > 1)
                pktloss(j) = pktloss(j) + matrix(i,1) - matrix(i-1,1) - 1;
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
    grid on
    %hold on;

    % Delay
    subplot (4, 2, 2);
    plot(0:length(delay)-1, delay,'-');
    title('Delay');
    xlabel('time [s]');
    ylabel('[ms]');
    axis([0 max(t_conv) min(delay)-0.00001 max(delay)]);
    grid on
    %hold on;

    % Jitter
    subplot (4, 2, 3);
    plot(0:length(jitter)-1, jitter,'-');
    title('Jitter');
    xlabel('time [s]');
    ylabel('[ms]');
    axis([0 max(t_conv) min(jitter)-0.00001 max(jitter)+0.00001]);
    grid on

    % Packet loss
    subplot (4, 2, 4);
    plot(0:length(pktloss)-1, pktloss,'-');
    title('Packet loss');
    xlabel('time [s]');
    ylabel('[pps]');
    axis([0 max(t_conv) 0 round(max(pktloss))+1]);
    grid on

    % IDT distribution
    subplot (4, 2, 5);
    d = diff(t_conv);
    m = max(d);
    hist(d);
    title('Inter-departure time Distribution');
    xlabel('time [s]');
    ylabel('Empirical PDF');
    %axis([0 max([1 m]) 0 1]);
    grid on

    % PS distribution
    subplot (4, 2, 6);
    hist(matrix(:,8));
    title('Packet size Distribution');
    xlabel('[bytes]');
    ylabel('Empirical PDF');
    grid on

    %errorbar
    subplot (4, 2, 7);
    %errorbar();
    title('errorbar');
    xlabel('xlabel');
    ylabel('ylabel');
    grid on

    %dummy
    subplot (4, 2, 8);

end
