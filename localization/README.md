# Game UI Localization

This readme describes how to add and maintain game UI localization (this means only messages and various UI components visible in the game; dialogs are handled differently).

## Add new language

Here are simple steps on how to add a new language:

1. Navigate to the `localization` directory in the repository.
2. Open the `localization.csv` file in a text editor (note: you can also use MS Excel and other table processors, but be sure to save it back to CSV format and make sure it didn't add any unwanted symbols).
3. Add the locale code of the new language to the first line (find yours [here](https://docs.godotengine.org/cs/4.x/tutorials/i18n/locales.html)). For example, we have the first line like this: `keys,en,cs` and we want to add the German language, so it will look like this: `keys,en,cs,de`.
4. On each line, add a comma and the translation in the new language.
5. When you translate all the lines, save the file and open the project.
6. In the project, navigate to Project -> Project Settings -> Localization -> Translations. There, click on the Add... button and navigate to the translations directory. You should see a `localization.xx.translation` file (where `xx` is the locale code of the language, so for example our German language should be `localization.de.translation`).
7. Commit and push the updated `localization.csv`, `localization.csv.import` and `project.godot` files to a new branch and create a pull request.

## Update transaltion

You found an error or you want to improve a specific translation. Here are simple steps on how to do it:

1. Navigate to the `localization` directory in the repository.
2. Open the `localization.csv` file in a text editor (note: you can also use MS Excel and other table processors, but be sure to save it back to CSV format and make sure it didn't add any unwanted symbols).
3. Find and update the translation.
4. Save the file.
5. Commit and push the updated `localization.csv` file to a new branch and create a pull request.

## Add new localization

You are a dev and you added something that should be localized. There are two ways: you have some native UI element that has a label, text or something similar, or you want to translate something in the code.

### Translate UI element:

1. Navigate to the text field that should be translated.
2. Pick some good placeholder name (you can use the location of the component or its name and property, for example settings item text in the terminal could be `TERMINAL_ITEMS_SETTINGS_TEXT`).
3. Add the placeholder name at the end of the `localization.csv` file and add known translations.

### Translate message in code:

1. Add `tr("PLACEHOLDER_NAME")`.
2. Pick some good placeholder name (you can use the location of the component or its name and property, for example resize note in console could be `CONSOLE_RESIZE_NOTE`).
3. Add the placeholder name at the end of the `localization.csv` file and add known translations.

## Notes about translations:

* When a translation doesn't have any line in the `localization.csv` file, the placeholder will be used.
* When there is a line in the `localization.csv` file but no translation in the given language column, it will fall back to the fallback locale `en`
* When you add a new language, keep an eye on whether there is a column for the previous language. If not, add an empty column with a comma (for example `ENtranslation,,DEtranslation`).
* When you are translating, leave all `{0} {1} {2}` placeholders there. Text from some variable will be inserted there. Also, there are tags in square brackets; those are text formatters, leave them as they are.
* When you have a comma in the text of your translation, wrap the whole column value in `" "` (for example `Well, leave it alone!` should be `"Well, leave it alone!"`).

And the most important thing: **If you don't know or you have a problem, ask for help**!
