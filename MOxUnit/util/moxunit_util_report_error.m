function moxunit_util_report_error(issue, message, stack)
    fprintf('--------------------------------------------------\n');
    fprintf('Some errors where found for `%s`:\n\n  %s\n\n', issue, message);
    for n = 1:length(stack)
        fprintf('Error in `%s` (%s:%d)\n', ...
            stack(n).name, stack(n).file, stack(n).line);
    end

    fprintf('--------------------------------------------------\n\n');
end
