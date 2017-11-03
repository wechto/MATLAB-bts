%btss([m n],[xo yo],r)
classdef btss < handle
    properties
        m=0;%行
        n=0;%列
        xo=0;%中心x坐标
        yo=0;%中心y坐标
        r=10;%单个基站半径
        gbts=cell(15,15);
    end
    methods
        function this=btss(varargin)
            narginchk(1,3);
            this.m=varargin{1}(1);
            this.n=varargin{1}(2);
            if nargin>=2
                this.xo=varargin{2}(1);
                this.yo=varargin{2}(2);
            end
            if nargin>=3
                this.r=varargin{3};
            end
            if this.m>15 || this.n>15 || this.m<=0 || this.n<=0
                error('0<m<=15 0<n<=15');
            end
        end
        function show(this)
            % i j x y r a b（左上角） xx yy (当下) tempi tempj
            hold on
            a=this.xo-1.5*this.r*this.n/2;
            b=this.yo-sqrt(3)*this.r*this.m/2;
            for j=1:this.n
                tempj = mod(j,2);
                xx=a+j*1.5*this.r+this.r/2;
                for i=1:this.m
                    %                 tempi = mod(i,2);(没用)
                    yy=b+i*sqrt(3)*this.r+sqrt(3)/2*this.r;
                    if tempj==0
                        yy=yy+sqrt(3)/2*this.r;
                    end
                    %                     [xx yy this.r]
                    obj_bts=bts([xx yy],this.r);
                    obj_bts.show;
                    %tempg
                    tempg=cell(1,3);
                    tempg{1,1}=i;
                    tempg{1,2}=j;
                    tempg{1,3}=obj_bts;
                    this.gbts=tempg;
                    %                     pause(0.05);
                end
            end
            clear i j x y r a b xx yy tempi tempj obj_bts tempg
            hold off
        end
        function set.gbts(this,tempg)
            this.gbts{tempg{1,1},tempg{1,2}}=tempg{1,3};
        end
    end
end

