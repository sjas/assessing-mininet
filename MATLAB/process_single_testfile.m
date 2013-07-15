function [ return_matrix ] = process_single_testfile( mx, matrix_name, log_type, current_picture_file_name, output_format )
%%% THIS FILE CONTAINS THE CODE HANDED OVER BY THE ITG DEVELOPERS.
%%% It generates the data for the single overviews, only minor changes
%%% occured here.

    t_start   = mx(1,5)  * 3600 + mx(1,6) * 60 + mx(1,7);
    t_conv    = (mx(:,5) * 3600 + mx(:,6) * 60 + mx(:,7)) - t_start;
    t_start_s = mx(1,2)  * 3600 + mx(1,3) * 60 + mx(1,4);
    t_conv_s  = (mx(:,2) * 3600 + mx(:,3) * 60 + mx(:,4)) - t_start_s;

    % compute intervals
    jj    = 1;
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
            %% CHANGED: ./125000 to convert scalar from Kbyte to Mbit
            bitrate(jj) = bitrate(jj) + mx(ii,8);
            delay(jj)   = mean([delay(jj) (t_conv(ii) - t_conv_s(ii))]);

            if (ii > 1)
                pktloss(jj) = pktloss(jj) + mx(ii,1) - mx(ii-1,1) - 1;
                jitter(jj)  = mean([jitter(jj) (t_conv(ii) - t_conv(ii-1))]);
            end
        end
    end
    
    
    %% CHANGED: ./125000 to convert scalar from Kbyte to Mbit
    bitrate = bitrate ./ 125000;
           
    %% CHANGED: output gathered for aggregation later on
    %return_matrix = [bitrate'];
    return_matrix = [bitrate' delay' jitter' pktloss'];

    %% THROUGHPUT
    subplot (2, 2, 1);
    bitrate_u = bitrate;
    plot(0:jj-2, bitrate_u(1:jj-1),'-');
    title('Throughput');
    xlabel('time [s]');
    ylabel('[Mbps]');
    axis([0 max(t_conv) 0 round(max(bitrate_u)*1.125)]);
    grid on;
    %hold on;

    %% DELAY
    subplot (2, 2, 2);
    plot(0:length(delay)-1, delay,'-');
    title('Delay');
    xlabel('time [s]');
    ylabel('[ms]');
    axis([0 max(t_conv) min(delay)-0.00001 max(delay)]);
    grid on;
    %hold on;

    %% JITTER
    subplot (2, 2, 3);
    plot(0:length(jitter)-1, jitter,'-');
    title('Jitter');
    xlabel('time [s]');
    ylabel('[ms]');
    axis([0 max(t_conv) min(jitter)-max(jitter)*1.125 max(jitter)*1.125]);
    grid on;

%     %% PACKETLOSS
%     subplot (3, 2, 4);
%     plot(0:length(pktloss)-1, pktloss,'-');
%     title('Packet loss');
%     xlabel('time [s]');
%     ylabel('[pps]');
%     %axis([0 max(t_conv) 0 round(max(pktloss))+1]);
%     axis([ sort([0,max(t_conv)])  sort([round(max(pktloss))+1 0])]);
%     grid on;

    %% INTER DEPARTURE TIME DISTRIBUTION
%     subplot (3, 2, 5);
    subplot (2, 2, 4);
    d = diff(t_conv);
    m = max(d);
    hist(d);
    title('Inter-departure time Distribution');
    xlabel('time [s]');
    ylabel('Empirical PDF');
    %axis([0 max([1 m]) 0 1]);
    grid on;

%     %% PACKETSIZE DISTRIBUTION
%     subplot (3, 2, 6);
%     hist(mx(:,8));
%     title('Packet size Distribution');
%     xlabel('[bytes]');
%     ylabel('Empirical PDF');
%     grid on;

    %% CHANGED: creation of picture files takes place in here
    % SAVE SINGLE OVERVIEW IMAGE FOR UDP RCV PACKETLOSS
    firstPicture = figure(1);
    set(firstPicture, 'PaperUnits','centimeters');
    set(firstPicture, 'PaperSize',[22 18]);
    set(firstPicture, 'PaperPosition',[0 0 22 18]);
    set(firstPicture, 'PaperOrientation','portrait');
    %set(firstPicture,'PaperType','A4');
    saveas(firstPicture, current_picture_file_name, output_format);
    close(firstPicture);
    
    % Packet loss picture for 'udp_rcv' type logs
    if (strcmp(log_type, 'udp_rcv')) 
        subplot (1, 1, 1);
        packetloss_picture = figure(1);
        % figure size printed on paper
        set(packetloss_picture, 'PaperUnits','centimeters');
        set(packetloss_picture, 'PaperSize',[12 10]);
        set(packetloss_picture, 'PaperPosition',[0 0 12 10]);
        set(packetloss_picture, 'PaperOrientation','portrait');
        plot(0:length(pktloss)-1, pktloss,'-');
        title('Packet loss');
        xlabel('time [s]');
        ylabel('[pps]');
        %axis([0 max(t_conv) 0 round(max(pktloss))+1]);
%         axis([ sort([min(t_conv),max(t_conv)])  sort([round(max(pktloss)),round(min(pktloss))])]);
        axis([ sort([0,max(t_conv)])  sort([round(max(pktloss))+1, round(min(pktloss))-1])]);
        grid on;
        saveas(packetloss_picture, strcat('pl_', current_picture_file_name), output_format);
        close(packetloss_picture);
    end    

end
