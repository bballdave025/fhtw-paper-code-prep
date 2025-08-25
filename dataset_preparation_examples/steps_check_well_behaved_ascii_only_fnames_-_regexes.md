# Checks for Well-Behaved Filenames

## The first super-great regex playground&mdash;locales,<br/>bytes, Unicode, utf-8, ... Prep easier parsing later.

## Project Note

This is one of the nice presentation parts of the RMFB 
(<strong>R</strong>eused <strong>M</strong>anuscript 
<strong>F</strong>ragments in <strong>B</strong>indings) project. 
Actually, `RMFB` is what I'm choosing to be the consistent way I refer
to this project in my GitHub portfolio. It seems short and easy and ... 
well, most of all, it's the one that is the one I picked. You'll likely 
also see the project called 
[`FHTW2025`](https://fhtw.byu.edu/) 
([archived](https://web.archive.org/web/20250825172528/https://fhtw.byu.edu/))
(<strong>F</strong>amily <strong>H</strong>istory 
<strong>T</strong>echnology <strong>W</strong>orkshop from the 
March <strong>2025</strong> program
{[archived](https://web.archive.org/web/20250825172644/https://fhtw.byu.edu/program/)}),
closely related to my project start during the 
[FHTW 2024 program](https://fhtw.byu.edu/archive/2024/) 
{[archived](https://web.archive.org/web/20250825172625/https://fhtw.byu.edu/archive/2024/)}).
You will likely run into `RIB-WriST-in-Bin-din`, 
[here's](https://github.com/bballdave025/rib-wrist-in-bin-din) a link 
to what is basically the main project repo as well as to a 
[Jupyter Notebook](https://github.com/bballdave025/rib-wrist-in-bin-din/blob/main/Paper_Code_Prep_01.ipynb) 
(perhaps better seen with the 
[Colab version](https://colab.research.google.com/github/bballdave025/rib-wrist-in-bin-din/blob/main/Paper_Code_Prep_01.ipynb)) 
that serves as a more-detailed README/abstract.
(RIB-WriST-in-Bin-din is my favorite funding-inducing name.) And, if
you're very lucky, you might see it referred to as `P2`
(Résumé GitHub <strong>P</strong>ortfolio Project 
Number <strong>2</strong>).

## The `bash` aliases and some command output that were/are my reference

```bash
bballdave025@MY_MACHINE ~ ~
$ type cfcftldr
cfcftldr is aliased to `commandsforcheckingfilenamesquick'

bballdave025@MY_MACHINE ~ ~
$ cfcftldr
#                                                                       #
######### COMMANDS CAN BE COPY/PASTED, OR YOU CAN USE THE IDEAS #########
######### TO GET WHAT YOU WANT. (DON'T INCLUDE LEADING $S)      #########

#  USE THIS MOST - Find characters that are non-ascii;
#+ Find characters that are non-printable ascii - includes
#+ space, tab, carriage return, linefeed
#+
# @@@@@@@@@@@@@@@@@@@@ IMPORTANT CHECK 1 @@@@@@@@@@@@@@@@@@@@

$ find . -type f | awk -F'/' '{print $NF}' |
    LC_ALL=C grep -oP "[\x00-\x20\x7F-\xFF]" | wc -l

# @@@@@@@@@


#  Do we have any filenames with undesired ASCII
#+ characters (Dave's no-nos, which are the characters
#+ he has found to cause problems in later parsing.)
#+
# @@@@@@@@@@@@@@@@@@@@ IMPORTANT CHECK 2 @@@@@@@@@@@@@@@@@@@@

$ find . -type f | awk -F'/' '{print $NF}' |
    LC_ALL=C grep '[] ~!@#$%^&|\/)(}{[*?><;:"`'"'"']' | wc -l

# @@@@@@@@@

#########################################################################

```