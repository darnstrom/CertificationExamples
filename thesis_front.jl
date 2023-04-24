## Setup dependencies 
using Pkg
Pkg.instantiate()
Pkg.activate(".")
using ASCertain
using LinearMPC:mpc_examples 

## Generate thesis front
using PGFPlotsX
using Colors
using ColorSchemes

# Load problem
mpQP, Θ = mpc_examples("aircraft")

# Setup certification settings
opts = CertSettings();
opts.storage_level = 2; # 0 store nothing, 2 store everything
opts.verbose = 1

# Run certification
@time (part,iter_max,~,ASs) = certify(mpQP,Θ,Int64[]; opts,normalize=false);

# Create plot
tot_ids = collect(1:10)
i,j = 2,6
fix_ids = setdiff(tot_ids,[i,j])
cmap = "RdBu"
opts = Dict(:colormap_name=>cmap)
fig = ASCertain.pplot(part;fix_ids,opts);
td = TikzDocument(TikzPicture(fig)); 
push_preamble!(td, (cmap, ColorSchemes.seaborn_icefire_gradient[1:end]));
display(td)

