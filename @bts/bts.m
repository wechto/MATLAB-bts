%bts([x y z],r)
classdef bts
    properties
        x=0;
        y=0;
        z=1;
        r=1;
        num=0;
    end
    methods
        function this=bts(varargin)
            narginchk(1,2);
            this.x=varargin{1}(1);
            this.y=varargin{1}(2);
            if size(varargin{1},2)==3
                this.z=varargin{1}(3);
            end
            if nargin>=2
                this.r=varargin{2};
            end
        end
        function show(this)
            % rr xx yy locX locY temp
            hold on;
            stem3(this.x,this.y,this.z);
            rr=this.r;
            xx=this.x;
            yy=this.y;
            locX=[xx+rr xx+rr/2 xx-rr/2 xx-rr xx-rr/2 xx+rr/2 xx+rr];
            locY=[yy yy+rr*sqrt(3)/2 yy+rr*sqrt(3)/2 yy yy-rr*sqrt(3)/2 yy-rr*sqrt(3)/2 yy];
            for temp = 1:6
                line([locX(temp) locX(temp+1)],[locY(temp) locY(temp+1)]);
            end
            clear rr xx yy locX locY temp ;
            hold off;
        end
    end
end

