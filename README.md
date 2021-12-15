# Airineme experimental data and codes


## I. airineme code
- F2_MSD_CCDF
  - To create CCDF in Figure 2:  
    - ccdf_dataPrep.m: load trajectory coordinate textfile and create matfile called experimental_ccdf.mat
    - F2_ccdf.m: load experimental_ccdf.mat and create complementary cummulative distribution function(CCDF)
  - To create MSD in Figure 2:  
    - msd_bins.m: load trajectory coordinate textfiles and create matfile called experimental_msd.mat
    - F2_MSD.m: load experimental_msd.mat and create mean squared displacement plot(MSD).
- F4
  - F4_main.m: use trajectory coordinates of airineme and compute the angular diffusion Dtheta value.
- SF5_directionSensing
  - expeimental_angle.m: use angle values from Airineme-Xan-Mel Coordinates with +-signs.xlsx and examine the target cell contact angle distribution 

## II. airineme data

  - trajectory coordinates
    - Airineme trajectory coordinates text files for each airineme microscopy image, and simulated data
  - matFiles
    - experimental_ccdf.mat
    - experimental_msd.mat
    - trajectory_matfiles: load all the trajectory coordinates text files and create a matfile

  - Airineme-Xan-Mel Coordinates with +-signs.xlsx
