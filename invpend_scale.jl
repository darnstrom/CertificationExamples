## Setup dependencies 
using Pkg
Pkg.instantiate()
Pkg.activate(".")
using ASCertain
using LinearMPC:mpc_examples 

## Run certification 

# Setup settings
opts = CertSettings();
opts.storage_level = 0; # 0 store nothing, 2 store everything
opts.store_regions = false;

# Warm up (to invoke compilation)
opts.verbose = 0 
mpQP_pre,Θ_pre,_ = mpc_examples("invpend");
part_pre,iter_max_pre,_,_ASs_pre = certify(mpQP_pre,Θ_pre,Int64[]; opts);
# Run the actual example
for N in 2:2:10
    println(">>>>>>>>>> N = $N <<<<<<<<<<<<<<")
    mpQP,Θ,mpc = mpc_examples("invpend",50,N);
    @time (part,iter_max,_,ASs) = certify(mpQP,Θ,Int64[]; opts);
end


