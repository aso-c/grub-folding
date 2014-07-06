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
# -i, --slash-screening - экранирование символа косой '/' (по умолчанию - нет)
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
	# use in pipe-mode
	main_subst
     else
	# use parameter as input
	echo "${*}" | main_subst
    fi
} # shield


#
# Shielding
# for using in sed-scripts
# Simplified sintaxis:
#	any symbols from set: {| (+ )?} -> \{original_symbol}
#	single symbol \ w/o {| (+ )?}   -> \\{original_symbol}
#	char chain \{| (+ )?}           -> {original_symbol} (w/o '\')
#       char chain \\                   -> \
# TODO: Замена должна иметь вид:
# [' ', '(', ');, '|'] -> ['\ ', '\(', '\)', '\|'] ; возможно что-то ещё, например '\'
# &[' ', '(', ');, '|'] -> [' ', '(', ');, '|'] ; отменяет действие, сохраняет первоначальный вид 
# && -> & ; отменяет действие '&'
# -i, --slash-screening - экранирование символа косой '/' (по умолчанию - нет)
# -b, --space-ignore - не экранировать пробелы
# -n, --no-std-subst - не делать стандартную подстановку
shield2()
{
# 	local subst='| (+)?'

	    local subst_base='|(+)?'
#	    local subst=" ${subst_base}"
	    local subst='|(+ )?'

    # parameter - substitution string
    main_subst()
    {
# 	    local subst_base='|(+)?'
# 	    local subst="$(subst_base) "

	# The order is important!
	# The List like '[|(+)?]' - same at all function code.
	#sed -e 's/[|(+ )?]/\\&/g'
	#sed -e "s/[|(+ )?]/\\\&/g"
	#sed -e "s/[${subst}]/\\\&/g"
	sed -e "s/[${1}]/\\\&/g;" -e "s/\(\\\\\\\\\)\([${1}]\)/\2/g"
	# -e 's/\\\\/\&/g'
	# -e 's/\(\\\\\)\([${1}]\)/\2/g'
	# -e "s/\\\+[^${1}]/\\\&/g"
#	echo "s/[${subst}]/\\\&/g"
    } # main_subst()

    echo "options in: ${*}"
    echo '\n'


    cfg=''
    # Processing the arguments.
    while getopts ibn f
    do
	case $f in
	b)
	    # не экранировать пробелы
	    echo '--=** No space screening **=--'
	    cfg="b$cfg"
	    ;;
	i)
	    # экранировать косую ('/')
	    echo "--=** Screening the slash - '/' **=--"
	    cfg="i$cfg"
	    ;;
	n)
	    # отменить стандартные подстановки
	    echo '--=** Std subst is canceled **=--'
	    cfg="n$cfg"
	    ;;
# 	--)
#  	    break ;;
#  	# Explicitly ignore unexpected options, for compatibility.
#  	-*)
#  	    #allopts="$allopts $option"
#  	    ;;
	esac
    done
    shift `expr $OPTIND - 1`

    echo "\noptions out: $*\n"
    echo "cfg is: $cfg"

#    expr index ublia n
    if [ "$(expr index ${cfg}u n)" != 0 ] ; then
	echo 'Stdandard subst canceled'
#	subst="$(echo "${subst}")"
	subst="$(echo "${subst}" | sed -e 's/[|(+)?]//g')"
    fi

   if [ "$(expr index u$cfg b)" != 0 ] ; then
	echo 'Space screening is cancelled'
	subst="$(echo "${subst}" | sed -e 's/ //g')"
#	subst="$(echo $subst)"
    fi

    if [ "$(expr index u$cfg i)" != 0 ] ; then
	echo "Screening the slash - '/'"
	subst="/$subst"
    fi

    echo "subst is [${subst}]"

    if [ "$1no" = 'no' ] ; then
	# use in pipe-mode
	main_subst "${subst}"
     else
	# use parameter as input
	echo "${*}" | main_subst "${subst}"
    fi
} # shield2


#
# Test for shielding space
# for using in sed-scripts
shield3()
{
#    echo "${*}" | sed 's/ /\\&/'g
    echo "${*}" | sed 's/[ \/]/\\&/'g
} # shld3


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
#shield '(+abc+cde)?rlq+(dfg)(gge|uud)?\n abc&+cde&?&+&(gfk&|dfe&)\n&&qqq&&+&&(ppp&&|mrm?&)'
shield2 $* '(+abc+cde)?rlq+(dfg)(gge|uud)?\n abc\+cde\?\+\(gfk\|dfe\)\n\\qqq\\+\\(ppp\\|mrm?\)\nabba\babba\\bambra\carramba'
#aaa=$(shield 'abba\\nbabba')
# aaa=$(shield2 $* 'abba\\nbabba')
# echo "$aaa" >&2
#
# uuu=" aaa bbb/ccc ddd/eee fghe  uuuuuuu!!!"
# echo "uuu is: ${uuu}"
#echo "uuu 2:3 ${uuu:2:3}"
#shield3 "${uuu}"
#shield2 $* "${uuu}"
echo '\I
\\II
\\\III
\\\\IIII
\\\\\V
\\\\\\VI' | shield2 $*

# echo "arifmeical expr: $(( 10 == 20 ))"
# echo $? # код возврата


# echo '==[ echo_cmd() ]=========================================================\n'
# echo
# echo_cmd gen prolog
