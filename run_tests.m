
% Script used to run tests with github CI
cd('MOxUnit')
moxunit_set_path();
cd ..;
addpath(fullfile(pwd, 'MOcov', 'MOcov'));
moxunit_runtests tests -verbose -with_coverage -cover MOxUnit -cover_xml_file coverage.xml;
exit(double(~ans))
