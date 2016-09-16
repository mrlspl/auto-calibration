function output = cpm( v )
%CPM determines the skew-symmetric matrix associated to vector
%v = [v(1); v(2); v(3)]

output = [  0   -v(3)  v(2);
           v(3)   0   -v(1);
          -v(2)  v(1)   0  ];

end

