function [error_id,whatswrong]=moxunit_util_elements_compatible(a,b)
% compare compatibilty in class, size, and sparsity of two inputs
%
% [error_id,whatswrong]=moxunit_util_elements_compatible(a,b)
%
% Inputs:
%   a           first input  } of any
%   b           second input } type
%
% Output:
%   id          the empty string ('') if a and b are of the same class,
%               size and sparsity, otherwise:
%               'moxunit:differentClass      a and b are of different class
%               'moxunit:differentSize'      a and b are of different size
%               'moxunit:differentSparsity'  a is sparse and b is not, or
%                                            vice versa
%   whatswrong  if id is not empty, a human-readible description of the
%               inequality between a and b
%
% Notes:
%   - This is a helper function for assertElementsAlmostEqual,
%     assertVectorsAlmostEqual, and assertEqual
%
% See also: assertElementsAlmostEqual, assertVectorsAlmostEqual,
%           assertEqual
%
% NNO Jan 2014
    if ~isequal(class(a), class(b))
        whatswrong='inputs are not of the same class';
        error_id='moxunit:differentClass';

    elseif ~isequal(size(a), size(b))
        whatswrong='inputs are not of the same size';
        error_id='moxunit:differentSize';

    elseif issparse(a)~=issparse(b)
        whatswrong='inputs do not have the same sparsity';
        error_id='moxunit:differentSparsity';

    else
        error_id=[];
        whatswrong='';
    end
