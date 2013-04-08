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
% getting all the files' info parameters
file_set        = dir(wildcard_string);

%INITIALIZE VARIABLES tFIRST
result_matrix          = []
complete_result_matrix = [];
mean_bitrate           = [];
std_dev_bitrate        = [];
mean_delay             = [];
std_dev_delay          = [];
mean_jitter            = [];
std_dev_jitter         = [];
mean_packetloss        = [];
std_dev_packetloss     = [];
% ACTUAL PROCESSING
% loop from 1 through to the amount of rows
for i = 1:length(file_set)

    % getting just the filename.ext
    current_file_name_with_ext = file_set(i).name;

    % extract sanitized filename for picture by replacing the extension
    bare_file_name            = strrep(current_file_name_with_ext, extension_loadfile, '');
    temp_picture_file_name    = strcat(bare_file_name, extension_imgfile);
    current_picture_file_name = strcat(prefix_imgfile, temp_picture_file_name);


    file_to_be_processed = load_wrapper(strcat(folder_name, current_file_name_with_ext)); 

    % load file with absolute path, 
    % since the file_set provides just the bare filename
    parsed_data = process_data(file_to_be_processed, bare_file_name);

    % SAVE SINGLE OVERVIEW IMAGE
    %saveas(1, current_picture_file_name);

    % save for having a complete dataset for the final graphs
    %fixme
    %result_matrix = [result_matrix, parsed_data];

    %%% PRODUCE DATA STRUCTURES TO BE USED FOR THE GRAPH
    %SAVE CORRESPONDING BITRATE VALUE, THE X VALUE FOR CORRESPONDENCE
    %bitrate_of_test(i)   = str2num(substr(current_file_name_with_ext, 25, 5));
    %bitrate_of_test(i)   = 8000:100:12000;
    %SAVE CALCULATIONS HERE FOR OVERVIEW GRAPH AT THE END
    % mean values as y value according to x
    % standard deviations for having error values
    mean_bitrate       (:,i) = mean (parsed_data (:,1));
    std_dev_bitrate    (:,i) = std  (parsed_data (:,1));
    mean_delay         (:,i) = mean (parsed_data (:,2));
    std_dev_delay      (:,i) = std  (parsed_data (:,2));
    mean_jitter        (:,i) = mean (parsed_data (:,3));
    std_dev_jitter     (:,i) = std  (parsed_data (:,3));
    mean_packetloss    (:,i) = mean (parsed_data (:,4));
    std_dev_packetloss (:,i) = std  (parsed_data (:,4));

end

% took that out of the loop, since its got no running index
bitrate_of_test    = 8000:100:12000;



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
clear all
% close gfx windows
%close all
