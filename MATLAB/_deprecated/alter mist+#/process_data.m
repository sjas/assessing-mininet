function [ x ] = process_data( mx, matrix_name )

    t_start   = mx(1,5)  * 3600 + mx(1,6) * 60 + mx(1,7);
    t_conv    = (mx(:,5) * 3600 + mx(:,6) * 60 + mx(:,7)) - t_start;
    t_start_s = mx(1,2)  * 3600 + mx(1,3) * 60 + mx(1,4);
    t_conv_s  = (mx(:,2) * 3600 + mx(:,3) * 60 + mx(:,4)) - t_start_s;

    % compute intervals
    jj     = 1;
    t_int = 0;

    bitrate(jj) = 0;
    delay(jj)   = 0;
    jitter(jj)  = 0;
    pktloss(jj) = 0;


    for ii = 1:length(mx)

        % EITHER
        if (t_conv(ii) - t_int >= 1)
            jj          = jj + 1;
            t_int       = t_conv(ii);
            bitrate(jj) = mx(ii,8);
            delay(jj)   = t_conv(ii) - t_conv_s(ii);

            if (ii > 1)
                pktloss(jj) = mx(ii,1) - mx(ii-1,1) - 1;
                jitter(jj)  = t_conv(ii) - t_conv(ii-1);
            end

        % OR
        else

            bitrate(jj) = bitrate(jj) + mx(ii,8);
            delay(jj)   = mean([delay(jj) (t_conv(ii) - t_conv_s(ii))]);

            if (ii > 1)
                pktloss(jj) = pktloss(jj) + mx(ii,1) - mx(ii-1,1) - 1;
                jitter(jj)  = mean([jitter(jj) (t_conv(ii) - t_conv(ii-1))]);
            end
        end
    end

    %x = [bitrate'];
    x = [bitrate' delay' jitter' pktloss'];

    % Throughput
    subplot (3, 2, 1);
    bitrate_u = bitrate ./ 125;
    plot(0:jj-2, bitrate_u(1:jj-1),'-');
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
    %axis([0 max(t_conv) 0 round(max(pktloss))+1]);
    axis([ sort([0,max(t_conv)])  sort([round(max(pktloss))+1 0])]);
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
