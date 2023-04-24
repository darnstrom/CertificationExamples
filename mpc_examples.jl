## Setup dependencies 
using Pkg
Pkg.instantiate()
Pkg.activate(".")
using ASCertain
using LinearMPC:mpc_examples 

## Run certification 

# Setup settings
opts = CertSettings();
opts.storage_level = 2; # 0 store nothing, 2 store everything
opts.compute_chebyball = false;
opts.store_regions = true;
opts.minrep_regions = false;

# Warm up (to invoke compilation)
opts.verbose = 0 
mpQP_pre,Θ_pre,_ = mpc_examples("invpend");
certify(mpQP_pre,Θ_pre,Int64[]; opts,normalize=false);
# Run the actual example
opts.verbose = 1
results = []
for example in ["invpend","dcmotor", "nonlinear", "aircraft"]
    print("\n >>>>>>>>>>> $example <<<<<<<<<<<< ")
    mpQP,Θ,mpc = mpc_examples(example);
    @time (part,iter_max,_,ASs) = certify(mpQP,Θ,Int64[]; opts,normalize=false);
    push!(results,part)
end


## Visualize result
if opts.storage_level > 0 && opts.store_regions==true
    for r in results
        display(ASCertain.pplot(r))
    end
end
