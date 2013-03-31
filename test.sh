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


# Echoing control string for insert folding section
# in config file function on file insertion
# Parameters:
#   $1 - OS class (win/gentoo)
#   $2 - sect class (prolog/epilog)
echo_final()
{
#echo "!/$(fullmark $BEG $(sect_fn $1 $2))/ b exit
##h   # hold current string
#/$(fullmark $EN $(sect_fn $1 $2))/ {
##x   # exchange hold & pattern space
##r $tmprefix$(sect_fn $1 $2)
#}
#
#:exit
#"

#echo "/$(fullmark $BEG $(sect_fn $1 $2))/! ctra-ta-ta"
echo "$ b"	# break processing, output
echo "/$(fullmark $BEG $(sect_fn $1 $2))/! b"
#echo 'p'
#echo 'ctra-ta-ta'
echo 'h'	# hold current string
#echo 'd'	# delete pattern space
echo 's/.*//'	# clear pattern space
echo 'n'	# read new line
echo "/$(fullmark $EN $(sect_fn $1 $2))/! {x; G; b}"
#echo "/$(fullmark $EN $(sect_fn $1 $2))/! {"
#    #echo 'ctututu'
#    echo 'x'	# retreat 1'st string
#    echo 'G'	# add 2'nd string
#    echo 'b'
#echo '}'

echo 'x'	# exchange hold & pattern space
echo "appa-appa-appa\\na$(fullmark $EN $(sect_fn $1 $2))"
echo 'b'	# exit


#echo ''
#echo ':exit'


} # echo_final()---------------------------------------------------------------


# Safe string
safe="!!!Reserved!!!"

# Insert folding section in config file function on file insertion
# Parameters:
#   $1 - OS class (win/gentoo)
#   $2 - sect class (prolog/epilog)
final_mark()
{
#${grub_mkcfg_dir}/$(sect_fn $1 $2) > "$tmprefix$(sect_fn $1 $2)"

#sed -e "/$(fullmark $BEG $(sect_fn $1 $2))/ {
#r $tmprefix$(sect_fn $1 $2)
#s/${safe}//
#}"

#sed -e "/$(fullmark $BEG $(sect_fn $1 $2))/! b
##h   # hold current string
#/$(fullmark $EN $(sect_fn $1 $2))/ {
##x   # exchange hold & pattern space
##r $tmprefix$(sect_fn $1 $2)
#}
#
#"


sed -e "$(echo_final $1 $2)"
#echo "$(echo_final $1 $2)"

#rm -f "tmprefix$(sect_fn $1 $2)"
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

#echo "$(echo_final $win $e)"

#sed -e "$(echo_remark $win)"    |
#sed -e "$(final_mark $win $p)"  |
#sed -e "$(echo_remark $gen)"

final_mark $win $p
#sed -e "$(echo_final $win $p)"
#echo "$(echo_final $win $p)"

#sed -e "$(remark_insert3 $win $e)" |...
