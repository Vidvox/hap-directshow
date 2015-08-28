## Hap is an open source video codec for fast decompression on modern graphics hardware ##

Usually when a movie is being played, the CPU has to decompress every frame before passing them to the graphics card (GPU). Hap passes the compressed frames to the GPU, who does all the decompression, saving your precious CPU from this work.

When Hap was originally released there was only support for QuickTime MOV files.  This video codec allows applications supporting DirectShow to encode AVI videos using the Hap codec and to play back Hap encoded videos.

Hap was developed by [Tom Butterworth](https://twitter.com/bang_noise) and commissioned by [Vidvox](http://www.vidvox.net/).

This port was created by [RenderHeads Ltd](http://www.renderheads.com/).

For general information about Hap, read the [Hap announcement](http://vdmx.vidvox.net/blog/hap).

For technical information about Hap, see the [Hap project](https://github.com/vidvox/hap).