function z = cutOut(v, ivAlign, wBefore, wAfter)
% v is vector of data to cut out
% ivAlign is center in v to cut out
% wBefore and wAfter are range to cutout

    z = nan(1, wBefore+wAfter+1);
    
    iv1 = ivAlign - wBefore;
    iv2 = ivAlign + wAfter;
    if iv1 < 1
        iz1 = -iv1 + 2;
        iv1 = 1;
    else
        iz1 = 1;
    end
    
    Lv = length(v);
    if iv2 > Lv
        iz2 = length(z) - (iv2 - Lv);
        iv2 = Lv;
    else
        iz2 = length(z);
    end
    try
        z(iz1 : iz2) = v(iv1 : iv2);
    catch
        length(v)
        length(z)
        wBefore
        wAfter
        iz1
        iz2
        iv1
        iv2
        stop
    end
end