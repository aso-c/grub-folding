grub-folding
============

/etc/grub.d configuration script for folding sequence of similar grub menu entries (as gentoo, gentoo... or Windows, Windows...)

###==[ en ]====================================================

Config script the grub-folding is provide the folding of similar GRUB menu entries sequence.
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
    - folding - the config script that creates a submenu from sequence of a homogeneous
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

####TODO:
- FIXED <S>exclude submenu creation for single menu entry from list of target OS'es;
- exclude submenu creation if sequence of target OS'es menu entries already
  enclosed into submenu.

###==[ ru ]====================================================

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
    - folding - непосредственно сам файл скрипта, преобразующего последовательность
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

####TODO:
- ИСПРАВЛЕНО <S>исключить создание подменю, если встречен одиночный пункт меню из списка обрабатывемых;
- исключить создание подменю, если последовательность пунктов меню уже заключена в подменю.

##==[ history ]========================================
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

####folding_v.5.1
#####(c) aso, v.2.1.0 by 17.06.2014.

    Transition variant 2 to exclusion re-creating submenu if it existing.
    Insertion output of the configuration script of section into the GRUB boot
    menu file uses 'e' subcommand of 's///' sed's command.
    The first section in the sequence completely sampled in pattern space with
    'N' command. Terminal criterion to fetch the first menu item is a sampling
    full block '{..}' with any number of internal groups '{..}' and up to
    3 levels of nesting.
    Create submenus for a single menu item is excluded.
    The 'shield' function provide escaping chars for simplify expressions.
    The 'shield0' function provide uncompatible part of functionality 'shield0'.

        Product revision version V-1.
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
