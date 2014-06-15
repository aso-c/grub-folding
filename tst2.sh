#! /bin/sh
set -e

_dev=1
export _dev
#
# #. "./foldlib"
. "./folding"

#grub_mkcfg_dir="cfg-test"
#grub_mkcfg_dir='/etc/grub.d'


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


#echo_final()
#{
#echo "/$(fullmark $BEG $(sect_fn $1 $2))$safe/ {
#r $tmprefix$(sect_fn $1 $2)
#s/${safe}//
#}"
##r $tmprefix$(basename $(sect_fn $1 $2))
#
#} # echo_final()---------------------------------------------------------------


## Echoing string for markup section in config file function
## Parameters:
##   $1 - OS class (gen, win...)
#echo_remark()
#{
#
#echo "
#/\([^#]*.*menuentry\)\([^#].*$(o_name $1)\)/! b end  # detect start of section /menuentry <OS_Name>/
#
#i\\
#\\\n$(fullmark $BEG $(sect_fn $1 $p))$safe
#i\\$(fullmark $EN $(sect_fn $1 $p))\\\n
#
#:consect		# continue sampling section
#n
#/^}/! b consect
#
#:interch		# final of section. Sampling iterval between sections
#n
#/[^#]*.*menuentry/ {	# detect new section
#/[^#]*.*$(o_name $1)/ b consect	# new section is desired
#b close			# new section is not desired
#}
#/### \($BEG\)\|\($EN\)/ b close	# detect new section, marked by control comments
#b interch
#
#:close
#
#i\\
#\\\n$(fullmark $BEG $(sect_fn $1 $e))$safe
#i\\$(fullmark $EN $(sect_fn $1 $e))\\\n
#
#:end
#"
#
#} # echo_remark() -------------------------------------------------------------------------

## Echoing string for test regexp & all for section markup
## Parameters: None
##   $1 - ...
echo_test()
{
	fullavoidcmt='/\(\([^{]*\\n\)\?[^#{\\n]\+\)\?/'
#	blkcmt='([^#{\\n]*)'
	blkcmt='[^#{]*'
	echo "$(shield1 $blkcmt)" >&2
	echo "/^$(shield1 $blkcmt{$blkcmt})/" >&2

cat << EOF
#presample
 # if not matched /menuentry <OS_Name>/ - e.g. nedeed section was not started - exit
    /\([^#]*menuentry\)\([^#].*myunit\)/! b; $ b
  b strtsmpl
:presample
 # sampling menuentry section in pattern space
    N
:strtsmpl
#  /\n}/! b presample
#  /{.*}/! b presample
#  /\(^\|\n\)[^#{]*{\(\([^{]*\n\)\?[^#{]*{\([^}]*\n\)\?[^#}]*}\)*\([^}]*\n\)\?[^#}]*}/! b presample
#  /^\(\([^{]*\n\)\?[^#{\n]\+\)\?{\1}/! b presample
#  /^\(\([^{]*\n\)\?[^#{\n]\+\)\?{\1\?}/! b presample
#  /^\([^#{\n]\)*{\([^#{\n]\)*}/! b presample
#  /^[^#{\n]*{[^#{\n]*}/! b presample
  /^$(shield1 $blkcmt{$blkcmt})/! b presample
  #/.*[\^cfghi].*/! b
#  /\(^\|\n\)[^#]*{\(.*\n\)\\?[^#]*}/! b presample
  $ b
#-------------------------------------
	#  /\n}/! b presample
#  /[\n^][^#]*{\([^#\n]*\)\|\(\n[^#]*\)}/! b presample
#  /### \($BEG\)\|\($EN\)/ b             # control comment - go out
#  /\n[^#\n]*menuentry/! b presample     # detect that not start of new section - continue
#  /\n[^#\n]*$(o_name $1)/! b            # new section is not in sequence - go out
#-------------------------------------

  =
  w ./sect_extracted
  s/.*/--= This staff outputed =--\n/
  w ./sect_extracted
  s/.*/This is my unit menu!/
#  s/.*//
# out of first target section, sampling interval between sections
EOF
} # echo_remark() -------------------------------------------------------------------------


##
## Shielded Slash
## for using in sed-scripts
#shldslash()
#{
#    echo $1 | sed 's/\//\\&/'g
#} # shldslash


#
# Shielding
# for using in sed-scripts
#
# TODO: Замена должна иметь вид:
# [' ', '(', ');, '|'] -> ['\ ', '\(', '\)', '\|'] ; возможно что-то ещё, например '\'
# &[' ', '(', ');, '|'] -> [' ', '(', ');, '|'] ; отменяет действие, сохраняет первоначальный вид 
# && -> & ; отменяет действие '&'
shield1()
{
    # The order is important!
    # The List like '[|(+)?]' - same at all function code.   
    echo $* | #sed -e 's/\\n/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n/g' |
#    echo $* | sed -e 's/\(^\|[^&]\|&&\)\([|(+)?]\)/\1\\\2/g' |
	sed -e 's/\(^\|[^&]\|&&\)\([|(+)?]\)/\1\\\2/g' |
	sed -e 's/\([|(+)?]\)\([|(+)?]\)/\1\\\2/g' |
	sed -e "s/\([^&]\)&\([|(+)?]\)/\1\2/g" |
	sed -e "s/\([|(+)?]\)&\([|(+)?]\)/\1\2/g" |
	sed -e 's/&&/\&/g' #|	sed -e 's/\\n/\\\\n/g'
#    sed 's/[\/ (){|}]/\\&/'g
} # shield


# Create marker
mark() {
local MARK='###'
#echo "$MARK\ $1\ $MARK"
echo "$MARK $* $MARK"
} # mark() ---------------------------------------

# Create full format marker string
# Paramatars:
#   $1 - 'BEGIN' / 'END'
#   $2 - full file name
fullmark()
{
#sed 's/\//\\&/'g <<EOF
#$(mark "$1\ $grub_mkcfg_dir/$2")
#EOF
    echo "$(shield $(mark $1 $grub_mkcfg_dir/$2))"
    echo "$(mark $1 $grub_mkcfg_dir/$2)"
} # fullmark() -----------------------------------


echo 'Mark'

#echo "$(fullmark $BEG $(sect_fn $gen $p))"
#echo "$(fullmark $BEG $(sect_fn $win $e))"
#echo "$(shield '### /abc/def/(ghi|klmn) ###')"
echo "gen: $gen"
echo "p: $p"
echo "BEG: $BEG"
#echo "$(fullmark $BEG _$gen-$p)"
echo "$(shield "$(fullmark $BEG _$gen-$p)")"
#echo "$(shield '### /abc/def/(ghi|klmn) ###')"
echo '==[ Remark ]=============================================================\n'

#echo_remark $win
#sed -e "/aaa/!b;n;s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $1 $2))\)#.*/\2 -i/e"

# Реализация замены имени файла через exec-комментарий (командный комментарий),
# опция исполнения файла задаётся в сценарии
#sed -e "/aaa/!b;n;s/\(# exec\!\)\($(shldslash '${grub_mkcfg_dir}/$(sect_fn $gen $p)')\)#.*/\2 -i/e"
#sed -e "s/\(# exec\!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $gen $p))\)#.*/\2 -i/e"
#sed "s/\(# exec\!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $gen $p))\)#.*/\2 -i/e"
#echo "s/\(# exec\!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $gen $p))\)#.*/\2 -i/e"

# Замена имени исполняемого файла на вывод его исполнения,
# вариант с переменной сценария, и одновременным выводом через команду echo
# В заменяющей части команды s/// - \2 - добавлен лишний бэкслэш: \\2
#teta="s/\(# exec\!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $gen $p))\)#.*/\\2 -i/e"
#sed -e "${teta}"
#echo "$teta"


# Вариант со считыванием опции исполнения сценария из командного комментария.
# Сценарий в переменной shell.
##teta="s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $gen $p))\)\([^#]*\)/\\2 -i /e"
#teta="s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $win $p))\)\([^#]*\)/\\2\\3 /e"
#sed -e "${teta}"
##sed -e "/aaa/!b;n;s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $gen $p))\)\([^#]*\)/\2 -i/e"
#echo "${teta}"


# Вариант: замена сразу обоих типов файлов секций - _[gen,win]-prolog за один проход sed
#sed -e "/aaa/!b;n;s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/)\)_\($gen\|$win\)-\($p\)#.*/\2_\3-\4 -i/e"
#sed -e "s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/)\)_\($gen\|$win\)-\($p\)#.*/\2_\3-\4 -i/e"
#echo "/aaa/!b;n;s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/)\)_\($gen\|$win\)-\($p\)#.*/\2_\3-\4 -i/e"

sed $allopts -e "$(echo_test)"

#echo '==[ echo_test ]==========================================================\n'
#echo "$(echo_test)"

echo '==[ Insert ]=============================================================\n'

#echo_final $win $p

#fullmark $win $p

echo '\nsect_extracted content:'
echo '=========================\n'
cat sect_extracted
echo ''

echo '==[ Shield1 ]============================================================\n'
shield1 '(abc+cde)?rlq+(dfg)(gge|uud)?\n abc&+cde&?&+&(gfk&|dfe&)\n&&qqq&&+&&(ppp&&|mrm?&)'
aaa=$(shield1 'abba\\nbabba')
echo "$aaa" >&2
