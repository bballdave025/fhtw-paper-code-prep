# Illustrating my usual regex usage<br/>(`sed`, `grep`, ...)<br/>as well as my `awk` usage in this <br/>ML CV Manuscript Reuse project

## There's also some nice usage of `find` and some good file handling.

The specific usage examples will be colored &ndash; for which I need to use MathJax (LaTeX)
and thus won't have a <code>code</code> font. (Solutions people had tried, such as
`<code style="color:red">whatever code</code>` hadn't worked.)

<code>I'll put my </code> ${{\color{Cerulean}\small{\texttt{ \quad awk \quad code \quad \}}}}$ <code> in </code> ${{\color{Cerulean}\small{\texttt{ \quad blue \quad \}}}}$

<code>I'll put my (not-specifically-regex) </code> ${{\color{BrickRed}\small{\texttt{ \quad grep \quad code \quad \}}}}$ <code> in </code> ${{\color{BrickRed}\small{\texttt{ \quad red \quad \}}}}$

<code>I'll put my (not-specifically-regex) </code> ${{\color{ForestGreen}\small{\texttt{ \quad sed \quad code \quad \}}}}$ <code> in </code> ${{\color{ForestGreen}\small{\texttt{ \quad green \quad \}}}}$

<code>I'll put my </code> ${{\color{DarkOrange}\small{\texttt{ \quad code \quad for \quad regexes \quad \}}}}$ <code> in </code> ${{\color{DarkOrange}\small{\texttt{ \quad orange \quad \}}}}$

<br/>

<sub>
  <a href="https://github.com/orgs/community/discussions/31570">using color reference</a> (<a href="https://web.archive.org/web/20250122202654/https://github.com/orgs/community/discussions/31570">archived</a>)
  <br/>
  <a href="https://tex.stackexchange.com/questions/659029/colour-packages-beyond-xcolor">specific colors reference 1</a> (<a href="https://web.archive.org/web/20250619043053/https://tex.stackexchange.com/questions/659029/colour-packages-beyond-xcolor">archived</a>)
  <br/>
  <a href="https://tex.stackexchange.com/questions/657715/display-colors-and-their-names">specific colors reference 2</a> (<a href="https://web.archive.org/web/20250619043340/https://tex.stackexchange.com/questions/657715/display-colors-and-their-names">archived</a>)
</sub>

<hr/>

## I still need to run everything with the new PDF to show output (more nicely put-together)

```bash
$ cat >/dev/null <<EOF
#####################################################################
#  Going through one run of renaming files to my preferred format,
#+ used for al ~10^5 codex image files in the dataset.
#+ For some reason, when I use the PDF files from Universiteit 
#+ Utrecht (all open access), the image files extracted using
#+ a script I've put together called  `unwind_the_binding.py`
#+ end up with a different filename pattern than those from
#+ any other PDFs I've used. It keeps redownloading all them
#+ document images with slightly different filenames until them
#+ memory fills up.
#  Anyway, back to the different filename pattern ...
#+ Sounds like some good regexes will help.
#####################################################################
EOF
$ #  Keep track of stuff for repeatability
$ checksituation
$ #  What that command is (set up in ~/.bashrc and other sourced
$ #+ dotfiles). Note I can use tab completion
$ type checksituation
```

```bash
checksituation is aliased to `echo; echo " Current date/time is"; trpdate; echo; echo " Current directory ( pwd ) is "; pwd; echo;'
```

```bash
$ type trpdate
trpdate is aliased to `tripledate'
$ type tripledate
tripledate is aliased to `date && date +'%s' && date +'%s_%Y-%m-%dT%H%M%S%z''
$ find ./new_to_convert_PDF/ -type f | wc -l # Making sure not tons of output
$ find ./new_to_convert_PDF/ -type f
$ find ./converted_from_PDF/ | wc -l
$ find ./converted_from_PDF/
$ #  just the directory, itself.
$
$ #  Let's make a nice, multi-line comment in an easy way
cat >/dev/null <<EOF
In Anaconda Prompt (for this example, I'm in Windows.)

path>:: Starting near <timestamp from checksituation>
path>python unwind_the_binding.py
##OUTPUT

Default usage looks for PDF in 'new_to_convert_PDF'
and outputs into 'converted from PDF'

(Note that my  bash  is from Cygwin, and I'm returning
typing this multi-line comment there.)

EOF

$ checksituation

$ cat >/dev/null <<EOF
After a [Ctrl]+[c] in Anaconda Prompt, which is done
when I can see that we're downloading repeat/duplicate
images with the Python script.

path>:: blah

EOF

$ #  First run-through gives files with <fname>_p0-<number>.png
$ #+ Repeats give similar, but with '_p1-', '_p2-', etc. 

$ find . -type f | wc -l
$ find . -type f -iname "*.png" | wc -l  # all files are PNG, for now
```
`$ find . -type f -iname "*.png" | `${{\color{BrickRed}\texttt{ \quad grep \quad\}} {\color{DarkOrange} " \large{\textunderscore}} {\color{DarkOrange}\texttt{p0 \large{-} " \quad \}}}$` | wc -l`<br/>
`$   #  Matches the count from the image extraction`<br/>
`$ find . -type f -iname "*.png" | `${{\color{BrickRed}\texttt{ \quad grep \quad -v \quad\}} {\color{DarkOrange} " \large{\textunderscore}} {\color{DarkOrange}\texttt{p0 \large{-} " \quad \}}}$` | wc -l`<br/>
`$   #  That's the number of duplicates. Double checking`<br/>
`$ find . -type f -iname "*.png" | `${{\color{BrickRed}\texttt{ \quad grep \quad\}} {\color{DarkOrange} " \large{\textunderscore}} {\color{DarkOrange}\texttt{p1 \large{-} " \quad \}}}$"` | wc -l`<br/>
`$ find . -type f -iname "*.png" | `${{\color{BrickRed}\texttt{ \quad grep \quad\}} {\color{DarkOrange} " \large{\textunderscore}} {\color{DarkOrange}\texttt{p2 \large{-} " \quad \}}}$` | wc -l`<br/>
`$ find . -type f -iname "*.png" | `${{\color{BrickRed}\texttt{ \quad grep \quad\}} {\color{DarkOrange} " \large{\textunderscore}} {\color{DarkOrange}\texttt{p3 \large{-} " \quad \}}}$` | wc -l`
```bash
$ cat >/dev/null <<EOF
Let's delete the duplicates. 
Null separating filenames in case there are any spaces, etc.
in any filenames. (There aren't, but I want it portable for
when I'm using filenames created by others.
EOF
```
`$ find . -type f -iname "*.png" | `${{\color{BrickRed} \texttt{ \quad grep \quad -v \quad\}} {\color{DarkOrange} " \large{\textunderscore}} {\color{DarkOrange}\texttt{p0 \large{-} " \quad \}}}$` | \`<br/>
`                        tr '\n' '\0' | xargs -I'{}' -0 rm "{}"`<br/>
`$ find . -type f -iname "*.png" | `${{\color{BrickRed} \texttt{ \quad grep \quad -v \quad\}} {\color{DarkOrange} " \large{\textunderscore}} {\color{DarkOrange}\texttt{p0 \large{-} " \quad \}}}$` | wc -l`<br/>
`$ #  They're all gone. Let's check for what's left`<br/>
`$ find . -type f -iname "*.png" | `${{\color{BrickRed} \texttt{ \quad grep \quad\}} {\color{DarkOrange} " \large{\textunderscore}} {\color{DarkOrange}\texttt{p0 \large{-} " \quad \}}}$` | wc -l`
```bash
$ #  Matches. Let's take a quick look at the filenames
$ find . -type f -iname "*.png" | sort | head
#<UnivUltrecht_-_F-oct-39-dl-1>
$ #  Make the filenames consistent with my others
$ #+ I'll be metaprogramming a script to do this
```
`$ #  I usually use  sed 's#search#replace#flags;' , but MathJax (LaTeX) here doesn't`
`$ #+ like the ways I've tried to replace it, so I'm doing  sed 's|search|replace|flags;'`
`$ #+ This will still make it easier to use the '/' character as part of the filepath`
`$ #find . -type f -iname "*.png | `${{\color{ForestGreen} \texttt{ \quad sed \quad \}} { \mathtt{^{^{_{\rule{0.6ex}{1.2ex}}}}} } \color{ForestGreen} \texttt{s|}  {\color{DarkOrange} \mathtt{^{\wedge}\}} {\color{DarkOrange} \texttt{ [ \ \ . \ \ ]/ ' \color{ForestGreen}| \ |g; ' \quad \}}}$` | sort > rename&lt;whatever&gt;.sh`<br/>
`$   # probably more compute with regex engine, less robust than awk`<br/>
`$ find . -type f -iname "*.png" | `$`awk -F'/' '{print $NF}'`$` | sort | wc -l`<br/>
`$ find . -type f -iname "*.png" | \`<br/>
`                        `awk -F'/' '{print $NF}'` | sort > rename_utrecht_foct39dl1_pre.sh`
```bash
$ head rename_utrecht_foct39dl1_pre.sh
$ cat >/dev/null <<EOF
  Metaprogramming (running something that will output a script)
+ First testing my long command by outputting to stdout (not to
+ script file) and not running any file-changing commands (such
+ as rm, mv, etc.) Not running tee to filename or anything
+ like that.
EOF
$
$ cat >/dev/null <<EOF
#  Here are the commands from the previous big rename.
#+ I change things around. This could be automated, but
#+ I think getting the automation (a meta-meta-programming
#+ script) done would take longer than the combined
#+ time to manually make changes.
```
`curr_idx=1; ofn="rename_utrecht_eoct416dl1.sh"; >"${ofn}"; while read -r line; do orig_fname="${line}"; ofn="rename_utrecht_eoct416dl1.sh"; new_fname_pre=$(echo "${orig_fname}" | `sed 's#_p[0-9]\+[-][0-9]\+[.]png##g;'`); new_fname="${new_fname_pre}_$(printf '%05d' ${curr_idx}).png"; echo "echo" | tee -a "${ofn}"; echo "echo \"  Moving\"" | tee -a "${ofn}"; echo "echo \"${orig_fname}\"" | tee -a "${ofn}"; echo "echo \"  TO\"" | tee -a "${ofn}"; echo "echo \"${new_fname}\"" | tee -a "${ofn}"; echo "echo \"      ...\"" | tee -a "${ofn}"; echo "mv \"${orig_fname}\" \"${new_fname}\" && echo \"          ... success\" || echo \"          ... FAILURE\"" | tee -a "${ofn}"; curr_idx=$(echo "${curr_idx}+1" | bc); done < rename_utrecht_eoct416dl1_pre.sh`<br/>

`curr_idx=1; ofn="rename_utrecht_eoct416dl1.sh"; >"${ofn}"; while read -r line; do orig_fname="${line}"; ofn="rename_utrecht_eoct416dl1.sh"; new_fname_pre=$(echo "${orig_fname}" | `sed 's#_p[0-9]\+[-][0-9]\+[.]png##g;'`); new_fname="${new_fname_pre}_$(printf '%05d' ${curr_idx}).png"; echo "echo" >> "${ofn}"; echo "echo \"  Moving\"" >> "${ofn}"; echo "echo \"${orig_fname}\"" >> "${ofn}"; echo "echo \"  TO\"" >> "${ofn}"; echo "echo \"${new_fname}\"" >> "${ofn}"; echo "echo \"      ...\"" >> "${ofn}"; echo "mv \"${orig_fname}\" \"${new_fname}\" && echo \"          ... success\" || echo \"          ... FAILURE\"" >> "${ofn}"; curr_idx=$(echo "${curr_idx}+1" | bc); done < rename_utrecht_eoct416dl1_pre.sh`
```bash
#  this time: rename_utrecht_foct39dl1_pre.sh, rename_utrecht_foct39dl1.sh
EOF
$
$ #  Copy/paste into here and from here
$ cat >/dev/null <<EOF

#  Checking that the script will look like we want it to look.
curr_idx=1; ofn="rename_utrecht_foct39dl1.sh"; >"${ofn}"; \
while read -r line; do \
  orig_fname="${line}"; \
  ofn="rename_utrecht_foct39dl1.sh"; \
```
`  new_fname_pre=$(echo "${orig_fname}" | \`<br/>
`        `sed 's#_p[0-9]\+[-][0-9]\+[.]png##g;'`); \`
```bash
  new_fname="${new_fname_pre}_$(printf '%05d' ${curr_idx}).png"; \
  echo "echo"; \
  echo "echo \"  Moving\""; \
  echo "echo \"${orig_fname}\""; \
  echo "echo \"  TO\""; \
  echo "echo \"${new_fname}\""; \
  echo "echo \"      ...\""; \
  echo "mv \"${orig_fname}\" \"${new_fname}\" \
    && echo \"          ... success\" \
    || echo \"          ... FAILURE\""; 
  curr_idx=$(echo "${curr_idx}+1" | bc); 
done < rename_utrecht_foct39dl1_pre.sh | \
                                     head -n 50

#  Saving the commands to a script that we'll run.
curr_idx=1; ofn="rename_utrecht_eoct416dl1.sh"; >"${ofn}"; \
while read -r line; do \
  orig_fname="${line}"; \
  ofn="rename_utrecht_eoct416dl1.sh"; \
```
`  new_fname_pre=$(echo "${orig_fname}" | \`<br/>
`        `sed 's#_p[0-9]\+[-][0-9]\+[.]png##g;'`); \`
```bash
  new_fname="${new_fname_pre}_$(printf '%05d' ${curr_idx}).png"; \
  echo "echo" >> "${ofn}"; \
  echo "echo \"  Moving\"" >> "${ofn}"; \
  echo "echo \"${orig_fname}\"" >> "${ofn}"; \
  echo "echo \"  TO\"" >> "${ofn}"; \
  echo "echo \"${new_fname}\"" >> "${ofn}"; \
  echo "echo \"      ...\"" >> "${ofn}"; \
  echo "mv \"${orig_fname}\" \"${new_fname}\" \
    && echo \"          ... success\" \
    || echo \"          ... FAILURE\"" >> "${ofn}"; 
  curr_idx=$(echo "${curr_idx}+1" | bc); 
done < rename_utrecht_foct39dl1_pre.sh

EOF
```
<!--
## {
$ type ttdate
$ type ttdatechk
## }
-->
```bash
$ #  Check 50 lines 
$ curr_idx=1; ofn="rename_utrecht_foct39dl1.sh"; >"${ofn}"; \
while read -r line; do \
  orig_fname="${line}"; \
  ofn="rename_utrecht_foct39dl1.sh"; \
```
`  new_fname_pre=$(echo "${orig_fname}" | \`<br/>
`        `sed 's#_p[0-9]\+[-][0-9]\+[.]png##g;'`); \`
```bash
  new_fname="${new_fname_pre}_$(printf '%05d' ${curr_idx}).png"; \
  echo "echo"; \
  echo "echo \"  Moving\""; \
  echo "echo \"${orig_fname}\""; \
  echo "echo \"  TO\""; \
  echo "echo \"${new_fname}\""; \
  echo "echo \"      ...\""; \
  echo "mv \"${orig_fname}\" \"${new_fname}\" \
    && echo \"          ... success\" \
    || echo \"          ... FAILURE\""; 
  curr_idx=$(echo "${curr_idx}+1" | bc); 
done < rename_utrecht_foct39dl1_pre.sh | \
                                     head -n 50

$ #  Metaprogramming the meat of the bash script
$ curr_idx=1; ofn="rename_utrecht_eoct416dl1.sh"; >"${ofn}"; \
while read -r line; do \
  orig_fname="${line}"; \
  ofn="rename_utrecht_eoct416dl1.sh"; \
```
`  new_fname_pre=$(echo "${orig_fname}" | \`<br/>
`        `sed 's#_p[0-9]\+[-][0-9]\+[.]png##g;'`); \`
```bash
  new_fname="${new_fname_pre}_$(printf '%05d' ${curr_idx}).png"; \
  echo "echo" >> "${ofn}"; \
  echo "echo \"  Moving\"" >> "${ofn}"; \
  echo "echo \"${orig_fname}\"" >> "${ofn}"; \
  echo "echo \"  TO\"" >> "${ofn}"; \
  echo "echo \"${new_fname}\"" >> "${ofn}"; \
  echo "echo \"      ...\"" >> "${ofn}"; \
  echo "mv \"${orig_fname}\" \"${new_fname}\" \
    && echo \"          ... success\" \
    || echo \"          ... FAILURE\"" >> "${ofn}"; 
  curr_idx=$(echo "${curr_idx}+1" | bc); 
done < rename_utrecht_foct39dl1_pre.sh

$ #  Note that this will allow us to see either 'success' or 'FAILURE'
$ #+ output for each rename. Since it's redirected to an output file,
$ #+ we can check if there are any failures and count the successes.
$ #+ More on that, later.

$ head rename_utrecht_foct39dl1.sh
$ rm rename_utrecht_foct39dl1_pre.sh
$ #  Finishing the script (and showing it)
$ cp rename_utrecht_foct39dl1.sh ru_bak
$ echo -e "\x23\x21/usr/bin/env bash\n\n" # check
$ echo -e "\x23\x21/usr/bin/env bash\n\n" > first_part
$ cat first_part rename_utrecht_foct39dl1.sh > tmpf \
       && mv tmpf rename_utrecht_foct39dl1.sh
$ diff rename_utrecht_foct39dl1.sh ru_bak
$ rm first_part
$ rm ru_bak
$ chmod a+x rename_utrecht_foct39dl1.sh  # make it executable
$ #  I'm teeing the output to a progress file and to stdout.
$ #+ that will allow me to see if there are a bunch of FAILUREs,
$ #+ in which case I could [Ctrl]+[c]
$ ./rename_utrecht_foct39dl1.sh 2>&1 | tee renaming_utrecht_foct39dl1.out

### I've taken out most of the output
#
### ... OUTPUT ...

$ #  Now, check for any FAILUREs, using case-insensitive flag
```
`$ `grep -i --failure renaming_utrecht_foct39dl1.out` | wc -l # n_failures?`<br/>
```bash
grep: unknown option -- failure
Usage: grep [OPTION]... PATTERNS [FILE]...
Try 'grep --help' for more information.
0
$ #  hahahahaha. I've got to make sure I laugh every day.
$ #+ Failure is not an option ('unknown option -- failure')
```
`$ `grep -i failure renaming_utrecht_eoct416dl1.out` | wc -l # n_failures`<br/>
`$ #  Great! No failures. Check successes.`<br/>
`$ `grep -i success renaming_utrecht_eoct416dl1.out` | wc -l`<br/>
```bash
$ #  Matches our original number of files; good
$
$ #  A regex check that all filenames match my favored pattern
$ find . -type f -iname "*.png" | wc -l
$ find . -type f -iname "*.png" | sort | head
```
`$ find . -type f -iname "*.png" | sort | `grep "_[0-9]\{5\}[.]png$"` | wc -l`<br/>
`$ find . -type f -iname "*.png" | sort | `grep -v "_[0-9]\{5\}[.]png$"` | wc -l`<br/>
`result`
