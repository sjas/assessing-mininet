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
    bitrate_of_test(i) = str2num(substr(current_file_name_with_ext, 25, 5));


    %SAVE CALCULATIONS HERE FOR OVERVIEW GRAPH AT THE END
    % mean bitrate as y value according to x
    %mean_bitrate(i,1)       = bitrate_of_test(i);
    mean_bitrate(i)       = mean(parsed_data(i,1));
    % standard deviation for bitrate according to each x value
    %std_dev_bitrate(i,1)    = bitrate_of_test(i);
    std_dev_bitrate(i)    = std(parsed_data(i,1));
    
    % mean delay as y value according to x
    %mean_delay(i,1)         = bitrate_of_test(i);
    mean_delay(i)         = mean(parsed_data(i,2));
    % standard deviation for delay according to each x value
    %std_dev_delay(i,1)      = bitrate_of_test(i);
    std_dev_delay(i)      = std(parsed_data(i,2));

    % mean jitter as y value according to x
    %mean_jitter(i,1)        = bitrate_of_test(i);
    mean_jitter(i)        = mean(parsed_data(i,3));
    % standard deviation for jitter according to each x value
    %std_dev_jitter(i,1)     = bitrate_of_test(i);
    std_dev_jitter(i)     = std(parsed_data(i,3));

    % mean packetloss as y value according to x
    %mean_packetloss(i,1)    = bitrate_of_test(i);
    mean_packetloss(i)    = mean(parsed_data(i,4));
    % standard deviation for packetloss according to each x value
    %std_dev_packetloss(i,1) = bitrate_of_test(i);
    std_dev_packetloss(i) = std(parsed_data(i,4));

    % SAVE SINGLE OVERVIEW IMAGE
    %saveas(1, current_picture_file_name);

end

whos parsed_data;

% CREATE THE ERRORBARS FOR BETTER OVERVIEW ALTOGETHER
% FIRST CREATE START AND END VALUES FOR GRAPHS
s_abitrate        = min(bitrate_of_test);
e_abitrate        = max(bitrate_of_test);
e_mean_bitrate    = max(mean_bitrate)    * 1.1-0.1;
s_mean_bitrate    = min(mean_bitrate)    * 0.9;

s_bbitrate        = min(bitrate_of_test);
e_bbitrate        = max(bitrate_of_test);
s_mean_jitter     = min(mean_jitter)     * 0.9;
e_mean_jitter     = max(mean_jitter)     * 1.1;

s_cbitrate        = min(bitrate_of_test);
e_cbitrate        = max(bitrate_of_test);
s_mean_delay      = min(mean_delay)      * 0.9;
e_mean_delay      = max(mean_delay)      * 1.1;

s_dbitrate        = min(bitrate_of_test);
e_dbitrate        = max(bitrate_of_test);
s_mean_packetloss = min(mean_packetloss) * 0.9-0.1;
e_mean_packetloss = max(mean_packetloss) * 1.1+0.1;

axis_bitrate    = ([s_abitrate, e_abitrate, s_mean_bitrate, e_mean_bitrate]);
axis_delay      = ([s_bbitrate, e_bbitrate, s_mean_delay, e_mean_delay]);
axis_jitter     = ([s_cbitrate, e_cbitrate, s_mean_jitter, e_mean_jitter]);
axis_packetloss = ([s_dbitrate, e_dbitrate, s_mean_packetloss, e_mean_packetloss]);

% NOW PLOT ACTUAL GRAPHS
%% THROUGHPUT
subplot(4,1,1);
%figure(1);
errorbar(bitrate_of_test, mean_bitrate, std_dev_bitrate, '~');
title('mean throughput + std. dev.');
%xlabel('bitrates');
ylabel('bitrate value');
axis(axis_bitrate);
grid on

%% DELAY
subplot(4,1,2);
%figure(2);
errorbar(bitrate_of_test, mean_delay, std_dev_delay, '~');
title('mean delay + std. dev.');
%xlabel('bitrates');
ylabel('delay value');
axis(axis_delay);
grid on

%% JITTER
subplot(4,1,3);
%figure(3);
errorbar(bitrate_of_test, mean_jitter, std_dev_jitter, '~');
title('mean jitter + std. dev.');
%xlabel('bitrates');
ylabel('jitter value');
axis(axis_jitter);
grid on

%% PACKET LOSS
subplot(4,1,4);
%figure(4);
errorbar(bitrate_of_test, mean_packetloss, std_dev_packetloss, '~');
title('mean packetloss + std. dev.');
%xlabel('bitrates');
ylabel('packetloss value');
axis(axis_packetloss);
grid on


% TIDY UP
% clear variables
clear folder_name;
clear extension_loadfile;
clear extension_imgfile;
clear prefix_imgfile;
clear wildcard;
clear wildcard_string;
clear file_set;
clear i;
clear current_file_name_with_ext;
clear bare_file_name;
clear temp_picture_file_name;
clear current_picture_file_name;
clear current_file;
clear parsed_data;
clear parse_result;
clear bitrate_of_test;
clear mean_bitrate;
clear mean_delay;
clear mean_jitter;
clear mean_packetloss;
%clear std_dev_bitrate;
%clear std_dev_delay;
%clear std_dev_jitter;
%clear std_dev_packetloss;
clear e_mean_bitrate;
clear s_mean_bitrate;
clear e_mean_delay;
clear s_mean_delay;
clear e_mean_jitter;
clear s_mean_jitter;
clear e_mean_packetloss;
clear s_mean_packetloss;
clear axis_bitrate;
clear axis_delay;
clear axis_jitter;
clear axis_packetloss;
clear e_abitrate;
clear s_abitrate;
clear e_bbitrate;
clear s_bbitrate;
clear e_cbitrate;
clear s_cbitrate;
clear e_dbitrate;
clear s_dbitrate;
% close gfx window
%close all
