function [np,gam,hm,tm,hv,tv] = var2diuv (nd,x,y,u,v,nlag,xlag,xltol,ndir,azm, ...
                atol,bandw,nvarg,ivtail,ivhead,ivtype,nvar,option )
%
%
% 	Variogram of 2-D Irregularly Spaced Velocity Data
%
% Modified from vario2di to compute the variogramme of the current
% components. 
%
% This subroutine computes a variety of spatial continuity measures of a
% set of irregularly spaced velocity data.  The user can specify any 
% combination of direct and cross variograms using any of eight
% "variogram" measures
%
%
%
% INPUT VARIABLES:
%
%   nd               Number of data (no missing values)
%   x(nd)            X coordinates of the data
%   y(nd)            Y coordinates of the data
%   u(nd,nv)	     East-West current
%   v(nd,nv)	     north-south current
%   tmin,tmax        Trimming limits
%   nlag             Number of lags to calculate
%   xlag             Length of the unit lag
%   xltol            Distance tolerance (if <0 then set to xlag/2)
%   ndir             Number of directions to consider
%   azm(ndir)        Azimuth angle of direction (measured positive
%                      degrees clockwise from NS).
%   atol(ndir)       Azimuth (half window) tolerances
%   bandw(ndir)      Maximum bandwidth (i.e., the deviation in the
%                      direction perpendicular to the defined azimuth).
%   nvarg            Number of variograms to compute
%   ivtail(nvarg)    Variable for the tail of each variogram
%   ivhead(nvarg)    Variable for the head of each variogram
%   ivtype(nvarg)    Type of variogram to compute:
%                      1. semivariogram
%                      2. cross-semivariogram
%                      3. covariance
%                      4. correlogram
%                      5. general relative semivariogram
%                      6. pairwise relative semivariogram
%                      7. semivariogram of logarithms
%                      8. rodogram
%                      9. madogram
%                     10. indicator semivariogram: an indicator variable
%                         is constructed in the main program.
%   nvar             Number of variables
%   option	     'parallel' or 'perpendi'
%
%
% OUTPUT VARIABLES:  The following arrays are ordered by direction,
%                    then variogram, and finally lag, i.e.,
%                      iloc = (id-1)*nvarg*MAXLG+(iv-1)*MAXLG+il
%
%   np()             Number of pairs
%   dis()            The average distance of pairs in this lag
%   gam()            Semivariogram, covariance, correlogram,... value
%   hm()             Mean of the tail data
%   tm()             Mean of the head data
%   hv()             Variance of the tail data
%   tv()             Variance of the head data

%   INPUT VARIABLES

tmin = -1e21;
tmax = +1e21;

%   VARIOGRAMME

[np, dis, gam, hm, tm, hv, tv] = gamv2uv (nd,x,y,u,v,tmin,tmax,nlag,...
		xlag,xltol,ndir,azm, atol,bandw,nvarg,ivtail,ivhead,...
		ivtype,nvar,option );

%   OUTOUT VARIABLES

[np, gam, hm, tm, hv, tv] = outvario(nlag+2,dis,ndir,nvarg,np,gam,hm,tm,hv,tv,ivtype);


 