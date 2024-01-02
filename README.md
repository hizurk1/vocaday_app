# Vocaday: English vocabulary app

📚 Welcome to Vocaday, your go-to English vocabulary learning app! 🌟

**Vocaday** is designed to make your English vocabulary learning experience **effective and enjoyable**. Whether you're a beginner or looking to enhance your language skills, Vocaday has got you covered.

## ⬇️ Download

Download `apk` file for ``Android`` 👉 [vocaday_app.apk](https://github.com/helkaloic/vocaday_app)

Download from `Google Play Store` 👉 [Vocaday: English vocabulary](https://play.google.com/store/apps/details?id=com.vocaday.vocadayapp)

## ⚙️ Setup

Get started with Vocaday by following these simple steps:

1. **Clean and Get Dependencies:**
    ```bash
    flutter clean
    flutter pub get
    ```

2. **Run the App:**
    ```bash
    flutter run
    ```

3. **(Optional) to build `.apk` file:**
    ```bash
    flutter build apk
    ```


## 🪲 Debug/Release

Generate `debug.keystore`:

```
keytool -genkey -v -keystore "android\app\debug.keystore" -storepass android -keypass android -keyalg RSA -keysize 2048 -validity 10000 -alias androiddebugkey -dname "CN=Android Debug,O=Android,C=US"
```

Get `SHA-1` or `SHA256`:

```
keytool -list -v -keystore "android\app\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```


## 💻 Code Generation

- ### Easy_localization:

    If you make any changes from the translation file. To update the new changes, run those commands below:

1. Generate Loader class:

    ```bash
    dart run easy_localization:generate -S "assets/translations" -O "lib/app/translations"
    ```

2. Generate Keys class:
    ```bash
    dart run easy_localization:generate -S "assets/translations" -O "lib/app/translations" -o "local_keys.g.dart" -f keys -u true
    ```

    For detailed information, refer to the [easy_localization documentation](https://pub.dev/packages/easy_localization#-code-generation).

    | Arguments | Short | Default | Description |
    | --------- | ----- | ------- | ----------- |
    | --help    | -h    |         | Help info   |
    | --source-dir | -S | resources/langs | Folder containing localization files |
    | --source-file | -s | First file | File to use for localization |
    | --output-dir | -O | lib/generated | Output folder stores for the generated file |
    | --output-file | -o | codegen_loader.g.dart | Output file name |
    | --format | -f | json | Support json or keys formats |
    | --[no-]skip-unnecessary-keys | -u  | false | Ignores keys defining nested object except for plural(), gender() keywords |


## 🔗 Resource

Here's some sources for `assets` folder.

- `data` [English Dictionary Data](https://github.com/helkaloic/english-dictionary-data)
- `fonts` [Google Fonts - Roboto](https://fonts.google.com/specimen/Roboto)
- `icons` & `images` Icons from [Lunacy](https://icons8.com/lunacy)
- `jsons` [Lotties](https://lottiefiles.com/)
- `translations` created with the support of [i18n Manager](https://github.com/gilmarsquinelato/i18n-manager)


## 📂 Folder Structure

Here's a simple folder structure of this project.

> _**Note**: it may has more folders and files in there_

```plaintext
vocaday_app/
|-- assets/
|-- lib/
|   |-- app/
|   |-- core/
|   |-- features/
|   |   |-- feature-1/
|   |   |   |-- data/
|   |   |   |   |-- data_sources/
|   |   |   |   |-- models/
|   |   |   |   |-- repositories/
|   |   |   |-- domain/
|   |   |   |   |-- repositories/
|   |   |   |   |-- entities/
|   |   |   |   |-- usecases/
|   |   |   |-- presentation/
|   |   |   |   |-- blocs/
|   |   |   |   |-- pages/
|   |   |   |   |-- widgets/
|   |   |-- feature-2/
|   |   |-- ...
|   |-- app.dart
|   |   ...
|   |-- main.dart
|-- test/
|-- pubspec.yaml
```


## 👀 User Interface

Vocaday currently offers a clean and intuitive user interface with two main pages:

1. **Home Page:**
    - [Image Placeholder]

2. **Feature Page:**
    - [Image Placeholder]


**Happy learning with Vocaday! 🚀**