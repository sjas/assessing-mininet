function [ ] = process_complete_test_set( log_type, test_suite_prefix, folder_name, crosstraffic_switch )
%%% analyze given files for one of the four test setups
%%% calls script to analyze each file separately


    addpath(folder_name);
    % change dir so pictures will be placed with the log files
%     cd(folder_name);
%     addpath('..');
    
    %%% SETTINGS
    file_general_prefix  = 'decoded_dat_log_';
    extension_loadfile   = '.dat';
    
    % choose: ps, eps, jpg, png, emf, pdf 
    % others are possible, lookup in documentation!
    output_format        = 'pdf';
    prefix_imgfile       = 'pic_';
    overview_img_part    = 'overview_';
    
    extension_imgfile    = strcat('.', output_format);
    




    %%% CODE
    % string concatenation for the files' names and getting a file list
    wildcard          = strcat(file_general_prefix, log_type, '*', extension_loadfile);
    wildcard_string   = strcat(folder_name, wildcard);
    % getting all the files' info parameters loaded
    file_set          = dir(wildcard_string);
    % name for the final overview image file
    overview_img_file = strcat(prefix_imgfile, overview_img_part, log_type, '_', test_suite_prefix, extension_imgfile);
    

    %INITIALIZE VARIABLES FIRST
    % cells are used for performance reasons, initialized with needed size
    % and are later converted to vectors
    cmean_bitrate           = cell(length(file_set),1);
    cstd_dev_bitrate        = cell(length(file_set),1);
    cmean_delay             = cell(length(file_set),1);
    cstd_dev_delay          = cell(length(file_set),1);
    cmean_jitter            = cell(length(file_set),1);
    cstd_dev_jitter         = cell(length(file_set),1);
    cmean_packetloss        = cell(length(file_set),1);
    cstd_dev_packetloss     = cell(length(file_set),1);

    % for debugging purposes in case files are not read/found
    disp('not in loop, not yet iterating over files, amount of files found:');
    disp(length(file_set));
    
    % ACTUAL PROCESSING
    % loop from 1 through to the amount of rows
    for ii = 1:length(file_set)
        
        % for debugging purposes in case files are not read
        disp('in loop, iterating through list of found files...');
        
        % getting just the filename.ext
        current_file_name_with_ext = file_set(ii).name;

        % extract sanitized filename for picture by replacing the extension
        bare_file_name            = strrep(current_file_name_with_ext, extension_loadfile, '');
        temp_picture_file_name    = strcat(bare_file_name, extension_imgfile);
        current_picture_file_name = strcat(test_suite_prefix, '_' , prefix_imgfile, temp_picture_file_name);

        file_to_be_processed = load_function(strcat(folder_name, current_file_name_with_ext)); 

        % load file with absolute path, 
        % since the file_set provides just the bare filename
        parsed_data = process_single_testfile(file_to_be_processed, bare_file_name,...
                                        log_type, current_picture_file_name, output_format);

        
        %%% PRODUCE DATA STRUCTURES TO BE USED FOR THE GRAPH
        
        %% left in here, in case the bitrate values are to be collected automatically one day
        %SAVE CORRESPONDING BITRATE VALUE, THE X VALUE FOR CORRESPONDENCE
        %bitrate_of_test(ii)   = str2num(substr(current_file_name_with_ext, 25, 5));

        %SAVE CALCULATIONS HERE FOR OVERVIEW GRAPH AT THE END
        % mean values as y value according to x
        % standard deviations for having error values

%         disp(mean(parsed_data (1,1)));
        cmean_bitrate        {ii,1} = mean(parsed_data (:,1)) ;
        cstd_dev_bitrate     {ii,1} = std(parsed_data (:,1)) ;
        cmean_delay          {ii,1} = mean(parsed_data (:,2)) ;
        cstd_dev_delay       {ii,1} = std(parsed_data (:,2)) ;
        cmean_jitter         {ii,1} = mean(parsed_data (:,3)) ;
        cstd_dev_jitter      {ii,1} = std(parsed_data (:,3)) ;
        cmean_packetloss     {ii,1} = mean(parsed_data (:,4)) ;
        cstd_dev_packetloss  {ii,1} = std(parsed_data (:,4)) ;
     

    end
    
    %% these if's are needed to set the custom x-axis labels for the overviews
    if (crosstraffic_switch == 1)
        % interval set here is the bitrate difference between two tests
        bitrate_interval = 0.25;
        % contains all the proper test values
        bitrate_of_test = 4:bitrate_interval:6;
    end
    if (crosstraffic_switch == 0)
        % interval set here is the bitrate difference between two tests
        bitrate_interval = 0.5;
        % contains all the proper test values
        bitrate_of_test = 8:bitrate_interval:12;
    end


    % convert cells to vectors
    mean_bitrate =       [ cmean_bitrate{:,1} ];
    std_dev_bitrate =    [ cstd_dev_bitrate{:,1} ];
    mean_delay =         [ cmean_delay{:,1} ];
    std_dev_delay =      [ cstd_dev_delay{:,1} ];
    mean_jitter =        [ cmean_jitter{:,1} ];
    std_dev_jitter =     [ cstd_dev_jitter{:,1} ];
%     mean_packetloss =    [ cmean_packetloss{:,1} ];
%     std_dev_packetloss = [ cstd_dev_packetloss{:,1} ];

    

    % CREATE THE ERRORBARS FOR BETTER OVERVIEW ALTOGETHER
    % FIRST CREATE START AND END POINTS FOR GRAPHS' AXES
    s_bitrate         = min(bitrate_of_test) - bitrate_interval;
    e_bitrate         = max(bitrate_of_test) + bitrate_interval;
    s_mean_bitrate    = min(mean_bitrate)-max(std_dev_bitrate);
    e_mean_bitrate    = max(mean_bitrate)+max(std_dev_bitrate);
    s_mean_jitter     = min(mean_jitter)-max(std_dev_jitter);
    e_mean_jitter     = max(mean_jitter)+max(std_dev_jitter);
    s_mean_delay      = min(mean_delay)-max(std_dev_delay);
    e_mean_delay      = max(mean_delay)+max(std_dev_delay);

    % SET ACTUAL AXES LIMITS
    axis_bitrate    = ([s_bitrate, e_bitrate, s_mean_bitrate, e_mean_bitrate]);
    axis_delay      = ([s_bitrate, e_bitrate, sort([round(s_mean_delay)-1,...
                                                            round(e_mean_delay)+1])]);
    axis_jitter     = ([s_bitrate, e_bitrate, s_mean_jitter, e_mean_jitter]);
%     axis_packetloss = ([sort([s_bitrate, e_bitrate]), sort([s_mean_packetloss, e_mean_packetloss])]);



    %%% SECTION FOR SHOWING TEST DATA START(debugging purposes)
    disp('\n\n\n*** START TESTDATA ***\n');
    disp(bitrate_of_test);
    %disp(parsed_data (:,1));
    %disp(parsed_data (1,:));
    disp(mean_bitrate);
    disp(std_dev_bitrate);
    disp('\n*** END TESTDATA ***\n\n\n');
    %%% SECTION FOR SHOWING TEST DATA END

    
    
    % NOW PLOT ACTUAL GRAPHS
    %% THROUGHPUT 
    subplot(3,1,1);
    disp(length(bitrate_of_test));
    disp(length(mean_bitrate));
    disp(length(std_dev_bitrate));
    errorbar(bitrate_of_test, mean_bitrate, std_dev_bitrate, 'kx');
    %errorbar(bitrate_of_test, mean_bitrate, std_dev_bitrate, 'rd');
    title('mean throughput with standard deviation');
    xlabel('test bitrate [Mbps]');
    ylabel('bitrate value [Mbps]');
    disp(axis_bitrate);
    axis(axis_bitrate);
    grid on;

    %% DELAY
    subplot(3,1,2);
    errorbar(bitrate_of_test, mean_delay, std_dev_delay, 'kx');
    %errorbar(bitrate_of_test, mean_delay, std_dev_delay, 'g*');
    title('mean delay with standard deviation');
    xlabel('test bitrate [Mbps]');
    ylabel('delay value [ms]');
    axis(axis_delay);
    grid on;

    %% JITTER
    subplot(3,1,3);
    %figure(3);
    errorbar(bitrate_of_test, mean_jitter, std_dev_jitter, 'kx');
    %errorbar(bitrate_of_test, mean_jitter, std_dev_jitter, 'ms');
    title('mean jitter with standard deviation');
    xlabel('test bitrate [Mbps]');
    ylabel('jitter value [ms]');
    axis(axis_jitter);
    grid on;

    %% currently dead
%     %% PACKET LOSS
%     subplot(1,1,1);
%     errorbar(bitrate_of_test, mean_packetloss, std_dev_packetloss, 'kx');
%     %errorbar(bitrate_of_test, mean_packetloss, std_dev_packetloss, 'cx');
%     title('mean packetlossand standard deviation');
%     %%xlabel('test bitrate [Mbps]');
%     ylabel('packetloss value [count]');
%     axis(axis_packetloss);
%     grid on;

    % open picture handler
    aggregatedPicture = figure(1);
    set(aggregatedPicture, 'PaperUnits','centimeters')
    set(aggregatedPicture, 'PaperSize',[30 16])
    set(aggregatedPicture, 'PaperPosition',[0 0 30 16])
    set(aggregatedPicture, 'PaperOrientation','portrait')
    %set(aggregatedPicture,'PaperType','A4');
    saveas(aggregatedPicture, overview_img_file, output_format);
    % close picture handler
    close(aggregatedPicture);
    
    % TIDY UP
    %clean all workspace info
    clear all
end
