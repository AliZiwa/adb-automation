### Setup
---
#### Clone
- Clone repository

#### Configuration
- Make the `adb_auto.sh` script file executable by running `chmod +x start_emulator_and_open_settings.sh` in terminal
- Execute script `./adb_auto.sh`
- Ensure you have the emulator on the `ANDROID_PATH`, otherwise
  
  Add `export PATH=$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH` to your `.zshrc` file
  Then run `source ~/.zshrc` to save and apply changes.
