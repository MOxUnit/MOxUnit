function value = get(obj, property)
% Get the value corresponding to a property of the object.
%
% value=get(obj,property)
%
% Inputs:
%   obj             MoxUnitFunctionHandleTestCase object.
%   property        String containing the desired property.
%
% Output:
%   value           Value of the field named `property` attributed
%                   to `obj`.
%
% Notes:
%   - Unlike the get for handle objects, one must always specify
%     the name of a property to return. This method cannot be
%     used to get a list of all the fields and associated values of
%     the MoxUnitFunctionHandleTestCase object.
%
% SCL 2015

    value = obj.(property);

end