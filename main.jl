## Setup dependencies 
using Pkg
Pkg.instantiate()
Pkg.activate(".")
using ASCertain
using CertificationTools:plot_partition
using LinearMPC:mpc_examples 

## Setup problem 

mpQP, Θ = mpc_examples("invpend");
#mpQP, Θ = mpc_examples("aircraft");
#mpQP, Θ = mpc_examples("dcmotor");
cert_prob = DualCertProblem(mpQP,normalize=false);
cert_prob,Θ,mpQP = ASCertain.normalize(cert_prob,Θ,mpQP);


## Run certification
opts = CertSettings();
opts.storage_level = 2; # Store all regions
opts.verbose = 1; # Only print final results
AS = Int64[];
@time (part,iter_max) = certify(cert_prob,Θ,AS,opts);

## Visualize result
plot_partition(part)
