% Script used to run tests with github CI

IS_CI = getenv('CI');
if ~IS_CI
    error('This script should only run in continuous integration.');
end

cd('MOxUnit');
moxunit_set_path();
cd ..;
addpath(fullfile(pwd, 'MOcov', 'MOcov'));
moxunit_runtests tests -verbose -with_coverage -cover MOxUnit -cover_xml_file coverage.xml;
exit(double(~ans));
