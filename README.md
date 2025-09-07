# fhtw-paper-code-prep
Stuff to clone onto Amazon AWS SageMaker instances for different models. Different notebooks with different models and different platforms (TF, Torch).

<br/>

You might want to go down to the discussion of models, Jupyter Notebooks, drafts of papers to publish, etc. For now, though, you'd need to wait for me to write that part. A Good place to look until I get that done is my repo for [rib-wrist-in-bin-din](https://github.com/bballdave025/rib-wrist-in-bin-din/tree/main), one of the funding-attracting type names I've come up with, standing for <strong>R</strong>eused <strong>I</strong>nformation <strong>B</strong>earing <strong>Wri</strong>ting <strong>S</strong>urface <strong>T</strong>races <strong>in</strong> <strong>Bin</strong>-<strong>Din</strong>-gs. Especially interesting (though <em>very</em> drafty) are a Google Drive hosted [draft of the more-technical paper](https://docs.google.com/document/d/1JAIL4PFmIm3_gScfscTj88yXKjorG7NIcXnTlT2IcSI/edit?usp=sharing)&emdash;for now a chain-of-consciousness discussion that incorporates my literature search, the types of models I plan to use or have already scaffolded, and some goals on classification metrics. Something that goes even more into the "why" of the project, discussing how many documents I want to search through to find these <strong>R</strong>Reused <strong>M</strong>Manuscript <strong>F</strong>ragments in <strong>B</strong>indings (RMFBs) and giving visualizations and references for some of the Deep Learning architectures I want to use, is a [Jupyter notebook with some of my vision and the plans for my baseline](https://github.com/bballdave025/rib-wrist-in-bin-din/blob/main/Paper_Code_Prep_01.ipynb) (a Vanilla CNN for identification on the CIFAR-10 dataset).

For now, I'm putting in `README`s for the models to be used, analyzed, and perhaps voted on by a much later ensemble model. They're somewhat in the order of complexity, but don't quote me on that.

# First Step: Local E2E C

## Discussion of Models, Jupyter Notebooks, Paper-draft PDFs, etc.

Coming soon!

<br/>

## Useful Commands for Dave

### Convert Commands

#### 0

```bash
identify \
  -format "
      \n\n%f\n%[magick] %[colorspace] %[type] \
              %[extension] %[bit-depth] %[channels]\n
" \
  *.tiff | tr -s ' '  #  TIFF as example
```

often with the output redirected to a file, as shown below.

An example of my most-used `0` command, then (using aliases I detail, below), is

```bash
ttdate && \
  time \
    identify -format "
      \n\n%f\n%[magick] %[colorspace] %[type] \
              %[extension] %[bit-depth] %[channels]\n" \
          *.tiff | tr -s ' ' \
        > informative_filename_$(ttdate).out \
    && ttdatechk
```

where the following two aliases have been created: 

```
alias ttdate="date +'%s_%Y-%m-%dT%H%M%S%z'"

alias ttdatechk='  echo -e "$(ttdate)\nExitedNormally" '\
'               || echo -e "$(ttdate)\nExitedNonZero" '\
'; ttdate; echo "  (this may be a BONUS timestamp)";'
```

included in (something sourced by) my `$HOME/.bashrc`, though typing them at the
terminal prompt works, too.

<br/>

#### 1

```bash
mogrify -colorspace srgb -type truecolor *.jpg
```

<strong>IMPORTANT!!!</strong>
ALWAYS USE A COMMAND LIKE THIS, <strong>WITHOUT ANY `-quality PERCENT`
FLAG</strong>, WHEN DOING CONVERSIONS FROM JPEG TO (DIFFERENT-FORMAT)
JPEG.

An example of my most-used `1` command, then (using aliases I detailed in '0', above), is

```bash
ttdate && \
  time \
    mogrify -colorspace srgb -type truecolor *.jpg \
  && ttdatechk
```

<br/>

#### 2

```bash
mogrify -format jpg -quality 92 -colorspace srgb -type truecolor *.png
```

A `quality` of `92` is pretty standard<sup>1</sup>.

An example of my most-used `2` command, then (using aliases I detailed in '0', above), is

```bash
ttdate && \
  time \
    mogrify -colorspace srgb -type truecolor *.jpg \
  && ttdatechk
```

<br/>

#### 3

```bash
mogrify -format jpg -quality 92 *.tiff  # *.tiff for an example
```

An example of my most-used `3` command, then (using aliases I detailed in '0', above), is

```bash
ttdate && \
  time \
    mogrify -format jpg -quality 92 *.tiff \
  && ttdatechk
```

<br/>

#### 4

```bash

#  hopefully it's faster when not working on files on the external hard drive
#+ [ ... working with stuff ... ]
#+ yes, it goes much faster with the files on the local machine
```

<br/>

### Notes

1. I'm talking loose and fast by saying "pretty standard". I think the best way to
see why I call this standard is to look at the default settings for a few widely-
used programs.

I'll put in links to more formal research, later, though I'll note
that I like the analysis at
[Lenspiration](https://web.archive.org/web/20250619215342/https://www.lenspiration.com/2020/07/what-quality-setting-should-i-use-for-jpg-photos/)
(that's an archived version) about JPEG quality in (Adobe) [Lightroom](https://lightroom.adobe.com/)
(that's not an archived version).
From what I can gather, the actual pixel output (in Lightroom) is the same
(or more likely only trivially different)
anywhere in the 93-100 range, and similarly the same in the 85-92 range.
It keeps going like that for 11 more ranges or bands of quality value.
Though I didn't see the details of the experimental method used for the
"(Subjective) JPG quality at 100% zoom" for each quality setting, it seems 
very little different between 92 (or 93) and 100, while the file size grows
markedly (following a previously visible exponential trend) between
about 90 and 95.

<br/>

#### Default Settings

##### ImageMagick: 

92 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
[documentation (archived version)](https://web.archive.org/web/20250716224304/http://www.imagemagick.org/script/command-line-options.php)

used to be 85 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
[source from 2010](https://web.archive.org/web/20250719200242/https://imagemagick.org/discourse-server/viewtopic.php?t=16751), 
which is after the change had been made

<br/>

##### GIMP:

90 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Found just now, after I downloaded the newest stable GIMP 3.0.4, by exporting an
image as with a `.jpg` extension and pressing the <kbd>Reset to FactoryDefaults</kbd> button. Right after I finished,
I got the UNIX Timestamp as `1752957414` which is the same as `Sat Jul 19 20:36:54 UTC 2025` (from `date -u`)
I found the same version when following similar steps in version 2.10.

<br/>

##### Irfanview:

80 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
[Irfanview Forum](https://web.archive.org/web/20250720161514/https://irfanview-forum.de/forum/program/support/98629-can-t-save-default-jpg-quality)

<br/>

##### Adobe Lightroom:

90 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
[Adobe Community post](https://web.archive.org/web/20250720154131/https://community.adobe.com/t5/lightroom-ecosystem-cloud-based-discussions/lightroom-cc-export-res-mobile-vs-desktop/m-p/10566888) 

<br/>

##### Picasa

85  [Google Sites](https://web.archive.org/web/20250720154425/https://sites.google.com/site/picasaresources/picasa/save-photos)

Note that the formatting/style went a little wacky for the archived version 
(at least in my view of it). Scroll past the big images of an X and a 
magnifying glass, some other stuff, and another magnifying glass, and then 
you should be able to see the content just fine.

<br/>

##### Canva

80 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; This isn't a standard/default value (it
seems the user picks their default when installing), but the value I most often
saw in Google results was 80.

<br/>

##### Snapseed:

95 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
[GadgetHacks > Smartphones](https://web.archive.org/web/20250720160842/https://smartphones.gadgethacks.com/how-to/snapseed-101-save-photos-full-quality-0180555/)

<br/>

##### Photoprism:

92 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
[GitHub issue on the Photoprism repo](https://web.archive.org/web/20250722141918/https://github.com/photoprism/photoprism/issues/2215)

<br/>

##### Picsart:

No default.

<br/>

##### Affinity Photo:

100 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
[Affinity Forum](https://web.archive.org/web/20250720161928/https://forum.affinity.serif.com/index.php?/topic/41561-saving-jpg-ctrl-s-quality-is-100-how-to-setup/)

Someone should get fired. That's taking up a bunch of extra, unneeded storage (though I guess it's less than the RAW version).

<br/>

##### Firefox:

92 (sometimes stated as 0.92) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ???

[StackOverflow post 1](https://web.archive.org/web/20250722142520/https://stackoverflow.com/questions/8371510/canvas-reduces-imagesize-of-jpeg-but-why)

[StackOverflow post 2](https://web.archive.org/web/20250722142419/https://stackoverflow.com/questions/15754281/what-is-the-default-quality-for-html5-canvas-todataurl)
which gives source [a](https://web.archive.org/web/20250722142442/https://bugs.webkit.org/show_bug.cgi?id=49365#c6) as well as referencing the other SO post, above.

<br/>

##### Suggestions from a website

[Sirv](https://web.archive.org/web/20250722161503/https://sirv.com/help/articles/dynamic-imaging/format/)

> For best results, we recommend that you upload uncompressed JPEGs – at least 92% quality or above.

a \[sic\] for the intimation that "uncompressed" is equivalent to "92% (\[sic\] on the '%', too) quality or above"

Maybe `<strong>@TODO</strong>` : Look for suggestions from other websites.

<br/>

#### Lots of papers and technical discussions (archived version when possible)

[Image Quality Assessment Using The Ssim And The Just Noticeable Difference Paradigm](https://web.archive.org/web/20250722163124/https://link.springer.com/chapter/10.1007/978-3-642-39360-0_3?).
PDF viewable [here](https://www.researchgate.net/profile/Julian-Abich-Iv-2/publication/262897371_Image_Quality_Assessment_Using_the_SSIM_and_the_Just_Noticeable_Difference_Paradigm/links/00b495391c77795f7d000000/Image-Quality-Assessment-Using-the-SSIM-and-the-Just-Noticeable-Difference-Paradigm.pdf?__cf_chl_rt_tk=sjVwp.LY5bGUWhTGJ2MQeOfGwreBZkok73NKvpUCbew-1753201608-1.0.1.1-iLtjb2T5Ma8BIySt4s81oXgEsN4p7FG4N1yfF_txMas)
https://doi.org/10.1007/978-3-642-39360-0_3

[Perceptual Visual Quality Assessment: Principles, Methods, and Future Directions (arxiv)]([https://arxiv.org/html/2503.00625v1](https://web.archive.org/web/20250304060645/https://arxiv.org/html/2503.00625v1))
http://dx.doi.org/10.48550/arXiv.2503.00625

[Multiple just-noticeable-difference-based no-reference stereoscopic image quality assessment](https://web.archive.org/web/20250722162220/https://pubmed.ncbi.nlm.nih.gov/30645317/)
https://doi.org/10.1364/AO.58.000340

[Image Quality Assessment: From Error Visibility to Structural Similarity](https://web.archive.org/web/20250722163156/https://ieeexplore.ieee.org/document/1284395/)
[This link is for PDF download](https://www.cns.nyu.edu/pub/lcv/wang03-preprint.pdf)
https://doi.org/10.1109/TIP.2003.819861

[Post from fstoppers.com](https://web.archive.org/web/20250528180757/https://fstoppers.com/education/about-jpeg-images-and-their-quality-degradation-435235) 
which I include solely because of the statement that begins the article, 
"You lose information when an image is saved in JPEG format. This is acceptable, 
unless you save the same image more than once. 
Let’s have a look at how much information you really lose."

You should, however, see Wikipedia's JPEG article, specifically the Lossless Editing section, archived version 
[here](https://web.archive.org/web/20250716110206/https://en.wikipedia.org/wiki/JPEG#Lossless_editing)

[An Analysis of Lightroom JPEG Export Quality Settings](https://web.archive.org/web/20250722162339/https://regex.info/blog/lightroom-goodies/jpeg-quality)

[Post from darkroomphotos concerning Lighroom with scientific measurements](https://web.archive.org/web/20250719201256/https://darkroomphotos.com/lightroom-exporting-jpegs-lightroom-quality-settings/)

[A discussion of what quality means](https://web.archive.org/web/20250611223537/http://www.faqs.org/faqs/jpeg-faq/part1/section-5.html)

[Quality has to do with matrix coefficients (sometimes; it depends how the encoders work)](https://web.archive.org/web/20250722050928/https://stackoverflow.com/questions/21541502/imagemagick-jpeg-quality-size)
The matrix is called the Quantization Matrix or sometimes the Quantization Table.
(matrix coefficients related to frequency in DFT?)

[Photo StackExchange Discussion](https://web.archive.org/web/20250719201635/https://photo.stackexchange.com/questions/30243/what-quality-to-choose-when-converting-to-jpg)

[Something else from Photo StackExchange about what quality means]([https://photo.stackexchange.com/questions/57226/how-does-the-usual-jpeg-0-100-quality-settings-translate-into-photoshops-0-12-q](https://web.archive.org/web/20250722164003/https://photo.stackexchange.com/questions/57226/how-does-the-usual-jpeg-0-100-quality-settings-translate-into-photoshops-0-12-q))

There's a good discussion in the comments:

>  But possibly it is the case that quality number 0-100 isn't actually part of the jpeg standard (i.e. there aren't quantization tables specified in the standard by a given quality number) and so there IS no direct translation between adobes and libjpegs quality numbers because they actually use different quantization tables altogether. If that is the case, then there really isn't a translation between them and the answer you pointed to is as good as it is going to get. –John Robertson | Dec 3, 2014 at 19:15

>  It actually _is_ defined in [the standard](https://web.archive.org/web/20250722164256/https://datatracker.ietf.org/doc/html/rfc2435#section-4.2) but many encoders use a 0-100 scale which doesn't correspond to this. –mattdm | Dec 3, 2014 at 19:25

Link for 'the standard', https://datatracker.ietf.org/doc/html/rfc2435#section-4.2

[FotoForensics Post, very understandable](https://web.archive.org/web/20250720164555/https://fotoforensics.com/tutorial.php?tt=estq)

<br/>

#### OTHER STUFF

https://superuser.com/questions/62730/how-to-find-the-jpg-quality#comment1346047_62730

> Just to make sure that it is known: the quality setting of different applications is not comparable, in general: faqs.org/faqs/jpeg-faq/part1/section-5.html. Both GIMP and ImageMagick should use the IJG quality scale, though. –Michael Schumacher | Sep 29, 2015 at 12:36

https://www.numberanalytics.com/blog/jpeg-compression-essentials

https://www.adobe.com/uk/creativecloud/photography/discover/lossy-compression.html

https://realuca.wordpress.com/2015/10/13/color-and-light-linear-and-log-human-vs-video/#:~:text=HUMAN%20PERCEPTION%20IS%20NOT%20LINEAR&text=We%20are%20more%20sensitive%20to,scale%20than%20the%20high%20end.

https://web.archive.org/web/20250719205720/https://www.oreilly.com/library/view/high-performance-images/9781491925799/ch04.html

https://mjanja.ch/2023/05/evaluating-jpeg-webp-and-avif-for-pdf-thumbnails/

https://flothemes.com/flothemes-image-sizes/ Possible calculator? Seems not.

LLM prompt, still rough

> I remember having heard that a JPEG quality of 92 is ideal, because it gives a visual result not much different than anything from 93 to 100, but obviously uses less memory due to the higher compression that exists at the higher qualities. Is there some kind of standard that exists in a document or a well-respected study that backs up this advice?
>
> I would appreciate something that discusses perceptual quality having some kind of sweet spot after which increased quality is barely visually perceptual, but file size continues to grow.

<hr/>

And let's finish with this comment from `libjpeg`'s README, quoted 
[here](https://web.archive.org/web/20250722144316/https://www.phpied.com/ie9-and-jpeg-xr-first-impressions/) 
on Stoyan's phpied.com

> `FILE FORMAT WARS
> `================
> `
> `The ISO JPEG standards committee actually promotes different formats like
> `JPEG-2000 or JPEG-XR which are incompatible with original DCT-based JPEG
> `and which are based on faulty technologies.  IJG therefore does not and
> `will not support such momentary mistakes (see REFERENCES).
> `We have little or no sympathy for the promotion of these formats.  Indeed, `
> `one of the original reasons for developing this free software was to help  `
> `force convergence on common, interoperable format standards for JPEG files.`
> `Don't use an incompatible file format!                                     `
> `(In any case, our decoder will remain capable of reading existing JPEG     `
> `image files indefinitely.)                                                 `

It turns out that comes from the 
[`README` of v.8](https://web.archive.org/web/20250722144855/https://github.com/videoP/jaPRO/blob/master/lib/jpeg-8c/README), 
though the current version is v.9. An active fork called `libjpeg-turbo`, 
used by some programs, including ImageMagick, still uses v.8, though.
