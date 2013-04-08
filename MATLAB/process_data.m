function [ x ] = process_data( mx, matrix_name )

    t_start   = mx(1,5)  * 3600 + mx(1,6) * 60 + mx(1,7);
    t_conv    = (mx(:,5) * 3600 + mx(:,6) * 60 + mx(:,7)) - t_start;
    t_start_s = mx(1,2)  * 3600 + mx(1,3) * 60 + mx(1,4);
    t_conv_s  = (mx(:,2) * 3600 + mx(:,3) * 60 + mx(:,4)) - t_start_s;

    % compute intervals
    j     = 1;
    t_int = 0;

    bitrate(j) = 0;
    delay(j)   = 0;
    jitter(j)  = 0;
    pktloss(j) = 0;


    for i = 1:length(mx)

        % EITHER
        if (t_conv(i) - t_int >= 1)
            j          = j + 1;
            t_int      = t_conv(i);
            bitrate(j) = mx(i,8);
            delay(j)   = t_conv(i) - t_conv_s(i);

            if (i > 1)
                pktloss(j) = mx(i,1) - mx(i-1,1) - 1;
                jitter(j)  = t_conv(i) - t_conv(i-1);
            end

        % OR
        else

            bitrate(j) = bitrate(j) + mx(i,8);
            delay(j)   = mean([delay(j) (t_conv(i) - t_conv_s(i))]);

            if (i > 1)
                pktloss(j) = pktloss(j) + mx(i,1) - mx(i-1,1) - 1;
                jitter(j)  = mean([jitter(j) (t_conv(i) - t_conv(i-1))]);
            end
        end
    end

    %x = [bitrate'];
    x = [bitrate' delay' jitter' pktloss'];

    % Throughput
    subplot (3, 2, 1);
    bitrate_u = bitrate ./ 125;
    plot(0:j-2, bitrate_u(1:j-1),'-');
    title('Throughput');
    xlabel('time [s]');
    ylabel('[Kbps]');
    axis([0 max(t_conv) 0 round(max(bitrate_u))+1]);
    grid on
    %hold on;

    % Delay
    subplot (3, 2, 2);
    plot(0:length(delay)-1, delay,'-');
    title('Delay');
    xlabel('time [s]');
    ylabel('[ms]');
    axis([0 max(t_conv) min(delay)-0.00001 max(delay)]);
    grid on
    %hold on;

    % Jitter
    subplot (3, 2, 3);
    plot(0:length(jitter)-1, jitter,'-');
    title('Jitter');
    xlabel('time [s]');
    ylabel('[ms]');
    axis([0 max(t_conv) min(jitter)-0.00001 max(jitter)+0.00001]);
    grid on

    % Packet loss
    subplot (3, 2, 4);
    plot(0:length(pktloss)-1, pktloss,'-');
    title('Packet loss');
    xlabel('time [s]');
    ylabel('[pps]');
    axis([0 max(t_conv) 0 round(max(pktloss))+1]);
    grid on

    % IDT distribution
    subplot (3, 2, 5);
    d = diff(t_conv);
    m = max(d);
    hist(d);
    title('Inter-departure time Distribution');
    xlabel('time [s]');
    ylabel('Empirical PDF');
    %axis([0 max([1 m]) 0 1]);
    grid on

    % PS distribution
    subplot (3, 2, 6);
    hist(mx(:,8));
    title('Packet size Distribution');
    xlabel('[bytes]');
    ylabel('Empirical PDF');
    grid on


end
