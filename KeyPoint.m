classdef KeyPoint
    %KeyPoint extracted using SIFT
    
    properties
        Coordinates = []
        Magnitute
        Direction
        Descriptor
        Octave
        Scale
    end
    
    methods
        function co = coordinates(obj)
            % Returns Coordinates
            co = obj.Coordinates;
        end
        function co = magnitute(obj)
            % Returns Magnitute
            co = obj.Magnitute;
        end
        function co = direction(obj)
            % Returns direction
            co = obj.Direction;
        end
        function co = descriptor(obj)
            % Returns descriptor
            co = obj.Descriptor;
        end
        function co = octave(obj)
            % Returns octave
            co = obj.Octave;
        end
        function co = scale(obj)
            % Returns scale
            co = obj.Scale;
        end
    end
    
end

