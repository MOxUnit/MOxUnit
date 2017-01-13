function tf=moxunit_util_is_test_name(name)
% Return true if the input is a string indicating a test
%
% tf=moxunit_util_is_test_name(name)
%
% Input:
%   name                string
%
% Output:
%   tf                  true if name is a string and either starts with
%                       'test' or ends with 'test' (case insensitive)
%
% NNO Jan 2014

    tf=ischar(name) && numel(name)>=4 &&...
            (strcmpi(name(1:4),'test') || strcmpi(name(end-(4:0)),'test'));
