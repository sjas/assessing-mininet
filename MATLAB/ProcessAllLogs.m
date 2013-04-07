%%% this does some nice batch processing
%%% and make pictures out of it, while at it.

%%% SETTINGS: where are which files
folder_name        = '/cygdrive/c/Users/sjas/work/ktr/MATLAB/itg-logs/';
extension_loadfile = '.dat';
%choose: ps, eps, jpg, png, emf, pdf 
%others are possible, lookup in documentation!
extension_imgfile  = '.png';
prefix_imgfile     = 'pic_';

%%% CODE
% string concatenation and getting a file list
wildcard        = strcat('*', extension_loadfile);
wildcard_string = strcat(folder_name, wildcard);
file_set        = dir(wildcard_string);

% ACTUAL PROCESSING
% loop from 1 through to the amount of rows
for i = 1:length(file_set)
    current_file_name_with_ext = file_set(i).name;
    % create filename for picture by replacing the extension
    bare_file_name            = strrep(current_file_name_with_ext, extension_loadfile, '');
    temp_picture_file_name    = strcat(bare_file_name, extension_imgfile);
    current_picture_file_name = strcat(prefix_imgfile, temp_picture_file_name);

    % load file with absolute path, 
    % since the file_set provides just the bare filename
    %%% TODO check if this can be done easier with 'file_in_loadpath(<file>)'
    current_file = load_wrapper(strcat(folder_name, current_file_name_with_ext)); 
    parsed_data = process_data(current_file, bare_file_name);

    %%% PRODUCE DATA STRUCTURES TO BE USED FOR THE GRAPH
    %SAVE CORRESPONDING BITRATE VALUE, THE X VALUE FOR CORRESPONDENCE
    test_bitrate(i) = str2num(substr(current_file_name_with_ext, 25, 5));


    %SAVE CALCULATIONS HERE FOR OVERVIEW GRAPH AT THE END
    % mean bitrate as y value according to x
    %mean_bitrate(i,1)       = test_bitrate(i);
    mean_bitrate(i )       = mean(parsed_data(i,1));
    % standard deviation for bitrate according to each x value
    %std_dev_bitrate(i,1)    = test_bitrate(i);
    std_dev_bitrate(i )    = std(parsed_data(i,1));
    
    % mean delay as y value according to x
    %mean_delay(i,1)         = test_bitrate(i);
    mean_delay(i )         = mean(parsed_data(i,2));
    % standard deviation for delay according to each x value
    %std_dev_delay(i,1)      = test_bitrate(i);
    std_dev_delay(i )      = std(parsed_data(i,2));

    % mean jitter as y value according to x
    %mean_jitter(i,1)        = test_bitrate(i);
    mean_jitter(i )        = mean(parsed_data(i,3));
    % standard deviation for jitter according to each x value
    %std_dev_jitter(i,1)     = test_bitrate(i);
    std_dev_jitter(i )     = std(parsed_data(i,3));

    % mean packetloss as y value according to x
    %mean_packetloss(i,1)    = test_bitrate(i);
    mean_packetloss(i )    = mean(parsed_data(i,4));
    % standard deviation for packetloss according to each x value
    %std_dev_packetloss(i,1) = test_bitrate(i);
    std_dev_packetloss(i ) = std(parsed_data(i,4));

    % SAVE SINGLE OVERVIEW IMAGE
    %saveas(1, current_picture_file_name);

end

whos parsed_data;

% CREATE THE ERRORBARS FOR BETTER OVERVIEW ALTOGETHER
% FIRST CREATE START AND END VALUES FOR GRAPHS
s_bitrate         = min(test_bitrate);
e_bitrate         = max(test_bitrate);
s_mean_bitrate    = min(mean_bitrate);
e_mean_bitrate    = max(mean_bitrate);
s_mean_delay      = min(mean_delay);
e_mean_delay      = max(mean_delay);
s_mean_jitter     = min(mean_jitter);
e_mean_jitter     = max(mean_jitter);
s_mean_packetloss = min(mean_packetloss);
e_mean_packetloss = max(mean_packetloss);


% NOW PLOT ACTUAL GRAPHS
%% THROUGHPUT
subplot(4,1,1);
%figure(1);
errorbar(test_bitrate, mean_bitrate, std_dev_bitrate, '~');
title('mean throughput + std. dev.');
xlabel('bitrates');
ylabel('bitrate value');
axis(s_bitrate, e_bitrate, s_mean_bitrate, e_mean_bitrate);
%axis([0 max(t_conv) 0 round(max(bitrate_u))+1]);
grid on

%% DELAY
subplot(4,1,2);
%figure(2);
errorbar(test_bitrate, mean_delay, std_dev_delay, '~');
title('mean delay + std. dev.');
xlabel('bitrates');
ylabel('delay value');
%axis([0 max(t_conv) 0 round(max(bitrate_u))+1]);
axis(s_bitrate, e_bitrate, s_mean_delay, e_mean_delay);
grid on

%% JITTER
subplot(4,1,3);
%figure(3);
errorbar(test_bitrate, mean_jitter, std_dev_jitter, '~');
title('mean jitter + std. dev.');
xlabel('bitrates');
ylabel('jitter value');
%axis([0 max(t_conv) 0 round(max(bitrate_u))+1]);
axis(s_bitrate, e_bitrate, s_mean_jitter, e_mean_jitter);
grid on

%% PACKET LOSS
subplot(4,1,4);
%figure(4);
errorbar(test_bitrate, mean_packetloss, std_dev_packetloss, '~');
title('mean packetloss + std. dev.');
xlabel('bitrates');
ylabel('packetloss value');
%axis([0 max(t_conv) 0 round(max(bitrate_u))+1]);
axis(s_bitrate, e_bitrate, s_mean_packetloss, e_mean_packetloss);
grid on


% TIDY UP
% clear variables
%clear folder_name;
%clear extension_loadfile;
%clear extension_imgfile;
%clear prefix_imgfile;
%clear wildcard;
%clear wildcard_string;
%clear file_set;
%clear i;
%clear current_file_name_with_ext;
%clear bare_file_name;
%clear temp_picture_file_name;
%clear current_picture_file_name;
%clear current_file;
%clear parsed_data;
%clear parse_result;
%clear test_bitrate;
%clear mean_bitrate;
%clear mean_delay;
%clear mean_jitter;
%clear mean_packetloss;
%clear std_dev_bitrate;
%clear std_dev_delay;
%clear std_dev_jitter;
%clear std_dev_packetloss;
% close gfx window
%close all
