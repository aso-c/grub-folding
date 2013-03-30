#! /bin/sh
set -e

# The test of shell programming


. "./foldlib"


#=[ const part ]===============================================================

#sysconfdir="/etc"
#grub_mkcfg_dir="${sysconfdir}/grub.d"
#grub_mkcfg_dir="cfg-test"
grub_mkcfg_dir="./my.grub.d"


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


# Echoing string for varkup section in config file function
# Parameters:
#   $1 - OS class (gen, win...)
echo_remark()
{
echo "
/\([^#]*.*menuentry\)\([^#].*$(o_name $1)\)/! b end  # detect start of section /menuentry <OS_Name>/

i\\
\\\n$(fullmark $BEG $(sect_fn $1 $p))
i\\$(fullmark $EN $(sect_fn $1 $p))\\\n

:consect		# continue sampling section
n
/^}/! b consect

:interch		# final of section. Sampling iterval between sections
n
/[^#]*.*menuentry/ {	# detect new section
/[^#]*.*$(o_name $1)/ b consect	# new section is desired
b close			# new section is not desired
}
/### \($BEG\)\|\($EN\)/ b close	# detect new section, marked by control comments
b interch

:close

i\\
\\\n$(fullmark $BEG $(sect_fn $1 $e))
i\\$(fullmark $EN $(sect_fn $1 $e))\\\n

:end
"
} # echo_remark() -------------------------------------------------------------------------


echo '==========================================================================================\n'
echo '$win insertion'

#echo '---------------------------------------------------\n'
echo '$gen insertion'

#sed  -ne "$(remark_insert2 $win $p)" | sed -ne "$(remark_insert2 $win $e)"
#final_mark $win $p | final_mark $win $e |
#final_mark $gen $p | final_mark $gen $e

sed -e "$(echo_remark $win)" |
#| sed -e "$(remark_insert2 $win $p)"
sed -e "$(echo_remark $gen)"

#sed -e "$(remark_insert3 $win $e)" |...
