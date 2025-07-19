# fhtw-paper-code-prep
Stuff to clone onto Amazon AWS SageMaker instances for different models. Different notebooks with different models and different platforms (TF, Torch).

## Discussion of Models, Jupyter Notebooks, Paper-draft PDFs, etc.

Coming soon!

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



#### 1

```bash
mogrify -colorspace srgb -type truecolor *.jpg
```

<strong>IMPORTANT!!!</strong>
ALWAYS USE A COMMAND LIKE THIS, <strong>WITHOUT ANY `-quality PERCENT`
FLAG</strong>, WHEN DOING CONVERSIONS FROM JPEG TO (DIFFERENT-FORMAT)
JPEG.

#### 2

```bash
mogrify -format jpg -quality 92 -colorspace srgb -type truecolor *.png
```

A `quality` of `92` is pretty standard<sup>1</sup>.

#### 3

```bash
mogrify -format jpg -quality 92 *.tiff
```

#### 4

```bash

#  hopefully it's faster when not working on files on the external hard drive
#+ [ ... working with stuff ... ]
#+ yes, it goes much faster with the files on the local machine
```

### Notes

1. I'm talking loose and fast by saying "pretty standard". I think the best way to
see why I call this standard is to look at the default settings for a few widely-
used programs.

I'll put in links to more formal research, later, though I'll note
that I like the analysis at
[Lenspiration](https://web.archive.org/web/20250619215342/https://www.lenspiration.com/2020/07/what-quality-setting-should-i-use-for-jpg-photos/)
(that's an archived version) about JPEG quality in (Adobe) [Lightroom](https://lightroom.adobe.com/).
From what I can gather, the actual pixel output (in Lightroom) is the same
(or more likely only trivially different)
anywhere in the 93-100 range, and similarly the same in the 85-92 range.
It keeps going like that for 11 more ranges or bands of quality value.
Though I didn't see the details of the experimental method used for the
"(Subjective) JPG quality at 100% zoom" for each quality setting, it seems 
very little different between 92 (or 93) and 100, while the file size grows
markedly (following a previously visible exponential trend) between
about 90 and 95.

#### Default Settings

##### ImageMagick: 

92 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [documentation (archived version)](https://web.archive.org/web/20250716224304/http://www.imagemagick.org/script/command-line-options.php)

used to be 85 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
[source from 2010](https://web.archive.org/web/20250719200242/https://imagemagick.org/discourse-server/viewtopic.php?t=16751), 
which is after the change had been made

##### GIMP:

90 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Found just now, after I downloaded the newest stable GIMP 3.0.4, by exporting an
image as with a `.jpg` extension and pressing the <kbd>Reset to FactoryDefaults</kbd> button. Right after I finished,
I got the UNIX Timestamp as `1752957414` which is the same as `Sat Jul 19 20:36:54 UTC 2025` (from `date -u`)

used to be 92  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; which I found when doing the same thing in a 2.x version

##### Adobe Lightroom:

90 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [Adobe Community post]() 
https://community.adobe.com/t5/lightroom-ecosystem-cloud-based-discussions/lightroom-cc-export-res-mobile-vs-desktop/m-p/10566888

##### Picasa

##### Canva

80 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; This isn't a standard/default value (it
seems the user picks their default when installing), but the value I most often
saw in Google results was 80.

##### Snapseed:

95 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; https://smartphones.gadgethacks.com/how-to/snapseed-101-save-photos-full-quality-0180555/

##### Photoprism:

92 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [Try to find a better source that the title of a GitHub issue]()
https://github.com/photoprism/photoprism/issues/2215

##### Firefox:

92 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

##### Suggestions from a website (and hopefully more websites)

https://sirv.com/help/articles/dynamic-imaging/format/

> For best results, we recommend that you upload uncompressed JPEGs – at least 92% quality or above.

a \[sic\] for the intimation that "uncompressed" is equivalent to "92% ([sic] on the '%', too) quality or above"

#### Lots of papers and technical discussions (archived version when possible)

[Image Quality Assessment Using The Ssim And The Just Noticeable Difference Paradigm](https://www.researchgate.net/profile/Julian-Abich-Iv-2/publication/262897371_Image_Quality_Assessment_Using_the_SSIM_and_the_Just_Noticeable_Difference_Paradigm/links/00b495391c77795f7d000000/Image-Quality-Assessment-Using-the-SSIM-and-the-Just-Noticeable-Difference-Paradigm.pdf?__cf_chl_tk=lMD1O9vfCcn.kLyQZyVkxgivkLqtiER0FEV9isAfCWY-1752953478-1.0.1.1-KdFFTtv9AjJIuF.yByCJJkrlb0XyE7CGs7OnyJ6q3eE)

[Perceptual Visual Quality Assessment: Principles, Methods, and Future Directions (arxiv)](https://arxiv.org/html/2503.00625v1)

[Multiple just-noticeable-difference-based no-reference stereoscopic image quality assessment](https://opg.optica.org/ao/viewmedia.cfm?uri=ao-58-2-340&seq=0&html=true)
https://doi.org/10.1364/AO.58.000340

[Image Quality Assessment: From Error Visibility to Structural Similarity, LINK IS TO PDF DOWNLOAD](https://www.cns.nyu.edu/pub/lcv/wang03-preprint.pdf)

[Post from fstoppers.com](https://web.archive.org/web/20250528180757/https://fstoppers.com/education/about-jpeg-images-and-their-quality-degradation-435235) 
which I include solely because of the statement that begins the article, 
"You lose information when an image is saved in JPEG format. This is acceptable, 
unless you save the same image more than once. 
Let’s have a look at how much information you really lose."

You should, however, see Wikipedia's JPEG article, specifically the Lossless Editing section, archived version 
[here](https://web.archive.org/web/20250716110206/https://en.wikipedia.org/wiki/JPEG#Lossless_editing)


[An Analysis of Lightroom JPEG Export Quality Settings]()
https://regex.info/blog/lightroom-goodies/jpeg-quality

[Post from darkroomphotos concerning Lighroom with scientific measurements](https://web.archive.org/web/20250719201256/https://darkroomphotos.com/lightroom-exporting-jpegs-lightroom-quality-settings/)

[A discussion of what quality means](https://web.archive.org/web/20250611223537/http://www.faqs.org/faqs/jpeg-faq/part1/section-5.html)

[Quality has to do with matrix coefficients related to frequency of DFT (sometimes; it depends how the encoders work)]()
Also https://stackoverflow.com/a/41577078/6505499

[Photo StackExchange Discussion](https://web.archive.org/web/20250719201635/https://photo.stackexchange.com/questions/30243/what-quality-to-choose-when-converting-to-jpg)

[Something else from Photo StackExchange about what quality means](https://photo.stackexchange.com/questions/57226/how-does-the-usual-jpeg-0-100-quality-settings-translate-into-photoshops-0-12-q)

There's a good discussion in the comments:

>  But possibly it is the case that quality number 0-100 isn't actually part of the jpeg standard (i.e. there aren't quantization tables specified in the standard by a given quality number) and so there IS no direct translation between adobes and libjpegs quality numbers because they actually use different quantization tables altogether. If that is the case, then there really isn't a translation between them and the answer you pointed to is as good as it is going to get. –John Robertson | Dec 3, 2014 at 19:15

>  It actually _is_ defined in [the standard]() but many encoders use a 0-100 scale which doesn't correspond to this. –mattdm | Dec 3, 2014 at 19:25

Link for 'the standard', https://datatracker.ietf.org/doc/html/rfc2435#section-4.2

[FotoForensics Post, very understandable]()
https://fotoforensics.com/tutorial.php?tt=estq

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
