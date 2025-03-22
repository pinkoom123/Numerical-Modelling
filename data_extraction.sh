#!/bin/bash

# Input files for each variable
rs_file="Net_surface.nc"  # Solar Radiation (avg_snswrf)
lh_file="Net_latentheat.nc"  # Latent Heat Flux (avg_slhtf)
sh_file="Net_sensible.nc"  # Sensible Heat Flux (avg_ishf)

# Output directory for saving processed files
output_dir="out_files"
mkdir -p "$output_dir"

# Extract data for the specific point (latitude: 9.08333300, longitude: -1.81666700)
savannah_rs="${output_dir}/savannah_rs.nc"
cdo sellonlatbox,-3.3667,0.75,7.5,11.05 "$rs_file" "$savannah_rs"

savannah_lh="${output_dir}/savannah_lh.nc"
cdo sellonlatbox,-3.3667,0.75,7.5,11.05 "$lh_file" "$savannah_lh"

savannah_sh="${output_dir}/savannah_sh.nc"
cdo sellonlatbox,-3.3667,0.75,7.5,11.05 "$sh_file" "$savannah_sh"

# Calculate Ground Heat Storage (GH = Rs - Lh - Sh)
savannah_gh="${output_dir}/savannah_gh.nc"
cdo expr,'GH=avg_snswrf-(avg_slhtf*-1)-(avg_ishf*-1)' -merge "$savannah_rs" "$savannah_lh" "$savannah_sh" "$savannah_gh"

# Calculate monthly means for each variable
rs_monthly="${output_dir}/rs_monthly.nc"
cdo ymonmean "$savannah_rs" "$rs_monthly"

lh_monthly="${output_dir}/lh_monthly.nc"
cdo ymonmean "$savannah_lh" "$lh_monthly"

sh_monthly="${output_dir}/sh_monthly.nc"
cdo ymonmean "$savannah_sh" "$sh_monthly"

gh_monthly="${output_dir}/gh_monthly.nc"
cdo ymonmean "$savannah_gh" "$gh_monthly"

# Calculate spatial means
rs_mean="${output_dir}/rs_mean.nc"
cdo fldmean "$rs_monthly" "$rs_mean"

lh_mean="${output_dir}/lh_mean.nc"
cdo fldmean "$lh_monthly" "$lh_mean"

sh_mean="${output_dir}/sh_mean.nc"
cdo fldmean "$sh_monthly" "$sh_mean"

gh_mean="${output_dir}/gh_mean.nc"
cdo fldmean "$gh_monthly" "$gh_mean"

echo "Data processing complete. Output files saved in: $output_dir"
