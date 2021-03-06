grub-folding
============

grub-mkconfig helper script for folding the sequence of similar
grub menu entries (as gentoo, gentoo... or Windows, Windows...)

###==[ en ]================================================

Config script the grub-folding is provide the folding of similar GRUB menu
entries sequence.
Each sequence of entries for Microsoft Windows or Gentoo OS loading separately
is included into submenu section.
Submenu section was implemented by insertion output of suitable section file
before or after sequention body. (Early version of grub-folder was inserting
immediately contents of suitable section files.)
Sequention of GRUB menu entries was not reordered.
User can be insert custom code before/after standart text of section file
(e.g. in or out submenu section with sequence).
Used subcommand "e" of sed "s///"-command for insertion the config helper script output
into the GRUB boot menu file.

The config script is create individual submenu for each group of consequtive
items GRUB boot menu for each type OS.
####List of supported OS in the GRUB boot menu is:
 - Microsoft Windows;
 - Gentoo.

####Project files:
    - folding      - the config script that creates a submenu from sequence of a homogeneous
                     menu items.
    - _gen-prolog  - Gentoo section prologue file; it can contain custom code,
                     that will be placed immediately before the submenu "Gentoo"
                     or inside submenu at the beginning of it.
                     Submenu title also given in that file.
    - _gen-epilog  - Gentoo section epilogue file; it can contain custom code,
                     that will be placed immediately after the submenu "Gentoo"
                     or inside submenu at the end of it.
    - _win-prolog  - Microsoft Windows section prologue file; it can contain custom code,
                     that will be placed immediately before the submenu "Microsoft Windows"
                     or inside submenu at the beginning of it.
                     Submenu title also given in that file.
    - _win-epilog  - Microsoft Windows section epilogue file; it can contain custom code,
                     that will be placed immediately after the submenu "Microsoft Windows"
                     or inside submenu at the end of it.
                     Submenu title also given in that file.

The project files are placed in /etc/grub.d directory.
All project files are executable scripts.
The "folding" script in the order of execution must follow after os_prober and before
user scripts (usually exec priority 40 and more), e.g. 31..39. (39_folding, for example).
Section files priority is absent, they used in its original form.
Execution in the GRUB configurator context are bypassed.
Expanding the list of supported OS'es is possibly by simple code modification &
define appropriate section files.

####For appending support of new OS needed:

 - choose the OS "short name", for example 'win' - it will be used in script;
 - create section files in the GRUB config dir; by default - /etc/grub.d;
    - section files must be execution shell script and should have names as:
        `_<short_name_OS>-prolog`,
        `_<short_name_ОС>-epilog`
       (for example: `_win-prolog`, `_win-epilog`);
    - section files may be created by copying an existing file;
    - in section file needed define submenu name, and enter custom text if necessary;
      (output of this files executions will be placed into grub.cfg; output into stderr
      (redirection >&2) - will be printed to screen).
 - define OS "long name", which will be determined that the menu item refers to this OS
      (for example 'Microsoft Windows');
 -  in the file 'folding' create variable with a name as are short name of the OS and a
      having long name of the OS (for example: win='Microsoft Windows');
 - append (by analogy with existing) handlers for this OS in the sequence of handlers in
      processing section at the end of the script file 'folding', for example:

        sed -e "$(echo_remark win)"     |
        sed -e "$(echo_final win $p)"   |
        sed -e "$(echo_final win $e)"

Consistency of the list supported operating systems provided by the user.

####TODO:
- exclude submenu creation if sequence of target OS'es menu entries already
  enclosed into submenu.

###==[ ru ]==================================================

Конфигурационный скрипт "grub-folding" обеспечивает сворачивание последовательности
из нескольких подобных пунктов меню загрузки GRUB (несколько установленных ОС
Microsoft Windows или несколько вариантов загрузки Gentoo) в один пункт меню
созданием подменю.
Последовательность пунктов меню не переупорядочивается.
Подменю организуется путём вставки перед началом и в конце массива однородных пунктов
загрузочного меню GRUB вывода соответствующего файла секции.
(Более ранние версии grub-folding вставляли непосредственно содержимое этих файлов).
Пользователь имеет возможность вставить собственный код/текст/пункты меню
непосредственно перед и/или после стандар тного кода подменю (т.е. в начале/конце
секции подменю с последовательностью - либо вне её).
Вставка вывода конфигурационных скриптов в файл загрузочного меню GRUB осуществляется
при помощи подкоманды "e" команды "s///" sed. 

Конфигурационный скрипт создаёт отдельные подменю для каждой групы последовательно
расположенных пунктов загрузочного меню GRUB отдельно для каждого вида ОС.
####Список поддерживаемых ОС в загрузочном меню GRUB: 
 - Microsoft Windows;
 - Gentoo.

####Файлы проекта:
    - folding      - непосредственно сам файл скрипта, преобразующего последовательность
                     однородных пунктов меню в подменю.
    - _gen-prolog  - заголовочный файл начала секции "Gentoo"; может содержать
                     произвольный пользовательский код, который будет помещён
                     непосредственно перед подменю "Gentoo" - или внутри подменю
                     в самом начале секции "Gentoo".
                     В этом же файле задаётся заголовок подменю "Gentoo".
    - _gen-epilog  - заголовочный файл окончания секции "Gentoo"; может содержать
                     произвольный пользовательский код, который будет помещён
                     непосредственно после подменю "Gentoo" - либо в конце секции
                     внутри подменю.
    - _win-prolog  - заголовочный файл начала секции "Microsoft Windows"; может
                     содержать произвольный пользовательский код, который будет
                     помещён непосредственно перед подменю "Windows" - либо внутри подменю
                     в самом начале секции "Windows".
                     В этом же файле задаётся заголовок подменю "Microsoft Windows".
    - _win-epilog  - заголовочный файл окончания секции "Microsoft Windows"; может
                     содержать произвольный пользовательский код, который будет
                     помещён либо непосредственно после подменю "Windows" - либо
                     в конце секции "Windows".

Все файлы размещаются в каталоге /etc/grub.d
Все файлы являются исполняемыми.
Приоритет исполнения сценария "folding" должен обеспечивать его запуск
после модуля os_prober и до запуска пользовательских скриптов,
т.е. обычно - 31 - 39. Пример: 39_folding.
Для заголовочных файлов секций приоритет не задаётся, они размещаются в
/etc/grub.d в исходном виде и в контексте конфигуратора GRUB (update-grub)
исполняются "вхолостую".
Возможно расширение списка поддерживаемых ОС путём несложной доработки кода
сценария folding и создания соответствующих заголовочный файлов секций.

####Для добавления поддержки новой ОС необходимо:

 - задать "короткое имя" ОС - например "win"; это обозначение будет
     использоваться пограммой;
 - создать файлы секций в каталоге конфигурации GRUB - /etc/grub.d по умолчанию;
     - файлы секций должны быть исполняемыми сценариями оболочки и должны иметь имена вида:
         `_<короткое_имя_ОС>-prolog`,
         `_<короткое_имя_ОС>-epilog`
       (например: `_win-prolog`, `_win-epilog`);
     - файлы секций могут быть созданы путём копирования существующих;
     - в файле необходимо определить имя секции подменю и, при необходимости -
       ввести пользовательский текст;
  (вывод в stdout при исполнении этих файлов будет помещён в файл grub.cfg,
  вывод в stderror (перенаправление >&2) - выводится на экран;
 - определить "длинное имя ОС", по которому будут определяться пункты меню для этой ОС,
   например "Microsoft Windows";
 - в файле 'folding' создать переменную, с именем, соответствующим короткому имени ОС и
   содержащую "длинное имя", например - win='Microsoft Windows';
 - добавить (по аналогии) обработчики для этой ОС в конец конвейера в секции обработки
   в конце сценария 'folding', например:
   
        sed -e "$(echo_remark win)"     |
        sed -e "$(echo_final win $p)"   |
        sed -e "$(echo_final win $e)"

Непротиворечивость перечня обрабатываемых ОС обеспечивается самим пользователем. 

####TODO:
- исключить создание подменю, если последовательность пунктов меню уже заключена в подменю.

##==[ history ]=============================
####ru
Ранние версии grub-folding использовали непосредственную вставку содержимого файлов секций
в файл меню загрузки GRUB, затем была реализована вставка вывода конфигурационных
скриптов файлов секций при помощи сохранение его во временных файлах.

-------------------------------------------------------------------------------
####en
Early versions of grub-folding used directly insert of section file contents into
GRUB boot menu file. It was later implemented insertion of output of section file
config script into GRUB boot menu file by storing it in a temporary files.

-------------------------------------------------------------------------------

####folding_v.5.3
#####(c) aso, v.2.3.0 by 14.07.2014.
    Transition variant 3 with exclusion re-creating submenu if it existing.
    - Mutable the 'shield' function - input from parameter, if position parameter
    (not flag) is not empty.
    - Simplify any using the 'shield' function.
    - Exclude the function 'o_name' - convert short name to long name.
        Use instead of them set variables with short names and contens the long names.
    - Reordered function - the 'shield' function is shifted to the end of
        all function definitions.
    - Changed place creation of tmp buffer - now it's created in /tmp/folding{$$$} dir.
    - Change dev mk.config dir from ./my.grub.d to ./grub.d
    
        Product revision version V-3
       (c) aso, v.2.3.0 by 14.07.2014.

-------------------------------------------------------------------------------

####folding_v.5.2
#####(c) aso, v.2.2.0 by 07.07.2014.
    Transition variant 2 with exclusion re-creating submenu if it existing.
    The universal 'shield' function - with parameter analyse, two form of calling -
    input from parameters or input file. Using one func for all substitutions.
    The simplified sintax at the 'shield' function: provide '\' as escaping chars.
    New keyword 'submenu' for breaking section sampling was added.

        Product revision version V-2
-------------------------------------------------------------------------------

####folding_v.5.1
#####(c) aso, v.2.1.0 by 17.06.2014.

    Transition variant 2 to exclusion re-creating submenu if it existing.
    Used 'e' subcommand of 's///' sed's command for insertion output of the
    configuration script into the output file
    The first section in the sequence completely sampled in pattern space
    with 'N' command, new criteria for correct full sampling of the menu item.
    is completed block '{..}' with any quantity inner group '{..}'
    up to 3 level nesting.
    Excludes create submenus for a single menu item.
    The 'shield' function provide escaping chars for simplify expressions.
    The 'shield0' function provide uncompatible part of functionality 'shield'.

        Product revision version V-1
-------------------------------------------------------------------------------

####folding_v.5.0
#####(c) aso, v.2.0.0 by 07.06.2014.
Sat Jun 28 12:20:26 2014 +0400

    Transition variant to exclusion re-creating submenu if submenu already created.
    Used 'e' subcommand of 's///' sed's command for insertion output of the section
    config scripts into the GRUB boot menu file.
    The first section in the sequence completely sampled in pattern space
    with 'N' command - preparation to exclude creating a submenu for a single
    selected menu entry.

        Product revision version V.
-------------------------------------------------------------------------------

####folding_v.4.0
#####(c) aso, v.1.7.3 by 02.04.2013.	
Tue Apr 2 19:02:40 2013 +0400

    Insert Folding section in GRUB configuration file
    (c) aso, v.1.7.3 by 02.04.2013.
    Final revision of Version IV.
    Release.

    Config of folding subsection as executable script in grub.d
    Output of subsection config redirected to tmp file, with append
    of endmarker.
    Content of this file was inserted in grub.cfg file.

    Product revision version IV.
    Clean code.
-------------------------------------------------------------------------------

####folding_v.3.0
#####(c) aso, v.1.6.1 by 29.03.2013.
Fri Mar 29 20:44:04 2013 +0400

    Create Folding section in GRUB configuration file
    (c) aso, v.1.6.1 by 29.03.2013.

     ********************************************
         Release revision of Version III
      subsection config files as grub.d scripts
      output of subsection config scripts
      redirected in environment variables
     ********************************************

    Subsection config script was clearned from devel code.
-------------------------------------------------------------------------------

####folding_v.2.0
#####(c) aso, v.1.4.3 by 17.01.2013.
Thu Mar 28 12:40:43 2013 +0400

    Insert Folding section in GRUB configuration file
    (c) aso, v.1.4.3 by 31.01.2013.
    Cleaning & make more nice code.
    ==============================
    Production Release, variant 2.
    ==============================
    Create core functional of folding with section sub-config files
    as exec script similar other /etc/grub.d config's.
    from 29.01.2013.
-------------------------------------------------------------------------------

####folding_v.1.0
#####v.0.4.0 from 29.12.2012. by aso
Wed Mar 27 21:25:19 2013 +0400

    => folding==:
    Insert Folding section in GRUB configuration file
    (c) aso, v.0.9.2 by 14.01.2013
       GPLv3
    Final Revision, version 1: config file's as text,
    inserted "as is" in grub.cfg

    => update-fold: development utility
    Interactive launch of Sectioneer
    v.0.4.0 from 05.01.2013. by aso
    Rename from section-update & upgrade to rev.0.4.

    => update-grub-my: development variant of update-grub for project
       by 18.12.2012.
