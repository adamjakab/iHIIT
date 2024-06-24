# iHIIT

High Intensity Interval Training (or any other repetition based) App for your Garmin device.

## How to obtain it?

You can install the app on your device through the IQ app store. This is a [direct link](https://apps.garmin.com/en-US/apps/bc02f0f2-9d7d-4476-8aaf-ef99f2e78c33) to the app page.

## How does it work?

You can configure up to 5 workouts. Each workout can contain up to 12 exercises with a set exercise duration and a rest duration. Additionally, you can configure how many times the workout will repeat the exercises (repetitions) and the time to pause between repetitions.

When you start the app on your watch it will propose you the configured workouts. You can scroll through the exercises with the up/down buttons and select one with the activity button. Once selected, iHIIT will lead you through your configured exercises alternating between exercise and rest periods.

## How to configure iHIIT?

The easiest way to configure iHIIT is through the use the Garmin ConnctIQ application installed on your mobile phone. Alternatively, you can use the GarminExpress application installed on your PC.

**On Garmin ConnctIQ:**
Open "My Device Apps" and Select the `iHIIT` application from the list of apps installed on your device. Hit the `Settings` button to open the configuration window. Enter/change your configuration and click `Save`. Your configuration will be immediately transferred to your device.

**On GarminExpress:**
Select the `iHIIT` application from the list of IQ Apps installed on your device. Hit the `...` button next to the name of of the application to open the configuration window. Enter/change your configuration and click `Save`. Your configuration will be immediately transferred to your device.

For each workout you can configure the following:

- Title
- Enabled (Yes/No)
- Exercise duration (seconds)
- Rest between exercises (seconds)
- Number of repetitions (number of times the set of exercises will be repeated)
- Rest between repetitions (seconds)
- Name of the exercises (1-12)

Exercises must be consecutive. The first blank exercise title will indicate the end of the workout.

## Bugs? Enhancements? Contributions

Please use github for [Issues & Enhancement requests](https://github.com/adamjakab/iHIIT/issues).

[Contributions](https://github.com/adamjakab/iHIIT) are absolutely welcome!

If you haven't got a github account write a review or use the 'Contact Developer' link on the right under 'Additional information'.

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

## Contributions

Always welcome!

## Testing

```bash
docker pull ghcr.io/adamjakab/connectiq-builder:latest
docker run --rm -v /mnt/Code/Garmin/iHIIT:/iHIIT -w /iHIIT ghcr.io/adamjakab/connectiq-builder:latest /scripts/test.sh --type-check-level=2
```
