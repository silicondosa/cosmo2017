# CoSMo Day 6

## Bayesian Brains
* look at the slides.

### Steps in MATLAB
* add 'dm-0.3.1' to path
* load phs_[ah/eh/jd/jp/mk/mm].mat
* plot_psych_chron(cohs, choice, rt)
* plot_speed_accuracy
* plot_rt_quant(cohs, choice, rt)
* plot_rt_dist(cohs, choice, rt)
* sim_ddm
* fit_psych_chron(cohs, choice, rt)
* clear all; load rs_b.mat
* plot_fitted_rt_dists(cohs, choice, rt)
* plot_dp_valueintersect_point(mu0, cost) %

### Questions
* Drift Diffusion Model (DDM)
* In DDM, adding a sigma_z(noise variance), need to add the sqrt(delta t).sigma_z - but why?
* More Questions in the notes
* Sequential probability ratio test (SPRT)?
