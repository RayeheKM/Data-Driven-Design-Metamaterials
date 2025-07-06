function [y1, y2]=CrossoverBending(x1,x2, targetElements)

    pSinglePoint=0.1;
    pDoublePoint=0.2;
    pUniform=1-pSinglePoint-pDoublePoint;
    
    METHOD=RouletteWheelSelection([pSinglePoint pDoublePoint pUniform]);
    
    switch METHOD
        case 1
            [y1, y2]=SinglePointCrossoverBending(x1,x2, targetElements);
            
        case 2
            [y1, y2]=DoublePointCrossoverBending(x1,x2, targetElements);
            
        case 3
            [y1, y2]=UniformCrossoverBending(x1,x2, targetElements);
            
    end


end