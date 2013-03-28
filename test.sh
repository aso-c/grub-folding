#! /bin/sh
set -e

# The test of shell programming


. "./foldlib"


#=[ const part ]===============================================================

#sysconfdir="/etc"
#grub_mkcfg_dir="${sysconfdir}/grub.d"
grub_mkcfg_dir="cfg-test"


#=[ end of const part ]========================================================




# Calling from folding marker 
_infolding='Yes'
export _infolding

# Insert folding section in config file function
# Parameters:
#   $1 - OS class
remark_insert()
{
## control string for sed for search control comment: '### Begin...' & insert file name
#echo "
#/$(mark "BEGIN\ $(echo $grub_mkcfg_dir/$(sect_fn $1 $p)| sed 's/\//\\&/'g)")/ r $(sect_fn $1 $p)
#/$(mark "BEGIN\ $(echo $grub_mkcfg_dir/$(sect_fn $1 $e)| sed 's/\//\\&/'g)")/ r $(sect_fn $1 $e)
#"
echo "
/$(fullmark $BEG $(sect_fn $1 $p))/ r $(sect_fn $1 $p)
/$(fullmark $BEG $(sect_fn $1 $e))/ r $(sect_fn $1 $e)
"
} # remark_insert()------------------------------------------------------------

# Insert folding section in config file function
# Parameters:
#   $1 - OS class (win/gentoo)
#   $2 - sect class (prolog/epilog)
remark_insert2()
{
## control string for sed for search control comment: '### Begin...' & insert file name
#echo "
#/$(mark "BEGIN\ $(echo $(sect_fn $1 $p)| sed 's/\//\\&/'g)")/ r $(sect_fn $1 $p)
#/$(mark "BEGIN\ $(echo $(sect_fn $1 $e)| sed 's/\//\\&/'g)")/ r $(sect_fn $1 $e)
#"
echo "
/$(fullmark $BEG $(sect_fn $1 $2))/! b end

n
/$(fullmark $EN $(sect_fn $1 $2))/! end
i \\
$($grub_mkcfg_dir/$(sect_fn $1 $2) | sed 's/\\/\\\\/g; s/[#; {}//]/\\&/g; $!s/.$/&\\/g')

:end
"
} # remark_insert2()-----------------------------------------------------------


# Safe string
safe="!!!Reserved!!!"

# Insert folding section in config file function
# on file insertion & full control of output (-n option)
# Parameters:
#   $1 - OS class (win/gentoo)
#   $2 - sect class (prolog/epilog)
final_mark()
{
${grub_mkcfg_dir}/$(sect_fn $1 $2) > "$tmprefix$(sect_fn $1 $2)"
sed -e "/$(fullmark $BEG $(sect_fn $1 $2))${safe}/ {
r $tmprefix$(sect_fn $1 $2)
s/${safe}//
}"
rm -f "tmprefix$(sect_fn $1 $2)"
} # final_mark()---------------------------------------------------------------


echo '==========================================================================================\n'
#echo '$win insertion'
#remark_insert $win

#echo '---------------------------------------------------\n'
#echo '$gen insertion'
##remark_insert $gen
#remark_insert2 $gen

#sed  -ne "$(remark_insert2 $win $p)" | sed -ne "$(remark_insert2 $win $e)"
#final_mark $win $p | final_mark $win $e |
#final_mark $gen $p | final_mark $gen $e

#remark_insert $win
remark_insert2 $win $p
sed -e "$(remark_insert2 $win $p)"
#sed -e "$(remark_insert3 $win $e)" |...
