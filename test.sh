#! /bin/sh
set -e

# The test of shell programming


_dev=1
export _dev

#. "./foldlib"
. "./folding"


#=[ const part ]===============================================================

#sysconfdir="/etc"
#grub_mkcfg_dir="${sysconfdir}/grub.d"
grub_mkcfg_dir="./my.grub.d"

## Generate section file name
## Parameters:
##   #1 - prefix, OS_name (gentoo, win),
##   #2 - tail {prolog | epilog}
#sect_fn() {
#echo "_$1-$2"
#} # sect_fn() ------------------------------------


#=[ end of const part ]========================================================


## Echoing control string for insert folding section
## in config file function on file insertion
## Parameters:
##   $1 - OS class (win/gentoo)
##   $2 - sect class (prolog/epilog)
#echo_final()
#{
#cat <<-EOF
#    /$(fullmark $BEG $(sect_fn $1 $2))/! b; $ b # stop current line processing
#    h; s/.*//; n	# hold && clear pattern space; read new lone
#    /$(fullmark $EN $(sect_fn $1 $2))/! {x; G; b}
#    # exchange & output file after restored str
#    x; r $tmprefix$(sect_fn $1 $2)
#EOF
#} # echo_final()---------------------------------------------------------------


## Echoing string for markup section in config file function
## Parameters:
##   $1 - OS class (gen, win...)
#echo_remark()
#{
#cat << EOF
#    /\([^#]*.*menuentry\)\([^#].*$(o_name $1)\)/! b; $ b # if section /menuentry <OS_Name>/ was not started - exit
#    i$(fullmark $BEG $(sect_fn $1 $p))
#    i # exec!$grub_mkcfg_dir/$(sect_fn $1 $p) -i #
#    i$(fullmark $EN $(sect_fn $1 $p))\\n
#
#:consect	# continue sampling section
#    n; /^}/! b consect
#
#:intersect	# out of section, sampling interval between sections
#    n; /### \($BEG\)\|\($EN\)/ b close	# control comment - close section
#    /[^#]*.*menuentry/! b intersect	# detect that not start of new section
#    /[^#]*.*$(o_name $1)/ b consect	# new section is started
#
#:close
#    i$(fullmark $BEG $(sect_fn $1 $e))
#    i# exec!$grub_mkcfg_dir/$(sect_fn $1 $e) -i #
#    i$(fullmark $EN $(sect_fn $1 $e))\\n
#EOF
#} # echo_remark() -------------------------------------------------------------------------


echo '==========================================================================================\n'

# echo 'win remark'
# echo "$(echo_remark $win)"


#echo "$win insertion"

#echo_final $win $p

#echo '---------------------------------------------------\n'
#echo "$gen insertion"

#echo_cmd 'gen' 'prolog'

#echo_final $gen $e

#sed  -ne "$(remark_insert2 $win $p)" | sed -ne "$(remark_insert2 $win $e)"
#final_mark $win $p | final_mark $win $e |
#final_mark $gen $p | final_mark $gen $e

#remark_insert2 $win $p | remark_insert2 $win $e |
#remark_insert2 $gen $p | remark_insert2 $gen $e

#echo "$(echo_remark win)"
# echo_remark win
# echo_final win $e
#echo "$(echo_final win $e)"

# #sed -e "$(echo_remark win)"
sed -e "$(echo_remark win)"	|
sed -e "$(echo_remark gen)"	|
sed -e "$(echo_final win $p)" |
sed -e "$(echo_final win $e)" |
sed -e "$(echo_final gen $p)" |
sed -e "$(echo_final gen $e)"
# #sed -e "$(echo_final win $e)"

#sed -e "$(remark_insert3 $win $e)" |...
#echo "$(echo_final win $p)"
