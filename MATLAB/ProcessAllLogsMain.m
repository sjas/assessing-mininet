%% convenience function to parse all data collections at once
%% if crosstraffic is tested, other axes are needed for graphs, thus the switch

%  There are many magic numbers in here, cannot help that until there is no
%  system redesign coming, during when i.e. config files are transmitted, the
%  transmitted test data will be placed in special folders, etc. etc. etc.
%  Without a system redesign up front changing how test files are
%  generated, not much can be done here. 
%  Try and fail, every other solution will also just be like 'walking with crutches'.

%% enable processing of each of the available test sets
% setup / initialize
process_test_set_01 = 0;
process_test_set_02 = 0;
process_test_set_03 = 0;
process_test_set_04 = 0;
process_test_set_05 = 0;
process_test_set_06 = 0;
crosstraffic_switch_on = 1;
crosstraffic_switch_off = 0;








%% ============================================================================================
%% ============================ comment out if unneeded =======================================
%% ============================================================================================
                                %  1 is on, 0 is off
                                process_test_set_01 = 1;
                                process_test_set_02 = 1;
                                process_test_set_03 = 1;
                                process_test_set_04 = 1;
                                process_test_set_05 = 1;
                                process_test_set_06 = 1;
%% ============================================================================================
%% ============================================================================================
%% ============================================================================================

















%% ============================================================================================
%% ============================================================================================
%% ============================  NO CHANGES BELOW HERE  =======================================
%% ============================================================================================
%% ============================================================================================

%% folders containing test data
folder_01 = '/home/ktr/Documents/MATLAB/Mininet/logs1/';
folder_02 = '/home/ktr/Documents/MATLAB/Mininet/logs2/';
folder_03 = '/home/ktr/Documents/MATLAB/Mininet/logs3/';
folder_04 = '/home/ktr/Documents/MATLAB/Mininet/logs4/';
folder_05 = '/home/ktr/Documents/MATLAB/Mininet/logs5/';
folder_06 = '/home/ktr/Documents/MATLAB/Mininet/logs6/';
%% testsuite id
test_suite_prefix_01 = 'testsuite_01_lineartopo-lonetraffic';
test_suite_prefix_02 = 'testsuite_02_lineartopo-crosstraffic';
test_suite_prefix_03 = 'testsuite_03_meshedtopo-lonetraffic';
test_suite_prefix_04 = 'testsuite_04_meshedtopo-crosstraffic';
test_suite_prefix_05 = 'testsuite_05_lineartopo-crosstraffic-2x10000';
test_suite_prefix_06 = 'testsuite_06_meshedtopo-crosstraffic-2x10000';

%% sub settings
% non-meshed topology, single traffic source
if (process_test_set_01 == 1)
    process_complete_test_set('tcp_rcv', test_suite_prefix_01 , folder_01, crosstraffic_switch_off);
    process_complete_test_set('tcp_snd', test_suite_prefix_01 , folder_01, crosstraffic_switch_off);
    process_complete_test_set('udp_rcv', test_suite_prefix_01 , folder_01, crosstraffic_switch_off);
    process_complete_test_set('udp_snd', test_suite_prefix_01 , folder_01, crosstraffic_switch_off);
end
% non-meshed topology, crosstraffic with two sources
if (process_test_set_02 == 1)
    process_complete_test_set('tcp_rcv', test_suite_prefix_02 , folder_02, crosstraffic_switch_on);
    process_complete_test_set('tcp_snd', test_suite_prefix_02 , folder_02, crosstraffic_switch_on);
    process_complete_test_set('udp_rcv', test_suite_prefix_02 , folder_02, crosstraffic_switch_on);
    process_complete_test_set('udp_snd', test_suite_prefix_02 , folder_02, crosstraffic_switch_on);
end
% meshed topology, single traffic source
if (process_test_set_03 == 1)
    process_complete_test_set('tcp_rcv', test_suite_prefix_03 , folder_03, crosstraffic_switch_off);
    process_complete_test_set('tcp_snd', test_suite_prefix_03 , folder_03, crosstraffic_switch_off);
    process_complete_test_set('udp_rcv', test_suite_prefix_03 , folder_03, crosstraffic_switch_off);
    process_complete_test_set('udp_snd', test_suite_prefix_03 , folder_03, crosstraffic_switch_off);
end
% meshed topology, crosstraffic with two sources
if (process_test_set_04 == 1)
    process_complete_test_set('tcp_rcv', test_suite_prefix_04 , folder_04, crosstraffic_switch_on);
    process_complete_test_set('tcp_snd', test_suite_prefix_04 , folder_04, crosstraffic_switch_on);
    process_complete_test_set('udp_rcv', test_suite_prefix_04 , folder_04, crosstraffic_switch_on);
    process_complete_test_set('udp_snd', test_suite_prefix_04 , folder_04, crosstraffic_switch_on);
end
% non-meshed topology, crosstraffic with two sources
if (process_test_set_05 == 1)
    process_complete_test_set('tcp_rcv', test_suite_prefix_05 , folder_05, crosstraffic_switch_off);
    process_complete_test_set('tcp_snd', test_suite_prefix_05 , folder_05, crosstraffic_switch_off);
    process_complete_test_set('udp_rcv', test_suite_prefix_05 , folder_05, crosstraffic_switch_off);
    process_complete_test_set('udp_snd', test_suite_prefix_05 , folder_05, crosstraffic_switch_off);
end
% meshed topology, crosstraffic with two sources
if (process_test_set_06 == 1)
    process_complete_test_set('tcp_rcv', test_suite_prefix_06 , folder_06, crosstraffic_switch_off);
    process_complete_test_set('tcp_snd', test_suite_prefix_06 , folder_06, crosstraffic_switch_off);
    process_complete_test_set('udp_rcv', test_suite_prefix_06 , folder_06, crosstraffic_switch_off);
    process_complete_test_set('udp_snd', test_suite_prefix_06 , folder_06, crosstraffic_switch_off);
end
