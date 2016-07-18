function tf = moxunit_util_is_message_identifier(id)
% returns whether the input string is a message identifier
%
% tf = moxunit_util_is_message_identifier(string)
%
% Input:
%   id              input string
%
% Output
%   tf              true if the input string is a message identifier. A
%                   message identifier is a string with the following
%                   properties:
%                   - contains only alphanumeric characters, and/or the
%                     underscore character ('_') and colon (':')
%                   - it contains at least one colon
%                   - the first character is an alphabetic character
%                   - every colon is immediately followed by an alphabetic
%                     character

    if ~ischar(id)
        error('illegal input: first argument must be char');
    end

    alpha_pat = '[a-zA-Z]';
    word_pat = '\w';

    id_pat = sprintf('(%s(%s*))',alpha_pat,word_pat);
    pat = sprintf('^%s(:%s)+$',id_pat,id_pat);

    tf = ~isempty(regexp(id, pat, 'once'));
