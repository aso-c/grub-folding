#! /bin/sh
set -e

. "./foldlib"

#grub_mkcfg_dir="cfg-test"
grub_mkcfg_dir='/etc/grub.d'


# The test of shell programming

#out_cfg='babc ddu -rrt'
#
#echo "out_cfg is '$out_cfg', len ${#out_cfg}"
##echo "out_cfg is '${out_cfg:0}'"
#echo `expr "$out_cfg" : '-.'`       # 8
#if ! expr "$out_cfg" : "-."> /dev/null; then
##if [ "za" = "z." ]; then
##if test "x${out_cfg}" = "x"; then
#  echo "This is True"
#else
#  echo "This is false"
#fi

#sed 's/\//\\&/'g

# ------------------------------------------------------------------------------


echo_final()
{
echo "/$(fullmark $BEG $(sect_fn $1 $2))$safe/ {
r $tmprefix$(sect_fn $1 $2)
s/${safe}//
}"
#r $tmprefix$(basename $(sect_fn $1 $2))

} # echo_final()---------------------------------------------------------------


# Echoing string for varkup section in config file function
# Parameters:
#   $1 - OS class (gen, win...)
echo_remark()
{

echo "
/\([^#]*.*menuentry\)\([^#].*$(o_name $1)\)/! b end  # detect start of section /menuentry <OS_Name>/

i\\
\\\n$(fullmark $BEG $(sect_fn $1 $p))$safe
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
\\\n$(fullmark $BEG $(sect_fn $1 $e))$safe
i\\$(fullmark $EN $(sect_fn $1 $e))\\\n

:end
"

} # echo_remark() -------------------------------------------------------------------------


echo '==[ Remark ]==============================================================================\n'

echo_remark $win

echo '==[ Insert ]==============================================================================\n'

echo_final $win $p

#fullmark $win $p
