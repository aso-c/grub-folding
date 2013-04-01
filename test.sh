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



# Echoing control string for insert folding section
# in config file function on file insertion
# Parameters:
#   $1 - OS class (win/gentoo)
#   $2 - sect class (prolog/epilog)
echo_final()
{
cat <<-EOF
    /$(fullmark $BEG $(sect_fn $1 $2))/! b; $ b # stop current line processing
    h; s/.*//; n	# hold && clear pattern space; read new lone
    /$(fullmark $EN $(sect_fn $1 $2))/! {x; G; b}
    # exchange & output file after restored str
    x; r $tmprefix$(sect_fn $1 $2)
EOF
} # echo_final()---------------------------------------------------------------



# Insert folding section in config file function on file insertion
# Parameters:
#   $1 - OS class (win/gentoo)
#   $2 - sect class (prolog/epilog)
remark_insert()
{
sed -e "$ a$(fullmark $EN $(sect_fn $1 $2))" << EOF > "$tmprefix$(sect_fn $1 $2)"
$(${grub_mkcfg_dir}/$(sect_fn $1 $2))
EOF

sed -e "$(echo_final $1 $2)"
#echo_final $1 $2

rm -f "$tmprefix$(sect_fn $1 $2)"
} # remark_insert()------------------------------------------------------------


# Echoing string for varkup section in config file function
# Parameters:
#   $1 - OS class (gen, win...)
echo_remark()
{
cat << EOF
    /\([^#]*.*menuentry\)\([^#].*$(o_name $1)\)/! b; $ b # if section /menuentry <OS_Name>/ was not started - exit
    i$(fullmark $BEG $(sect_fn $1 $p))
    i$(fullmark $EN $(sect_fn $1 $p))\\n

:consect		# continue sampling section
    n; /^}/! b consect

:interch		# final of section. Sampling iterval between sections
    n
    /[^#]*.*menuentry/ {	# detect new section
	/[^#]*.*$(o_name $1)/ b consect	# new section is desired
	b close			# new section is not desired
    }
    /### \($BEG\)\|\($EN\)/ b close	# detect new section, marked by control comments
    b interch

:close
    i$(fullmark $BEG $(sect_fn $1 $e))
    i$(fullmark $EN $(sect_fn $1 $e))\\n
EOF

} # echo_remark() -------------------------------------------------------------------------


echo '==========================================================================================\n'
echo '$win insertion'

#echo '---------------------------------------------------\n'
echo '$gen insertion'

#sed  -ne "$(remark_insert2 $win $p)" | sed -ne "$(remark_insert2 $win $e)"
#final_mark $win $p | final_mark $win $e |
#final_mark $gen $p | final_mark $gen $e

#echo_final $win $e

#sed -e "$(echo_remark $win)"
sed -e "$(echo_remark $win)"	|
sed -e "$(echo_remark $gen)"	|
remark_insert $win $p	|
remark_insert $win $e	|
remark_insert $gen $p	|
remark_insert $gen $e

#sed -e "$(remark_insert3 $win $e)" |...
