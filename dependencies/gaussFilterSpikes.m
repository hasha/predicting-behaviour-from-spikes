function z = gaussFilterSpikes(x, sig)
% places a Gaussian centered on every spike
% if x is matrix, then perform on the columns

    %sig = round(sig);
    
    if sig <= 0.5
        %y = [0 1 0];
        w = 3;
        t = -w : w;
        y = normpdf(t,0,sig);
    else
        %sig
        w = round(sig * 5);
        t = -w : w;
        y = normpdf(t,0,sig);
    end
    O=conv(ones(size(x)),y);
  
        
    if isvector(x)
        z = conv(x,y);
        z = z./O;
        %z = z()
        z = z(w+1 : end-w);
        %z = z(1 : length(x));
    else
        z = zeros(size(x));
        for i = 1 : size(x,2)
            z1 = conv(x(:,i),y);
            z1 = z1./O;
            z1 = z1(w+1 : end-w);
            %z1 = z1(1 : length(x));
            z(:,i) = z1;
        end
    end
    
        
    %plot(t,y)
            
end