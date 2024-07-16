🛰️ Overview 🛰️
--------------

Gnudo is a wildly unfinished To-Do list app accessible on the terminal with a name pertaining to wildebeest.

It's written in 🐦‍🔥[Swift](swift.org)🐦‍🔥 with its ArgumentParser, stores the task data in json, and will automatically back it up somewhere else on disk.

🛣️ Where We're Going 🛣️
-----------------------
Having a to-do list on the command line really allows for a lot of integration with your workflow as a developer. The app could link tasks to editing certain files, actions in git, and all sorts of other integrations as well as all of the intrinsic benefits to having the app in your terminal, like aliases and shell scripts, along with the fact that it's right where you're working. There is a lot of potential for this tool, and I hope you let us realise it.

🙋 How to Help 🙋
-----------------

Feel free to add issues (existent ones, hopefully) to the repo, and maybe fix them yourself, or fix some posed by others or even just label some. When you get down to coding you can clone the GitHub repo into a new directory with `git clone https://github.com/thegnugod/gnudo.git NEW_DIRECTORY_NAME`. Once you've done that, you can build and run the project with `swift run` from anywhere inside `NEW_DIRECTORY_NAME` (including subdirectories), just build it with `swift build -c debug` and then just run it with the generated executable found at `NEW_DIRECTORY_NAME/.build/debug/gnudo`.

**Thanks for READING ME, and hopefully helping out with Gnudo!**
