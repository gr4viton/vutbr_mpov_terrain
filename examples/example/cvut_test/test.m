s = ones( 2*m+1, 2*n+1, 'int8' );
s(1:2:(2*m+1),:) = zeros( m+1, 2*n+1, 'int8' );
s(:,1:2:(2*n+1)) = zeros( 2*m+1, n+1, 'int8' );
s(2:2:2*m,3:2:(2*n-1)) = all(cat(3, ... % horizontal edges
abs(z(:,2:end,1:2)-z(:,1:(end-1),1:2)) < hs, ...
abs(z(:,2:end,3:end)-z(:,1:(end-1),3:end)) < hr ),3);
s(3:2:(2*m-1),2:2:2*n) = all(cat(3, ... % vertical edges
abs(z(2:end,:,1:2)-z(1:(end-1),:,1:2)) < hs, ...
abs(z(2:end,:,3:end)-z(1:(end-1),:,3:end)) < hr ),3);
l = bwlabel(s,4); % find connected regions
l = l(2:2:2*m, 2:2:2*n); % extract labeling