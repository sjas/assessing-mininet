function [ ] = process_all_logs( log_type )
%%% this does also make for some real nice batch processing...
%%% and make pictures out of it, while at it.


    %%% SETTINGS: where are which files
    % this stuff does just work because the file naming convention is being proper
    folder_name         = '/home/ktr/Documents/MATLAB/Mininet/itg-logs-test';
    file_general_prefix = 'decoded_dat_log_';
    extension_loadfile  = '.dat';
    %choose: ps, eps, jpg, png, emf, pdf 
    output_format       = 'png';
    %others are possible, lookup in documentation!
    extension_imgfile  = strcat('.', output_format);
    prefix_imgfile     = 'pic_';
    overview_img_part  = 'overview_';
    




    %%% CODE
    % string concatenation for the files' names and getting a file list
    wildcard          = strcat(file_general_prefix, log_type, '*', extension_loadfile);
    wildcard_string   = strcat(folder_name, wildcard);
    % getting all the files' info parameters loaded
    file_set          = dir(wildcard_string);
    % name for the final overview image file
    overview_img_file = strcat(prefix_imgfile, overview_img_part, log_type, extension_imgfile);
    

    %INITIALIZE SOME VARIABLES FIRST
    % cells are used for performance reasons, initialized with needed size
    % are later converted to vectors
    cmean_bitrate           = cell(length(file_set),1);
    cstd_dev_bitrate        = cell(length(file_set),1);
    cmean_delay             = cell(length(file_set),1);
    cstd_dev_delay          = cell(length(file_set),1);
    cmean_jitter            = cell(length(file_set),1);
    cstd_dev_jitter         = cell(length(file_set),1);
    cmean_packetloss        = cell(length(file_set),1);
    cstd_dev_packetloss     = cell(length(file_set),1);
    
    % ACTUAL PROCESSING
    % loop from 1 through to the amount of rows
    for ii = 1:length(file_set)
        % getting just the filename.ext
        current_file_name_with_ext = file_set(ii).name;

        % extract sanitized filename for picture by replacing the extension
        bare_file_name            = strrep(current_file_name_with_ext, extension_loadfile, '');
        temp_picture_file_name    = strcat(bare_file_name, extension_imgfile);
        current_picture_file_name = strcat(prefix_imgfile, temp_picture_file_name);


        file_to_be_processed = load_wrapper(strcat(folder_name, current_file_name_with_ext)); 

        % load file with absolute path, 
        % since the file_set provides just the bare filename
        parsed_data = process_data(file_to_be_processed, bare_file_name);

        % SAVE SINGLE OVERVIEW IMAGE
        firstPicture = figure(1);
        set(firstPicture,'PaperType','A4');
        saveas(firstPicture, current_picture_file_name, output_format);

        %FIXME
        % save for having a complete dataset for the final graphs
        % with which all the axes could be made the same size
        %result_matrix = [result_matrix, parsed_data];

        %%% PRODUCE DATA STRUCTURES TO BE USED FOR THE GRAPH
        %SAVE CORRESPONDING BITRATE VALUE, THE X VALUE FOR CORRESPONDENCE
        %bitrate_of_test(ii)   = str2num(substr(current_file_name_with_ext, 25, 5));
        %bitrate_of_test(ii)   = 8000:100:12000;
        %SAVE CALCULATIONS HERE FOR OVERVIEW GRAPH AT THE END
        % mean values as y value according to x
        % standard deviations for having error values

        cmean_bitrate        {ii,1} = mean(parsed_data (:,1)) ;
        cstd_dev_bitrate     {ii,1} = std(parsed_data (:,1)) ;
        cmean_delay          {ii,1} = mean(parsed_data (:,2)) ;
        cstd_dev_delay       {ii,1} = std(parsed_data (:,2)) ;
        cmean_jitter         {ii,1} = mean(parsed_data (:,3)) ;
        cstd_dev_jitter      {ii,1} = std(parsed_data (:,3)) ;
        cmean_packetloss     {ii,1} = mean(parsed_data (:,4)) ;
        cstd_dev_packetloss  {ii,1} = std(parsed_data (:,4)) ;
     

    end

    %convert cells to vectors
        mean_bitrate =       [ cmean_bitrate{:,1} ];
        std_dev_bitrate =    [ cstd_dev_bitrate{:,1} ];
        mean_delay =         [ cmean_delay{:,1} ];
        std_dev_delay =      [ cstd_dev_delay{:,1} ];
        mean_jitter =        [ cmean_jitter{:,1} ];
        std_dev_jitter =     [ cstd_dev_jitter{:,1} ];
        mean_packetloss =    [ cmean_packetloss{:,1} ];
        std_dev_packetloss = [ cstd_dev_packetloss{:,1} ];

    % close last picture or be damned
    % seriously
    close;
    
    %old
    %bitrate_interval   = 500;
    %bitrate_of_test = 8000:bitrate_interval:12000;
    %new
    %bitrate_interval   = 1000;
    %bitrate_of_test = 9000:bitrate_interval:11000;
    bitrate_of_test = parsed_data (:,1);
    disp(parsed_data (:,1));
    


    % CREATE THE ERRORBARS FOR BETTER OVERVIEW ALTOGETHER
    % FIRST CREATE START AND END POINTS FOR GRAPHS' AXES
    s_bitrate         = min(bitrate_of_test) - 3 * bitrate_interval;
    e_bitrate         = max(bitrate_of_test) + 3 * bitrate_interval;
    s_mean_bitrate    = min(mean_bitrate)    * 0.9 - 1;
    e_mean_bitrate    = max(mean_bitrate)    * 1.1 + 1;
    s_mean_jitter     = min(mean_jitter)     * 0.9;
    e_mean_jitter     = max(mean_jitter)     * 1.1;
    s_mean_delay      = min(mean_delay)             - 0.1;
    e_mean_delay      = max(mean_delay)             + 0.1;
    s_mean_packetloss = min(mean_packetloss) * 0.9  - 0.1;
    e_mean_packetloss = max(mean_packetloss) * 1.1  + 0.1;

    axis_bitrate    = ([s_bitrate, e_bitrate, s_mean_bitrate, e_mean_bitrate]);
    axis_delay      = ([s_bitrate, e_bitrate, s_mean_delay, e_mean_delay]);
    axis_jitter     = ([s_bitrate, e_bitrate, s_mean_jitter, e_mean_jitter]);
    axis_packetloss = ([sort([s_bitrate, e_bitrate]), sort([s_mean_packetloss, e_mean_packetloss])]);

    
    % NOW PLOT ACTUAL GRAPHS
    %% THROUGHPUT 
    subplot(4,1,1);
    %figure(1);
    %disp(bitrate_of_test);
    disp(mean_bitrate);
    disp(std_dev_bitrate);
    errorbar(bitrate_of_test, mean_bitrate, std_dev_bitrate, 'rd');
    title('mean throughput + std. dev.');
    %xlabel('bitrates');
    ylabel('bitrate value');
    disp(axis_bitrate);
    axis(axis_bitrate);
    grid on

    %% DELAY
    subplot(4,1,2);
    %figure(2);
    errorbar(bitrate_of_test, mean_delay, std_dev_delay, 'g*');
    title('mean delay + std. dev.');
    %xlabel('bitrates');
    ylabel('delay value');
    axis(axis_delay);
    grid on

    %% JITTER
    subplot(4,1,3);
    %figure(3);
    errorbar(bitrate_of_test, mean_jitter, std_dev_jitter, 'ms');
    title('mean jitter + std. dev.');
    %xlabel('bitrates');
    ylabel('jitter value');
    axis(axis_jitter);
    grid on

    %% PACKET LOSS
    subplot(4,1,4);
    %figure(4);
    errorbar(bitrate_of_test, mean_packetloss, std_dev_packetloss, 'cx');
    title('mean packetloss + std. dev.');
    %%xlabel('bitrates');
    ylabel('packetloss value');
    axis(axis_packetloss);
    grid on


    secondPicture = figure(1);
    set(secondPicture,'PaperType','A4');
    saveas(secondPicture, overview_img_file, output_format);
    close;

    % TIDY UP
    %clean all workspace info
    clear all
    % close gfx windows
    %close all
end
