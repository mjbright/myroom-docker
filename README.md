# Running HPMyRoom in Docker

Running multi-lib sound like a death sentance, run it in Docker instead.

Makes a lot of assumptions, so you may need to tweek it for your Pulse or X setup


## Prepare

### PulseAudio network clients

Run `paprefs`, goto the network tab and click `enable network access to local sound devices`

Or do it via the CLI.


## Run It

```
./start.sh ${CONTAINER}
```


## Troubleshooting

If a popup keeps coming up and going away whenever you click, spam the mosue over the button you want to click and click fast.  You'll get it eventually...
