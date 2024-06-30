# Developer Notes

## Development

- Follow the SDK setup guide [here](https://developer.garmin.com/connect-iq/sdk/)
- install Java JRE/JDK:

```bash
    sudo apt install openjdk-18-jre-headless default-jre
    sudo apt install openjdk-18-jdk --fix-missing
```

- Set `Monkey C: Type Check Level` to `Off` if you get type check errors. (it's better to fix them ;)
- Use _Ctrl + Shift + P_ to invoke `Monkey C` commands.

Note: Note that saving settings inside groups does not work! There is a bug:
My tests show that it works the first time in ConnectIQ app but not after.
https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://forums.garmin.com/developer/connect-iq/f/discussion/289743/settings-in-groups-are-not-persisted&ved=2ahUKEwiKu4vc_POGAxXM-AIHHV6OCHQQFnoECB0QAQ&usg=AOvVaw2vo5c1OfK5KCKtMFwv4f1C

List of resources:

- https://developer.garmin.com/connect-iq/api-docs/Toybox/Lang.html
- https://developer.garmin.com/connect-iq/core-topics/persisting-data/

## Device list and notes

This [device list](./docs/devices.md) is intended for development checklist purposes.

## Testing

```bash
docker pull ghcr.io/adamjakab/connectiq-builder:latest
docker run --rm -v /mnt/Code/Garmin/iHIIT:/iHIIT -w /iHIIT ghcr.io/adamjakab/connectiq-builder:latest /scripts/test.sh --type-check-level=2
```
