# KindleJailbreakHotfix
This is the "persistent" glue for the jailbreak hotfix

This currently only supports the KOA2 partition scheme.  Please note the partition 'dev/mmcblk2p5'.  any recommendations are appreciated

To build for KOA2

There is probably an easier way than this.

1. Export all code to a directory, say: koa2_hf
2. KT_WITH_UNKNOWN_DEVCODES=1 kindletool create ota2 -d touch -d 295 -d 296 -d 297 -d 298 -d 2E1 -d 2E2 -d 2E6 -d 2E7 -d 2E8 -d 341 -d 342 -d 343 -d 344 -d 347 -d 34A -O -s 0 -t 18446744073709551615 koa2_hf > koa2_hf.bin
3. kindletool extract koa2_hf.bin koa2_hf_signed
4. Edit koa2_hf_signed/update-filelist.dat
5. Tar that up
6. gz that tar
7. KT_WITH_UNKNOWN_DEVCODES=1 kindletool create ota2 -d touch -d 295 -d 296 -d 297 -d 298 -d 2E1 -d 2E2 -d 2E6 -d 2E7 -d 2E8 -d 341 -d 342 -d 343 -d 344 -d 347 -d 34A -O -s 0 -t 18446744073709551615 koa2_hf_signed.tar.gz > koa2_hf_signed.bin
