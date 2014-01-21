#! /bin/sh
set -e

_dev=1
export _dev

#. "./foldlib"
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


## Echoing string for varkup section in config file function
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

##
## Shielded Slash
## for using in sed-scripts
#shldslash()
#{
#    echo $1 | sed 's/\//\\&/'g
#} # shldslash

echo 'Mark'

echo "$(fullmark $BEG $(sect_fn $gen $p))"
echo "$(fullmark $BEG $(sect_fn $win $e))"

echo '==[ Remark ]==============================================================================\n'

#echo_remark $win
#sed -e "/aaa/!b;n;s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $1 $2))\)#.*/\2 -i/e"

# Htfkbpfwbz замены имени файла через exec-комментарий (командный комментарий),
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
#teta="s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $gen $p))\)\([^#]*\)/\\2 -i /e"
teta="s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $win $p))\)\([^#]*\)/\\2\\3 /e"
sed -e "${teta}"
#sed -e "/aaa/!b;n;s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/$(sect_fn $gen $p))\)\([^#]*\)/\2 -i/e"
echo "${teta}"


# Вариант: замена сразу обоих типов файлов секций - _[gen,win]-prolog за один проход sed
#sed -e "/aaa/!b;n;s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/)\)_\($gen\|$win\)-\($p\)#.*/\2_\3-\4 -i/e"
#sed -e "s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/)\)_\($gen\|$win\)-\($p\)#.*/\2_\3-\4 -i/e"
#echo "/aaa/!b;n;s/\(# exec!\)\($(shldslash ${grub_mkcfg_dir}/)\)_\($gen\|$win\)-\($p\)#.*/\2_\3-\4 -i/e"

echo '==[ Insert ]==============================================================================\n'

#echo_final $win $p

#fullmark $win $p
