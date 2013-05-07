function connectaxes(varargin)
%CONNECTAXES   Controls, whether or not different axes should zoom synchronously
%   CONNECTAXES with no arguments synchronizes zooming of ALL axes of the
%   currrent figure in X- and Y-direction.
%
%   CONNECTAXES(MODE,AXESLIST) applies the specified mode to the given axes.
%   MODE is a string starting with either '+' or '-' for connecting or dis-
%   connecting the axes. Additionally the zoom-direction ('x' or 'y') to be
%   synchronized can be given. If no direction is given, both 'x' and 'y' are
%   assumed.
%   AXESLIST is an array of axes-handles. If you omit AXESLIST, the command
%   applies to all axes in the current figure. NB: If you specify axes by their
%   handles, they may well be in different figures and still zoom synchro-
%   nously.
%
%   See also: ZOOM.

%   How it works...
%   Wenever you turn on ZOOM on a 2-D plot some application specific data
%   is stored in the (unused) z-axis label. It can be retrieved with
%
%   >> axz = get(ax, 'ZLabel');
%   >> data = get(axz,  'UserData');
%  (or data = getappdata(axz, 'ZOOMAxesData'); for Matlab 5.3)
%
%   'data' is a 2 by 4 array. The first row, data(1,1:4), contains the original
%   axes limits [xmin xmax ymin ymax] that are stored when the ZOOM command
%   is first issued. The second row, data(2,1:2) contains pointers to succes-
%   sors [nax nay] in a circular list of axes handles.
%   Whenever the user zooms into an axes, ZOOM checks these pointers. If 'nax'
%   is equal to the actual axes handle (which is the default) nothing happens.
%   If it is different, the x-limits of the succeeding axes will be set to the
%   same values as those of the actual axes. Then, the successor of the suc-
%   cessor is determined and so on until the original axes are reached. The
%   same procedure applies to 'nay'.
%   CONNECTAXES uses this (undocumented) feature of ZOOM by establishing the
%   user data for the required circular lists in the z-axis labels.

%   W. Hammer 16.09.98
%   Version checking added on 2.2.00 by W. Hammer
%   Power Electronics and Electrometrology Laboratory, ETH Zurich

% check matlab version and set commands accordingly
[r,sr] = strtok(version,'.');
sr = strtok(sr,'.');
r = str2num(r);
sr = str2num(sr);

if ((r>5) | ((r==5) & (sr>2)))
  getcmd = 'getappdata';
  setcmd = 'setappdata';
  propname = 'ZOOMAxesData';
else
  getcmd = 'get';
  setcmd = 'set';
  propname = 'UserData';
end

allAxes = findobj(get(gcf,'Children'),'flat','type','axes');
mode = 'connect';
xdir = 1;
ydir = 1;

switch nargin,
case 1,
   if ischar(varargin{1}),
      if strncmp(varargin{1},'-',1),
         mode = 'disconnect';
      elseif strncmp(varargin{1},'+',1),
      else,
         error(['Unknown command line argument: ' varargin{1}])
      end
      if length(varargin{1})>1,
         if isempty(findstr(lower(varargin{1}),'x')),
            xdir = 0;
         end
         if isempty(findstr(lower(varargin{1}),'y')),
            ydir = 0;
         end
      end         
   elseif isnumeric(varargin{1}),
      allAxes = varargin{1};
   else
      error(['Unknown command line argument: ' varargin{1}])
   end
case 2,
   if ischar(varargin{1}),
      if strncmp(varargin{1},'-',1),
         mode = 'disconnect';
      elseif strncmp(varargin{1},'+',1),
      else,
         error(['Unknown connection mode ' varargin{1}])
      end
      if length(varargin{1})>1,
         if isempty(findstr(lower(varargin{1}),'x')),
            xdir = 0;
         end
         if isempty(findstr(lower(varargin{1}),'y')),
            ydir = 0;
         end
      end         
   end
   if isnumeric(varargin{2}),
      allAxes = varargin{2};
   else
      error(['Unknown type of axes list: ' varargin{2}])
   end
end

if strcmp(mode, 'connect'),
   connAxes = [];
   for i=1:length(allAxes),
      ax = allAxes(i);
      if ~strcmp(get(ax,'Type'),'axes')
         errmsg = ['Handle ' num2str(ax) ' does not refer to an axes-object.'];
         error(errmsg);
      end      
      limits = feval(getcmd,get(ax,'ZLabel'),propname);
      if isempty(limits)|(size(limits,2)==4 & size(limits,1)<=2),
         connAxes = [connAxes ax];
      else
         warning(['Can''t connect axes ' num2str(ax) '. UserData is already used otherwise.'])
      end
      if ~isempty(limits)&(size(limits,2)==4 & size(limits,1)==2),
         % need to check existing connectivity
         nax = limits(2,1);
         nay = limits(2,2);
         if xdir & nax~=ax,
            % Axes are already in a x-connect-list
            errmsg = ['Axes ' num2str(ax) ' are already connected for X-Zooms.'];
            error(errmsg);
         end
         if ydir & nay~=ax,
            % Axes are already in a y-connect-list
            errmsg = ['Axes ' num2str(ax) ' are already connected for Y-Zooms.'];
            error(errmsg);
         end
      end
   end
   
   if length(connAxes)==1,
      % nothing to connect...
      return;
   end
   
   connAxes = [connAxes connAxes(1)];
   
   for i=1:(length(connAxes)-1),
      ax = connAxes(i);
      na = connAxes(i+1);
      limits = feval(getcmd,get(ax,'ZLabel'),propname);
      if isempty(limits),
         xlim = get(ax,'xlim');
         if strcmp(get(ax,'XScale'),'log'),
            xlim = log10(xlim);
         end
         ylim = get(ax,'ylim');
         if strcmp(get(ax,'YScale'),'log'),
            ylim = log10(ylim);
         end
         limits=[xlim ylim; ax ax 0 0];
      elseif size(limits)==[1 4],
         limits = [limits;ax ax 0 0];
      end
      if xdir,
         limits(2,1) = na;
      end
      if ydir,
         limits(2,2) = na;
      end            
      feval(setcmd,get(ax,'ZLabel'),propname,limits);
   end
elseif strcmp(mode, 'disconnect')
   for i=1:length(allAxes),
      ax = allAxes(i);
      limits = feval(getcmd,get(ax,'ZLabel'),propname);
      if ~isempty(limits)&(size(limits,2)==4 & size(limits,1)==2),
         % check existing connectivity
         nax = limits(2,1);
         if xdir & nax~=ax,
            % Axes are in a x-connect-list
            % get predecessor to free it
            pa = get_xpredecessor(ax,getcmd,propname);
            plimits = feval(getcmd,get(pa,'ZLabel'),propname);
            plimits(2,1) = nax;
            feval(setcmd,get(pa,'ZLabel'),propname,plimits);
            limits(2,1) = ax;
            feval(setcmd,get(ax,'ZLabel'),propname,limits);
         end
         nay = limits(2,2);
         if ydir & nay~=ax,
            % Axes are in a y-connect-list
            % get predecessor to free it
            pa = get_ypredecessor(ax,getcmd,propname);
            plimits = feval(getcmd,get(pa,'ZLabel'),propname);
            plimits(2,2) = nay;
            feval(setcmd,get(pa,'ZLabel'),propname,plimits);
            limits(2,2) = ax;
            feval(setcmd,get(ax,'ZLabel'),propname,limits);
         end
      end      
   end
end


function pa = get_xpredecessor(ax,getcmd,propname)
limits = feval(getcmd,get(ax,'ZLabel'),propname);
pa = ax;
h = limits(2,1);

while h ~= ax,
   pa = h;
   next = feval(getcmd,get(h,'ZLabel'),propname);
   if all(size(next)==[2 4]), h = next(2,1); else h = ax; end
end


function pa = get_ypredecessor(ax,getcmd,propname)
limits = feval(getcmd,get(ax,'ZLabel'),propname);
pa = ax;
h = limits(2,2);

while h ~= ax,
   pa = h;
   next = feval(getcmd,get(h,'ZLabel'),propname);
   if all(size(next)==[2 4]), h = next(2,2); else h = ax; end
end

