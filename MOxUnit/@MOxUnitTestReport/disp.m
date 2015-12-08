function disp(obj)
% Display test results
%
% disp(obj)
%
%   obj             MOxUnitTestReport instance.
%
% Notes:
%   - this function writes results to the file descriptor provided when
%     obj was instantiated, and with the provided verbosity level
%
% NNO 2015


    horizontal_line=sprintf('\n\n%s\n\n',repmat('-',1,50));

    output_format='text';

    if obj.verbosity>0
        fprintf(obj.stream,horizontal_line);

        if ~wasSuccessful(obj)
            writeNonSuccesses(obj, output_format, obj.stream);
            fprintf(obj.stream, horizontal_line);
        end

        fprintf(obj.stream,'%s\n',getStatisticsStr(obj,output_format));
    end