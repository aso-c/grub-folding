#! /bin/sh
set -e

#
# Третий, окончательный вариант выражения для выборки всей секции в pattern space.

_dev=1
export _dev

. "./folding"

#grub_mkcfg_dir="cfg-test"
#grub_mkcfg_dir='/etc/grub.d'


# The test of shell programming

out_cfg='babc ddu -rrt'
#
echo "out_cfg is '$out_cfg', len ${#out_cfg}"
#echo "out_cfg is '${out_cfg:0}'"
echo `expr "$out_cfg" : '-.'`       # 8
#if ! expr "$out_cfg" : "-."> /dev/null; then
##if [ "za" = "z." ]; then
##if test "x${out_cfg}" = "x"; then
#  echo "This is True"
#else
#  echo "This is false"
#fi

#sed 's/\//\\&/'g

# ------------------------------------------------------------------------------



## Echoing string for test regexp & all for section markup
## Parameters: None
##   $1 - ...
echo_test()
{
	fullavoidcmt='/\(\([^{]*\\n\)\?[^#{\\n]\+\)\?/'
#	blkcmt='([^#{\\n]*)'
#	blkcmt='((.*\\n)?[^#\\n]+)?'
#   первый рабочий вариант выражения, отбрасывающий комментарии
#	blkcmt='(.*\\n[^#\\n]*)?'
#   второй работающий вариант регекспа, исключающий комментарии перед обънктом
#   но допускающий множество произвольных строк до того.
#	blkcmt='([^#\\n]*(#[^\\n]*)?\\n)*[^#\\n]*'
#   третий вариант - для вложенных скобок,
#   предовращает появление '{' и '}' на защищаемых интервалах.
	blkcmt='([^{#}\\n]*(#[^\\n]*)?\\n)*[^{#}\\n]*'
#	blkcmt='([^#\\n]*)|(.*\\n[^#\\n]*)'
	echo "$(shield1 $blkcmt)" >&2
	echo "/^$(shield1 $blkcmt})/" >&2

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
#  /^[^#{\n]*{[^#{\n]*}/! b presample
#  /^$(shield1 $blkcmt{$blkcmt})/! b presample
  /^$(shield1 "$blkcmt{($blkcmt{($blkcmt{$blkcmt})*$blkcmt})*$blkcmt}")/! b presample
#  /^$(shield1 $blkcmt})/! b
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


#
# Shielding
# for using in sed-scripts
#
# TODO: Замена должна иметь вид:
# [' ', '(', ');, '|'] -> ['\ ', '\(', '\)', '\|'] ; возможно что-то ещё, например '\'
# &[' ', '(', ');, '|'] -> [' ', '(', ');, '|'] ; отменяет действие, сохраняет первоначальный вид 
# && -> & ; отменяет действие '&'
# -i, --slash-screening - экранирование символа обратной косой (по умолчанию - нет)
# -b, --space-ignore - не экранировать пробелы
#shield1()
shield()
{
# 	local subst='|(+)?'

    main_subst()
    {
	# The order is important!
	# The List like '[|(+)?]' - same at all function code.
#	echo "${*}" | sed -e 's/\([^&]\|&&\)\([|(+ )?]\)/\1\\\2/g' |
	sed -e 's/\([^&]\|&&\)\([|(+ )?]\)/\1\\\2/g' |
	sed -e 's/\([|(+ )?]\)\([|(+ )?]\)/\1\\\2/g; s/^[|(+ )?]/\\&/g' |
	sed -e "s/\([^&]\)&\([|(+ )?]\)/\1\2/g" |
	sed -e "s/\([|(+ )?]\)&\([|(+ )?]\)/\1\2/g" |
	sed -e 's/&&/\&/g' #|	sed -e 's/\n/\\\\n/g'
    } # main_subst()


    if [ "$1no" = 'no' ] ; then
# 	echo 'First parameter is absent'
	# use in pipe-mode
	main_subst
     else
# 	echo 'First parameter is present'
# 	echo $*
# 	echo
	# use parameter as inpur
	echo "${*}" | main_subst
    fi
#     echo "${*}" | main_subst
} # shield


#
# Test for shielding space
# for using in sed-scripts
shield3()
{
#    echo "${*}" | sed 's/ /\\&/'g
    echo "${*}" | sed 's/[ \/]/\\&/'g
} # shld3


# # Create marker
# mark() {
# local MARK='###'
# #echo "$MARK\ $1\ $MARK"
# echo "$MARK $* $MARK"
# } # mark() ---------------------------------------
#
# # Create full format marker string
# # Paramatars:
# #   $1 - 'BEGIN' / 'END'
# #   $2 - full file name
# fullmark()
# {
# #sed 's/\//\\&/'g <<EOF
# #$(mark "$1\ $grub_mkcfg_dir/$2")
# #EOF
#     echo "$(shield $(mark $1 $grub_mkcfg_dir/$2))"
#     echo "$(mark $1 $grub_mkcfg_dir/$2)"
# } # fullmark() -----------------------------------


# echo 'Mark'
#
# #echo "$(fullmark $BEG $(sect_fn $gen $p))"
# #echo "$(fullmark $BEG $(sect_fn $win $e))"
# #echo "$(shield '### /abc/def/(ghi|klmn) ###')"
# echo "gen: $gen"
# echo "p: $p"
# echo "BEG: $BEG"
# #echo "$(fullmark $BEG _$gen-$p)"
# echo "$(shield "$(fullmark $BEG _$gen-$p)")"
# #echo "$(shield '### /abc/def/(ghi|klmn) ###')"
# echo '==[ Remark ]=============================================================\n'

#echo_remark $win
#sed -e "/aaa/!b;n;s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $1 $2))\)#.*/\2 -i/e"


# Вариант: замена сразу обоих типов файлов секций - _[gen,win]-prolog за один проход sed
#sed -e "/aaa/!b;n;s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/)\)_\($gen\|$win\)-\($p\)#.*/\2_\3-\4 -i/e"
#sed -e "s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/)\)_\($gen\|$win\)-\($p\)#.*/\2_\3-\4 -i/e"
#echo "/aaa/!b;n;s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/)\)_\($gen\|$win\)-\($p\)#.*/\2_\3-\4 -i/e"

#sed $allopts -e "$(echo_test)"

#echo '==[ echo_test ]==========================================================\n'
#echo "$(echo_test)"

# echo '==[ Insert ]=============================================================\n'
#
# #echo_final $win $p
#
# #fullmark $win $p
#
# echo '\nsect_extracted content:'
# echo '=========================\n'
# cat sect_extracted
# echo ''

echo '==[ Shield ]============================================================\n'
shield '(+abc+cde)?rlq+(dfg)(gge|uud)?\n abc&+cde&?&+&(gfk&|dfe&)\n&&qqq&&+&&(ppp&&|mrm?&)'
aaa=$(shield 'abba\\nbabba')
echo "$aaa" >&2

uuu=" aaa bbb/ccc ddd/eee fghe  uuuuuuu!!!"
echo "${uuu}"
shield3 "${uuu}"

echo '==[ echo_cmd() ]=========================================================\n'
echo
echo_cmd gen prolog